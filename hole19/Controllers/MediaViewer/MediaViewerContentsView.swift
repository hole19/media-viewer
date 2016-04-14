
import UIKit

protocol MediaViewerContentsViewActionsDelegate: class {
    func longPressActionDetectedInContentView(contentView: MediaViewerContentsView)
}

class MediaViewerInfoOverlayView: UIView {
    func defaultHeight() -> CGFloat {
        return 0.0
    }
}

class MediaViewerContentsView: UIView {
    
    // MARK: properties
    
    weak var delegate: MediaViewerContentsViewActionsDelegate?
    
    var interfaceAlpha: CGFloat = 0.0 {
        didSet {
            backgroundView.alpha = interfaceAlpha
            controlsAlpha = interfaceAlpha
        }
    }
    
    var controlsAlpha: CGFloat = 0.0 {
        didSet {
            closeButton.alpha = controlsAlpha
            if let overlayView = overlayView {
                overlayView.alpha = controlsAlpha
            }
        }
    }

    var pannedViewModel: MediaViewerPanningViewModel!

    var scrollView: MediaViewerMultipleImageScrollView!

    var backgroundView: UIView!
    var closeButton: UIButton!
    var overlayView: MediaViewerInfoOverlayView?

    var controlsTapGestureRecogniser: UITapGestureRecognizer!
    var panGestureRecogniser: UIPanGestureRecognizer!
    var longPressGesture: UILongPressGestureRecognizer!
    
    // MARK: init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupGestureRecognisers()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    // MARK: public - selectors
    
    func viewTapped(sender: UITapGestureRecognizer) {
        let newAlpha: CGFloat = controlsAlpha == 0.0 ? 1.0 : 0.0
        setControlsAlpha(newAlpha, animated: true)
        scrollView.zoomOut()
    }
    
    func viewLongPressed(sender: UILongPressGestureRecognizer) {
        delegate?.longPressActionDetectedInContentView(self)
    }
    
    // MARK: private
    
    private func setupGestureRecognisers() {
        setupTapGestureRecogniser()
        setupPanGestureRecogniser()
        setupLongPressGestureRecogniser()
    }
    
    private func setupView() {
        setupBackgroundView()
        setupScrollView()
        setupCloseButton()
        setupOverlayView()
        backgroundColor = UIColor.clearColor()
        interfaceAlpha = 0.0
    }
    
    private func setupPanningModel() {
        pannedViewModel = MediaViewerPanningViewModel(pannedView: scrollView, backgroundView: backgroundView, containerView: self)
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
    
    private func setupScrollView() {
        scrollView = MediaViewerMultipleImageScrollView(frame: bounds)
        scrollView.alpha = 0.0
        scrollView.imageViewActionsDelgate = self
        scrollView.clipsToBounds = false
        addSubviewAndFullScreenConstraints(scrollView)
    }
    
    private func setupBackgroundView() {
        backgroundView = UIView()
        backgroundView.backgroundColor = UIColor(red:0.19, green:0.19, blue:0.19, alpha:1.00)
        addSubviewAndFullScreenConstraints(backgroundView)
    }
    
    private func setupOverlayView() {
        overlayView = MediaViewerAuthorInfoOverlayView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        overlayView!.translatesAutoresizingMaskIntoConstraints = false
        addSubview(overlayView!)
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("|[overlayView]|", options: NSLayoutFormatOptions.AlignAllLeft, metrics: nil, views: ["overlayView" : overlayView!]))
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[overlayView(height)]|", options: NSLayoutFormatOptions.AlignAllLeft, metrics: ["height": overlayView!.defaultHeight()], views: ["overlayView" : overlayView!]))
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
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-12-[closeButton(36)]", options: NSLayoutFormatOptions.AlignAllLeft, metrics: nil, views: ["closeButton" : closeButton]))
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
}

extension MediaViewerContentsView: MediaViewerInteractiveImageViewDelegate {
    
    func hideControls() {
        setControlsAlpha(0.0, animated: true)
    }
}
