
import Observation

/// Observes a trigger and invokes a closure as a `Task` rather than as part of a SwiftUI view.
///
/// This function provides the trigger as a parameter to the handling closure.
///
/// > Unless you are using a custom trigger type conforming to ``TriggerProtocol``, prefer using ``onTrigger(_:perform:)-(_,()->Void)``. See that function for details.
@_disfavoredOverload
public func onTriggerWithSource<T>(@_inheritActorContext _ emit: @escaping @isolated(any) @Sendable () -> T, perform operation: (T) async -> Void) async where T: TriggerProtocol & Sendable {
    let sequence = Observations(emit)
    var previous: T?
    
    for await new in sequence {
        guard !Task.isCancelled else {
            return
        }
        
        if new != previous {
            let shouldInvoke = previous != nil
            previous = new
            if shouldInvoke {
                await operation(new)
            }
        }
    }
}

/// Observes a trigger and invokes a closure as a `Task` rather than as part of a SwiftUI view.
///
/// > This function, as well as the base ``Trigger`` and ``ParametrizedTrigger`` types and supporting protocols, is available even on platforms where SwiftUI is not available.
///
/// This function starts an observation on the property value returned by the `emit` closure. Retrieving the trigger should occur from a key path that is instrumented by the `Observable` macro on its containing type. For example:
///
/// ```swift
/// @Observable final class Model {
///     private(set) var onEventHappened = Trigger()
/// }
///
/// // …
///
/// await onTrigger {
///     model.onEventHappened
/// } perform: {
///     // Handle the event…
/// }
/// ```
///
/// The function does not return until the task it's part of is cancelled. Consider using a `Task` to control when the observation starts or ends:
///
/// ```swift
/// let handlingTask = Task {
///     await onTrigger { … } perform: { … }
/// }
///
/// // Later:
/// handlingTask.cancel() // End observation.
/// ```
public func onTrigger<T>(@_inheritActorContext _ emit: @escaping @isolated(any) @Sendable () -> T, perform operation: () async -> Void) async where T: TriggerProtocol & Sendable {
    await onTriggerWithSource(emit, perform: { _ in await operation() })
}

/// Observes a parametrized trigger and invokes a closure as a `Task` rather than as part of a SwiftUI view.
///
/// This function observes the trigger much like ``onTrigger(_:perform:)-(_,()->Void)`` does for non-parametrized triggers. It provides the trigger value as a parameter to the handling closure.
///
/// > See ``onTrigger(_:perform:)-(_,()->Void)`` for more information on usage.
@_disfavoredOverload
public func onTriggerWithSource<T>(
    @_inheritActorContext _ emit: @escaping @isolated(any) @Sendable () -> T,
    perform operation: (T) async -> Void,
) async where T: ParametrizedTriggerProtocol & Sendable {
    await _onTrigger(someParametrizedTrigger: emit, perform: operation)
}

/// Observes a parametrized trigger and invokes a closure as a `Task` rather than as part of a SwiftUI view.
///
/// This function observes the trigger much like ``onTrigger(_:perform:)-(_,()->Void)`` does for non-parametrized triggers. It provides the arguments of the trigger invocation as parameters to the handling closure.
///
/// > See ``onTrigger(_:perform:)-(_,()->Void)`` for more information on usage.
public func onTrigger<T, each Argument>(
    @_inheritActorContext _ emit: @escaping @isolated(any) @Sendable () -> T,
    perform operation: (_ arguments: (repeat each Argument)) async -> Void,
) async where T: ParametrizedTriggerProtocol & Sendable,
              T.Arguments == (repeat each Argument),
              repeat each Argument: Sendable {
    await _onTrigger(someParametrizedTrigger: emit) { parametrized in
        await operation((repeat each parametrized.arguments))
    }
}

private func _onTrigger<T>(@_inheritActorContext someParametrizedTrigger emit: @escaping @isolated(any) @Sendable () -> T, perform operation: (T) async -> Void) async where T: ParametrizedTriggerProtocol & Sendable {
    let sequence = Observations(emit)
    var previous: T?
    
    for await new in sequence {
        guard !Task.isCancelled else {
            return
        }
        
        if new != previous {
            let shouldInvoke = previous != nil
            previous = new
            if shouldInvoke {
                await operation(new)
            }
        }
    }
}

#if canImport(SwiftUI)
import SwiftUI

extension View {
    /// Observes a trigger and invokes a closure when it is invoked.
    ///
    /// This modifier provides the trigger value to the handling closure.
    ///
    /// > Unless you are using a custom trigger type conforming to ``TriggerProtocol``, prefer using the ``onTrigger(_:perform:)-(_,()->Void)`` modifier. See ``Trigger`` for details.
    @_disfavoredOverload
    public func onTriggerWithSource<T>(_ trigger: T, perform operation: @escaping (T) -> Void) -> some View where T: TriggerProtocol {
        self.onChange(of: trigger) { _, newValue in
            operation(newValue)
        }
    }
    
    /// Observes a trigger and invokes a closure when it is invoked.
    ///
    /// > For information on usage, see ``Trigger``.
    public func onTrigger<T>(_ trigger: T, perform operation: @escaping () -> Void) -> some View where T: TriggerProtocol {
        self.onChange(of: trigger) { _, newValue in
            operation()
        }
    }
    
    /// Observes a parametrized trigger and invokes a closure when it is invoked.
    ///
    /// This modifier provides the parametrized trigger value to the handling closure.
    ///
    /// > Unless you are using a custom trigger type conforming to ``ParametrizedTriggerProtocol``, prefer using the ``onTrigger(_:perform:)-(_,((Argument))->Void)`` modifier. See ``ParametrizedTrigger`` for details.
    @_disfavoredOverload
    public func onTriggerWithSource<T>(_ trigger: T, perform operation: @escaping (T) -> Void) -> some View where T: ParametrizedTriggerProtocol {
        self.onChange(of: trigger) { _, newValue in
            operation(newValue)
        }
    }
    
    /// Observes a parametrized trigger and invokes a closure when it is invoked.
    ///
    /// This modifier provides the arguments for this trigger invocation to the handling closure. If the arguments are defined as a tuple, the tuple will be provided, and can be unpacked as separate arguments in the closure body.
    ///
    /// For example:
    ///
    /// ```swift
    /// var trigger = ParametrizedTrigger(arguments: String.self, Int.self, Bool.self)
    ///
    /// // …
    /// MyView()
    ///     .onTrigger(trigger) { string, int, bool in
    ///         // Handle trigger.
    ///         // …
    ///     }
    public func onTrigger<T, each Argument>(
        _ trigger: T,
        perform operation: @escaping (_ arguments: (repeat each Argument)) -> Void
    ) -> some View
    where T: ParametrizedTriggerProtocol,
          T.Arguments == (repeat each Argument) {
        self.onChange(of: AnyHashable(trigger)) { _, newValue in
            let newValue = newValue as! ParametrizedTrigger<repeat each Argument>
            operation((repeat each newValue.arguments))
        }
    }
}

// These variants combine .focusedValue/.focusedSceneValue and .onTrigger, since they are often combined.
extension View {
    /// Observes a trigger and invokes a closure when it is invoked. The trigger is made available as a focused value when this view is focused.
    ///
    /// This will present the trigger in the same fashion as a `focusedValue()` invocation.
    ///
    /// > For information on usage, see ``Trigger``.
    public func onFocusedTrigger<T>(_ keyPath: WritableKeyPath<FocusedValues, Binding<T>?>, _ trigger: Binding<T>, perform operation: @escaping () -> Void) -> some View where T: TriggerProtocol {
        self.onTrigger(trigger.wrappedValue, perform: operation)
            .focusedValue(keyPath, trigger)
    }

    /// Observes a trigger and invokes a closure when it is invoked. The trigger is made available as a focused value when this scene is focused.
    ///
    /// This will present the trigger in the same fashion as a `focusedSceneValue()` invocation.
    ///
    /// > For information on usage, see ``Trigger``.
    public func onFocusedSceneTrigger<T>(_ keyPath: WritableKeyPath<FocusedValues, Binding<T>?>, _ trigger: Binding<T>, perform operation: @escaping () -> Void) -> some View where T: TriggerProtocol {
        self.onTrigger(trigger.wrappedValue, perform: operation)
            .focusedSceneValue(keyPath, trigger)
    }
    
    /// Observes a parametrized trigger and invokes a closure when it is invoked. The trigger is made available as a focused value when this view is focused.
    ///
    /// This will present the trigger in the same fashion as a `focusedValue()` invocation.
    ///
    /// > For information on usage, see ``Trigger``.
    public func onFocusedTrigger<T, each Argument>(
        _ keyPath: WritableKeyPath<FocusedValues, Binding<T>?>,
        _ trigger: Binding<T>,
        perform operation: @escaping (_ arguments: (repeat each Argument)) -> Void
    ) -> some View
    where T: ParametrizedTriggerProtocol,
          T.Arguments == (repeat each Argument) {
        self.onTrigger(trigger.wrappedValue, perform: operation)
            .focusedValue(keyPath, trigger)
    }

    /// Observes a parametrized trigger and invokes a closure when it is invoked. The trigger is made available as a focused value when this scene is focused.
    ///
    /// This will present the trigger in the same fashion as a `focusedSceneValue()` invocation.
    ///
    /// > For information on usage, see ``Trigger``.
    public func onFocusedSceneTrigger<T, each Argument>(
        _ keyPath: WritableKeyPath<FocusedValues, Binding<T>?>,
        _ trigger: Binding<T>,
        perform operation: @escaping (_ arguments: (repeat each Argument)) -> Void
    ) -> some View
    where T: ParametrizedTriggerProtocol,
          T.Arguments == (repeat each Argument) {
        self.onTrigger(trigger.wrappedValue, perform: operation)
            .focusedSceneValue(keyPath, trigger)
    }
}

extension Scene {
    /// Observes a trigger and invokes a closure when it is invoked.
    ///
    /// This modifier provides the trigger value to the handling closure.
    ///
    /// > Unless you are using a custom trigger type conforming to ``TriggerProtocol``, prefer using the ``onTrigger(_:perform:)-(_,()->Void)`` modifier. See ``Trigger`` for details.
    @_disfavoredOverload
    public func onTriggerWithSource<T>(_ trigger: T, perform operation: @escaping (T) -> Void) -> some Scene where T: TriggerProtocol {
        self.onChange(of: trigger) { _, newValue in
            operation(newValue)
        }
    }
    
    /// Observes a trigger and invokes a closure when it is invoked.
    ///
    /// > For information on usage, see ``Trigger``.
    public func onTrigger<T>(_ trigger: T, perform operation: @escaping () -> Void) -> some Scene where T: TriggerProtocol {
        self.onChange(of: trigger) { _, newValue in
            operation()
        }
    }
    
    /// Observes a parametrized trigger and invokes a closure when it is invoked.
    ///
    /// This modifier provides the parametrized trigger value to the handling closure.
    ///
    /// > Unless you are using a custom trigger type conforming to ``ParametrizedTriggerProtocol``, prefer using the ``onTrigger(_:perform:)-(_,((Argument))->Void)`` modifier. See ``ParametrizedTrigger`` for details.
    @_disfavoredOverload
    public func onTriggerWithSource<T>(_ trigger: T, perform operation: @escaping (T) -> Void) -> some Scene where T: ParametrizedTriggerProtocol {
        self.onChange(of: trigger) { _, newValue in
            operation(newValue)
        }
    }
    
    /// Observes a parametrized trigger and invokes a closure when it is invoked.
    ///
    /// This modifier provides the arguments for this trigger invocation to the handling closure. If the arguments are defined as a tuple, the tuple will be provided, and can be unpacked as separate arguments in the closure body.
    ///
    /// > For more information on usage, see ``ParametrizedTrigger``.
    ///
    /// For example:
    ///
    /// ```swift
    /// var trigger = ParametrizedTrigger(arguments: String.self, Int.self, Bool.self)
    ///
    /// // …
    /// MyScene()
    ///     .onTrigger(trigger) { string, int, bool in
    ///         // Handle trigger.
    ///         // …
    ///     }
    public func onTrigger<T, each Argument>(
        _ trigger: T,
        perform operation: @escaping (_ arguments: (repeat each Argument)) -> Void
    ) -> some Scene
    where T: ParametrizedTriggerProtocol,
          T.Arguments == (repeat each Argument) {
        self.onChange(of: AnyHashable(trigger)) { _, newValue in
            let newValue = newValue as! T
            operation((repeat each newValue.arguments))
        }
    }
}

#endif
