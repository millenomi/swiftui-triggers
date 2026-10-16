
import Testing
@testable import SwiftUITriggers

@Suite struct `Parametrized Trigger Basics` {
    @Test func `invoking a trigger modifies its value and carries the new arguments`() async throws {
        let before = ParametrizedTrigger(arguments: String.self, Int.self)
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
        let before = ParametrizedTrigger(arguments: String.self, Int.self)
        #expect(!before.hasTriggered)
        
        var after = before
        after("Hello", 42)
        
        #expect(before != after)
        try #require(after.hasTriggered)
        #expect(after.arguments == ("Hello", 42))
        
        let before2 = after
        after("Goodbye", 108)
        
        #expect(before2 != after)
        try #require(after.hasTriggered)
        #expect(after.arguments == ("Goodbye", 108))
    }
    
    @MainActor @Test func `handling via Observable works`() async throws {
        let handled = Box(0)
        let host = TriggerHost(trigger: ParametrizedTrigger(arguments: String.self, Int.self))
        
        let task = Task {
            await onTrigger {
                host.trigger
            } perform: { string, int in
                #expect(string == "Hello")
                #expect(int == 42)
                
                await handled.edit {
                    $0 += 1
                }
            }
        }
        
        try await Task.sleep(for: .milliseconds(500))
        host.trigger("Hello", 42)
        try await Task.sleep(for: .milliseconds(500))
        task.cancel()
        await task.value
        
        let count = await handled.value
        #expect(count == 1)
    }
}
