# ``SwiftUITriggers``

Defines _triggers_, value types that allow a command in one part of a SwiftUI or Observation-based app to trigger behavior associated with another part.

## Overview

A common problem in SwiftUI and Observation-based apps is allowing one part of the application to perform behavior on behalf of another. The `SwiftUITriggers` library defines _triggers_, values that can be observed to trigger behavior from one part of the app in another, avoiding the issues inherent in passing closures around.

> Note: This package defines SwiftUI facilities on Apple OSes, but the base types and Observation-based handling are available on all platforms. See the ``onTrigger(_:perform:)-(_,()->Void)`` function for details.

For example, this pattern is sometimes used to set an action to execute from a SwiftUI command (e.g., a menu item) in the current window:

```swift
extension FocusedValues {
    @Entry var onShowHelloAlert: (() -> Void)?
}

// …

struct ContentView: View {
    @State var isPresentingHelloAlert = false
    
    // …

    var body: some View {
        MainWindowControls()
            .focusedSceneValue(\.onShowHelloAlert) {
                self.isPresentingHelloAlert = ture
            }
            // …
        }
    }
}
```

However, the closure has no associated identity and may change as the view is re-evaluated even if no change needs to occur. This may cause slowdowns and unnecessary redraws, and in the worst case app hangs as the layout 'loops' as new closures are created and set to the focused values key.

Triggers solve this by only passing around a value type with a well-defined identity:

```swift
extension FocusedValues {
    @Entry var onShowHelloAlert: Binding<Trigger>?
}

// …

struct ContentView: View {
    @State var onShowHelloAlert = Trigger()
    @State var isPresentingHelloAlert = false

    // …

    var body: some View {
        MainWindowControls()
            .focusedSceneValue(\.onShowHelloAlert, $onShowHelloAlert)
            .onTrigger(onShowHelloAlert) {
                self.isPresentingHelloAlert = true
            }
            // …
        }
    }
}
```

A command can invoke a trigger by using a syntax very similar to a closure's:

```swift
struct ShowHelloAlertCommand: Commands {
    @FocusedValue(\.onShowHelloAlert)
    var onShowHelloAlert
    
    var body: some Commands {
        CommandGroup(after: .importExport) {
            Section {
                Button("Show Hello Alert") {
                    onShowHelloAlert?()
                }
                .disabled(onShowHelloAlert == nil)
            }
        }
    }
}
```

This library also supports _parametrized_ triggers, which allow not just to detect requests, but also pass parameters along:

```swift
extension FocusedValues {
    @Entry var onShowErrorAlert: Binding<
        ParametrizedTrigger</* _ error: */ any Error, /* _ retry: */ () -> Void>
    >?
}

// …

// In a view:
struct ContentView: View {
    @FocusedValue(\.onShowErrorAlert)
    var onShowErrorAlert
    
    var body: some View {
        MainWindowControls()
            .onTrigger(onShowErrorAlert) { error, retry in
                // …
                if canRetry(for: error) {
                    retry()
                }
                // …
            }
            // …
    }
}
```

## Topics

### Create & Use Triggers

- ``Trigger``
- ``ParametrizedTrigger``
- ``SwiftUICore/View/onTrigger(_:perform:)-(_,()->Void)``
- ``onTrigger(_:perform:)-(_,()->Void)``
- ``SwiftUICore/View/onTrigger(_:perform:)-(_,()->Void)``
- ``onTrigger(_:perform:)-(_,((Argument))->Void)``
