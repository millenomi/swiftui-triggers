
enum Tests: String, Hashable, CaseIterable {
    case testInvokingTriggerExecutesModifierClosure
    case testInvokingTriggerExecutesModifierClosureWithSource
    case testInvokingParametrizedTriggerExecutesModifierClosure
    case testInvokingCustomParametrizedTriggerExecutesModifierClosure
    
    case testInvokingTriggerExecutesSceneModifierClosure
    case testInvokingTriggerExecutesSceneModifierClosureWithSource
    case testInvokingParametrizedTriggerExecutesSceneModifierClosure
    case testInvokingParametrizedTriggerExecutesSceneModifierClosureWithSource
    case testInvokingCustomParametrizedTriggerExecutesSceneModifierClosure
    
    case testTriggerCallAsFunctionThroughBinding
    case testParametrizedTriggerCallAsFunctionThroughBinding
    case testParametrizedTriggerCallAsFunctionThroughBindingWithDirectArguments
    
    case testInvokeTriggerWithFocusShorthand
    case testInvokeParametrizedTriggerWithFocusShorthand
    case testInvokeTriggerWithSceneFocusShorthand
    case testInvokeParametrizedTriggerWithSceneFocusShorthand
}

// -----

import Foundation

extension Tests {
    static var current: Self {
        let value = ProcessInfo.processInfo.environment["MN_SWIFTUI_TRIGGERS_UI_TEST"]!
        return .init(rawValue: value)!
    }
}

#if canImport(XCTest)
import XCTest

extension XCUIApplication {
    func setLaunchEnvironment(for test: Tests) {
        self.launchEnvironment["MN_SWIFTUI_TRIGGERS_UI_TEST"] = test.rawValue
    }
}
#endif
 
