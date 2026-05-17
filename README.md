# Swift Incremental Build Mini Demo

Small SwiftPM project for observing how different Swift code changes affect incremental builds.

The demo has two targets:

- `AppModule`: executable target
- `LibraryModule`: library target imported by `AppModule`

The point is to compare implementation-only changes, interface changes, unused declaration changes, and cross-module public API changes.

## Requirements

- macOS
- Xcode / Swift toolchain installed
- Swift 6-compatible toolchain recommended

Check your Swift version:

```sh
swift --version
```

## Baseline Build

Start with a clean build:

```sh
swift package clean
swift build 2>&1 | tee full-build.log
grep "Compiling .*swift" full-build.log
```

You should see all Swift source files compile.

Now run the build again without changing anything:

```sh
swift build 2>&1 | tee null-build.log
grep "Compiling .*swift" null-build.log
```

Expected result: no `Compiling ...swift` lines.

This is a null build: the build command ran, but no Swift source files needed to compile because the previous build outputs were still valid.

Do not run `swift package clean` before each scenario. Cleaning removes previous build state, so you are no longer testing incremental behavior.

## Scenarios

### 1. Same-Module Implementation Change

Open `Sources/AppModule/Feature.swift`.

Inside `AnalyticsManager.performTracking()`, uncomment:

```swift
print("Implementation changed!")
```

Run:

```sh
swift build 2>&1 | tee build.log
grep "Compiling .*swift" build.log
```

Expected:

```txt
Compiling AppModule Feature.swift
```

`main.swift` and `FeatureManager.swift` should not recompile.

### 2. Same-Module Interface Change

In `Sources/AppModule/Feature.swift`, rename:

```swift
func performTracking()
```

to:

```swift
func performAnalyticsTracking()
```

Run:

```sh
swift build 2>&1 | tee build.log
grep "Compiling .*swift" build.log
```

Expected:

```txt
Compiling AppModule Feature.swift
Compiling AppModule main.swift
```

The build should fail because `main.swift` still calls `performTracking()`.

### 3. Unused Declaration Change

Open `Sources/AppModule/Feature.swift`.

Inside `LegacyStruct`, uncomment:

```swift
var deadCodeChange = 1
```

Run:

```sh
swift build 2>&1 | tee build.log
grep "Compiling .*swift" build.log
```

Expected:

```txt
Compiling AppModule Feature.swift
```

No other file references `LegacyStruct`, so the dependency chain stops at the edited file.

### 4. Cross-Module Implementation Change

Open `Sources/LibraryModule/CoreLogic.swift`.

Inside `CoreLogic.fetchNetworkData()`, uncomment:

```swift
print("Secret internal library change!")
```

Run:

```sh
swift build 2>&1 | tee build.log
grep "Compiling .*swift" build.log
```

Expected:

```txt
Compiling LibraryModule CoreLogic.swift
```

`AppModule` source files should not recompile.

### 5. Cross-Module Public API Change

Open `Sources/LibraryModule/CoreLogic.swift`.

Uncomment or add:

```swift
public func fetchNewAPI() {
    print("New public capability added!")
}
```

Run:

```sh
swift build 2>&1 | tee build.log
grep "Compiling .*swift" build.log
```

Expected:

```txt
Compiling LibraryModule CoreLogic.swift
Compiling AppModule main.swift
```

Adding a public API changes the module interface, so importing files may need to be rechecked.

## What To Notice

`Compiling SomeFile.swift` means that Swift source file was recompiled.

Other build steps, such as `Emitting module` or `Linking`, can still run even when few Swift files recompile. Incremental compilation reduces unnecessary source recompilation; it does not mean the entire build does only one task.

## Article

Full article: https://medium.com/@kevin9huang/understanding-swift-incremental-builds-through-a-mini-demo-5aaba9f50081
