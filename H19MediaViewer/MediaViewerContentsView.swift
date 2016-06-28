
import UIKit

public protocol MediaViewerContentsViewActionsDelegate: class {
    func longPressActionDetectedInContentView(contentView: MediaViewerContentsView)
}

public class MediaViewerContentsView: UIView {
    
    // MARK: properties
    
    public var interfaceAlpha: CGFloat = 0.0 {
        didSet {
            backgroundView.alpha = interfaceAlpha
            controlsAlpha = interfaceAlpha
        }
    }
    
    public var controlsAlpha: CGFloat = 0.0 {
        didSet {
            let closeButtonAlpha = landscapeAsociatedInteractionsAllowed() ? controlsAlpha : 0.0
            closeButton.alpha = closeButtonAlpha
            if let overlayView = overlayView {
                overlayView.alpha = controlsAlpha
            }
        }
    }

    internal weak var delegate: MediaViewerContentsViewActionsDelegate?

    internal var pannedViewModel: MediaViewerPanningViewModel!

    internal var scrollView: MediaViewerMultipleImageScrollView!

    internal var backgroundView: UIView!
    internal var closeButton: UIButton!
    internal var closeButtonTopMarginConstraint: NSLayoutConstraint?
    internal var overlayView: MediaViewerInfoOverlayView?

    internal var controlsTapGestureRecogniser: UITapGestureRecognizer!
    internal var panGestureRecogniser: UIPanGestureRecognizer!
    internal var longPressGesture: UILongPressGestureRecognizer!
    
    internal var allowLandscapeDismissal: Bool

    private var closeButtonTopMarginPortrait: CGFloat = 10.0
    private var closeButtonTopMarginLandscape: CGFloat = 8.0

    // MARK: init
    
    public init(frame: CGRect, mediaViewerDelegate: MediaViewerDelegate? = nil, allowLandscapeDismissal: Bool = false) {
        self.allowLandscapeDismissal = allowLandscapeDismissal
        super.init(frame: frame)
        setupView(mediaViewerDelegate)
        setupGestureRecognisers()
    }
   
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: public

    public func setupOverlayView(imageModel: MediaViewerImageModel) {
        overlayView = imageModel.infoOverlayViewClass.init(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        overlayView!.translatesAutoresizingMaskIntoConstraints = false
        overlayView!.model = imageModel.overlayInfoModel
        overlayView!.alpha = 0.0
        addSubview(overlayView!)
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("|[overlayView]|", options: NSLayoutFormatOptions.AlignAllLeft, metrics: nil, views: ["overlayView" : overlayView!]))
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[overlayView(height)]|", options: NSLayoutFormatOptions.AlignAllLeft, metrics: ["height": overlayView!.defaultHeight()], views: ["overlayView" : overlayView!]))
    }
    
    public func updateViewStateWithLandscape(landscape: Bool) {
        backgroundView.alpha = 1.0
        if landscape && !allowLandscapeDismissal {
            controlsAlpha = 0.0
        } else {
            controlsAlpha = 1.0
        }
        closeButtonTopMarginConstraint?.constant = closeButtonHeight(isLandscape: landscape)
    }
    
    public func landscapeAsociatedInteractionsAllowed() -> Bool {
        var allowed = true
        if frame.size.width > frame.size.height && !allowLandscapeDismissal {
            allowed = false
        }
        return allowed
    }
    
    // MARK: selectors
    
    public func viewTapped(sender: UITapGestureRecognizer) {
        let newAlpha: CGFloat = controlsAlpha == 0.0 ? 1.0 : 0.0
        setControlsAlpha(newAlpha, animated: true)
        scrollView.zoomOut()
    }
    
    public func viewLongPressed(sender: UILongPressGestureRecognizer) {
        delegate?.longPressActionDetectedInContentView(self)
    }

    // MARK: private
    
    private func setupGestureRecognisers() {
        setupTapGestureRecogniser()
        setupPanGestureRecogniser()
        setupLongPressGestureRecogniser()
    }
    
    private func setupView(mediaViewerDelegate: MediaViewerDelegate? = nil) {
        setupBackgroundView()
        setupScrollView(mediaViewerDelegate)
        setupCloseButton()
        backgroundColor = UIColor.clearColor()
        interfaceAlpha = 0.0
    }
    
    private func setupPanningModel() {
        pannedViewModel = MediaViewerPanningViewModel(backgroundView: backgroundView, containerView: self)
    }
    
    private func setupTapGestureRecogniser() {
        controlsTapGestureRecogniser = UITapGestureRecognizer(target: self, action: #selector(MediaViewerContentsView.viewTapped(_:)))
        scrollView.singleTapGestureRecogniserThatReqiresFailure = controlsTapGestureRecogniser
        addGestureRecognizer(controlsTapGestureRecogniser)
    }
    
    private func setupLongPressGestureRecogniser() {
        longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(MediaViewerContentsView.viewLongPressed(_:)))
        addGestureRecognizer(longPressGesture)
    }
    
    private func setupPanGestureRecogniser() {
        setupPanningModel()

        panGestureRecogniser = UIPanGestureRecognizer(target: pannedViewModel, action: #selector(MediaViewerPanningViewModel.viewPanned(_:)))
        scrollView.addGestureRecognizer(panGestureRecogniser)
    }
    
    private func setupScrollView(mediaViewerDelegate: MediaViewerDelegate? = nil) {
        scrollView = MediaViewerMultipleImageScrollView(frame: bounds)
        scrollView.alpha = 0.0
        scrollView.imageViewActionsDelgate = self
        scrollView.clipsToBounds = false
        scrollView.scrollDelegate = self
        scrollView.mediaViewerDelegate = mediaViewerDelegate
        addSubviewWithFullScreenConstraints(scrollView)
    }
    
    private func setupBackgroundView() {
        backgroundView = UIView()
        backgroundView.backgroundColor = UIColor(red:0.19, green:0.19, blue:0.19, alpha:1.00)
        addSubviewWithFullScreenConstraints(backgroundView)
    }
    
    private func setupCloseButton() {
        closeButton = UIButton(type: UIButtonType.RoundedRect)
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        closeButton.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.1)
        closeButton.layer.borderColor = UIColor.whiteColor().CGColor
        closeButton.layer.cornerRadius = 6.0
        closeButton.tintColor = UIColor.whiteColor()
        closeButton.setImage(UIImage(named: "button-close-white"), forState: .Normal)
        addSubview(closeButton)
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("[closeButton(36)]-9-|", options: NSLayoutFormatOptions.AlignAllLeft, metrics: nil, views: ["closeButton" : closeButton]))
        let closeButtonMargin = closeButtonHeight(isLandscape: frame.size.width > frame.size.height)
        let closeButtonString = "V:|-\(closeButtonMargin)-[closeButton(36)]"
        let constraints = NSLayoutConstraint.constraintsWithVisualFormat(closeButtonString, options: NSLayoutFormatOptions.AlignAllLeft, metrics: nil, views: ["closeButton" : closeButton])
        for constr in constraints {
            if constr.constant == closeButtonMargin {
                closeButtonTopMarginConstraint = constr
                break
            }
        }
        addConstraints(constraints)
    }
    
    private func setControlsAlpha(alpha: CGFloat, animated: Bool) {
        if alpha != controlsAlpha {
            if animated {
                UIView.animateWithDuration(0.33, animations: { () -> Void in
                    self.controlsAlpha = alpha
                })
            } else {
                controlsAlpha = alpha
            }
        }
    }
    
    private func setOverlayAlpha(alpha: CGFloat, animated: Bool) {
        if alpha != overlayView?.alpha {
            if animated {
                UIView.animateWithDuration(0.33, animations: { () -> Void in
                    self.overlayView?.alpha = alpha
                })
            } else {
                overlayView?.alpha = alpha
            }
        }
    }
    
    private func closeButtonHeight(isLandscape landscape: Bool) -> CGFloat {
        return landscape ? closeButtonTopMarginLandscape : closeButtonTopMarginPortrait
    }
}

extension MediaViewerContentsView: MediaViewerInteractiveImageViewDelegate {
    
    public func hideControls() {
        setControlsAlpha(0.0, animated: true)
    }
}

extension MediaViewerContentsView: MediaViewerMultipleImageScrollViewActionsDelegate {
    public func scrollViewScrolledToImageModel(image: MediaViewerImageModel?) {
        overlayView?.model = image?.overlayInfoModel
    }
}
