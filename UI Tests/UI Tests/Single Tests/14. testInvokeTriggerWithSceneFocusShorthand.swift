
import SwiftUI
@testable import SwiftUITriggers

extension TestViewContent {
    struct testInvokeTriggerWithSceneFocusShorthand: View {
        @State var count = 0
        @State var trigger = Trigger()
        
        var body: some View {
            Text("Count: \(count)")
                .accessibilityLabel("Count")
                .accessibilityValue("Count: \(count)")
                .onFocusedSceneTrigger(\.onTrigger, $trigger) {
                    count += 1
                }
            
            InvokeButtonViaFocus()
        }
        
        struct InvokeButtonViaFocus: View {
            @FocusedValue(\.onTrigger)
            var onTrigger
            
            var body: some View {
                Button("Invoke Trigger") {
                    onTrigger?()
                }
                .disabled(onTrigger == nil)
            }
        }
    }
}
