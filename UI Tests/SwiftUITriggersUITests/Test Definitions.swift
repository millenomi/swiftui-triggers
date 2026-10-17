
import XCTest

@MainActor
final class SwiftUITriggersUITests: XCTestCase {
    override func setUpWithError() throws {
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
    }

    override func tearDownWithError() throws {
        // <#…#>
    }
    
    func testInvokingTriggerExecutesModifierClosure() throws {
        let app = XCUIApplication()
        app.setLaunchEnvironment(for: .testInvokingTriggerExecutesModifierClosure)
        app.launch()
        
        app.activate()
        
        app.buttons["Invoke Trigger"].firstMatch.clickOrTap()
        
        let count = app.staticTexts["Count"].value as? String
        XCTAssertEqual(count, "Count: 1")
    }
    
    func testInvokingTriggerExecutesModifierClosureWithSource() throws {
        let app = XCUIApplication()
        app.setLaunchEnvironment(for: .testInvokingTriggerExecutesModifierClosureWithSource)
        app.launch()
        
        app.activate()
        
        app.buttons["Invoke Trigger"].firstMatch.clickOrTap()
        
        let count = app.staticTexts["Count"].value as? String
        XCTAssertEqual(count, "Count: 1")
    }
    
    func testInvokingParametrizedTriggerExecutesModifierClosure() throws {
        let app = XCUIApplication()
        app.setLaunchEnvironment(for: .testInvokingParametrizedTriggerExecutesModifierClosure)
        app.launch()
        
        app.activate()
        
        app.buttons["Invoke Trigger"].firstMatch.clickOrTap()
        
        let count = app.staticTexts["Received"].value as? String
        XCTAssertEqual(count, "Received: Hello, 42; Count: 1")
    }
    
    func testInvokingCustomParametrizedTriggerExecutesModifierClosure() throws {
        let app = XCUIApplication()
        app.setLaunchEnvironment(for: .testInvokingCustomParametrizedTriggerExecutesModifierClosure)
        app.launch()
        
        app.activate()
        
        app.buttons["Invoke Trigger"].firstMatch.clickOrTap()
        
        let count = app.staticTexts["Received"].value as? String
        XCTAssertEqual(count, "Received: Hello, 42; Count: 1")
    }
    
    func testInvokingTriggerExecutesSceneModifierClosure() throws {
        let app = XCUIApplication()
        app.setLaunchEnvironment(for: .testInvokingTriggerExecutesSceneModifierClosure)
        app.launch()
        
        app.activate()
        
        app.buttons["Invoke Trigger"].firstMatch.clickOrTap()
        
        let count = app.staticTexts["Count"].value as? String
        XCTAssertEqual(count, "Count: 1")
    }
    
    func testInvokingTriggerExecutesSceneModifierClosureWithSource() throws {
        let app = XCUIApplication()
        app.setLaunchEnvironment(for: .testInvokingTriggerExecutesSceneModifierClosureWithSource)
        app.launch()
        
        app.activate()
        
        app.buttons["Invoke Trigger"].firstMatch.clickOrTap()
        
        let count = app.staticTexts["Count"].value as? String
        XCTAssertEqual(count, "Count: 1")
    }
    
    func testInvokingParametrizedTriggerExecutesSceneModifierClosure() throws {
        let app = XCUIApplication()
        app.setLaunchEnvironment(for: .testInvokingParametrizedTriggerExecutesSceneModifierClosure)
        app.launch()
        
        app.activate()
        
        app.buttons["Invoke Trigger"].firstMatch.clickOrTap()
        
        let count = app.staticTexts["Received"].value as? String
        XCTAssertEqual(count, "Received: Hello, 42; Count: 1")
    }
    
    func testInvokingParametrizedTriggerExecutesSceneModifierClosureWithSource() throws {
        let app = XCUIApplication()
        app.setLaunchEnvironment(for: .testInvokingParametrizedTriggerExecutesSceneModifierClosureWithSource)
        app.launch()
        
        app.activate()
        
        app.buttons["Invoke Trigger"].firstMatch.clickOrTap()
        
        let count = app.staticTexts["Received"].value as? String
        XCTAssertEqual(count, "Received: Hello, 42; Count: 1")
    }
    
    func testInvokingCustomParametrizedTriggerExecutesSceneModifierClosure() throws {
        let app = XCUIApplication()
        app.setLaunchEnvironment(for: .testInvokingCustomParametrizedTriggerExecutesSceneModifierClosure)
        app.launch()
        
        app.activate()
        
        app.buttons["Invoke Trigger"].firstMatch.clickOrTap()
        
        let count = app.staticTexts["Received"].value as? String
        XCTAssertEqual(count, "Received: Hello, 42; Count: 1")
    }
    
    func testTriggerCallAsFunctionThroughBinding() throws {
        let app = XCUIApplication()
        app.setLaunchEnvironment(for: .testTriggerCallAsFunctionThroughBinding)
        app.launch()
        
        app.activate()
        
        app.buttons["Invoke Trigger"].firstMatch.clickOrTap()
        
        let count = app.staticTexts["Count"].value as? String
        XCTAssertEqual(count, "Count: 1")
    }
    
    func testParametrizedTriggerCallAsFunctionThroughBinding() throws {
        let app = XCUIApplication()
        app.setLaunchEnvironment(for: .testParametrizedTriggerCallAsFunctionThroughBinding)
        app.launch()
        
        app.activate()
        
        app.buttons["Invoke Trigger"].firstMatch.clickOrTap()
        
        let count = app.staticTexts["Received"].value as? String
        XCTAssertEqual(count, "Received: Hello, 42; Count: 1")
    }
    
    func testParametrizedTriggerCallAsFunctionThroughBindingWithDirectArguments() throws {
        let app = XCUIApplication()
        app.setLaunchEnvironment(for: .testParametrizedTriggerCallAsFunctionThroughBindingWithDirectArguments)
        app.launch()
        
        app.activate()
        
        app.buttons["Invoke Trigger"].firstMatch.clickOrTap()
        
        let count = app.staticTexts["Received"].value as? String
        XCTAssertEqual(count, "Received: Hello, 42; Count: 1")
    }
    
    func testInvokeTriggerWithFocusShorthand() throws {
        let app = XCUIApplication()
        app.setLaunchEnvironment(for: .testInvokeTriggerWithFocusShorthand)
        app.launch()
        
        app.activate()
        
        app.staticTexts["Count"].clickOrTap() // To focus the field.
        app.buttons["Invoke Trigger"].firstMatch.clickOrTap()
        
        let count = app.staticTexts["Count"].value as? String
        XCTAssertEqual(count, "Count: 1")
    }
    
    func testInvokeParametrizedTriggerWithFocusShorthand() throws {
        let app = XCUIApplication()
        app.setLaunchEnvironment(for: .testInvokeParametrizedTriggerWithFocusShorthand)
        app.launch()
        
        app.activate()
        
        app.staticTexts["Received"].clickOrTap() // To focus the field.
        app.buttons["Invoke Trigger"].firstMatch.clickOrTap()
        
        let count = app.staticTexts["Received"].value as? String
        XCTAssertEqual(count, "Received: Hello; Count: 1")
    }
    
    func testInvokeTriggerWithSceneFocusShorthand() throws {
        let app = XCUIApplication()
        app.setLaunchEnvironment(for: .testInvokeTriggerWithSceneFocusShorthand)
        app.launch()
        
        app.activate()
        
        app.buttons["Invoke Trigger"].firstMatch.clickOrTap()
        
        let count = app.staticTexts["Count"].value as? String
        XCTAssertEqual(count, "Count: 1")
    }
    
    func testInvokeParametrizedTriggerWithSceneFocusShorthand() throws {
        let app = XCUIApplication()
        app.setLaunchEnvironment(for: .testInvokeParametrizedTriggerWithSceneFocusShorthand)
        app.launch()
        
        app.activate()
        
        app.buttons["Invoke Trigger"].firstMatch.clickOrTap()
        
        let count = app.staticTexts["Received"].value as? String
        XCTAssertEqual(count, "Received: Hello; Count: 1")
    }
    
    // -----
    
    // This method is never called, but makes it a compiler error if a test is defined
    // but doesn't have a body.
    func testMethod(associatedWith test: Tests) -> () throws -> Void {
        switch test {
        case .testInvokingTriggerExecutesModifierClosure:
            testInvokingTriggerExecutesModifierClosure
        case .testInvokingTriggerExecutesModifierClosureWithSource:
            testInvokingTriggerExecutesModifierClosureWithSource
        case .testInvokingParametrizedTriggerExecutesModifierClosure:
            testInvokingParametrizedTriggerExecutesModifierClosure
        case .testInvokingCustomParametrizedTriggerExecutesModifierClosure:
            testInvokingCustomParametrizedTriggerExecutesModifierClosure
        case .testInvokingTriggerExecutesSceneModifierClosure:
            testInvokingTriggerExecutesSceneModifierClosure
        case .testInvokingTriggerExecutesSceneModifierClosureWithSource:
            testInvokingTriggerExecutesSceneModifierClosureWithSource
        case .testInvokingParametrizedTriggerExecutesSceneModifierClosure:
            testInvokingParametrizedTriggerExecutesSceneModifierClosure
        case .testInvokingParametrizedTriggerExecutesSceneModifierClosureWithSource:
            testInvokingParametrizedTriggerExecutesSceneModifierClosureWithSource
        case .testInvokingCustomParametrizedTriggerExecutesSceneModifierClosure:
            testInvokingCustomParametrizedTriggerExecutesSceneModifierClosure
        case .testTriggerCallAsFunctionThroughBinding:
            testTriggerCallAsFunctionThroughBinding
        case .testParametrizedTriggerCallAsFunctionThroughBinding:
            testParametrizedTriggerCallAsFunctionThroughBinding
        case .testParametrizedTriggerCallAsFunctionThroughBindingWithDirectArguments:
            testParametrizedTriggerCallAsFunctionThroughBindingWithDirectArguments
        
        case .testInvokeTriggerWithFocusShorthand:
            testInvokeTriggerWithFocusShorthand
        case .testInvokeParametrizedTriggerWithFocusShorthand:
            testInvokeParametrizedTriggerWithFocusShorthand
        case .testInvokeTriggerWithSceneFocusShorthand:
            testInvokeTriggerWithSceneFocusShorthand
        case .testInvokeParametrizedTriggerWithSceneFocusShorthand:
            testInvokeParametrizedTriggerWithSceneFocusShorthand
        }
    }

}

extension XCUIElement {
    func clickOrTap() {
#if os(macOS)
        click()
#else
        tap()
#endif
    }
}
