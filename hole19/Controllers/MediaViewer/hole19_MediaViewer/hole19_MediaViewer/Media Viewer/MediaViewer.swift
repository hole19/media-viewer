
import UIKit
import SDWebImage

/// Swift class to display image gallery
class MediaViewer: UIViewController {
    
    // MARK: properties
    
    internal var sourceImageView: UIImageView?
    internal var initialImage: MediaViewerImage?
    
    internal var transitionAnimator: MediaViewerTransitionAnimator?
    
    internal var contentsView: MediaViewerContentsView!
    internal var imageTaskHandler = MediaViewerImageActionsHandler()
    internal var allImages: [MediaViewerImage]?
    internal var transitionDelegate: MediaViewerDelegate?
    
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
    convenience init(image: MediaViewerImage, allImages: [MediaViewerImage]? = nil, delegate:MediaViewerDelegate? = nil) {
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
        if transitionAnimator == nil, let sourceImageView = sourceImageView {
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
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return .All
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
        contentsView = MediaViewerContentsView(frame: view.bounds, mediaViewerDelegate: transitionDelegate)
        if let initialImage = initialImage {
            contentsView.setupOverlayView(initialImage)
        }
        view.addSubviewAndFullScreenConstraints(contentsView)
        contentsView.delegate = self
    }
    
    private func setupCloseButton() {
        contentsView.closeButton.addTarget(self, action: #selector(MediaViewer.close(_:)), forControlEvents: UIControlEvents.TouchUpInside)
    }
    
    private func dismissViewAnimated() {
        transitionAnimator?.transitionBackToSourceImageView(true, withCompletition: { [weak self] in
            self?.dismissViewControllerAnimated(false, completion: nil)
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
