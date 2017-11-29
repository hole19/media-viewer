import UIKit

public protocol MediaViewerPanningViewModelDelegate: class {
    func dismissView()
}

public class MediaViewerPanningViewModel: NSObject {

    // MARK: properties

    public var delegate: MediaViewerPanningViewModelDelegate?

    public var minBackgroundAlpha: CGFloat = 0.3

    // property to determine how far from view center user needs to pan to dismiss
    public var minYFactorToDismiss: CGFloat = 0.3

    public var backgroundView: UIView
    public var containerView: MediaViewerContentsView

    // MARK: init

    public init(backgroundView: UIView, containerView: MediaViewerContentsView) {
        self.backgroundView = backgroundView
        self.containerView = containerView
    }

    // MARK: public - selectors

    @objc public func viewPanned(_ recognizer: UIPanGestureRecognizer) {
        if containerView.landscapeAsociatedInteractionsAllowed() {
            let translation = recognizer.translation(in: containerView)
            if let view = recognizer.view {
                view.center = CGPoint(x: view.center.x + translation.x, y:view.center.y + translation.y)
            }
            recognizer.setTranslation(CGPoint.zero, in: containerView)
            let distance = distanceFromContainerCenter()
            if recognizer.state == .began {
                self.containerView.scrollView.setScrollViewImagesAlpha(0.0)
            }
            if recognizer.state == .ended || recognizer.state == .cancelled {
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
        return CGPoint(x: pannedView().center.x - containerCenterPoint.x, y: pannedView().center.y - containerCenterPoint.y)
    }

    private func animateImageViewBackToTheCenter() {
        let center = containerCenter()
        UIView.animate(withDuration: 0.33, animations: {
            self.pannedView().center = center
            self.backgroundView.alpha = 1.0
            self.containerView.controlsAlpha = 1.0

        }) { (fin) in
            self.containerView.scrollView.setScrollViewImagesAlpha(1.0)
        }
    }

    private func needToDismissView(_ distance: CGPoint) -> Bool {
        let yDistance = abs(distance.y)
        let halfHeight = containerView.frame.size.height / 2.0
        let maxYDistance = halfHeight * minYFactorToDismiss
        return yDistance > maxYDistance
    }

    private func updateBackgroundAlphaWithDistanceFomCenter(_ distance: CGPoint) {
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
        return CGPoint(x: containerView.bounds.size.width/2.0, y: containerView.bounds.size.height/2.0)
    }

    private func pannedView() -> UIView {
        return containerView.scrollView
    }

    private func updateControlsAlphaWithBackgroundAlpha(_ backgroundAlpha: CGFloat) {
        var controlsAlpha: CGFloat = 0.0
        if backgroundAlpha > 0.9 {
            controlsAlpha = (backgroundAlpha - 0.9) * 10.0
        }
        containerView.controlsAlpha = controlsAlpha
    }
}
