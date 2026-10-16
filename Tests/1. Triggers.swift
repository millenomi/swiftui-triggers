
import Testing
@testable import SwiftUITriggers

@Suite struct `Trigger Basics` {
    @Test func `invoking a trigger modifies its value`() async throws {
        let before = Trigger()
        var after = before
        after.trigger()
        
        #expect(before != after)
        
        let before2 = after
        after.trigger()
        
        #expect(before2 != after)
    }
    
    @Test func `invoking a trigger works with function syntax`() async throws {
        let before = Trigger()
        var after = before
        after()
        
        #expect(before != after)
        
        let before2 = after
        after()
        
        #expect(before2 != after)
    }
    
    @MainActor @Test func `handling via Observable works`() async throws {
        let handled = Box(0)
        let host = TriggerHost()
        
        let task = Task {
            await onTrigger {
                host.trigger
            } perform: {
                await handled.edit {
                    $0 += 1
                }
            }
        }
        
        try await Task.sleep(for: .milliseconds(500))
        host.trigger()
        try await Task.sleep(for: .milliseconds(500))
        task.cancel()
        await task.value
        
        let count = await handled.value
        #expect(count == 1)
    }
}

// -----

import Observation

@Observable
@MainActor
final class TriggerHost<TriggerType> {
    convenience init() where TriggerType == Trigger {
        self.init(trigger: .init())
    }
    
    init(trigger: TriggerType) where TriggerType: TriggerProtocol {
        self.trigger = trigger
    }
    
    init(trigger: TriggerType) where TriggerType: ParametrizedTriggerProtocol {
        self.trigger = trigger
    }
    
    var trigger: TriggerType
}

actor Box<Value: Sendable> {
    var value: Value
    init(_ value: Value) {
        self.value = value
    }
    
    func edit(_ editor: @Sendable (inout Value) -> Void) {
        editor(&value)
    }
}
