// swift-tools-version:5.2.0
import PackageDescription
let package = Package(
  name: "WKZombie",
products: [
	.library(name: "WKZombie", targets: ["WKZombie"])
],
  dependencies: [
	   .package(url: "https://github.com/theBreadCompany/hpple.git", .branch("spm"))
  ],
  targets: [
      .target(name: "WKZombie", dependencies: ["hpple"]),
      .target(name: "Example", dependencies:["WKZombie"])
  ]
)
