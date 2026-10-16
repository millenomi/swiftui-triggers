// swift-tools-version: 6.3

import PackageDescription
import Foundation

let enablePlayground = {
    let environment = ProcessInfo.processInfo.environment
    
    return environment["__CFBundleIdentifier"] == "com.apple.dt.Xcode" ||
        (environment["MN_ALLOW_PACKAGE_PLAYGROUNDS"] as? NSString)?.boolValue == true
}()

// -----
let playgroundProducts: [Product] = [
    .library(
        name: "_SwiftUITriggers_Playground",
        targets: ["_SwiftUITriggers_Playground"],
    ),
    .executable(
        name: "_SwiftUITriggers_Scratchpad",
        targets: ["_SwiftUITriggers_Scratchpad"],
    ),
]

let playgroundTargets: [Target] = [
    .target(
        name: "_SwiftUITriggers_Playground",
        dependencies: ["SwiftUITriggers"],
        swiftSettings: [
            .enableUpcomingFeature("ApproachableConcurrency"),
        ],
    ),
    .executableTarget(
        name: "_SwiftUITriggers_Scratchpad",
        dependencies: ["SwiftUITriggers"],
        swiftSettings: [
            .enableUpcomingFeature("ApproachableConcurrency"),
        ],
    ),
]
// -----

let package = Package(
    name: "SwiftUITriggers",
    platforms: [
        .macOS(.v26),
        .iOS(.v26),
        .watchOS(.v26),
        .tvOS(.v26),
        .visionOS(.v26),
    ],
    products: [
        .library(
            name: "SwiftUITriggers",
            targets: ["SwiftUITriggers"],
        ),
    ] + (enablePlayground ? playgroundProducts : []),
    targets: [
        .target(
            name: "SwiftUITriggers",
            swiftSettings: [
                .enableUpcomingFeature("ApproachableConcurrency"),
            ],
        ),
        .testTarget(
            name: "SwiftUITriggersTests",
            dependencies: [
                "SwiftUITriggers",
            ],
            swiftSettings: [
                .enableUpcomingFeature("ApproachableConcurrency"),
            ],
        ),
    ] + (enablePlayground ? playgroundTargets : []),
)
