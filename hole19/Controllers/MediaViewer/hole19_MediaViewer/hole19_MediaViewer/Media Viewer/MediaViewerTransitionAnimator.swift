
import UIKit

class MediaViewerTransitionAnimator: NSObject {
   
    // MARK: properties
    
    var animationTime: NSTimeInterval = 0.2
    
    var sourceImageView: UIImageView?
    var contentsView: MediaViewerContentsView!
    
    var transitionDelegate: MediaViewerDelegate?
    
    // MARK: init
    
    init(sourceImageView: UIImageView?, contentsView: MediaViewerContentsView, transitionDelegate: MediaViewerDelegate? = nil) {
        super.init()
        self.sourceImageView = sourceImageView
        self.contentsView = contentsView
        self.transitionDelegate = transitionDelegate
    }
    
    // MARK: public
    
    func setupTransitionToDestinationImageView() {
        self.contentsView.interfaceAlpha = 0.0
        guard let currentImageView = contentsView.scrollView.currentImageView(),
              let destinationSuperview = currentImageView.imageView.superview else { return }
        var sourceImageViewFrame = CGRectZero
        if let sourceImageView = sourceImageView, let sourceSuperview = sourceImageView.superview {
            sourceImageViewFrame = destinationSuperview.convertRect(sourceImageView.frame, fromView: sourceSuperview)
        } else {
            sourceImageViewFrame = currentImageView.frame
            sourceImageViewFrame.origin.y += currentImageView.frame.size.height
        }
        currentImageView.imageView.frame = sourceImageViewFrame
        currentImageView.imageView.alpha = 1.0
        sourceImageView?.hidden = true
        currentImageView.imageView.contentMode = .ScaleAspectFill
    }
    
    func transitionToDestinationImageView(animated: Bool, withCompletition completition: () -> (Void) = {}) {
        guard let currentImageView = contentsView.scrollView.currentImageView() else { return }
        let duration: NSTimeInterval = animated ? animationTime : 0.00
        let center = currentImageView.imageView.center
        setupTransitionToDestinationImageView()
        let endImageFrame = frameToScaleAspectFitBoundToFrame(currentImageView.bounds, img: currentImageView.imageView)
        self.contentsView.scrollView.alpha = 1.0
        UIView.animateWithDuration(duration, delay: 0.0, options: UIViewAnimationOptions.CurveEaseIn, animations: { () -> Void in
            self.contentsView.interfaceAlpha = 1.0
            currentImageView.imageView.frame = endImageFrame
            currentImageView.imageView.center = center
            }) { (finished) -> Void in
                currentImageView.imageView.contentMode = UIViewContentMode.ScaleAspectFit
                currentImageView.imageView.frame = CGRectMake(0.0, 0.0, self.contentsView.bounds.size.width, self.contentsView.bounds.size.height)
                completition()
        }
    }
    
    func setupTransitionBackToSourceImageView(withImageView imageView: UIImageView?) {
        imageView?.hidden = true
    }

    func transitionBackToSourceImageView(animated: Bool, withCompletition completition: () -> (Void) = {}) {
        guard let currentImageView = contentsView.scrollView.currentImageView(),
              let currentSuperview = currentImageView.imageView.superview else { return }
        
        var endImageFrame = CGRectZero
        var sourceImage = sourceImageView
        if let transitionDelegate = transitionDelegate,
           let image = currentImageView.imageModel,
           let imageView = transitionDelegate.imageViewForImage(image),
           let newSourceSuperview = imageView.superview {

            endImageFrame = currentSuperview.convertRect(imageView.frame, fromView: newSourceSuperview)
            sourceImage = imageView
            sourceImageView?.hidden = false
            
        } else if let image = currentImageView.imageModel, let sourceImageView = sourceImageView, let sourceSuperview = sourceImageView.superview where image.sourceImageView === sourceImageView {
            endImageFrame = currentSuperview.convertRect(sourceImageView.frame, fromView: sourceSuperview)
        } else {
            sourceImage = nil
            endImageFrame = currentImageView.frame
            endImageFrame.origin.x = 0
            endImageFrame.origin.y = currentImageView.frame.size.height
        }
        
        let duration: NSTimeInterval = animated ? animationTime : 0.00
        setupTransitionBackToSourceImageView(withImageView: sourceImage)
        let center = currentImageView.imageView.center
        currentImageView.imageView.frame = frameToScaleAspectFit(currentImageView.imageView)
        currentImageView.imageView.center = center
        currentImageView.imageView.contentMode = .ScaleAspectFill

        UIView.animateWithDuration(duration, delay: 0.0, options: UIViewAnimationOptions.CurveEaseIn, animations: { () -> Void in
            self.contentsView.interfaceAlpha = 0.0
            currentImageView.imageView.frame = endImageFrame
            }) { (finished) -> Void in
                sourceImage?.hidden = false
                completition()
        }
    }
    
    // MARK: private
    
    private func frameToScaleAspectFit(img: UIImageView) -> CGRect {
        guard let image = img.image where image.size.width > 0 && image.size.height > 0 else { return CGRectZero }
        
        let ratioImg = (image.size.width) / (image.size.height)
        let ratioSelf = (img.frame.size.width) / (img.frame.size.height);
        
        if ratioSelf < 1 {
            return CGRectMake(0, 0, img.frame.size.width, img.frame.size.width * 1.0/ratioImg)
        } else {
            return CGRectMake(0, 0, img.frame.size.height * ratioImg, img.frame.size.height)
        }
    }
    
    private func frameToScaleAspectFitBoundToFrame(newFrame: CGRect, img: UIImageView) -> CGRect {
        guard let image = img.image where image.size.width > 0 && image.size.height > 0 else { return CGRectZero }
        
        let ratioImg = (image.size.width) / (image.size.height)
        let ratioSelf = (newFrame.size.width) / (newFrame.size.height);
        
        if ratioSelf < 1 {
            return CGRectMake(0, 0, newFrame.size.width, newFrame.size.width * 1.0/ratioImg)
        } else {
            return CGRectMake(0, 0, newFrame.size.height * ratioImg, newFrame.size.height)
        }
    }

}
