
import SwiftUI
@testable import SwiftUITriggers

extension TestViewContent {
    struct testInvokeTriggerWithFocusShorthand: View {
        @State var count = 0
        @State var trigger = Trigger()
        
        @Namespace var focus
        
        var body: some View {
            Text("Count: \(count)")
                .accessibilityLabel("Count")
                .accessibilityValue("Count: \(count)")
                .focusable()
                .prefersDefaultFocus(in: focus)
                .onFocusedTrigger(\.onTrigger, $trigger) {
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

extension FocusedValues {
    @Entry var onTrigger: Binding<Trigger>?
}
