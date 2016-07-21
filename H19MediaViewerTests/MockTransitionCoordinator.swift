 
 import UIKit
 
 class MockTransitionCoordinator: NSObject,  UIViewControllerTransitionCoordinator {
    
    var animateAlongsideTransitionBlock: ((UIViewControllerTransitionCoordinatorContext) -> Void)?
    
        var isInterruptible = false
    
        func animate(alongsideTransition animation: ((UIViewControllerTransitionCoordinatorContext) -> Void)?, completion: ((UIViewControllerTransitionCoordinatorContext) -> Void)?) -> Bool {
            animateAlongsideTransitionBlock = animation
            return true
        }
        
        func animateAlongsideTransition(in view: UIView?, animation: ((UIViewControllerTransitionCoordinatorContext) -> Void)?, completion: ((UIViewControllerTransitionCoordinatorContext) -> Void)?) -> Bool {
            return true
        }
        func notifyWhenInteractionEnds(_ handler: (UIViewControllerTransitionCoordinatorContext) -> Void) {
        }
        func notifyWhenInteractionChanges(_ handler: (UIViewControllerTransitionCoordinatorContext) -> Void) {
        }
        func isAnimated() -> Bool {
            return true
        }
        func presentationStyle() -> UIModalPresentationStyle {
            return .currentContext
        }
        func initiallyInteractive() -> Bool {
            return true
        }
        func isInteractive() -> Bool {
            return true
        }
        func isCancelled() -> Bool {
            return true
        }
        func transitionDuration() -> TimeInterval {
            return 0.0
        }
        func percentComplete() -> CGFloat {
            return 0.0
        }
        func completionVelocity() -> CGFloat {
            return 0.0
        }
        func completionCurve() -> UIViewAnimationCurve {
            return .easeIn
        }
        func view(forKey key: String) -> UIView? {
            return nil
        }
        func viewController(forKey key: String) -> UIViewController? {
            return nil
        }
        func containerView() -> UIView {
            return UIView()
        }
        func targetTransform() -> CGAffineTransform {
            return .identity
        }
    }
