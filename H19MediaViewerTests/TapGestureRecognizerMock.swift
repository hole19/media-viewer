
import UIKit

class TapGestureRecogniserMock: UITapGestureRecognizer {
    
    // settable properties
    
    var locationInViewToReturn = CGPointZero
    
    override func locationInView(view: UIView?) -> CGPoint {
        return locationInViewToReturn
    }
    
    var requireGestureRecognizerToFailCallCount = 0
    var requireGestureRecognizerToFailRecogniser: UIGestureRecognizer?

    override func requireGestureRecognizerToFail(otherGestureRecognizer: UIGestureRecognizer) {
        requireGestureRecognizerToFailCallCount += 1
        requireGestureRecognizerToFailRecogniser = otherGestureRecognizer
    }
}
