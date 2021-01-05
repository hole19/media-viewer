import UIKit

public class MediaViewerInfoOverlayView: UIView {

    // properties

    public var model: Any? {
        didSet {
            updateViewWithModel(model)
        }
    }

    public var safeAreaBottomAnchor: NSLayoutYAxisAnchor? {
        didSet {
            updateSafeAreaBottomAnchor(safeAreaBottomAnchor)
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

    public func updateViewWithModel(_ model: Any?) {

    }

    public func updateSafeAreaBottomAnchor(_ anchor: NSLayoutYAxisAnchor?) {

    }
}
