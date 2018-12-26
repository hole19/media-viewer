import UIKit

 class MockTransitionCoordinator: NSObject, UIViewControllerTransitionCoordinator {

    var initiallyInteractive = true
    var isAnimated = true
    var presentationStyle = UIModalPresentationStyle.currentContext
    var isInteractive = true
    var isCancelled = true
    var transitionDuration: TimeInterval = 0.0
    var percentComplete: CGFloat = 0.0
    var completionVelocity: CGFloat = 0.0
    var completionCurve = UIView.AnimationCurve.easeIn
    var targetTransform = CGAffineTransform.identity
    var containerView = UIView()
    var isInterruptible = false

    func notifyWhenInteractionEnds(_ handler: @escaping (UIViewControllerTransitionCoordinatorContext) -> Swift.Void) {
    }

    func notifyWhenInteractionChanges(_ handler: @escaping (UIViewControllerTransitionCoordinatorContext) -> Swift.Void) {
    }

    var animateAlongsideTransitionBlock: ((UIViewControllerTransitionCoordinatorContext) -> Void)?

    func animateAlongsideTransition(in view: UIView?, animation: ((UIViewControllerTransitionCoordinatorContext) -> Swift.Void)?, completion: ((UIViewControllerTransitionCoordinatorContext) -> Swift.Void)? = nil) -> Bool {
        return true
    }

    func animate(alongsideTransition animation: ((UIViewControllerTransitionCoordinatorContext) -> Swift.Void)?, completion: ((UIViewControllerTransitionCoordinatorContext) -> Swift.Void)? = nil) -> Bool {
        animateAlongsideTransitionBlock = animation
        return true
    }

    func view(forKey key: UITransitionContextViewKey) -> UIView? {
        return nil
    }
    func viewController(forKey key: UITransitionContextViewControllerKey) -> UIViewController? {
        return nil
    }
 }
