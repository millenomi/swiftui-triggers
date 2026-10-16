
import Testing
@testable import SwiftUITriggers

struct CustomParametrizedTrigger: ParametrizedTriggerProtocol {
    var rawValue = 0
    
    mutating func trigger(arguments: Arguments) {
        _arguments = .init(string: arguments.0, int: arguments.1)
        rawValue &+= 1
    }
    
    struct ArgumentValues: Hashable {
        var string: String
        var int: Int
    }
    
    var _arguments: ArgumentValues?
    var arguments: (String, Int) {
        let arguments = _arguments!
        return (arguments.string, arguments.int)
    }
    
    var hasTriggered: Bool {
        _arguments != nil
    }
}

@Suite struct `Custom Parametrized Trigger Basics` {
    @Test func `invoking a trigger modifies its value and carries the new arguments`() async throws {
        let before = CustomParametrizedTrigger()
        #expect(!before.hasTriggered)
        
        var after = before
        after.trigger(arguments: ("Hello", 42))
        
        #expect(before != after)
        try #require(after.hasTriggered)
        #expect(after.arguments == ("Hello", 42))
        
        let before2 = after
        after.trigger(arguments: ("Goodbye", 108))
        
        #expect(before2 != after)
        try #require(after.hasTriggered)
        #expect(after.arguments == ("Goodbye", 108))
    }
    
    @Test func `invoking a trigger works with function syntax and carries the new arguments`() async throws {
        let before = CustomParametrizedTrigger()
        #expect(!before.hasTriggered)
        
        var after = before
        after(("Hello", 42))
        
        #expect(before != after)
        try #require(after.hasTriggered)
        #expect(after.arguments == ("Hello", 42))
        
        let before2 = after
        after(("Goodbye", 108))
        
        #expect(before2 != after)
        try #require(after.hasTriggered)
        #expect(after.arguments == ("Goodbye", 108))
    }
    
    @MainActor @Test func `handling via Observable works`() async throws {
        let handled = Box(0)
        let host = TriggerHost(trigger: CustomParametrizedTrigger())
        
        let task = Task {
            await onTriggerWithSource {
                host.trigger
            } perform: { trigger in
                #expect(trigger.arguments == ("Hello", 42))
                
                await handled.edit {
                    $0 += 1
                }
            }
        }
        
        try await Task.sleep(for: .milliseconds(500))
        host.trigger(("Hello", 42))
        try await Task.sleep(for: .milliseconds(500))
        task.cancel()
        await task.value
        
        let count = await handled.value
        #expect(count == 1)
    }
}
