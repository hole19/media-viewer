
import UIKit

protocol MediaViewerInteractiveImageViewDelegate: class {
    func hideControls()
}

class MediaViewerInteractiveImageView: UIView {

    // MARK: properties
    
    weak var delegate: MediaViewerInteractiveImageViewDelegate?
    
    var maximumZoomScale: CGFloat = 4.0 {
        didSet {
            scrollView.maximumZoomScale = maximumZoomScale
        }
    }
    
    var imageView: UIImageView!
    var scrollView: UIScrollView!

    var zoomDoubleTapGestureRecogniser: UITapGestureRecognizer!
    
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
    
    // MARK: public - selectors
    
    func viewDoubleTapped(sender: UITapGestureRecognizer) {
        var newZoomScale: CGFloat = 1.0
        if scrollView.zoomScale < scrollView.minimumZoomScale + (maximumZoomScale - scrollView.minimumZoomScale) * 0.5 {
            newZoomScale = maximumZoomScale
        }
        scrollView.setZoomScale(newZoomScale, animated: true)
    }
    
    // MARK: private
    
    private func setupView() {
        setupScrollView()
        setupImageView()
        setupTapGestureRecogniser()
        backgroundColor = UIColor.clearColor()
    }
    
    private func setupImageView() {
        imageView = UIImageView(frame: CGRectMake(0,0,100,100))
        imageView.contentMode = .ScaleAspectFit
        imageView.clipsToBounds = true
        imageView.alpha = 0.0
        imageView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        scrollView.addSubview(imageView)
        scrollView.contentSize = imageView.bounds.size
    }
    
    private func setupScrollView() {
        scrollView = UIScrollView(frame: CGRectMake(0,0,100,100))
        scrollView.clipsToBounds = true
        scrollView.userInteractionEnabled = true
        scrollView.backgroundColor = UIColor.clearColor()
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = maximumZoomScale
        scrollView.zoomScale = 1.0
        scrollView.delegate = self
        addSubviewAndFullScreenConstraints(scrollView)
    }
    
    private func setupTapGestureRecogniser() {
        zoomDoubleTapGestureRecogniser = UITapGestureRecognizer(target: self, action: "viewDoubleTapped:")
        zoomDoubleTapGestureRecogniser.numberOfTapsRequired = 2
        addGestureRecognizer(zoomDoubleTapGestureRecogniser)
    }

}

extension MediaViewerInteractiveImageView: UIScrollViewDelegate {
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    func scrollViewDidZoom(scrollView: UIScrollView) {
        delegate?.hideControls()
    }
}