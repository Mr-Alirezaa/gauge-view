//: A UIKit based Playground for presenting user interface
  
import UIKit
import PlaygroundSupport
import GaugeView

//: This is a really small sample to show how GaugeView is setup and used.

let gaugeView = GaugeView(frame: CGRect(x: 0, y: 0, width: 300, height: 300))

gaugeView.partsCount = 40
gaugeView.angleRange = (CGFloat.pi * 5 / 6)...(CGFloat.pi * 13 / 6)
gaugeView.dialSize = CGSize(width: 15, height: 4)
gaugeView.limitDialSize = CGSize(width: 20, height: 4)

gaugeView.dialColor = UIColor(red: 217 / 255, green: 229 / 255, blue: 214 / 255, alpha: 1)
gaugeView.passedDialColor = UIColor(red: 15 / 255, green: 163 / 255, blue: 177 / 255, alpha: 1)
gaugeView.limitDialColor = UIColor(red: 255 / 255, green: 155 / 255, blue: 66 / 255, alpha: 1)
gaugeView.limit = 0.5
gaugeView.progress = 0.4

PlaygroundPage.current.liveView = gaugeView

DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
    gaugeView.passedDialColor = .blue
}

DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
    gaugeView.setProgressAnimated(0.7, duration: 1)
}
