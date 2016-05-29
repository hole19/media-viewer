
import UIKit

protocol MediaViewerInteractiveImageViewDelegate: class {
    func hideControls()
}

class MediaViewerInteractiveImageView: UIView {

    // MARK: properties
    
    weak var delegate: MediaViewerInteractiveImageViewDelegate?
    var imageModel: MediaViewerImage? {
        didSet {
            updateViewWithModel(imageModel)
        }
    }
    
    var maximumZoomScale: CGFloat = 4.0 {
        didSet {
            scrollView.maximumZoomScale = maximumZoomScale
        }
    }
    
    var imageView: UIImageView!
    var scrollView: UIScrollView!
    var activityIndicator: UIActivityIndicatorView!

    var zoomDoubleTapGestureRecogniser: UITapGestureRecognizer!
    
    // MARK: private properties

    private var previousZoomScale: CGFloat = 1.0
    
    // MARK: init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    
    // MARK: public
    
    func zoomOut(animated animated: Bool = true) {
        if scrollView.zoomScale > 1.0 {
            scrollView.setZoomScale(1.0, animated: animated)
        }
    }
    
    // MARK: public - selectors
    
    func viewDoubleTapped(sender: UITapGestureRecognizer) {
        if scrollView.zoomScale < scrollView.minimumZoomScale + (maximumZoomScale - scrollView.minimumZoomScale) * 0.5 {
            let zoomPoint = sender.locationInView(scrollView)
            
            //derive the size of the region to zoom to
            let zoomSize = CGSize(width: scrollView.bounds.size.width / maximumZoomScale, height: scrollView.bounds.size.height / maximumZoomScale)
            
            //offset the zoom rect so the actual zoom point is in the middle of the rectangle
            let zoomRect = CGRectMake(zoomPoint.x - zoomSize.width / 2.0, zoomPoint.y - zoomSize.height / 2.0, zoomSize.width, zoomSize.height)
            
            scrollView.zoomToRect(zoomRect, animated: true)
        } else {
            scrollView.setZoomScale(1.0, animated: true)
        }
    }
    
    
    // MARK: private
    
    private func setupView() {
        setupScrollView()
        setupImageView()
        setupTapGestureRecogniser()
        setupActivityIndicatorView()
        backgroundColor = UIColor.clearColor()
    }
    
    private func setupImageView() {
        imageView = UIImageView(frame: scrollView.bounds)
        imageView.contentMode = .ScaleAspectFit
        imageView.clipsToBounds = true
        scrollView.addSubviewAndFullScreenConstraints(imageView)
        scrollView.addConstraint(NSLayoutConstraint(item: imageView, attribute: NSLayoutAttribute.Width, relatedBy: .Equal, toItem: scrollView, attribute: .Width, multiplier: 1.0, constant: 0.0))
        scrollView.addConstraint(NSLayoutConstraint(item: imageView, attribute: NSLayoutAttribute.Height, relatedBy: .Equal, toItem: scrollView, attribute: .Height, multiplier: 1.0, constant: 0.0))
        scrollView.contentSize = imageView.bounds.size
    }
    
    private func setupScrollView() {
        scrollView = UIScrollView(frame: bounds)
        scrollView.clipsToBounds = false
        scrollView.userInteractionEnabled = true
        scrollView.backgroundColor = UIColor.clearColor()
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = maximumZoomScale
        scrollView.zoomScale = 1.0
        scrollView.delegate = self
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        addSubviewAndFullScreenConstraints(scrollView)
    }
    
    private func setupActivityIndicatorView() {
        activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .WhiteLarge)
        activityIndicator.hidden = true
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        addSubview(activityIndicator)
        addConstraint(NSLayoutConstraint(item: activityIndicator, attribute: .CenterX, relatedBy: .Equal, toItem: self, attribute: .CenterX, multiplier: 1.0, constant: 0.0))
        addConstraint(NSLayoutConstraint(item: activityIndicator, attribute: .CenterY, relatedBy: .Equal, toItem: self, attribute: .CenterY, multiplier: 1.0, constant: 0.0))
    }
    
    private func setupTapGestureRecogniser() {
        zoomDoubleTapGestureRecogniser = UITapGestureRecognizer(target: self, action: #selector(MediaViewerInteractiveImageView.viewDoubleTapped(_:)))
        zoomDoubleTapGestureRecogniser.numberOfTapsRequired = 2
        addGestureRecognizer(zoomDoubleTapGestureRecogniser)
    }
    
    private func updateViewWithModel(imageModel: MediaViewerImage?) {
        imageView.image = imageModel?.image
        if let url = imageModel?.imageURL {
            imageView.sd_setImageWithURL(url)
        }
    }
}

extension MediaViewerInteractiveImageView: UIScrollViewDelegate {
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    func scrollViewDidZoom(scrollView: UIScrollView) {
        if scrollView.zoomScale > previousZoomScale {
            delegate?.hideControls()
        }
        previousZoomScale = scrollView.zoomScale
    }
}