
#if canImport(SwiftUI)
import SwiftUI

extension Binding where Value: TriggerProtocol {
    /// Allows invoking a trigger accessible through a binding with function syntax.
    ///
    /// This will invoke the ``TriggerProtocol/trigger()`` method on the wrapped value.
    ///
    /// For example:
    ///
    /// ```swift
    /// let trigger: Binding<Trigger> = /* … */
    ///
    /// trigger() // Equivalent to: trigger.wrappedValue.trigger()
    /// ```
    public func callAsFunction() {
        wrappedValue()
    }
}

extension Binding where Value: ParametrizedTriggerProtocol {
    /// Allows invoking a parametrized trigger accessible through a binding with function syntax.
    ///
    /// This will invoke the ``ParametrizedTriggerProtocol/trigger(arguments:)`` method on the wrapped value.
    ///
    /// For example:
    ///
    /// ```swift
    /// let trigger: Binding<ParametrizedTrigger<String>> = /* … */
    ///
    /// trigger("123") // Equivalent to: trigger.wrappedValue.trigger(arguments: "123")
    /// ```
    public func callAsFunction(_ arguments: Value.Arguments) {
        wrappedValue.trigger(arguments: arguments)
    }
    
    /// Allows invoking a parametrized trigger accessible through a binding with function syntax.
    ///
    /// This will invoke the ``ParametrizedTriggerProtocol/trigger(arguments:)`` method on the wrapped value.
    ///
    /// For example:
    ///
    /// ```swift
    /// let trigger: Binding<ParametrizedTrigger<String, Int>> = /* … */
    ///
    /// trigger("123", 45) // Equivalent to: trigger.wrappedValue.trigger(arguments: ("123", 45))
    /// ```
    public func callAsFunction<each Argument>(
        _ arguments: repeat each Argument,
    ) where Value.Arguments == (repeat each Argument) {
        wrappedValue.trigger(arguments: (repeat each arguments))
    }
}

#endif
