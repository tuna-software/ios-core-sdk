// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Tuna",
    platforms: [
        .macOS(.v10_15),
        .iOS(.v10),
        .tvOS(.v10),
		.watchOS(.v6)
    ],
    products: [
        .library(
            name: "Tuna",
            targets: ["Tuna"]),
        .library(
            name: "TunaDynamic",
            type: .dynamic,
            targets: ["Tuna"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "Tuna",
            dependencies: [],
			path: "Tuna/Tuna"),
        .testTarget(
            name: "TunaTests",
            dependencies: ["Tuna"],
			path: "Tuna/TunaTests"),
    ]
)
