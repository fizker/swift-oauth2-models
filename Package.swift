// swift-tools-version:5.5
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
