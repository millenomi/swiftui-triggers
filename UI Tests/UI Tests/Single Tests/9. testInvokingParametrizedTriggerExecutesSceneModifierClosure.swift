
import SwiftUI
@testable import SwiftUITriggers

extension TestViewContent {
    struct testInvokingCustomParametrizedTriggerExecutesSceneModifierClosure: View {
        @Binding var onCustomParametrizedSceneTrigger: CustomParametrizedTrigger
        let parametrizedSceneTriggerCount: Int
        let latestParametrizedSceneTriggerArguments: (String, Int)?
                
        var body: some View {
            let count = parametrizedSceneTriggerCount
            let received = latestParametrizedSceneTriggerArguments
            
            Group {
                let value = received.flatMap { string, int in
                    "\(string), \(int)"
                } ?? "—"
                
                let text = "Received: \(value); Count: \(count)"
                
                Text(text)
                    .accessibilityLabel("Received")
                    .accessibilityValue(text)
                
                Button("Invoke Trigger") {
                    onCustomParametrizedSceneTrigger("Hello", 42)
                }
            }
        }
    }
}
