
import UIKit
import SDWebImage

/// Swift class to display image gallery
class MediaViewer: UIViewController {
    
    // MARK: properties
    
    /// Property to determine if you want the gallery to be dismissable in landscape orientation.
    var allowLandscapeDismissal = false
    
    internal var sourceImageView: UIImageView?
    internal var initialImage: MediaViewerImageModel?
    
    internal var transitionAnimator: MediaViewerTransitionAnimator?
    
    internal var contentsView: MediaViewerContentsView!
    internal var imageTaskHandler = MediaViewerImageActionsHandler()
    internal var allImages: [MediaViewerImageModel]?
    internal var transitionDelegate: MediaViewerDelegate?
    
    internal var foregroundWindow: UIWindow?
    
    // MARK: init
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nil, bundle: nil)
    }
    
    /**
     Designated initialiser.
     
     :param: image MediaViewerImage instance with the source image to present.
     :param: allImages optional array of MediaViewerImage objects to present in a horizontal scroll view.
     :param: delegate - MediaViewerDelegate - optional delegate to support additional actions such as auto-scrolling underlying collection view.
     */
    convenience init(image: MediaViewerImageModel, allImages: [MediaViewerImageModel]? = nil, delegate:MediaViewerDelegate? = nil) {
        self.init(nibName: nil, bundle: nil)
        self.sourceImageView = image.sourceImageView
        self.allImages = allImages
        self.transitionDelegate = delegate
        self.initialImage = image
        modalPresentationStyle = .OverCurrentContext
    }

    // MARK: UIViewController
    
    override func loadView() {
        super.loadView()
        setupView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if transitionAnimator == nil {
            transitionAnimator = MediaViewerTransitionAnimator(sourceImageView: sourceImageView, contentsView: contentsView, transitionDelegate: transitionDelegate)
        }
        contentsView.pannedViewModel.delegate = self
    }
    
    override func viewDidLayoutSubviews() {
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
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        transitionAnimator?.transitionToDestinationImageView(true)
    }
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
        contentsView.scrollView.layoutSubviews()
        coordinator.animateAlongsideTransition({ (coordinate) in
            self.contentsView.updateViewStateWithLandscape(size.width > size.height)
        }) { (coordinate) in }
    }

    // MARK: public

    func present() {
        foregroundWindow = UIWindow(frame: UIScreen.mainScreen().bounds)
        
        guard let foregroundWindow = foregroundWindow else { return }

        foregroundWindow.backgroundColor = UIColor.clearColor()
        foregroundWindow.rootViewController = self
        foregroundWindow.windowLevel = UIWindowLevelStatusBar
        foregroundWindow.hidden = false
    }
    
    // MARK: public selectors
    
    func close(sender: UIButton) {
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
    func dismissView() {
        dismissViewAnimated()
    }
}

extension MediaViewer: MediaViewerContentsViewActionsDelegate {
    func longPressActionDetectedInContentView(contentView: MediaViewerContentsView) {
        if let image = contentsView.scrollView.currentImageView()?.imageView.image {
            let alert = imageTaskHandler.actionSheetWithAllTasksForImage(image)
            presentViewController(alert, animated: true, completion: nil)
        }
    }
}
