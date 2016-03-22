
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

    var pannedView: UIView
    var backgroundView: UIView
    var containerView: UIView
    
    // MARK: init
    
    init(pannedView: UIView, backgroundView: UIView, containerView: UIView) {
        self.pannedView = pannedView
        self.backgroundView = backgroundView
        self.containerView = containerView
    }
    
    // MARK: public - selectors
    
    func viewPanned(recognizer: UIPanGestureRecognizer) {
        let translation = recognizer.translationInView(containerView)
        if let view = recognizer.view {
            view.center = CGPoint(x: view.center.x + translation.x, y:view.center.y + translation.y)
        }
        recognizer.setTranslation(CGPointZero, inView: containerView)
        let distance = distanceFromContainerCenter()
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

    // MARK: private
    
    private func distanceFromContainerCenter() -> CGPoint {
        let containerCenterPoint = containerCenter()
        return CGPointMake(pannedView.center.x - containerCenterPoint.x, pannedView.center.y - containerCenterPoint.y)
    }

    private func animateImageViewBackToTheCenter() {
        let center = containerCenter()
        UIView.animateWithDuration(0.33) { () -> Void in
            self.pannedView.center = center
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
        var backgroundAlpha = abs(halfHeight - yDistance)/halfHeight + minBackgroundAlpha
        if backgroundAlpha > 1.0 {
            backgroundAlpha = 1.0
        }
        backgroundView.alpha = backgroundAlpha
    }
    
    private func containerCenter() -> CGPoint {
        return CGPointMake(containerView.bounds.size.width/2.0, containerView.bounds.size.height/2.0)
    }
}
