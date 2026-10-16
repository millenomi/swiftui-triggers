
import SwiftUI
@testable import SwiftUITriggers

extension TestViewContent {
    struct testParametrizedTriggerCallAsFunctionThroughBinding: View {
        @State var count = 0
        @State var trigger = ParametrizedTrigger(arguments: String.self, Int.self)
        
        @State var received: (String, Int)?
        
        var body: some View {
            Group {
                let value = received.flatMap { string, int in
                    "\(string), \(int)"
                } ?? "—"
                
                let text = "Received: \(value); Count: \(count)"
                
                Text(text)
                    .accessibilityLabel("Received")
                    .accessibilityValue(text)
                
                Button("Invoke Trigger") {
                    $trigger(("Hello", 42))
                }
            }
            .onTrigger(trigger) { string, int in
                self.count += 1
                self.received = (string, int)
            }
        }
    }
}
