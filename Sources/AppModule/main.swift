import LibraryModule

@MainActor
func runDemo() {
    let core = CoreLogic()
    core.fetchNetworkData()

    let analytics = AnalyticsManager()
    analytics.performTracking()
    
    let featureAnalytics = FeatureManager()
    featureAnalytics.performTracking()

    print("App finished running.")
}

runDemo()
