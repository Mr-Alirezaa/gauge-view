# Gauge

GaugeView is a project I created for one on my friends projects. Hope you use and enjoy it.

## How to install

### Swift Package Manager

The [Swift Package Manager](https://swift.org/package-manager/) is a tool for automating the distribution of Swift code and is integrated into the swift compiler.

Add the package to the `dependencies` of your project using the following line. 

```swift
dependencies: [
    .package(url: "https://github.com/Mr-Alirezaa/gauge-view.git", .upToNextMajor(from: "0.1.0"))
]
```

## Properties

### Main Properties

- `var progress: Double`: Progress of the gauge. Dials below the progress have different appearance.
- `var limit: Double`: Limit value of the gauge.

### UI Costumization

- `var dialSize: CGSize`: Size of normal dials.
- `var limitDialSize: CGSize` Size of the dial that shows the limit.
- `var dialColor: UIColor`: Color of normal dial.
- `var passedDialColor: UIColor`: Color of dials that are below the progress value.
- `var passedLimitDialColor: UIColor`: Color of dials that are below the progress value but greater than the limit.
- `var limitDialColor: UIColor`: Color of dial which shows the limit.
- `var partsCount: Int`: Number of parts that the desired angle is divided to.
- `var angleRange: ClosedRange<CGFloat>`: The range of angles that gauge uses.
