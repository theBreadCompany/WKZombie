// swift-tools-version:5.2.0

let package = Package(
  name: "WKZombieRevised",
  dependencies: [
	   .package(url: "https://github.com/mkoehnke/hpple.git", .branch("spm"))
  ],
  targets: [
      .target(name: "WKZombieRevised"),
      .target(name: "Example", dependencies:["WKZombieRevised"])
  ]
)
