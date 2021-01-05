import UIKit

@objc public protocol MediaViewerMultipleImageScrollViewDelegate {
    func scrollToItemWithIndex(_ index: Int)
}

@objc public protocol MediaViewerMultipleImageScrollViewActionsDelegate: class {
    func scrollViewScrolledToImageModel(_ image: MediaViewerImageModel?)
}

public class MediaViewerMultipleImageScrollView: UIView {

    // MARK: properties

    public var scrollView: UIScrollView!

    public var contentViews = [MediaViewerInteractiveImageView]()

    public weak var mediaViewerDelegate: MediaViewerDelegate?
    public weak var scrollDelegate: MediaViewerMultipleImageScrollViewActionsDelegate?

    public var imageViewActionsDelgate: MediaViewerInteractiveImageViewDelegate? {
        didSet {
            setDelegateForAllViews(contentViews)
        }
    }
    public var singleTapGestureRecogniserThatReqiresFailure: UITapGestureRecognizer? {
        didSet {
            setRecogniserRequiredToFailWithView(currentImageView())
        }
    }

    public var images: [MediaViewerImageModel]? {
        didSet {
            guard let images = images else { return }
            var selected = selectedImage
            if selected == nil {
                selected = images.first
            }
            updateViewWithImages(images, selectedImage: selected!)
        }
    }
    public var selectedImage: MediaViewerImageModel?
    public var currentPage: Int = 0

    private struct Constants {
        static let pageSpace: CGFloat = 4.0
        static let leadingMargin: CGFloat = pageSpace / 2
    }

    public var hiddenImageView: UIImageView?

    // MARK: init

    override public init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }

    // MARK: UIView

    override public func layoutSubviews() {
        super.layoutSubviews()

        scrollView.contentSize = contentSize()

        for (index, image) in contentViews.enumerated() {
            image.frame = contentViewFrame(index: index)
        }

        if let currentImage = currentImageView() {
            scrollView.contentOffset = CGPoint(x: currentImage.frame.origin.x - Constants.leadingMargin, y: 0.0)
        }
    }

    // MARK: public

    public func currentImageView() -> MediaViewerInteractiveImageView? {
        if currentPage < contentViews.count {
            return contentViews[currentPage]
        }
        return nil
    }

    public func zoomOut() {
        if let currentTopView = currentImageView() {
            currentTopView.zoomOut()
        }
    }

    public func setImages(_ images: [MediaViewerImageModel], withSelectedOne selImage: MediaViewerImageModel) {
        removeAllCurrentContents()
        self.selectedImage = selImage
        self.images = images
    }

    public func setScrollViewImagesAlpha(_ alpha: CGFloat) {
        let current = currentImageView()
        for imageContentView in contentViews {
            if imageContentView != current {
                imageContentView.alpha = alpha
            }
        }
    }

    public func setAllImageViewsButCurrentHidden(_ hidden: Bool) {
        let current = currentImageView()
        for imageContentView in contentViews {
            if imageContentView != current {
                imageContentView.imageView.isHidden = hidden
            }
        }
    }

    // MARK: private

    private func setupView() {
        setupScrollView()
        backgroundColor = UIColor.clear
    }

    private func setupScrollView() {
        var frame = bounds
        frame.origin.x -= Constants.leadingMargin
        frame.size.width += Constants.leadingMargin * 2

        scrollView = UIScrollView(frame: frame)
        scrollView.clipsToBounds = false
        scrollView.isUserInteractionEnabled = true
        scrollView.isPagingEnabled = true
        scrollView.backgroundColor = UIColor.clear
        scrollView.delegate = self
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        addSubview(scrollView)

        scrollView.setFullScreenConstraints(sideMargins: -Constants.leadingMargin)
    }

    private func updateViewWithImages(_ newImages: [MediaViewerImageModel], selectedImage: MediaViewerImageModel) {
        for (index, image) in newImages.enumerated() {
            let contentView = contentViewWithImageModel(image, index: index)
            contentViews.append(contentView)
        }

        if let mediaViewerDelegate = mediaViewerDelegate,
           let hasMoreToLoad = mediaViewerDelegate.hasMoreImagesToLoad?(newImages),
           hasMoreToLoad {

            let contentView = contentViewWithImageModel(nil, index: newImages.count)
            contentView.activityIndicator.startAnimating()
            contentView.activityIndicator.isHidden = false
            contentViews.append(contentView)
        }

        scrollView.contentSize = contentSize()
        setRecogniserRequiredToFailWithView(currentImageView())
        setDelegateForAllViews(contentViews)
        setupInitialContentOffsetWithImages(newImages, selectedImage: selectedImage)
    }

    private func setupInitialContentOffsetWithImages(_ images: [MediaViewerImageModel], selectedImage: MediaViewerImageModel) {
        if let index = images.firstIndex(where: { (some) -> Bool in
            return some === selectedImage
        }) {
            scrollView.contentOffset = contentViewOffset(index: index)
            currentPage = index
            if let delegate = mediaViewerDelegate {
                hiddenImageView = delegate.imageViewForImage(images[index])
            }
            setRecogniserRequiredToFailWithView(contentViews[index])
        }
    }

    private func contentSize() -> CGSize {
        let pages = CGFloat(contentViews.count)
        return CGSize(width: Constants.leadingMargin * 2 + bounds.size.width * pages + Constants.pageSpace * (pages - 1),
                      height: bounds.size.height)
    }

    private func contentViewOffset(index: Int) -> CGPoint {
        return CGPoint(x: Constants.leadingMargin + (bounds.size.width + Constants.pageSpace) * CGFloat(index),
                       y: 0.0)
    }

    private func contentViewFrame(index: Int) -> CGRect {
        return CGRect(origin: contentViewOffset(index: index),
                      size: bounds.size)
    }

    private func contentViewWithImageModel(_ imageModel: MediaViewerImageModel?, index: Int) -> MediaViewerInteractiveImageView {
        let contentView = MediaViewerInteractiveImageView(frame: contentViewFrame(index: index))
        contentView.imageModel = imageModel
        scrollView.addSubview(contentView)
        return contentView
    }

    func updateViewWithCurrentPage(_ currentPageIndex: Int) {
        let currentView = contentViews[currentPageIndex]
        setRecogniserRequiredToFailWithView(currentView)
    }

    private func setRecogniserRequiredToFailWithView(_ imageView: MediaViewerInteractiveImageView?) {
        guard let imageView = imageView else { return }

        if let rec = singleTapGestureRecogniserThatReqiresFailure {
            rec.require(toFail: imageView.zoomDoubleTapGestureRecogniser)
        }
    }

    private func setDelegateForAllViews(_ allViews: [MediaViewerInteractiveImageView]) {
        if let imageViewActionsDelgate = imageViewActionsDelgate {
            for view in allViews {
                view.delegate = imageViewActionsDelgate
            }
        }
    }

    func scrollImageViewContainerToCorrespondingImage(_ index: Int) {
        if let mediaViewerDelegate = mediaViewerDelegate {
            mediaViewerDelegate.scrollImageviewsContainer().scrollToItemWithIndex(index)
        }
    }

    func hideCorrespondingImage(_ index: Int) {
        hiddenImageView?.isHidden = false
        if let mediaViewerDelegate = mediaViewerDelegate,
            let images = images, images.count > index {
            hiddenImageView = mediaViewerDelegate.imageViewForImage(images[index])
            hiddenImageView?.isHidden = true
        } else {
            hiddenImageView = nil
        }
    }

    func zoomOutAllViewsButCurrentAtIndex(_ currentIndex: Int) {
        for (index, content) in contentViews.enumerated() {
            if index != currentIndex {
                content.zoomOut(animated: false)
            }
        }
    }

    func askDelegateForMoreImages() {
        guard let images = images else { return }

        _ = mediaViewerDelegate?.loadMoreImages?(withImages: images, completition: { [weak self] (newImages, error) in
            guard let weakSelf = self, let newImages = newImages else { return }
            var newCurrentImages = newImages
            if let currentImages = weakSelf.images {
                newCurrentImages = currentImages
                newCurrentImages.append(contentsOf: newImages)
            }
            var selectedImage = newCurrentImages.first
            if let currentImage = weakSelf.currentImageView()?.imageModel {
                selectedImage = currentImage
            } else if let currentCount = weakSelf.images?.count, newCurrentImages.count > currentCount {
                selectedImage = newCurrentImages[currentCount]
            }
            if let selectedImage = selectedImage {
                weakSelf.setImages(newCurrentImages, withSelectedOne: selectedImage)
                weakSelf.scrollDelegate?.scrollViewScrolledToImageModel(selectedImage)
            }
        })
    }

    private func removeAllCurrentContents() {
        for view in contentViews {
            view.removeFromSuperview()
        }
        contentViews = [MediaViewerInteractiveImageView]()
        scrollView.contentSize = CGSize.zero
        scrollView.contentOffset = CGPoint.zero
    }
}

extension MediaViewerMultipleImageScrollView: UIScrollViewDelegate {
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        currentPage = Int(scrollView.contentOffset.x / scrollView.frame.size.width)
        updateViewWithCurrentPage(currentPage)
        scrollImageViewContainerToCorrespondingImage(currentPage)
        hideCorrespondingImage(currentPage)
        if let images = images, images.count > currentPage {
            scrollDelegate?.scrollViewScrolledToImageModel(images[currentPage])
        } else {
            scrollDelegate?.scrollViewScrolledToImageModel(nil)
            askDelegateForMoreImages()
        }
        zoomOutAllViewsButCurrentAtIndex(currentPage)
    }
}
