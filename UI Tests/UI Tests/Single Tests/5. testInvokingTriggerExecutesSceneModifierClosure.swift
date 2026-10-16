
import SwiftUI
@testable import SwiftUITriggers

extension TestViewContent {
    struct testInvokingTriggerExecutesSceneModifierClosure: View {
        @Binding var onSceneTrigger: Trigger
        let sceneTriggerCount: Int
        
        var body: some View {
            Group {
                Text("Count: \(sceneTriggerCount)")
                    .accessibilityLabel("Count")
                    .accessibilityValue("Count: \(sceneTriggerCount)")
                Button("Invoke Trigger") {
                    onSceneTrigger()
                }
            }
        }
    }
}
