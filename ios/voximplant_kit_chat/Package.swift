// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "voximplant_kit_chat",
    platforms: [
        .iOS("13.0")
    ],
    products: [
        .library(name: "voximplant-kit-chat", targets: ["voximplant_kit_chat"])
    ],
    dependencies: [
        .package(url: "https://github.com/voximplant/ios-kit-chat-ui-sdk-releases.git", .upToNextMinor(from: "1.6.0"))
    ],
    targets: [
        .target(
            name: "voximplant_kit_chat",
            dependencies: [
                .product(name: "VoximplantKitChatUI", package: "ios-kit-chat-ui-sdk-releases"),
            ],
            resources: [
                .process("PrivacyInfo.xcprivacy"),
            ],
        )
    ]
)
