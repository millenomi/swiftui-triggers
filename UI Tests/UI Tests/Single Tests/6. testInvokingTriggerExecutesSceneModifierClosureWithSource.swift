
import SwiftUI
@testable import SwiftUITriggers

extension TestViewContent {
    struct testInvokingTriggerExecutesSceneModifierClosureWithSource: View {
        @Binding var onSceneTrigger: Trigger
        let sceneTriggerWithSourceCount: Int
        
        var body: some View {
            Group {
                Text("Count: \(sceneTriggerWithSourceCount)")
                    .accessibilityLabel("Count")
                    .accessibilityValue("Count: \(sceneTriggerWithSourceCount)")
                Button("Invoke Trigger") {
                    onSceneTrigger()
                }
            }
        }
    }
}
