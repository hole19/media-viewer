
import UIKit

class MediaViewerTransitionAnimator: NSObject {
   
    // MARK: properties
    
    var sourceImageView: UIImageView!
    var destinationImageView: UIImageView!
    var backgroundView: UIView?
    
    // MARK: init
    
    init(sourceImageView: UIImageView, destinationImageView: UIImageView, backgroundView: UIView?) {
        super.init()
        self.sourceImageView = sourceImageView
        self.destinationImageView = destinationImageView
        self.backgroundView = backgroundView
    }
    
    // MARK: public
    
    func setupTransitionToDestinationImageView() -> CGRect {
        backgroundView?.alpha = 0.0
        guard let destinationSuperview = destinationImageView.superview, let sourceSuperview = sourceImageView.superview else { return destinationImageView.frame }
        let sourceImageViewFrame = destinationSuperview.convertRect(sourceImageView.frame, fromView: sourceSuperview)
        let destinationImageViewFrame = destinationImageView.frame
        destinationImageView.frame = sourceImageViewFrame
        return destinationImageViewFrame
    }
    
    func transitionToDestinationImageView(animated: Bool, withCompletition completition: () -> (Void) = {}) {
        let duration: NSTimeInterval = animated ? 0.00 : 0.28
        let destinationImageViewFrame = setupTransitionToDestinationImageView()
        UIView.animateWithDuration(duration, delay: 0.0, usingSpringWithDamping: 0.1, initialSpringVelocity: 1.0, options: UIViewAnimationOptions.CurveEaseIn, animations: { () -> Void in
            self.destinationImageView.frame = destinationImageViewFrame
            }) { (finished) -> Void in }
        UIView.animateWithDuration(duration, delay: duration, options: UIViewAnimationOptions.BeginFromCurrentState, animations: { () -> Void in
            self.backgroundView?.alpha = 1.0
            }) { (finished) -> Void in
                completition()
        }
    }
    
    // MARK: private

}
