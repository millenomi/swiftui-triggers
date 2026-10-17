
import SwiftUI
import SwiftUITriggers

enum TestViewContent {}

struct ContentView: View {
    @Binding var onSceneTrigger: Trigger
    let sceneTriggerCount: Int
    let sceneTriggerWithSourceCount: Int
    
    @Binding var onParametrizedSceneTrigger: ParametrizedTrigger<String, Int>
    @Binding var onParametrizedSceneTriggerWithSource: ParametrizedTrigger<String, Int>
    let parametrizedSceneTriggerCount: Int
    let latestParametrizedSceneTriggerArguments: (String, Int)?
    
    @Binding var onCustomParametrizedSceneTrigger: CustomParametrizedTrigger
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    let test = Tests.current
                    
                    GroupBox {
                        VStack {
                            Text(test.rawValue)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                                .padding(2)
                            
                            switch test {
                            case .testInvokingTriggerExecutesModifierClosure:
                                TestViewContent.testInvokingTriggerExecutesModifierClosure()
                            case .testInvokingTriggerExecutesModifierClosureWithSource:
                                TestViewContent.testInvokingTriggerExecutesModifierClosureWithSource()
                            case .testInvokingParametrizedTriggerExecutesModifierClosure:
                                TestViewContent.testInvokingParametrizedTriggerExecutesModifierClosure()
                            case .testInvokingCustomParametrizedTriggerExecutesModifierClosure:
                                TestViewContent.testInvokingCustomParametrizedTriggerExecutesModifierClosure()
                                
                            case .testInvokingTriggerExecutesSceneModifierClosure:
                                TestViewContent.testInvokingTriggerExecutesSceneModifierClosure(
                                    onSceneTrigger: $onSceneTrigger,
                                    sceneTriggerCount: sceneTriggerCount,
                                )
                            case .testInvokingTriggerExecutesSceneModifierClosureWithSource:
                                TestViewContent.testInvokingTriggerExecutesSceneModifierClosureWithSource(
                                    onSceneTrigger: $onSceneTrigger,
                                    sceneTriggerWithSourceCount: sceneTriggerWithSourceCount,
                                )
                            case .testInvokingParametrizedTriggerExecutesSceneModifierClosure:
                                TestViewContent.testInvokingParametrizedTriggerExecutesSceneModifierClosure(
                                    onParametrizedSceneTrigger: $onParametrizedSceneTrigger,
                                    parametrizedSceneTriggerCount: parametrizedSceneTriggerCount,
                                    latestParametrizedSceneTriggerArguments: latestParametrizedSceneTriggerArguments,
                                )
                            case .testInvokingParametrizedTriggerExecutesSceneModifierClosureWithSource:
                                TestViewContent.testInvokingParametrizedTriggerExecutesSceneModifierClosureWithSource(
                                    onParametrizedSceneTriggerWithSource: $onParametrizedSceneTriggerWithSource,
                                    parametrizedSceneTriggerCount: parametrizedSceneTriggerCount,
                                    latestParametrizedSceneTriggerArguments: latestParametrizedSceneTriggerArguments,
                                )
                            case .testInvokingCustomParametrizedTriggerExecutesSceneModifierClosure:
                                TestViewContent.testInvokingCustomParametrizedTriggerExecutesSceneModifierClosure(
                                    onCustomParametrizedSceneTrigger: $onCustomParametrizedSceneTrigger,
                                    parametrizedSceneTriggerCount: parametrizedSceneTriggerCount,
                                    latestParametrizedSceneTriggerArguments: latestParametrizedSceneTriggerArguments,
                                )
                                
                            case .testTriggerCallAsFunctionThroughBinding:
                                TestViewContent.testTriggerCallAsFunctionThroughBinding()
                            case .testParametrizedTriggerCallAsFunctionThroughBinding:
                                TestViewContent.testParametrizedTriggerCallAsFunctionThroughBinding()
                            case .testParametrizedTriggerCallAsFunctionThroughBindingWithDirectArguments:
                                TestViewContent.testParametrizedTriggerCallAsFunctionThroughBindingWithDirectArguments()
                                
                            case .testInvokeTriggerWithFocusShorthand:
                                TestViewContent.testInvokeTriggerWithFocusShorthand()
                            case .testInvokeParametrizedTriggerWithFocusShorthand:
                                TestViewContent.testInvokeParametrizedTriggerWithFocusShorthand()
                            case .testInvokeTriggerWithSceneFocusShorthand:
                                TestViewContent.testInvokeTriggerWithSceneFocusShorthand()
                            case .testInvokeParametrizedTriggerWithSceneFocusShorthand:
                                TestViewContent.testInvokeParametrizedTriggerWithSceneFocusShorthand()
                            }
                        }
                    }
                }
            }
            .navigationTitle("UI Tests")
#if !os(macOS)
            .navigationBarTitleDisplayMode(.inline)
#endif
        }
    }
}

#Preview {
    ContentView(
        onSceneTrigger: .constant(Trigger()),
        sceneTriggerCount: 0,
        sceneTriggerWithSourceCount: 0,
        
        onParametrizedSceneTrigger: .constant(ParametrizedTrigger()),
        onParametrizedSceneTriggerWithSource: .constant(ParametrizedTrigger()),
        parametrizedSceneTriggerCount: 0,
        latestParametrizedSceneTriggerArguments: nil,
        
        onCustomParametrizedSceneTrigger: .constant(CustomParametrizedTrigger()),
    )
}
