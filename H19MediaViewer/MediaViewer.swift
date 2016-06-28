
import UIKit
import SDWebImage

/// Swift class to display image gallery
public class MediaViewer: UIViewController {
    
    // MARK: properties
    
    /// Property to determine if you want the gallery to be dismissable in landscape orientation.
    public var allowLandscapeDismissal = false
    
    /// If you have view controller based status bar appereance, statusBarStyle value will be returned
    public var statusBarStyle = UIStatusBarStyle.LightContent
    
    internal var sourceImageView: UIImageView?
    internal var initialImage: MediaViewerImageModel?
    
    internal var transitionAnimator: MediaViewerTransitionAnimator?
    
    internal var contentsView: MediaViewerContentsView!
    internal var imageTaskHandler = MediaViewerImageActionsHandler()
    internal var allImages: [MediaViewerImageModel]?
    internal var transitionDelegate: MediaViewerDelegate?
    
    internal var foregroundWindow: UIWindow?
    
    // MARK: init
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override public init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nil, bundle: nil)
    }
    
    /**
     Designated initialiser.
     
     :param: image MediaViewerImage instance with the source image to present.
     :param: allImages optional array of MediaViewerImage objects to present in a horizontal scroll view.
     :param: delegate - MediaViewerDelegate - optional delegate to support additional actions such as auto-scrolling underlying collection view.
     */
    convenience public init(image: MediaViewerImageModel, allImages: [MediaViewerImageModel]? = nil, delegate:MediaViewerDelegate? = nil) {
        self.init(nibName: nil, bundle: nil)
        self.sourceImageView = image.sourceImageView
        self.allImages = allImages
        self.transitionDelegate = delegate
        self.initialImage = image
        modalPresentationStyle = .OverCurrentContext
    }

    // MARK: UIViewController
    
    override public func loadView() {
        super.loadView()
        setupView()
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        if transitionAnimator == nil {
            transitionAnimator = MediaViewerTransitionAnimator(sourceImageView: sourceImageView, contentsView: contentsView, transitionDelegate: transitionDelegate)
        }
        contentsView.pannedViewModel.delegate = self
    }
    
    override public func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if contentsView.scrollView.images == nil {
            if let sourceImage = initialImage {
                if let moreImages = allImages {
                    contentsView.scrollView.setImages(moreImages, withSelectedOne: sourceImage)
                } else {
                    contentsView.scrollView.setImages([sourceImage], withSelectedOne: sourceImage)
                }
            }
        }
    }
    
    override public func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        transitionAnimator?.transitionToDestinationImageView(true)
    }
    
    override public func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
        contentsView.scrollView.layoutSubviews()
        let current = contentsView.scrollView.currentImageView()
        for cView in contentsView.scrollView.contentViews {
            if current != cView {
                cView.imageView.hidden = true
            }
        }
        contentsView.scrollView.setAllImageViewsButCurrentHidden(true)
        coordinator.animateAlongsideTransition({ (coordinate) in
            self.contentsView.updateViewStateWithLandscape(size.width > size.height)
        }) { (coordinate) in
            self.contentsView.scrollView.setAllImageViewsButCurrentHidden(false)
        }
    }

    override public func preferredStatusBarStyle() -> UIStatusBarStyle {
        return statusBarStyle
    }

    // MARK: public

    /**
     Use present to show MediaViewer. Do not use presentViewController.
     */
    public func present() {
        foregroundWindow = UIWindow(frame: UIScreen.mainScreen().bounds)
        
        guard let foregroundWindow = foregroundWindow else { return }

        foregroundWindow.backgroundColor = UIColor.clearColor()
        foregroundWindow.rootViewController = self
        foregroundWindow.windowLevel = UIWindowLevelStatusBar
        foregroundWindow.hidden = false
    }
    
    // MARK: public selectors
    
    public func close(sender: UIButton) {
        dismissViewAnimated()
    }
    
    // MARK: private
    
    private func setupView() {
        setupContentsView()
        setupCloseButton()
        view.backgroundColor = UIColor.clearColor()
    }
    
    private func setupContentsView() {
        contentsView = MediaViewerContentsView(frame: view.bounds, mediaViewerDelegate: transitionDelegate, allowLandscapeDismissal: allowLandscapeDismissal)
        if let initialImage = initialImage {
            contentsView.setupOverlayView(initialImage)
        }
        view.addSubviewWithFullScreenConstraints(contentsView)
        contentsView.delegate = self
    }
    
    private func setupCloseButton() {
        contentsView.closeButton.addTarget(self, action: #selector(MediaViewer.close(_:)), forControlEvents: UIControlEvents.TouchUpInside)
    }
    
    private func dismissViewAnimated() {
        transitionAnimator?.transitionBackToSourceImageView(true, withCompletition: { [weak self] in
            self?.foregroundWindow?.hidden = true
            self?.foregroundWindow?.rootViewController = nil
            self?.foregroundWindow = nil
        })
    }
}

extension MediaViewer: MediaViewerPanningViewModelDelegate {
    public func dismissView() {
        dismissViewAnimated()
    }
}

extension MediaViewer: MediaViewerContentsViewActionsDelegate {
    public func longPressActionDetectedInContentView(contentView: MediaViewerContentsView) {
        if let image = contentsView.scrollView.currentImageView()?.imageView.image {
            let alert = imageTaskHandler.actionSheetWithAllTasksForImage(image)
            presentViewController(alert, animated: true, completion: nil)
        }
    }
}
