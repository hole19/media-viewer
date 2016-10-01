import UIKit

public class MediaViewerTransitionAnimator: NSObject {

    // MARK: properties

    public var animationTime: TimeInterval = 0.2

    public var sourceImageView: UIImageView?
    public var contentsView: MediaViewerContentsView!

    public var transitionDelegate: MediaViewerDelegate?

    // MARK: init

    public init(sourceImageView: UIImageView?, contentsView: MediaViewerContentsView, transitionDelegate: MediaViewerDelegate? = nil) {
        super.init()
        self.sourceImageView = sourceImageView
        self.contentsView = contentsView
        self.transitionDelegate = transitionDelegate
    }

    // MARK: public

    public func setupTransitionToDestinationImageView() {
        self.contentsView.interfaceAlpha = 0.0
        guard let currentImageView = contentsView.scrollView.currentImageView(),
              let destinationSuperview = currentImageView.imageView.superview else { return }
        var sourceImageViewFrame = CGRect.zero
        if let sourceImageView = sourceImageView, let sourceSuperview = sourceImageView.superview {
            sourceImageViewFrame = destinationSuperview.convert(sourceImageView.frame, from: sourceSuperview)
        } else {
            sourceImageViewFrame = currentImageView.frame
            sourceImageViewFrame.origin.y += currentImageView.frame.size.height
        }
        currentImageView.imageView.frame = sourceImageViewFrame
        currentImageView.imageView.alpha = 1.0
        sourceImageView?.isHidden = true
        currentImageView.imageView.contentMode = .scaleAspectFill
    }

    public func transitionToDestinationImageView(_ animated: Bool, withCompletition completition: @escaping () -> (Void) = {}) {
        guard let currentImageView = contentsView.scrollView.currentImageView() else { return }
        let duration: TimeInterval = animated ? animationTime : 0.00
        let center = currentImageView.imageView.center
        setupTransitionToDestinationImageView()
        let endImageFrame = frameToScaleAspectFitBoundToFrame(currentImageView.bounds, img: currentImageView.imageView)
        self.contentsView.scrollView.alpha = 1.0
        UIView.animate(withDuration: duration, delay: 0.0, options: UIViewAnimationOptions.curveEaseIn, animations: { () -> Void in
            self.contentsView.interfaceAlpha = 1.0
            currentImageView.imageView.frame = endImageFrame
            currentImageView.imageView.center = center
            }) { (finished) -> Void in
                currentImageView.imageView.contentMode = UIViewContentMode.scaleAspectFit
                currentImageView.imageView.frame = CGRect(x: 0.0,
                                                          y: 0.0,
                                                          width: self.contentsView.bounds.size.width,
                                                          height: self.contentsView.bounds.size.height)
                completition()
        }
    }

    public func setupTransitionBackToSourceImageView(withImageView imageView: UIImageView?) {
        imageView?.isHidden = true
    }

    public func transitionBackToSourceImageView(_ animated: Bool, withCompletition completition: @escaping () -> (Void) = {}) {
        guard let currentImageView = contentsView.scrollView.currentImageView(),
              let currentSuperview = currentImageView.imageView.superview else { return }

        var endImageFrame = CGRect.zero
        var sourceImage = sourceImageView
        if let transitionDelegate = transitionDelegate,
           let image = currentImageView.imageModel,
           let imageView = transitionDelegate.imageViewForImage(image),
           let newSourceSuperview = imageView.superview {

            endImageFrame = currentSuperview.convert(imageView.frame, from: newSourceSuperview)
            sourceImage = imageView
            sourceImageView?.isHidden = false

        } else if let image = currentImageView.imageModel,
                  let sourceImageView = sourceImageView,
                  let sourceSuperview = sourceImageView.superview, image.sourceImageView === sourceImageView {
            endImageFrame = currentSuperview.convert(sourceImageView.frame, from: sourceSuperview)
        } else {
            sourceImage = nil
            endImageFrame = currentImageView.frame
            endImageFrame.origin.x = 0
            endImageFrame.origin.y = currentImageView.frame.size.height
        }

        let duration: TimeInterval = animated ? animationTime : 0.00
        setupTransitionBackToSourceImageView(withImageView: sourceImage)
        let center = currentImageView.imageView.center
        currentImageView.imageView.frame = frameToScaleAspectFit(currentImageView.imageView)
        currentImageView.imageView.center = center
        currentImageView.imageView.contentMode = .scaleAspectFill

        UIView.animate(withDuration: duration, delay: 0.0, options: UIViewAnimationOptions.curveEaseIn, animations: { () -> Void in
            self.contentsView.interfaceAlpha = 0.0
            currentImageView.imageView.frame = endImageFrame
            }) { (finished) -> Void in
                sourceImage?.isHidden = false
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(20) / Double(NSEC_PER_SEC), execute: {
                    completition()
                })
        }
    }

    // MARK: private

    private func frameToScaleAspectFit(_ img: UIImageView) -> CGRect {
        guard let image = img.image, image.size.width > 0 && image.size.height > 0 else { return CGRect.zero }

        let ratioImg = (image.size.width) / (image.size.height)
        let ratioSelf = (img.frame.size.width) / (img.frame.size.height)

        if ratioSelf < 1 {
            return CGRect(x: 0, y: 0, width: img.frame.size.width, height: img.frame.size.width * 1.0/ratioImg)
        } else {
            return CGRect(x: 0, y: 0, width: img.frame.size.height * ratioImg, height: img.frame.size.height)
        }
    }

    private func frameToScaleAspectFitBoundToFrame(_ newFrame: CGRect, img: UIImageView) -> CGRect {
        guard let image = img.image, image.size.width > 0 && image.size.height > 0 else { return CGRect.zero }

        let ratioImg = (image.size.width) / (image.size.height)
        let ratioSelf = (newFrame.size.width) / (newFrame.size.height)

        if ratioSelf < 1 {
            return CGRect(x: 0, y: 0, width: newFrame.size.width, height: newFrame.size.width * 1.0/ratioImg)
        } else {
            return CGRect(x: 0, y: 0, width: newFrame.size.height * ratioImg, height: newFrame.size.height)
        }
    }

}
