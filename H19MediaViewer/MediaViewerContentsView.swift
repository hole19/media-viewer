
import UIKit

public protocol MediaViewerContentsViewActionsDelegate: class {
    func longPressActionDetectedInContentView(_ contentView: MediaViewerContentsView)
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

    public func setupOverlayView(_ imageModel: MediaViewerImageModel) {
        overlayView = imageModel.infoOverlayViewClass.init(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        overlayView!.translatesAutoresizingMaskIntoConstraints = false
        overlayView!.model = imageModel.overlayInfoModel
        overlayView!.alpha = 0.0
        addSubview(overlayView!)
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "|[overlayView]|", options: NSLayoutFormatOptions.alignAllLeft, metrics: nil, views: ["overlayView" : overlayView!]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[overlayView(height)]|", options: NSLayoutFormatOptions.alignAllLeft, metrics: ["height": overlayView!.defaultHeight()], views: ["overlayView" : overlayView!]))
    }
    
    public func updateViewStateWithLandscape(_ landscape: Bool) {
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
    
    public func viewTapped(_ sender: UITapGestureRecognizer) {
        let newAlpha: CGFloat = controlsAlpha == 0.0 ? 1.0 : 0.0
        setControlsAlpha(newAlpha, animated: true)
        scrollView.zoomOut()
    }
    
    public func viewLongPressed(_ sender: UILongPressGestureRecognizer) {
        delegate?.longPressActionDetectedInContentView(self)
    }

    // MARK: private
    
    private func setupGestureRecognisers() {
        setupTapGestureRecogniser()
        setupPanGestureRecogniser()
        setupLongPressGestureRecogniser()
    }
    
    private func setupView(_ mediaViewerDelegate: MediaViewerDelegate? = nil) {
        setupBackgroundView()
        setupScrollView(mediaViewerDelegate)
        setupCloseButton()
        backgroundColor = UIColor.clear
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
    
    private func setupScrollView(_ mediaViewerDelegate: MediaViewerDelegate? = nil) {
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
        backgroundView.backgroundColor = UIColor(red:0, green:0, blue:0, alpha:1.00)
        addSubviewWithFullScreenConstraints(backgroundView)
    }
    
    private func setupCloseButton() {
        closeButton = UIButton(type: UIButtonType.roundedRect)
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        closeButton.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.1)
        closeButton.layer.borderColor = UIColor.white.cgColor
        closeButton.layer.cornerRadius = 6.0
        closeButton.tintColor = UIColor.white
        closeButton.setImage(UIImage(named: "button-close-white"), for: UIControlState())
        addSubview(closeButton)
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "[closeButton(36)]-9-|", options: NSLayoutFormatOptions.alignAllLeft, metrics: nil, views: ["closeButton" : closeButton]))
        let closeButtonMargin = closeButtonHeight(isLandscape: frame.size.width > frame.size.height)
        let closeButtonString = "V:|-\(closeButtonMargin)-[closeButton(36)]"
        let constraints = NSLayoutConstraint.constraints(withVisualFormat: closeButtonString, options: NSLayoutFormatOptions.alignAllLeft, metrics: nil, views: ["closeButton" : closeButton])
        for constr in constraints {
            if constr.constant == closeButtonMargin {
                closeButtonTopMarginConstraint = constr
                break
            }
        }
        addConstraints(constraints)
    }
    
    func setControlsAlpha(_ alpha: CGFloat, animated: Bool) {
        if alpha != controlsAlpha {
            if animated {
                UIView.animate(withDuration: 0.33, animations: { () -> Void in
                    self.controlsAlpha = alpha
                })
            } else {
                controlsAlpha = alpha
            }
        }
    }
    
    private func setOverlayAlpha(_ alpha: CGFloat, animated: Bool) {
        if alpha != overlayView?.alpha {
            if animated {
                UIView.animate(withDuration: 0.33, animations: { () -> Void in
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
    public func scrollViewScrolledToImageModel(_ image: MediaViewerImageModel?) {
        overlayView?.model = image?.overlayInfoModel
    }
}
