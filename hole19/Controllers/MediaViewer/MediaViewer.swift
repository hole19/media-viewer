
import UIKit
import SDWebImage

class MediaViewer: UIViewController {
    
    // MARK: properties
    
    var mediaURL = NSURL()
    
    var imageView: UIImageView!
    
    // MARK: init
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nil, bundle: nil)
    }
    
    convenience init(mediaURL: NSURL) {
        self.init(nibName: nil, bundle: nil)
        
        self.mediaURL = mediaURL
    }

    // MARK: UIViewController
    
    override func loadView() {
        super.loadView()
        setupImageView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.sd_setImageWithURL(mediaURL)
    }
    
    // MARK: public
    
    // MARK: private
    
    func setupImageView() {
        imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .ScaleAspectFit
        view.addSubview(imageView)
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("|[imageView]|", options: NSLayoutFormatOptions.AlignAllLeft, metrics: nil, views: ["imageView" : imageView]))
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[imageView]|", options: NSLayoutFormatOptions.AlignAllLeft, metrics: nil, views: ["imageView" : imageView]))
    }

}