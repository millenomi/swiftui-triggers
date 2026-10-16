
import Testing
@testable import SwiftUITriggers

@Suite struct `Odds and Ends` {
    @Test func `test ParametrizedTrigger init with and without argument types`() async throws {
        _ = ParametrizedTrigger(arguments: String.self, Int.self)
        _ = ParametrizedTrigger<String, Int>()
    }
    
    @Test func `test Trigger and ParametrizedTrigger Hashable conformance`() {
        // Somehow, some of these are not hit elsewhere. Do so here.
        
        do {
            var trigger = Trigger()
            let trigger2 = trigger
            
            #expect(trigger.hashValue == trigger2.hashValue)
            trigger()
            #expect(trigger.hashValue != trigger2.hashValue)
        }
        
        do {
            var trigger = ParametrizedTrigger(arguments: String.self)
            let trigger2 = trigger
            
            #expect(trigger.hashValue == trigger2.hashValue)
            trigger("Hello")
            #expect(trigger.hashValue != trigger2.hashValue)
        }
    }
    
    @Test func `test the unpack functions for parametrized triggers`() async {
        var a = CustomParametrizedTrigger()
        func waitASmidge() async {
            try? await Task.sleep(for: .milliseconds(10))
        }
        
        var hasBeenInvoked = false
        
        // Void variant.
        
        a.unpack { _ in
            hasBeenInvoked = true
        }
        #expect(!hasBeenInvoked)
        
        hasBeenInvoked = false
        await a.unpack { _ in
            await waitASmidge()
            hasBeenInvoked = true
        }
        #expect(!hasBeenInvoked)
        
        // Returning variants.
        do {
            // Returns non-optional
            let result = a.unpack { (argument) -> Int in
                return 42
            }
            #expect(type(of: result) == Int?.self)
            #expect(result == nil)
        }
        
        do {
            // Returns non-optional, async
            let result = await a.unpack { (argument) -> Int in
                await waitASmidge()
                return 42
            }
            #expect(type(of: result) == Int?.self)
            #expect(result == nil)
        }
        
        do {
            // Returns optional
            let result = a.unpack { (argument) -> Int? in
                return 42
            }
            #expect(type(of: result) == Int?.self)
            #expect(result == nil)
        }
        
        do {
            // Returns optional, async
            let result = await a.unpack { (argument) -> Int? in
                await waitASmidge()
                return 42
            }
            #expect(type(of: result) == Int?.self)
            #expect(result == nil)
        }
        
        a("Hello", 42)
        
        // Void variant.
        a.unpack { string, int in
            #expect(string == "Hello")
            #expect(int == 42)
        }
        
        a.unpack { argument in
            #expect(argument == ("Hello", 42))
        }
        
        // Void variant, async.
        await a.unpack { string, int in
            await waitASmidge()
            #expect(string == "Hello")
            #expect(int == 42)
        }
        
        await a.unpack { argument in
            await waitASmidge()
            #expect(argument == ("Hello", 42))
        }
        
        // Returning variants.
        do {
            // Returns optional.
            let result = a.unpack { (string, int) -> Int in
                #expect(string == "Hello")
                #expect(int == 42)
                return 108
            }
            #expect(type(of: result) == Int?.self)
            #expect(result == 108)
        }
        
        do {
            // Returns optional, async.
            let result = await a.unpack { (string, int) -> Int in
                await waitASmidge()
                #expect(string == "Hello")
                #expect(int == 42)
                return 108
            }
            #expect(type(of: result) == Int?.self)
            #expect(result == 108)
        }
        
        do {
            // Returns non-optional.
            let result = a.unpack { (string, int) -> Int? in
                #expect(string == "Hello")
                #expect(int == 42)
                return 108
            }
            #expect(type(of: result) == Int?.self)
            #expect(result == 108)
        }
        
        do {
            // Returns non-optional, async.
            let result = await a.unpack { (string, int) -> Int? in
                await waitASmidge()
                #expect(string == "Hello")
                #expect(int == 42)
                return 108
            }
            #expect(type(of: result) == Int?.self)
            #expect(result == 108)
        }
    }
}
