
import SwiftUI
import SwiftUITriggers

@main struct MyApp: App {
    @State var onSceneTrigger = Trigger()
    @State var sceneTriggerCount = 0
    
    @State var sceneTriggerWithSourceCount = 0
    
    @State var onParametrizedSceneTrigger = ParametrizedTrigger(arguments: String.self, Int.self)
    @State var onParametrizedSceneTriggerWithSource = ParametrizedTrigger(arguments: String.self, Int.self)
    @State var parametrizedSceneTriggerCount = 0
    @State var latestParametrizedSceneTriggerArguments: (String, Int)?
    
    @State var onCustomParametrizedSceneTrigger = CustomParametrizedTrigger()
    
    var body: some Scene {
        WindowGroup {
            ContentView(
                onSceneTrigger: $onSceneTrigger,
                sceneTriggerCount: sceneTriggerCount,
                sceneTriggerWithSourceCount: sceneTriggerWithSourceCount,
                
                onParametrizedSceneTrigger: $onParametrizedSceneTrigger,
                onParametrizedSceneTriggerWithSource: $onParametrizedSceneTriggerWithSource,
                parametrizedSceneTriggerCount: parametrizedSceneTriggerCount,
                latestParametrizedSceneTriggerArguments: latestParametrizedSceneTriggerArguments,
                
                onCustomParametrizedSceneTrigger: $onCustomParametrizedSceneTrigger,
            )
        }
        .onTrigger(onSceneTrigger) {
            sceneTriggerCount += 1
        }
        .onTriggerWithSource(onSceneTrigger) { _ in
            sceneTriggerWithSourceCount += 1
        }
        .onTrigger(onParametrizedSceneTrigger) { string, int in
            self.parametrizedSceneTriggerCount += 1
            self.latestParametrizedSceneTriggerArguments = (string, int)
        }
        .onTriggerWithSource(onParametrizedSceneTriggerWithSource) { trigger in
            self.parametrizedSceneTriggerCount += 1
            self.latestParametrizedSceneTriggerArguments = (trigger.arguments.0, trigger.arguments.1)
        }
        .onTrigger(onCustomParametrizedSceneTrigger) { string, int in
            self.parametrizedSceneTriggerCount += 1
            self.latestParametrizedSceneTriggerArguments = (string, int)
        }
    }
}
