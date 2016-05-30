
import UIKit

extension UINavigationController {
    
    public override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return visibleViewController?.supportedInterfaceOrientations() ?? .Portrait
    }
    
    public override func shouldAutorotate() -> Bool {
        return visibleViewController?.shouldAutorotate() ?? false
    }
}
