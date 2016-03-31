
import UIKit

class MediaViewerTransitionAnimator: NSObject {
   
    // MARK: properties
    
    var animationTime: NSTimeInterval = 0.25
    
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
        self.contentsView.interfaceAlpha = 0.0
        guard let destinationSuperview = contentsView.interactiveImageView.imageView.superview, let sourceSuperview = sourceImageView.superview else { return }
        let sourceImageViewFrame = destinationSuperview.convertRect(sourceImageView.frame, fromView: sourceSuperview)
        contentsView.interactiveImageView.imageView.frame = sourceImageViewFrame
        contentsView.interactiveImageView.imageView.alpha = 1.0
        sourceImageView.hidden = true
        contentsView.interactiveImageView.imageView.contentMode = .ScaleAspectFill
    }
    
    func transitionToDestinationImageView(animated: Bool, withCompletition completition: () -> (Void) = {}) {
        let duration: NSTimeInterval = animated ? animationTime : 0.00
        setupTransitionToDestinationImageView()
        let endImageFrame = endImageViewFrameForTransitionIn()
        self.contentsView.interactiveImageView?.alpha = 1.0

        UIView.animateWithDuration(duration, delay: duration, options: UIViewAnimationOptions.CurveEaseIn, animations: { () -> Void in
            self.contentsView.interfaceAlpha = 1.0
            self.contentsView.interactiveImageView.imageView.frame = endImageFrame
            }) { (finished) -> Void in
                self.contentsView.interactiveImageView.imageView.contentMode = UIViewContentMode.ScaleAspectFit
                completition()
        }
    }
    
    func setupTransitionBackToSourceImageView() {
        sourceImageView.hidden = true
        contentsView.interactiveImageView.imageView.contentMode = .ScaleAspectFill
    }

    func transitionBackToSourceImageView(animated: Bool, withCompletition completition: () -> (Void) = {}) {
        guard let currentSuperview = contentsView.interactiveImageView.imageView.superview, let sourceSuperview = sourceImageView.superview else { return }
        let endImageFrame = currentSuperview.convertRect(sourceImageView.frame, fromView: sourceSuperview)

        let duration: NSTimeInterval = animated ? animationTime : 0.00
        setupTransitionBackToSourceImageView()
        UIView.animateWithDuration(duration, delay: duration, options: UIViewAnimationOptions.CurveEaseIn, animations: { () -> Void in
            self.contentsView.interfaceAlpha = 0.0
            self.contentsView.interactiveImageView.imageView.frame = endImageFrame
            }) { (finished) -> Void in
                self.sourceImageView.hidden = false
                completition()
        }
    }
    
    // MARK: private
    
    func endImageViewFrameForTransitionIn() -> CGRect {
        let imageSize = sourceImageView.image != nil ? sourceImageView.image!.size : contentsView.bounds.size
        let aspectRatio = imageSize.height / imageSize.width
        let actualImageHeight = contentsView.bounds.size.width * aspectRatio
        let endImageFrameOriginY = (contentsView.bounds.size.height - actualImageHeight) / 2.0
        return CGRectMake(contentsView.bounds.origin.x, endImageFrameOriginY, contentsView.bounds.size.width, actualImageHeight)
    }
}
