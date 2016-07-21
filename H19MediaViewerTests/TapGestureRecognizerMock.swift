
import UIKit

class TapGestureRecogniserMock: UITapGestureRecognizer {
    
    // settable properties
    
    var locationInViewToReturn = CGPoint.zero
    
    override func location(in view: UIView?) -> CGPoint {
        return locationInViewToReturn
    }
    
    var requireGestureRecognizerToFailCallCount = 0
    var requireGestureRecognizerToFailRecogniser: UIGestureRecognizer?

    override func require(toFail otherGestureRecognizer: UIGestureRecognizer) {
        requireGestureRecognizerToFailCallCount += 1
        requireGestureRecognizerToFailRecogniser = otherGestureRecognizer
    }
}
