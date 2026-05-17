import Foundation

class AnalyticsManager {
    func performTracking() {
        print("Tracking user engagement...")

        // 🛠 TEST SCENARIO A: Intra-Module Implementation Change
        // UNCOMMENT the line below, then run `swift build 2>&1 | tee build.log`.
        // ✅ EXPECTED: In the Build Timeline (Cmd+9 → clock icon), ONLY a "Compile Feature.swift" block appears.
        //    main.swift and FeatureManager.swift are completely absent — proof they were skipped!
        // print("Implementation changed!")
    }

    // 🛠 TEST SCENARIO B: Intra-Module Interface Change (Modifying a Used API)
    // RENAME the function above to `func performAnalyticsTracking() {` and hit Cmd+B.
    // ✅ EXPECTED: Build Timeline shows blocks for BOTH Feature.swift AND main.swift.
    //    Note: The "Planning" phase may show "Skipping input: main.swift" — ignore that.
    //    The compiler corrects itself mid-build once it sees the interface changed. Build will FAIL.
}

struct LegacyStruct {
    var isDeprecated = true

    // 🛠 TEST SCENARIO C: Dead Code Edit (Isolated Change)
    // UNCOMMENT the line below, then run `swift build 2>&1 | tee build.log`.
    // ✅ EXPECTED: Build Timeline shows ONLY Feature.swift. Nothing else appears — because
    //    no other file in the project references LegacyStruct at all.
    // var deadCodeChange = 1
}
