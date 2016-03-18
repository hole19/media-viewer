
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
        setupImageView()
        backgroundColor = UIColor.clearColor()
    }

    private func setupImageView() {
        imageView = UIImageView(frame: CGRectMake(0,0,100,100))
        imageView.contentMode = .ScaleAspectFit
        imageView.clipsToBounds = true
        imageView.alpha = 0.0
        addSubviewAndFullScreenConstraints(imageView)
    }

}