
# SwiftUI Triggers

*The fanciest wrapper around `Bool.toggle()` that you've ever seen…*

It is easy in a SwiftUI or reactive Swift application to pass around closures to trigger behavior in one part of the app from another. For example, a `FocusedValue` entry could be a closure, and invoking that closure from a `Command…` implementation (like a menu item) could work to affect the current window.

However, this is not efficient. Closures are recreated as views are evaluated, and changing a focused value can have then cascading effects, requiring a reevaluation of the full app dependency tree. This can produce large effects or 'layout loops' in the application that are hard to diagnose or debug.

This package defines _triggers_. A `Trigger` is a lightweight value that can take the place of those closures, and is only meaningful insofar as it changes over time. It can be invoked just like a closure can, triggering a change that the SwiftUI and Observation frameworks can detect:

```swift
extension FocusedValue {
    @Entry var onPrintToLabelPrinter: Binding<Trigger>?
}

struct PrintCommand: Commands {
    @FocusedValue(\.onPrintToLabelPrinter)
    var onPrintToLabelPrinter

    var body: some Commands {
        CommandGroup(after: .importExport) {
            Button("Print to Label Printer…") {
                onPrintToLabelPrinter?()
            }
            .disabled(onPrintToLabelPrinter == nil)
        }
    }
}
``` 

A view can then offer to handle that view by hosting the trigger in its own state, and using the `onTrigger` modifier:

```swift
    @State var onPrintToLabelPrinter = Trigger()
    
    // …
    
    var body: some View {
        /* some view content */
        .onTrigger(onPrintToLabelPrinter) {
            // Handle the invocation.
        }
        .focusedSceneValue(\.onPrintToLabelPrinter, $onPrintToLabelPrinter)
    }
```

This replaces similar idioms where `onPrintToLabelPrinter` would be defined as a `() -> Void` closure, fixing this performance issue without sacrificing ease of use.

This package also defines a similar type, `ParametrizedTrigger`, that can receive and pass arguments in its invocation. It can receive and pass on any number of arguments. For example:


```swift
enum TabID: Hashable {
    case home
    case search
}

extension FocusedValue {
    @Entry var onSwitchTab: Binding<ParametrizedTrigger<TabID>>?
}

struct PrintCommand: Commands {
    @FocusedValue(\.onSwitchTab)
    var onSwitchTab

    var body: some Commands {
        CommandGroup(after: .toolbar) {
            Section {
                Button("Go Home") {
                    onSwitchTab?(.home)
                }
                Button("Show Search") {
                    onSwitchTab?(.search)
                }
            }
            .disabled(onSwitchTab == nil)
        }
    }
}
``` 

A view could then handle it as follows:

```swift
    @State var onSwitchTab = ParametrizedTrigger(arguments: TabID.self)
    
    // …
    
    var body: some View {
        /* some view content */
        .onTrigger(onSwitchTab) { tab in
            // Switch to the provided `tab`…
        }
        .focusedSceneValue(\.onSwitchTab, $onSwitchTab)
    }
```

