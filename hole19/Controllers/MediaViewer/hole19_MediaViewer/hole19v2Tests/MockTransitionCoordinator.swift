 
 import UIKit
 
 class MockTransitionCoordinator: NSObject,  UIViewControllerTransitionCoordinator {
    
    var animateAlongsideTransitionBlock: ((UIViewControllerTransitionCoordinatorContext) -> Void)?
    
        func animateAlongsideTransition(animation: ((UIViewControllerTransitionCoordinatorContext) -> Void)?, completion: ((UIViewControllerTransitionCoordinatorContext) -> Void)?) -> Bool {
            animateAlongsideTransitionBlock = animation
            return true
        }
        
        func animateAlongsideTransitionInView(view: UIView?, animation: ((UIViewControllerTransitionCoordinatorContext) -> Void)?, completion: ((UIViewControllerTransitionCoordinatorContext) -> Void)?) -> Bool {
            return true
        }
        func notifyWhenInteractionEndsUsingBlock(handler: (UIViewControllerTransitionCoordinatorContext) -> Void) {
        }
        func isAnimated() -> Bool {
            return true
        }
        func presentationStyle() -> UIModalPresentationStyle {
            return .CurrentContext
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
        func transitionDuration() -> NSTimeInterval {
            return 0.0
        }
        func percentComplete() -> CGFloat {
            return 0.0
        }
        func completionVelocity() -> CGFloat {
            return 0.0
        }
        func completionCurve() -> UIViewAnimationCurve {
            return .EaseIn
        }
        func viewForKey(key: String) -> UIView? {
            return nil
        }
        func viewControllerForKey(key: String) -> UIViewController? {
            return nil
        }
        func containerView() -> UIView {
            return UIView()
        }
        func targetTransform() -> CGAffineTransform {
            return CGAffineTransformIdentity
        }
    }
