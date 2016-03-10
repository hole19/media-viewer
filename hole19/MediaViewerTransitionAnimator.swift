
import UIKit

class MediaViewerTransitionAnimator: NSObject {
   
    // MARK: properties
    
    var sourceImageView: UIImageView!
    var contentsView: MediaViewerContentsView!
    
    // MARK: init
    
    init(sourceImageView: UIImageView, contentsView: MediaViewerContentsView) {
        super.init()
        self.sourceImageView = sourceImageView
        self.contentsView = contentsView
    }
    
    // MARK: public
    
    func setupTransitionToDestinationImageView() {
        contentsView.backgroundView?.alpha = 0.0
        guard let destinationSuperview = contentsView.imageView.superview, let sourceSuperview = sourceImageView.superview else { return }
        let sourceImageViewFrame = destinationSuperview.convertRect(sourceImageView.frame, fromView: sourceSuperview)
        contentsView.imageView.frame = sourceImageViewFrame
        contentsView.imageView.alpha = 1.0
    }
    
    func transitionToDestinationImageView(animated: Bool, withCompletition completition: () -> (Void) = {}) {
        let duration: NSTimeInterval = animated ? 0.5 : 0.00
        setupTransitionToDestinationImageView()
        UIView.animateWithDuration(duration, delay: duration, options: UIViewAnimationOptions.CurveEaseIn, animations: { () -> Void in
            self.contentsView.backgroundView?.alpha = 1.0
            self.contentsView.closeButton?.alpha = 1.0
            }) { (finished) -> Void in
                UIView.animateWithDuration(duration, delay: 0.0, usingSpringWithDamping: 0.1, initialSpringVelocity: 1.0, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
                    self.contentsView.imageView.frame = self.contentsView.bounds
                    self.contentsView.imageView.contentMode = .ScaleAspectFit
                    }) { (finished) -> Void in
                        completition()
                        print(self.contentsView.imageView)
                }
        }
    }
    
    // MARK: private

}
