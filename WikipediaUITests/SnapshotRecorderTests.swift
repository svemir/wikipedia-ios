import XCTest

// Details: see `README.md` in same folder as this file.

class WikipediaUITests: XCTestCase {
    
    let app = XCUIApplication()
    var snapshotIndex = 0

    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        
        snapshotIndex = 0
        
        // uncomment one of these as needed when testing (useful when adding new screenshots to ensure `tapButton` works with non-EN)
        /*
         app.launchArguments = [
             "-AppleLanguages",
             "(de)",
             "-AppleLocale",
             "de_DE"
         ]

         app.launchArguments = [
             "-AppleLanguages",
             "(zh)",
             "-AppleLocale",
             "zh_Hans"
         ]

        app.launchArguments = [
            "-AppleLanguages",
            "(ja)",
            "-AppleLocale",
            "ja_JA"
        ]
        */
        
        
        setupSnapshot(app, waitForAnimations: false)
        
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        app.launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    // Prepends an auto-incremented numeric prefix to screenshot names so they appear on the index html page in the order they were captured.
    func wmf_snapshot(_ name: String, timeWaitingForIdle timeout: TimeInterval = 45) {
        snapshot("\(String(format: "%04d", snapshotIndex))-\(name)", timeWaitingForIdle: timeout)
        snapshotIndex = snapshotIndex + 1
    }
    
    // This UI test is used as a harness to navigate to various parts of the app and record screenshots. Fastlane snapshots don't seem to play nice with multiple tests taking snapshots, so we have all of them in this single test.
    func testRecordAppScreenshots() {


        // WECOME
        wmf_snapshot("Welcome1")
    }
}
