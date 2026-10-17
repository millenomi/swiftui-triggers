
/** A protocol for triggers, which are requests to perform an action.
 
 Triggers are hashable and equatable values. By detecting a change in equality in a sequence of trigger values, an application can trigger an action to be performed.
 
 > You can use this protocol to implement your own trigger types, but the ``Trigger`` type provides a simple implementation of this protocol.
 
 To request that a trigger occur, a part of the app modifies the trigger value by invoking the ``trigger()`` method. This changes the value in an implementation-defined way, and another portion of the application observing changes to the trigger value can then respond by performing the action.
 
 Triggers do not have other constraints. In particular, it is not necessarily true that all trigger values are unique over time. Triggers should only be compared to immpediately previous values to detect changes, not stored or compared to states observed previously to the change.
 
 The ``callAsFunction()`` method invokes ``trigger()``, allowing you to invoke the trigger by calling as if it was a function:
 
 ```swift
    func doSomething(_ onAlert: inout some TriggerProtocol) {
        // …
        onAlert()
        // …
    }
 ```
 */
public protocol TriggerProtocol: Hashable {
    /// Invokes the trigger.
    ///
    /// The method modifies the trigger so that it no longer compares equal to its previous value, allowing an observer to detect a change.
    mutating func trigger()
}

/** A protocol for parametrized triggers, which are requests to perform an action with a specified set of parameters.
 
 Parametrized triggers are hashable and equatable values. By detecting a change in equality in a sequence of trigger values, an application can trigger an action to be performed. Parametrized triggers also carry arguments for each invocation. The arguments for the latest invocation can be accessed using the ``arguments`` property.
 
 > You can use this protocol to implement your own parametrized trigger types, but the ``ParametrizedTrigger`` type provides a simple implementation of this protocol.
 
 To request that a trigger occur, a part of the app modifies the trigger value by invoking the ``trigger(arguments:)`` method. This changes the value in an implementation-defined way, and another portion of the application observing changes to the trigger value can then respond by performing the action.
 
 Triggers do not have other constraints. In particular, it is not necessarily true that all trigger values are unique over time. Triggers should only be compared to immpediately previous values to detect changes, not stored or compared to states observed previously to the change.
 
 The ``callAsFunction(_:)-(Arguments)`` method invokes ``trigger(arguments:)``, allowing you to invoke the trigger by calling as if it was a function:
 
 ```swift
    func doSomething(_ onAlert: inout some ParametrizedTriggerProtocol<String>) {
        // …
        onAlert("Hello!")
        // …
    }
 ```
 */
public protocol ParametrizedTriggerProtocol<Arguments>: Hashable {
    /// The arguments associated with the trigger.
    ///
    /// Each parametrized trigger type can define any behavior they desire for their argument type or types. Use a parameter pack or tuple with your type for multiple arguments.
    ///
    /// > For an implementation that uses a parameter pack, see ``ParametrizedTrigger``.
    associatedtype Arguments
    
    /// Invokes the trigger with the specified arguments.
    ///
    /// The method modifies the trigger so that it no longer compares equal to its previous value, allowing an observer to detect a change. The arguments will be associated to this invocation.
    mutating func trigger(arguments: Arguments)
    
    /// Returns the arguments associated to the latest trigger invocation.
    ///
    /// Only invoke this property after the trigger has been invoked at least once.
    ///
    /// > Important: If the trigger has not yet been invoked, attempting to read this property will cause a fatal error. Use the ``unpack(_:)-n8sm`` family of methods to retrieve these values safely.
    var arguments: Arguments { get }
    
    /// Returns whether the trigger has been invoked at least once.
    ///
    /// A trigger that has never been invoked has no associated arguments to provide.
    ///
    /// > Important: If the trigger has not yet been invoked, attempting to read the ``arguments`` property will cause a fatal error. Use the ``unpack(_:)-n8sm`` family of methods to retrieve these values safely.
    var hasTriggered: Bool { get }
}

/**
 Defines a parametrized trigger.
 
 A parametrized trigger is a trigger that can also pass along arguments with each invocation.
 
 > Parametrized triggers work very similar to regular triggers. See the ``Trigger`` type for how to define and use a trigger.
 >
 > For more information on how to correctly use parmetrized triggers outside of the functions built into this module, see ``ParametrizedTriggerProtocol``.
 
 To define arguments, specify their types in the `Arguments` type pack or using the ``init(arguments:)`` initializer:
 
 ```swift
 @State var onShowError = ParametrizedTrigger(arguments:
    /* error: */ (any Error).self,
    /* retry: */ (() -> Void).self,
 )
 ```
 
 The ``callAsFunction(_:)-(Arguments)`` method allows you to invoke the trigger like you would a closure:
 
 ```swift
 onShowError(someError, {
    // Retry…
 })
 ```
 
 Receive the arguments using the appropriate overload of the `onTrigger…` family of methods. For example, using ``SwiftUICore/View/onTrigger(_:perform:)-(_,((Argument))->Void)``:
 
 ```swift
 MainWindowContentView()
     .onTrigger(onShowError) { error, retry in
        // …
     }
 ```
 */
public struct ParametrizedTrigger<each Argument>: ParametrizedTriggerProtocol {
    var rawValue = false
    var _arguments: (repeat each Argument)?
    
    /// Creates a new parametrized trigger.
    ///
    /// Specify the types for the arguments in the `each Argument` parameter pack.
    public init() {}
    
    /// Creates a new parametrized trigger where each argument has the specified types.
    public init(arguments: repeat (each Argument).Type) {}
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(rawValue)
    }
    
    public static func == (_ lhs: Self, _ rhs: Self) -> Bool {
        guard lhs.rawValue == rhs.rawValue else {
            return false
        }
        
        guard (lhs._arguments != nil && rhs._arguments != nil) ||
              (lhs._arguments == nil && rhs._arguments == nil) else {
            return false
        }
        
        return true
    }
    
    public mutating func trigger(arguments: (repeat each Argument)) {
        self._arguments = arguments
        rawValue.toggle()
    }
    
    public var arguments: (repeat each Argument) {
        self._arguments!
    }
    
    public var hasTriggered: Bool {
        _arguments != nil
    }
}
extension ParametrizedTrigger: Sendable where repeat each Argument: Sendable {}

extension ParametrizedTriggerProtocol {
    /// Allows invoking the parametrized trigger as if it was a function.
    public mutating func callAsFunction(_ arguments: Arguments) {
        trigger(arguments: arguments)
    }
    
    /// Allows invoking the parametrized trigger as if it was a function.
    ///
    /// If the Arguments value is defined as a tuple, this allows invoking the trigger by specifying the tuple member as arguments.
    ///
    /// For example:
    ///
    /// ```swift
    /// struct CustomTrigger: ParametrizedTrigger {
    ///     typealias Arguments = (String, Int)
    ///     // …
    /// }
    ///
    /// // …
    /// 
    /// var trigger = CustomTrigger()
    /// trigger("Hello", 42) // Rather than trigger(("Hello", 42))
    /// ```
    public mutating func callAsFunction<each Argument>(_ arguments: repeat each Argument) where Arguments == (repeat each Argument) {
        trigger(arguments: (repeat each arguments))
    }
    
    /// Safely retrieves the arguments of a trigger.
    ///
    /// If the trigger has never been invoked, the `handler` closure will not be executed.
    public func unpack<X: ~Copyable>(_ handler: (Arguments) throws -> X) rethrows -> X? {
        if hasTriggered {
            return try handler(arguments)
        } else {
            return nil
        }
    }
    
    /// Safely retrieves the arguments of a trigger.
    ///
    /// If the trigger has never been invoked, the `handler` closure will not be executed.
    public func unpack<X: ~Copyable>(_ handler: (Arguments) throws -> X?) rethrows -> X? {
        if hasTriggered {
            return try handler(arguments)
        } else {
            return nil
        }
    }
    
    /// Safely retrieves the arguments of a trigger.
    ///
    /// If the trigger has never been invoked, the `handler` closure will not be executed.
    public func unpack<X: ~Copyable>(_ handler: (Arguments) async throws -> X) async rethrows -> X? {
        if hasTriggered {
            return try await handler(arguments)
        } else {
            return nil
        }
    }
    
    /// Safely retrieves the arguments of a trigger.
    ///
    /// If the trigger has never been invoked, the `handler` closure will not be executed.
    public func unpack<X: ~Copyable>(_ handler: (Arguments) async throws -> X?) async rethrows -> X? {
        if hasTriggered {
            return try await handler(arguments)
        } else {
            return nil
        }
    }
}

/**
 Defines a trigger, that is, a request of a part of an application to perform behavior in another part.
 
 Triggers are values that are observed over time. Usually, you don't do the observation directly; storing a trigger as a `@State` for a SwiftUI window will do the observation for you.
 
 > Triggers are available across non-Apple platforms and can also be observed without SwiftUI available. See the ``onTrigger(_:perform:)-(_,()->Void)`` function for details.
 
 You can use the ``onTrigger(_:perform:)-(_,()->Void)`` modifier in your SwiftUI view to then respond to a trigger being invoked:
 
 ```swift
 struct ContentView: View {
    @State var onMessageSent = Trigger()
 
    var body: some View {
        ContentSubviews()
            .onTrigger(onMessageSent) {
                // Show that the message has been sent…
            }
    }
 }
 ```
 
 Observing and reacting to a trigger only requires reading its value, but invoking it requires being able to modify its storage. For example, to allow another part of the app to invoke it, you may pass it using a binding, as follows in this example:
 
 ```swift
 // Top-level:
 extension FocusedValues {
    @Entry var onMessageSent: Binding<Trigger>?
 }
 
 // In a view:
 @State var onMessageSent = Trigger()
 
 // In the view's body:
 ….focusedSceneValue(\.onMessageSent, $onMessageSent)
 ```
 
 Then, invoke it through the binding elsewhere. In this example, since a focused value is always optional, we use the `?` operator, but otherwise invoke the trigger much like a function or closure:
 
 ```swift
 // In a command or view:
 @FocusedValue(\.onMessageSent) var onMessageSent
 
 func sendMessage() {
     // …
     onMessageSent?()
 }
 ```
 
 The trigger can also be provided and invoked from within an Observable model type. For example:
 
 ```swift
 // Top-level:
 @Observable final class Model {
    private(set) var onMessageSent = Trigger()
 
    func sendMessage() {
        // …
        onMessageSent()
    }
 }
 
 // In a SwiftUI view:
 @State var model = Model()
 
 // In the view's body:
 ….onTrigger(model.onMessageSent) {
    // Show that the message has been sent…
 }
 ```
 
 > For more information on how to correctly use triggers outside of the functions built into this module, see ``TriggerProtocol``.
 */
public struct Trigger: TriggerProtocol, Sendable {
    var rawValue = false
    
    /// Creates a new trigger.
    public init() {}
    
    public mutating func trigger() {
        rawValue.toggle()
    }
}

extension TriggerProtocol {
    /// Allows invoking the trigger as if it was a function.
    ///
    /// This is equivalent to using ``trigger()``, but allows invoking the trigger using function syntax. For example:
    ///
    /// ```swift
    /// var onAction = Trigger()
    ///
    /// // …
    ///
    /// onAction() // Invoke.
    /// ```
    public mutating func callAsFunction() {
        trigger()
    }
}
