
import UIKit

class MediaViewerMultipleImageScrollView: UIView {
    
    // MARK: properties

    var scrollView: UIScrollView!

    var contentViews = [MediaViewerInteractiveImageView]()

    var images: [UIImage]? {
        didSet {
            guard let images = images else { return }
            updateViewWithImages(images)
        }
    }
    
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
        scrollView.contentSize = CGSize(width: bounds.size.width * CGFloat(contentViews.count), height: bounds.size.height)
        var currentViewFrame = scrollView.bounds
        for image in contentViews {
            image.frame = currentViewFrame
            currentViewFrame.origin.x += scrollView.bounds.size.width
        }
    }

    // MARK: public
    
    func currentImageView() -> MediaViewerInteractiveImageView? {
        return contentViews.first
    }

    // MARK: private
    
    private func setupView() {
        setupScrollView()
        backgroundColor = UIColor.clearColor()
    }

    private func setupScrollView() {
        scrollView = UIScrollView(frame: bounds)
        scrollView.clipsToBounds = false
        scrollView.userInteractionEnabled = true
        scrollView.pagingEnabled = true
        scrollView.backgroundColor = UIColor.clearColor()
        scrollView.delegate = self
        self.addSubviewAndFullScreenConstraints(scrollView)
    }

    private func updateViewWithImages(newImages: [UIImage]) {
        scrollView.contentSize = CGSize(width: bounds.size.width * CGFloat(newImages.count), height: bounds.size.height)
        var currentViewFrame = scrollView.bounds
        for image in newImages {
            let contentView = MediaViewerInteractiveImageView(frame: currentViewFrame)
            contentView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
            contentView.imageView.image = image
            contentViews.append(contentView)
            scrollView.addSubview(contentView)
            currentViewFrame.origin.x += currentViewFrame.size.width
        }
    }
}

extension MediaViewerMultipleImageScrollView: UIScrollViewDelegate {
    
}
