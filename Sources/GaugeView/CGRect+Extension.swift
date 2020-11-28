
import UIKit

extension CGRect {
    var center: CGPoint {
        CGPoint(x: width / 2 + origin.x, y: height / 2 + origin.y)
    }

    func inclosingRect() -> CGRect {
        let minValue = min(height, width)
        let rect = CGRect(
            x: (width - minValue) / 2,
            y: (height - minValue) / 2,
            width: minValue,
            height: minValue
        )
        return rect
    }
}
