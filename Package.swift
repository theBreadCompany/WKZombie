// swift-tools-version:5.2.0
import PackageDescription
let package = Package(
  name: "WKZombieRevised",
products: [
	.library(name: "WKZombie", target: ["WKZombieRevised"])
],
  dependencies: [
	   .package(url: "https://github.com/mkoehnke/hpple.git", .branch("spm"))
  ],
  targets: [
      .target(name: "WKZombieRevised"),
      .target(name: "Example", dependencies:["WKZombieRevised"])
  ]
)
