
import SwiftUI
@testable import SwiftUITriggers

extension TestViewContent {
    struct testInvokeParametrizedTriggerWithFocusShorthand: View {
        @State var count = 0
        @State var parametrizedTrigger = ParametrizedTrigger(arguments: String.self)
        
        @State var received: String?
        
        @Namespace var focus
        
        var body: some View {
            let text = "Received: \(received, default: "—"); Count: \(count)"
            
            Text(text)
                .accessibilityLabel("Received")
                .accessibilityValue(text)
                .focusable()
                .prefersDefaultFocus(in: focus)
                .onFocusedTrigger(\.onParametrizedTrigger, $parametrizedTrigger) { string in
                    received = string
                    count += 1
                }
            
            InvokeParametrizedTriggerViaFocusButton()
        }
        
        struct InvokeParametrizedTriggerViaFocusButton: View {
            @FocusedValue(\.onParametrizedTrigger)
            var onParametrizedTrigger
            
            var body: some View {
                Button("Invoke Trigger") {
                    onParametrizedTrigger?("Hello")
                }
                .disabled(onParametrizedTrigger == nil)
            }
        }
    }
}

extension FocusedValues {
    @Entry var onParametrizedTrigger: Binding<ParametrizedTrigger<String>>?
}
