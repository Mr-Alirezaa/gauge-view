
import UIKit


/// `GaugeView` is a minimal gauge which has no indicator. instead dials colors will change whenever progress happens.
/// `GaugeView` supports showing a dial differnty as a limit.
public class GaugeView: UIView {

    /// Size of normal dials.
    public var dialSize = CGSize(width: 14, height: 3) { didSet { setupLayers() } }

    /// Size of the dial that shows the limit
    public var limitDialSize = CGSize(width: 14, height: 3) { didSet { setupLayers() } }

    /// Color of normal dial.
    public var dialColor: UIColor = .gray { didSet { recolorDials() } }

    /// Color of dials that are below the progress value.
    public var passedDialColor: UIColor = .green { didSet { recolorDials() } }

    /// Color of dial which shows the limit.
    public var limitDialColor: UIColor = .red { didSet { recolorDials() } }

    /// Number of parts that the desired angle is divided to.
    public var partsCount = 60 { didSet { setupLayers() } }

    /// The range of angles that gauge uses.
    public var angleRange: ClosedRange<CGFloat> = (CGFloat.pi * 5 / 6)...CGFloat.pi * 13 / 6 { didSet { setupLayers() } }

    /// Progress of the gauge. Dials below the progress have different appearance.
    public var progress: Double {
        get { _progress }
        set { _progress = newValue; recolorDials() }
    }

    /// Limit value of the gauge.
    public var limit: Double = 0.5 { didSet { setupLayers() } }

    // MARK: Private variables

    private var limitDialOffset: Int { Int((limit * Double(partsCount + 1)).rounded(.down)) }
    private var activeDialsCount: Int { Int((progress * Double(partsCount + 1)).rounded(.down)) }

    private var _progress: Double = 0.5

    // MARK: Layers

    private var gaugeLayer: CALayer = CALayer()
    private var dialsLayers: [CAShapeLayer] = []

    // MARK: Public functions

    /// Initiates a `GuageView` with the specified frame. Gauge will be placed in the inclosing circle.
    ///
    /// - Parameter frame: The frame of the view.
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayers()
    }

    /// Initiates a GaugeView from nib.
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupLayers()
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
    }

    /// Updates the progress of the `GaugeView` with an animation.
    ///
    /// - Parameters:
    ///   - progress: The new progress value.
    ///   - duration: Duration of the animation.
    public func setProgressAnimated(_ progress: Double, duration: TimeInterval) {
        let currentActiveDialsCount = activeDialsCount

        let activeDialsCount = Int((progress * Double(partsCount + 1)).rounded(.down))

        self._progress = progress

        let changedCount = activeDialsCount - currentActiveDialsCount
        if changedCount >= 0 {
            for offset in (currentActiveDialsCount..<activeDialsCount) {
                let dialLayer = dialsLayers[offset]
                let animation = CABasicAnimation(keyPath: "fillColor")
                let duration = duration / Double(changedCount)
                animation.toValue = fillColorFor(dialAt: offset).cgColor
                animation.duration = duration
                animation.beginTime = CACurrentMediaTime() + Double(offset - currentActiveDialsCount) * duration
                animation.fillMode = .both
                animation.isRemovedOnCompletion = false
                animation.timingFunction = CAMediaTimingFunction(name: .default)
                dialLayer.add(animation, forKey: nil)
            }
        } else {
            for offset in (activeDialsCount..<currentActiveDialsCount).reversed() {
                let dialLayer = dialsLayers[offset]
                let animation = CABasicAnimation(keyPath: "fillColor")
                let duration = duration / Double(changedCount)
                animation.toValue = fillColorFor(dialAt: offset).cgColor
                animation.duration = duration
                animation.beginTime = CACurrentMediaTime() + Double(activeDialsCount - offset) * duration
                animation.repeatCount = 0
                animation.timingFunction = CAMediaTimingFunction(name: .default)
                dialLayer.add(animation, forKey: "fillColor")
            }
        }
    }

    // MARK: Design functions

    private func setupLayers() {
        gaugeLayer.removeFromSuperlayer()
        gaugeLayer.sublayers?.forEach { $0.removeFromSuperlayer() }
        let frame = bounds.inclosingRect()
        gaugeLayer.frame = frame
        layer.addSublayer(gaugeLayer)

        dialsLayers = []

        for offset in 0...partsCount {
            let dialLayer = makeDialLayer(offset: offset)
            dialsLayers.append(dialLayer)
            gaugeLayer.addSublayer(dialLayer)
            dialLayer.position = positionFor(dialAt: offset)
        }
    }

    private func recolorDials() {
        dialsLayers
            .enumerated()
            .forEach { $0.element.fillColor = self.fillColorFor(dialAt: $0.offset).cgColor }
    }

    private func makeDialLayer(offset: Int) -> CAShapeLayer {
        let layer = CAShapeLayer()
        let frame = frameFor(dialAt: offset)
        layer.frame = frame
        layer.path = UIBezierPath(roundedRect: frame, cornerRadius: frame.height / 2).cgPath

        layer.transform = transformFor(dialAt: offset)
        layer.fillColor = fillColorFor(dialAt: offset).cgColor
        return layer
    }

    private func angleFor(
        dialAt offset: Int
    ) -> CGFloat {
        CGFloat(offset) / CGFloat(partsCount) * (angleRange.upperBound - angleRange.lowerBound) + angleRange.lowerBound
    }

    private func positionFor(dialAt offset: Int) -> CGPoint {
        let angle: CGFloat = angleFor(dialAt: offset)
        let radius: CGFloat = radiusFor(dialAt: offset)
        let center: CGPoint = gaugeLayer.frame.center
        return CGPoint(x: center.x + radius * cos(angle), y: center.y + radius * sin(angle))
    }

    private func frameFor(dialAt offset: Int) -> CGRect {
        if offset == limitDialOffset {
            return CGRect(origin: .zero, size: limitDialSize)
        } else {
            return CGRect(origin: .zero, size: dialSize)
        }
    }

    private func transformFor(dialAt offset: Int) -> CATransform3D {
        CATransform3DMakeRotation(angleFor(dialAt: offset), 0, 0, 1)
    }

    private func fillColorFor(dialAt offset: Int) -> UIColor {
        switch offset {
        case limitDialOffset:
            return limitDialColor
        case 0..<activeDialsCount:
            return passedDialColor
        default:
            return dialColor
        }
    }

    private func radiusFor(dialAt offset: Int) -> CGFloat {
        let dialWidth = max(dialSize.width, limitDialSize.width)
        return gaugeLayer.frame.height / 2 - dialWidth / 2
    }
}
