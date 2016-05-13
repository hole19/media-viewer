
import UIKit

class MediaViewerInfoOverlayView: UIView {
  
    // properties
    
    var model: Any? {
        didSet {
            updateViewWithModel(model)
        }
    }
    
    // init
    
    required override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    // public

    func defaultHeight() -> CGFloat {
        return 0.0
    }
    
    func updateViewWithModel(model: Any?) {

    }
}
