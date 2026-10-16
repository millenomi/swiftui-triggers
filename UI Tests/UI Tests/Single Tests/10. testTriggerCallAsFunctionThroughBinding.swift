
import SwiftUI
@testable import SwiftUITriggers

extension TestViewContent {
    struct testTriggerCallAsFunctionThroughBinding: View {
        @State var count = 0
        @State var trigger = Trigger()
        
        var body: some View {
            Group {
                Text("Count: \(count)")
                    .accessibilityLabel("Count")
                    .accessibilityValue("Count: \(count)")
                Button("Invoke Trigger") {
                    $trigger()
                }
            }
            .onTrigger(trigger) {
                count += 1
            }
        }
    }
}
