
import UIKit
import SDWebImage

class MediaViewer: UIViewController {
    
    // MARK: properties
    
    var mediaURL = NSURL()
    var sourceImageView: UIImageView?
    var backgroundView: UIView!
    var closeButton: UIButton!
    
    var transitionAnimator: MediaViewerTransitionAnimator?
    
    var imageView: UIImageView!
    
    // MARK: init
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nil, bundle: nil)
    }
    
    convenience init(mediaURL: NSURL, sourceImageView: UIImageView) {
        self.init(nibName: nil, bundle: nil)
        self.mediaURL = mediaURL
        self.sourceImageView = sourceImageView
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
            transitionAnimator = MediaViewerTransitionAnimator(sourceImageView: sourceImageView, destinationImageView: imageView, backgroundView: backgroundView)
        }
        imageView.sd_setImageWithURL(mediaURL)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        transitionAnimator?.transitionToDestinationImageView(true)
    }
    
    // MARK: public
    
    func close(sender: UIButton) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: private
    
    private func setupView() {
        setupBackgroundView()
        setupImageView()
        setupCloseButton()
        view.backgroundColor = UIColor.clearColor()
    }
    
    private func setupImageView() {
        imageView = UIImageView()
        imageView.contentMode = .ScaleAspectFit
        addSubviewAndFullScreenConstraints(imageView)
    }
    
    private func setupBackgroundView() {
        backgroundView = UIView()
        backgroundView.backgroundColor = UIColor.blackColor()
        addSubviewAndFullScreenConstraints(backgroundView)
    }
    
    private func setupCloseButton() {
        closeButton = UIButton(type: UIButtonType.RoundedRect)
        closeButton.setTitle(NSLocalizedString("Close", comment: ""), forState: UIControlState.Normal)
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        closeButton.backgroundColor = UIColor.whiteColor()
        closeButton.addTarget(self, action: "close:", forControlEvents: UIControlEvents.TouchUpInside)
        backgroundView.addSubview(closeButton)
        backgroundView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("[closeButton(88)]-20-|", options: NSLayoutFormatOptions.AlignAllLeft, metrics: nil, views: ["closeButton" : closeButton]))
        backgroundView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-20-[closeButton(44)]", options: NSLayoutFormatOptions.AlignAllLeft, metrics: nil, views: ["closeButton" : closeButton]))
    }
    
    private func addSubviewAndFullScreenConstraints(subview: UIView) {
        subview.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(subview)
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("|[subview]|", options: NSLayoutFormatOptions.AlignAllLeft, metrics: nil, views: ["subview" : subview]))
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[subview]|", options: NSLayoutFormatOptions.AlignAllLeft, metrics: nil, views: ["subview" : subview]))
    }
}