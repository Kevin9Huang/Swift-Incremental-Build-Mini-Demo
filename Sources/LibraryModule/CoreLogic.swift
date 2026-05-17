public struct CoreLogic: Sendable {
    public init() {}

    public func fetchNetworkData() {
        print("Fetching data from the network...")

        // 🛠 TEST SCENARIO A: Cross-Module Implementation Change
        // UNCOMMENT the line below, then run `swift build 2>&1 | tee build.log`.
        // ✅ EXPECTED: Build Timeline shows ONLY a "Compile CoreLogic.swift" block under LibraryModule.
        //    The entire AppModule section (main.swift, Feature.swift) is completely absent — skipped!
        // print("Secret internal library change!")
    }

    // 🛠 TEST SCENARIO B: Cross-Module Interface Change
    // UNCOMMENT the line below, then run `swift build 2>&1 | tee build.log`.
    // ✅ EXPECTED: Build Timeline shows CoreLogic.swift compiling first, then main.swift compiling after.
    //    This proves the compiler re-evaluated AppModule only AFTER LibraryModule emitted its new interface.
    // public func fetchNewAPI() {
    //     print("New public capability added!")
    // }
}
