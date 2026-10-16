
import Testing
@testable import SwiftUITriggers

struct CustomTrigger: TriggerProtocol {
    var rawValue = 0
    
    mutating func trigger() {
        rawValue &+= 1
    }
}

@Suite struct `Custom Trigger Basics` {
    @MainActor @Test func `handling via Observable works`() async throws {
        let handled = Box(0)
        let host = TriggerHost(trigger: CustomTrigger())
        
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
