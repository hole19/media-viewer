import UIKit

final class MediaGalleryNavigationController: UINavigationController, UIGestureRecognizerDelegate {
    private enum Constants {
        static let restoreDuration: TimeInterval = 0.3
    }

    private let model: MediaGalleryModel
    private let transition: MediaGalleryTransition

    init(rootViewController: UIViewController, model: MediaGalleryModel, transition: MediaGalleryTransition) {
        self.model = model
        self.transition = transition
        super.init(rootViewController: rootViewController)
        modalPresentationStyle = .overFullScreen
        transitioningDelegate = transition
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear

        let panRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        panRecognizer.delegate = self
        view.addGestureRecognizer(panRecognizer)

        model.onShare = { [weak self] image in
            self?.presentShareSheet(for: image)
        }
    }

    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        guard let panRecognizer = gestureRecognizer as? UIPanGestureRecognizer
        else { return true }
        let velocity = panRecognizer.velocity(in: view)
        return model.isZoomed == false && abs(velocity.y) > abs(velocity.x)
    }

    func gestureRecognizer(
        _ gestureRecognizer: UIGestureRecognizer,
        shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer
    ) -> Bool {
        true
    }

    @objc private func handlePan(_ recognizer: UIPanGestureRecognizer) {
        let translation = recognizer.translation(in: view).y

        switch recognizer.state {
        case .began:
            model.hideChrome()
        case .changed:
            view.transform = CGAffineTransform(translationX: .zero, y: translation)
            transition.backdropView.alpha = MediaGalleryDismissPolicy.backdropAlpha(translation: translation, height: view.bounds.height)
        case .ended, .cancelled:
            let shouldDismiss = recognizer.state == .ended
                && MediaGalleryDismissPolicy.shouldDismiss(
                    translation: translation,
                    velocity: recognizer.velocity(in: view).y,
                    height: view.bounds.height
                )
            shouldDismiss ? dismiss(animated: true) : restorePosition()
        default:
            break
        }
    }

    private func restorePosition() {
        UIView.animate(
            withDuration: Constants.restoreDuration,
            delay: .zero,
            usingSpringWithDamping: 0.85,
            initialSpringVelocity: .zero
        ) {
            self.view.transform = .identity
            self.transition.backdropView.alpha = 1
        }
    }

    private func presentShareSheet(for image: UIImage) {
        let activityController = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        activityController.popoverPresentationController?.sourceView = view
        activityController.popoverPresentationController?.sourceRect = CGRect(
            x: view.bounds.midX,
            y: view.bounds.midY,
            width: .zero,
            height: .zero
        )
        present(activityController, animated: true)
    }
}
