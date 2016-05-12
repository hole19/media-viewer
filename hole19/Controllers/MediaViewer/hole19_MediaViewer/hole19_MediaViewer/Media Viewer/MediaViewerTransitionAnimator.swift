
import UIKit

class MediaViewerTransitionAnimator: NSObject {
   
    // MARK: properties
    
    var animationTime: NSTimeInterval = 0.2
    
    var sourceImageView: UIImageView!
    var contentsView: MediaViewerContentsView!
    
    var transitionDelegate: MediaViewerTransitionDelegate?
    
    // MARK: init
    
    init(sourceImageView: UIImageView, contentsView: MediaViewerContentsView, transitionDelegate: MediaViewerTransitionDelegate? = nil) {
        super.init()
        self.sourceImageView = sourceImageView
        self.contentsView = contentsView
        self.transitionDelegate = transitionDelegate
    }
    
    // MARK: public
    
    func setupTransitionToDestinationImageView() {
        self.contentsView.interfaceAlpha = 0.0
        guard let currentImageView = contentsView.scrollView.currentImageView(),
              let destinationSuperview = currentImageView.imageView.superview, let sourceSuperview = sourceImageView.superview else { return }
        let sourceImageViewFrame = destinationSuperview.convertRect(sourceImageView.frame, fromView: sourceSuperview)
        currentImageView.imageView.frame = sourceImageViewFrame
        currentImageView.imageView.alpha = 1.0
        sourceImageView.hidden = true
        currentImageView.imageView.contentMode = .ScaleAspectFill
    }
    
    func transitionToDestinationImageView(animated: Bool, withCompletition completition: () -> (Void) = {}) {
        guard let currentImageView = contentsView.scrollView.currentImageView() else { return }

        let duration: NSTimeInterval = animated ? animationTime : 0.00
        setupTransitionToDestinationImageView()
        let endImageFrame = endImageViewFrameForTransitionIn()
        self.contentsView.scrollView.alpha = 1.0

        UIView.animateWithDuration(duration, delay: 0.0, options: UIViewAnimationOptions.CurveEaseIn, animations: { () -> Void in
            self.contentsView.interfaceAlpha = 1.0
            currentImageView.imageView.frame = endImageFrame
            }) { (finished) -> Void in
                currentImageView.imageView.contentMode = UIViewContentMode.ScaleAspectFit
                currentImageView.imageView.frame = CGRectMake(0.0, 0.0, self.contentsView.bounds.size.width, self.contentsView.bounds.size.height)
                completition()
        }
    }
    
    func setupTransitionBackToSourceImageView(withImageView: UIImageView) {
        withImageView.hidden = true
    }

    func transitionBackToSourceImageView(animated: Bool, withCompletition completition: () -> (Void) = {}) {
        guard let currentImageView = contentsView.scrollView.currentImageView(),
              let currentSuperview = currentImageView.imageView.superview,
              let sourceSuperview = sourceImageView.superview else { return }
        
        var endImageFrame = CGRectZero
        var sourceImage = sourceImageView
        if let transitionDelegate = transitionDelegate {
            let image = currentImageView.imageView.image!
            
            if let imageView = transitionDelegate.imageViewForImage(image), let newSourceSuperview = imageView.superview {
                endImageFrame = currentSuperview.convertRect(imageView.frame, fromView: newSourceSuperview)
                sourceImage = imageView
                sourceImageView.hidden = false
            }
        } else {
            endImageFrame = currentSuperview.convertRect(sourceImageView.frame, fromView: sourceSuperview)
        }
        
        let duration: NSTimeInterval = animated ? animationTime : 0.00
        setupTransitionBackToSourceImageView(sourceImage)
        sourceImage.hidden = true
        let center = currentImageView.imageView.center
        currentImageView.imageView.frame = frameToScaleAspectFitToFrame(endImageFrame, img: currentImageView.imageView)
        currentImageView.imageView.center = center
        currentImageView.imageView.contentMode = .ScaleAspectFill

        UIView.animateWithDuration(duration, delay: 0.0, options: UIViewAnimationOptions.CurveEaseIn, animations: { () -> Void in
            self.contentsView.interfaceAlpha = 0.0
            currentImageView.imageView.frame = endImageFrame
            }) { (finished) -> Void in
                sourceImage.hidden = false
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
    
    private func choiseFunctionWithRationImg(ratioImg: CGFloat, newFrame: CGRect) -> Bool {
        var resultat = false
    
        let ratioSelf = (newFrame.size.width) / (newFrame.size.height);
    
        if (ratioImg < 1) {
            if (ratioImg > ratioSelf ) {
                resultat = true
            }
        } else {
            if (ratioImg > ratioSelf ) {
                resultat = true
            }
        }

        return resultat;
    }
    
    private func frameToScaleAspectFitToFrame(newFrame: CGRect, img: UIImageView) -> CGRect {
        guard img.image!.size.width > 0 && img.image!.size.height > 0 else { return CGRectZero }

        let ratioImg = (img.image!.size.width) / (img.image!.size.height)
        let ratioSelf = (img.frame.size.width) / (img.frame.size.height);

        var newFrameImg = CGRectZero
        
        if ratioSelf < 1 {
            newFrameImg = CGRectMake(0, 0, img.frame.size.width, img.frame.size.width * 1.0/ratioImg)
        } else {
            newFrameImg = CGRectMake(0, 0, img.frame.size.height * ratioImg, img.frame.size.height * ratioImg)
        }

        return newFrameImg
    }

}
