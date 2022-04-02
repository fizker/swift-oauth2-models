// swift-tools-version:5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
	name: "swift-oauth2-models",
	products: [
		.library(
			name: "OAuth2Models",
			targets: ["OAuth2Models"]
		),
	],
	dependencies: [
		.package(url: "https://github.com/apple/swift-docc-plugin", from: "1.0.0"),
	],
	targets: [
		.target(
			name: "OAuth2Models",
			dependencies: []
		),
		.testTarget(
			name: "OAuth2ModelsTests",
			dependencies: ["OAuth2Models"]
		),
	]
)
