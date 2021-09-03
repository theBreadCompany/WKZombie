// swift-tools-version:5.2.0
import PackageDescription

let package = Package(
  name: "WKZombieRevised",
  targets: [
      Target(name: "WKZombieRevised"),
      Target(name: "Example", dependencies:["WKZombieRevised"])
  ],
  dependencies: [
	   .Package(url: "https://github.com/mkoehnke/hpple.git", Version(0,2,2))
  ]
)
