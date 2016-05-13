
import UIKit

class MediaViewerInfoOverlayView: UIView {
  
    // properties
    
    var model: Any? {
        didSet {
            updateViewWithModel(model)
        }
    }
    
    // public

    func defaultHeight() -> CGFloat {
        return 0.0
    }
    
    func updateViewWithModel(model: Any?) {

    }
}
