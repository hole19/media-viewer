
import UIKit

protocol MediaViewerPanningViewModelDelegate: class {
    func dismissView()
}

class MediaViewerPanningViewModel: NSObject {
    
    // MARK: properties
    
    var delegate: MediaViewerPanningViewModelDelegate?
    
    var minBackgroundAlpha: CGFloat = 0.3
    
    // property to determine how far from view center user needs to pan to dismiss
    var minYFactorToDismiss: CGFloat = 0.3

    var backgroundView: UIView
    var containerView: MediaViewerContentsView
    
    // MARK: init
    
    init(backgroundView: UIView, containerView: MediaViewerContentsView) {
        self.backgroundView = backgroundView
        self.containerView = containerView
    }
    
    // MARK: public - selectors
    
    func viewPanned(recognizer: UIPanGestureRecognizer) {
        if containerView.landscapeAsociatedInteractionsAllowed() {
            let translation = recognizer.translationInView(containerView)
            if let view = recognizer.view {
                view.center = CGPoint(x: view.center.x + translation.x, y:view.center.y + translation.y)
            }
            recognizer.setTranslation(CGPointZero, inView: containerView)
            let distance = distanceFromContainerCenter()
            if recognizer.state == .Began {
                self.setScrollViewImagesAlpha(0.0)
            }
            if recognizer.state == .Ended || recognizer.state == .Cancelled {
                if needToDismissView(distance) {
                    delegate?.dismissView()
                } else {
                    animateImageViewBackToTheCenter()
                }
            } else {
                updateBackgroundAlphaWithDistanceFomCenter(distance)
            }
        }
    }

    // MARK: private
    
    private func distanceFromContainerCenter() -> CGPoint {
        let containerCenterPoint = containerCenter()
        return CGPointMake(pannedView().center.x - containerCenterPoint.x, pannedView().center.y - containerCenterPoint.y)
    }

    private func animateImageViewBackToTheCenter() {
        let center = containerCenter()
        UIView.animateWithDuration(0.33, animations: {
            self.pannedView().center = center
            self.backgroundView.alpha = 1.0
            self.containerView.controlsAlpha = 1.0

        }) { (fin) in
            self.setScrollViewImagesAlpha(1.0)
        }
    }
    
    private func needToDismissView(distance: CGPoint) -> Bool {
        let yDistance = abs(distance.y)
        let halfHeight = containerView.frame.size.height / 2.0
        let maxYDistance = halfHeight * minYFactorToDismiss
        return yDistance > maxYDistance
    }
    
    private func updateBackgroundAlphaWithDistanceFomCenter(distance: CGPoint) {
        var yDistance = abs(distance.y)
        let halfHeight = containerView.frame.size.height / 2.0
        if yDistance > halfHeight {
            yDistance = halfHeight
        }
        var backgroundAlpha = abs(halfHeight - yDistance)/halfHeight
        if backgroundAlpha > 1.0 {
            backgroundAlpha = 1.0
        } else if backgroundAlpha < minBackgroundAlpha {
            backgroundAlpha = minBackgroundAlpha
        }
        backgroundView.alpha = backgroundAlpha
        updateControlsAlphaWithBackgroundAlpha(backgroundAlpha)
    }
    
    private func containerCenter() -> CGPoint {
        return CGPointMake(containerView.bounds.size.width/2.0, containerView.bounds.size.height/2.0)
    }
    
    private func pannedView() -> UIView {
        return containerView.scrollView
    }
    
    private func setScrollViewImagesAlpha(alpha: CGFloat) {
        let current = containerView.scrollView.currentImageView()
        for imageContentView in containerView.scrollView.contentViews {
            if imageContentView != current {
                imageContentView.alpha = alpha
            }
        }
    }
    
    private func updateControlsAlphaWithBackgroundAlpha(backgroundAlpha: CGFloat) {
        var controlsAlpha: CGFloat = 0.0
        if backgroundAlpha > 0.9 {
            controlsAlpha = (backgroundAlpha - 0.9) * 10.0
        }
        containerView.controlsAlpha = controlsAlpha
    }
}
