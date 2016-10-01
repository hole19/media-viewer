import UIKit

class MockScrollView: UIScrollView {

    var numberOfTimesSetZoomScaleWasCalled = 0
    var animatedValueOfSetZoomScale = false

    var rectValueOfSetZoomToRect = CGRect.zero
    var animatedValueOfSetZoomToRect = false
    var numberOfTimesZoomToRectWasCalled = 0

    override func setZoomScale(_ scale: CGFloat, animated: Bool) {
        numberOfTimesSetZoomScaleWasCalled += 1
        animatedValueOfSetZoomScale = animated
    }

    override func zoom(to rect: CGRect, animated: Bool) {
        rectValueOfSetZoomToRect = rect
        animatedValueOfSetZoomToRect = animated
        numberOfTimesZoomToRectWasCalled += 1
    }
}
