// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Nimbus",
	platforms: [
		.iOS(.v15)
	],
    products: [
        .library(
            name: "Nimbus",
            targets: ["Nimbus"]),
    ],
    dependencies: [
		.package(url: "https://github.com/jacobcaraballo/uikit-previews.git", branch: "master"),
		.package(url: "https://github.com/lukaskubanek/LoremSwiftum.git", branch: "master"),
    ],
    targets: [
        .target(
            name: "Nimbus",
            dependencies: [
				.product(name: "UIKitPreviews", package: "uikit-previews"),
				"LoremSwiftum"
			],
			resources: [.process("Resources")]
		),
        .testTarget(
            name: "NimbusTests",
            dependencies: ["Nimbus"]),
    ]
)
