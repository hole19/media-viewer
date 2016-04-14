
import UIKit

class MockScrollView: UIScrollView {
    
    var numberOfTimesSetZoomScaleWasCalled = 0
    var animatedValueOfSetZoomScale = false
    
    var rectValueOfSetZoomToRect = CGRectZero
    var animatedValueOfSetZoomToRect = false
    var numberOfTimesZoomToRectWasCalled = 0

    override func setZoomScale(scale: CGFloat, animated: Bool) {
        numberOfTimesSetZoomScaleWasCalled += 1
        animatedValueOfSetZoomScale = animated
    }
    
    override func zoomToRect(rect: CGRect, animated: Bool) {
        rectValueOfSetZoomToRect = rect
        animatedValueOfSetZoomToRect = animated
        numberOfTimesZoomToRectWasCalled += 1
    }
}

