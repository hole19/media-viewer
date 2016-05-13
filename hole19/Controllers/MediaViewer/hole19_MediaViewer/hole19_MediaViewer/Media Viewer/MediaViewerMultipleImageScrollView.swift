
import UIKit

class MediaViewerMultipleImageScrollView: UIView {
    
    // MARK: properties

    var scrollView: UIScrollView!

    var contentViews = [MediaViewerInteractiveImageView]()
    
    var transitionDelegate: MediaViewerTransitionDelegate?
    var imageViewActionsDelgate: MediaViewerInteractiveImageViewDelegate? {
        didSet {
            setDelegateForAllViews(contentViews)
        }
    }
    var singleTapGestureRecogniserThatReqiresFailure: UITapGestureRecognizer? {
        didSet {
            setRecogniserRequiredToFailWithView(currentImageView())
        }
    }
    
    var images: [MediaViewerImage]? {
        didSet {
            guard let images = images else { return }
            var selected = selectedImage
            if selected == nil {
                selected = images.first
            }
            updateViewWithImages(images, selectedImage: selected!)
        }
    }
    var selectedImage: MediaViewerImage?
    var currentPage: Int = 0
    let inbetweenImagesMargin: CGFloat = 4.0
    
    private var hiddenImageView = UIImageView()
    
    // MARK: init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    // MARK: UIView
    
    override func layoutSubviews() {
        super.layoutSubviews()
        scrollView.contentSize = CGSize(width: scrollView.bounds.size.width * CGFloat(contentViews.count), height: bounds.size.height)
        var currentViewFrame = CGRect(x: inbetweenImagesMargin, y: 0.0, width: bounds.size.width, height: scrollView.bounds.size.height)
        for image in contentViews {
            image.frame = currentViewFrame
            currentViewFrame.origin.x += scrollView.bounds.size.width
        }
        scrollView.contentOffset = CGPoint(x:CGFloat(currentPage)*scrollView.bounds.size.width, y:0.0)
}

    // MARK: public
    
    func currentImageView() -> MediaViewerInteractiveImageView? {
        if currentPage < contentViews.count {
            return contentViews[currentPage]
        }
        return nil
    }
    
    func zoomOut() {
        if let currentTopView = currentImageView() {
            currentTopView.zoomOut()
        }
    }

    func setImages(images: [MediaViewerImage], withSelectedOne selImage: MediaViewerImage) {
        self.selectedImage = selImage
        self.images = images
    }
    
    // MARK: private
    
    private func setupView() {
        setupScrollView()
        backgroundColor = UIColor.clearColor()
    }

    private func setupScrollView() {
        var frame = bounds
        frame.origin.x -= inbetweenImagesMargin
        frame.size.width += inbetweenImagesMargin*2.0
        scrollView = UIScrollView(frame: frame)
        scrollView.clipsToBounds = false
        scrollView.userInteractionEnabled = true
        scrollView.pagingEnabled = true
        scrollView.backgroundColor = UIColor.clearColor()
        scrollView.delegate = self
        self.addSubviewAndFullScreenConstraints(scrollView, sideMargins: -inbetweenImagesMargin)
    }

    private func updateViewWithImages(newImages: [MediaViewerImage], selectedImage: MediaViewerImage) {
        scrollView.contentSize = CGSize(width: scrollView.bounds.size.width * CGFloat(newImages.count), height: bounds.size.height)
        var currentViewFrame = scrollView.bounds
        currentViewFrame.origin.x = inbetweenImagesMargin
        currentViewFrame.size.width = bounds.width
        for image in newImages {
            let contentView = MediaViewerInteractiveImageView(frame: currentViewFrame)
            contentView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
            contentView.imageModel = image
            contentViews.append(contentView)
            scrollView.addSubview(contentView)
            currentViewFrame.origin.x += scrollView.bounds.size.width
        }
        setRecogniserRequiredToFailWithView(currentImageView())
        setDelegateForAllViews(contentViews)
        if let index = newImages.indexOf(selectedImage) {
            scrollView.contentOffset = CGPoint(x:CGFloat(index)*scrollView.bounds.size.width, y:0.0)
            currentPage = index
            if let hiddentImageView = transitionDelegate?.imageViewForImage(newImages[index]) {
                self.hiddenImageView = hiddentImageView
            }
        }
    }
    
    private func updateViewWithCurrentPage(currentPageIndex: Int) {
        let currentView = contentViews[currentPageIndex]
        setRecogniserRequiredToFailWithView(currentView)
    }
    
    private func setRecogniserRequiredToFailWithView(imageView: MediaViewerInteractiveImageView?) {
        guard let imageView = imageView else { return }
        
        if let rec = singleTapGestureRecogniserThatReqiresFailure {
            rec.requireGestureRecognizerToFail(imageView.zoomDoubleTapGestureRecogniser)
        }
    }
    
    private func setDelegateForAllViews(allViews: [MediaViewerInteractiveImageView]) {
        if let imageViewActionsDelgate = imageViewActionsDelgate {
            for view in allViews {
                view.delegate = imageViewActionsDelgate
            }
        }
    }
    
    private func scrollImageViewContainerToCorrespondingImage(index: Int) {
        if let transitionDelegate = transitionDelegate {
            if let collectionView = transitionDelegate.scrollImageviewsContainer() as? UICollectionView {
                collectionView.scrollToItemWithIndex(index)
            }
        }
    }
    
    private func hideCorrespondingImage(index: Int) {
        hiddenImageView.hidden = false
        if let transitionDelegate = transitionDelegate,
           let images = images {
            if let hiddentImageView = transitionDelegate.imageViewForImage(images[index]) {
                self.hiddenImageView = hiddentImageView
                hiddentImageView.hidden = true
            }
        }
    }
}

extension MediaViewerMultipleImageScrollView: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        currentPage = Int(scrollView.contentOffset.x / scrollView.frame.size.width)
        updateViewWithCurrentPage(currentPage)
        scrollImageViewContainerToCorrespondingImage(currentPage)
        hideCorrespondingImage(currentPage)
    }
}
