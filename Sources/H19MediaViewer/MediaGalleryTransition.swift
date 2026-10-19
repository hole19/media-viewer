import UIKit

@MainActor
final class MediaGalleryTransition: NSObject, UIViewControllerTransitioningDelegate {
    let backdropView = UIView()
    private let model: MediaGalleryModel
    private weak var initialSourceImageView: UIImageView?

    init(model: MediaGalleryModel, initialSourceImageView: UIImageView?) {
        self.model = model
        self.initialSourceImageView = initialSourceImageView
        super.init()
        backdropView.backgroundColor = .black
    }

    func animationController(
        forPresented presented: UIViewController,
        presenting: UIViewController,
        source: UIViewController
    ) -> (any UIViewControllerAnimatedTransitioning)? {
        PresentAnimator(transition: self)
    }

    func animationController(forDismissed dismissed: UIViewController) -> (any UIViewControllerAnimatedTransitioning)? {
        DismissAnimator(transition: self)
    }

    fileprivate var displayedImage: UIImage? {
        model.currentImage ?? initialSourceImageView?.image
    }

    fileprivate func sourceImageViewForCurrentItem() -> UIImageView? {
        guard let item = model.currentItem
        else { return nil }
        if let view = model.delegate?.mediaGallery(sourceImageViewFor: item) {
            return view
        }
        return item.id == model.initialItemID ? initialSourceImageView : nil
    }

    fileprivate func restoreSourceImageViews() {
        initialSourceImageView?.isHidden = false
        sourceImageViewForCurrentItem()?.isHidden = false
    }

    fileprivate func hideInitialSourceImageView() {
        initialSourceImageView?.isHidden = true
    }

    fileprivate var hasInitialSourceImageView: Bool { initialSourceImageView != nil }
    fileprivate var initialSourceImage: UIImage? { initialSourceImageView?.image }

    fileprivate func initialSourceFrame(in container: UIView) -> CGRect? {
        frame(of: initialSourceImageView, in: container)
    }

    fileprivate func currentSourceFrame(in container: UIView) -> CGRect? {
        frame(of: sourceImageViewForCurrentItem(), in: container)
    }

    fileprivate func cornerRadius(of imageView: UIImageView?) -> CGFloat {
        imageView?.layer.cornerRadius ?? .zero
    }

    private func frame(of imageView: UIImageView?, in container: UIView) -> CGRect? {
        guard let imageView, let superview = imageView.superview, imageView.window != nil
        else { return nil }
        return superview.convert(imageView.frame, to: container)
    }

    fileprivate var initialSourceCornerRadius: CGFloat { cornerRadius(of: initialSourceImageView) }
    fileprivate var currentSourceCornerRadius: CGFloat { cornerRadius(of: sourceImageViewForCurrentItem()) }
}

private enum Constants {
    static let duration: TimeInterval = 0.32
    static let springDamping: CGFloat = 0.9
}

@MainActor
private func makeHeroImageView(
    image: UIImage,
    frame: CGRect,
    cornerRadius: CGFloat
) -> UIImageView {
    let heroImageView = UIImageView(image: image)
    heroImageView.contentMode = .scaleAspectFill
    heroImageView.clipsToBounds = true
    heroImageView.frame = frame
    heroImageView.layer.cornerRadius = cornerRadius
    return heroImageView
}

@MainActor
private final class PresentAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    private let transition: MediaGalleryTransition

    init(transition: MediaGalleryTransition) {
        self.transition = transition
    }

    func transitionDuration(using transitionContext: (any UIViewControllerContextTransitioning)?) -> TimeInterval {
        Constants.duration
    }

    func animateTransition(using transitionContext: any UIViewControllerContextTransitioning) {
        let container = transitionContext.containerView
        guard let toView = transitionContext.view(forKey: .to)
        else {
            transitionContext.completeTransition(false)
            return
        }

        let backdrop = transition.backdropView
        backdrop.frame = container.bounds
        backdrop.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        backdrop.alpha = .zero
        container.addSubview(backdrop)

        toView.frame = container.bounds
        toView.alpha = .zero
        container.addSubview(toView)
        toView.layoutIfNeeded()

        let duration = transitionDuration(using: transitionContext)

        guard let image = transition.initialSourceImage,
            let sourceFrame = transition.initialSourceFrame(in: container)
        else {
            UIView.animate(
                withDuration: duration,
                animations: {
                    backdrop.alpha = 1
                    toView.alpha = 1
                },
                completion: { _ in transitionContext.completeTransition(transitionContext.transitionWasCancelled == false) }
            )
            return
        }

        let heroImageView = makeHeroImageView(
            image: image,
            frame: sourceFrame,
            cornerRadius: transition.initialSourceCornerRadius
        )
        container.addSubview(heroImageView)
        transition.hideInitialSourceImageView()

        UIView.animate(
            withDuration: duration,
            delay: .zero,
            usingSpringWithDamping: Constants.springDamping,
            initialSpringVelocity: .zero,
            animations: {
                backdrop.alpha = 1
                heroImageView.frame = MediaGalleryGeometry.aspectFitFrame(for: image.size, in: container.bounds)
                heroImageView.layer.cornerRadius = .zero
            },
            completion: { _ in
                toView.alpha = 1
                heroImageView.removeFromSuperview()
                transitionContext.completeTransition(transitionContext.transitionWasCancelled == false)
            }
        )
    }
}

@MainActor
private final class DismissAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    private let transition: MediaGalleryTransition

    init(transition: MediaGalleryTransition) {
        self.transition = transition
    }

    func transitionDuration(using transitionContext: (any UIViewControllerContextTransitioning)?) -> TimeInterval {
        Constants.duration
    }

    func animateTransition(using transitionContext: any UIViewControllerContextTransitioning) {
        let container = transitionContext.containerView
        guard let fromView = transitionContext.view(forKey: .from)
        else {
            transitionContext.completeTransition(false)
            return
        }

        let backdrop = transition.backdropView
        backdrop.frame = container.bounds
        let duration = transitionDuration(using: transitionContext)
        let dragOffset = fromView.transform.ty
        let finish: (Bool) -> Void = { [transition] _ in
            transition.restoreSourceImageViews()
            backdrop.removeFromSuperview()
            transitionContext.completeTransition(transitionContext.transitionWasCancelled == false)
        }

        guard let image = transition.displayedImage,
            let targetFrame = transition.currentSourceFrame(in: container)
        else {
            UIView.animate(
                withDuration: duration,
                animations: {
                    backdrop.alpha = .zero
                    fromView.alpha = .zero
                },
                completion: finish
            )
            return
        }

        let startFrame = MediaGalleryGeometry
            .aspectFitFrame(for: image.size, in: container.bounds)
            .offsetBy(dx: .zero, dy: dragOffset)
        let heroImageView = makeHeroImageView(
            image: image,
            frame: startFrame,
            cornerRadius: .zero
        )
        container.addSubview(heroImageView)
        fromView.alpha = .zero
        fromView.transform = .identity

        UIView.animate(
            withDuration: duration,
            delay: .zero,
            usingSpringWithDamping: Constants.springDamping,
            initialSpringVelocity: .zero,
            animations: {
                backdrop.alpha = .zero
                heroImageView.frame = targetFrame
                heroImageView.layer.cornerRadius = self.transition.currentSourceCornerRadius
            },
            completion: { completed in
                heroImageView.removeFromSuperview()
                finish(completed)
            }
        )
    }
}
