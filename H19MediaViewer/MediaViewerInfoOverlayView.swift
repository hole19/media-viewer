
import UIKit

public class MediaViewerInfoOverlayView: UIView {
  
    // properties
    
    public var model: Any? {
        didSet {
            updateViewWithModel(model)
        }
    }
    
    // init
    
    required public override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required public init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    // public

    public func defaultHeight() -> CGFloat {
        return 0.0
    }
    
    public func updateViewWithModel(model: Any?) {

    }
}
