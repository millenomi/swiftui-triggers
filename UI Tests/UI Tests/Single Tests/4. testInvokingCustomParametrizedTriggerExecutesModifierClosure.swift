
import SwiftUI
@testable import SwiftUITriggers

struct CustomParametrizedTrigger: ParametrizedTriggerProtocol {
    var rawValue = 0
    private var _arguments: ArgumentStorage?
    
    struct ArgumentStorage: Hashable {
        var string: String
        var int: Int
    }
    
    var arguments: (String, Int) {
        (_arguments!.string, _arguments!.int)
    }
    
    mutating func trigger(arguments: (String, Int)) {
        self.rawValue &+= 1
        self._arguments = .init(string: arguments.0, int: arguments.1)
    }
    
    var hasTriggered: Bool {
        _arguments != nil
    }
}

extension TestViewContent {
    struct testInvokingCustomParametrizedTriggerExecutesModifierClosure: View {
        @State var count = 0
        @State var trigger = CustomParametrizedTrigger()
        
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
                    trigger(("Hello", 42))
                }
            }
            .onTriggerWithSource(trigger) { newValue in
                self.count += 1
                self.received = newValue.arguments
            }
        }
    }
}
