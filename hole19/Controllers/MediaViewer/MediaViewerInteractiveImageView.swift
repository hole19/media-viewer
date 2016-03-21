
import UIKit

class MediaViewerInteractiveImageView: UIView {

    // MARK: properties
    
    var imageView: UIImageView!
    var scrollView: UIScrollView!

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
    
    // MARK: public
    
    // MARK: private
    
    private func setupView() {
        setupScrollView()
        setupImageView()
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
        scrollView.maximumZoomScale = 2.0
        scrollView.zoomScale = 1.0
        scrollView.delegate = self
        addSubviewAndFullScreenConstraints(scrollView)
    }

}

extension MediaViewerInteractiveImageView: UIScrollViewDelegate {
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return imageView
    }
}