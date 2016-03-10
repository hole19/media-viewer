
import UIKit

class MediaViewerContentsView: UIView {
    
    // MARK: properties
    
    var backgroundView: UIView!
    var closeButton: UIButton!
    var imageView: UIImageView!

    // MARK: init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: UIView
    
    // MARK: public
    
    // MARK: private
    
    private func setupView() {
        setupBackgroundView()
        setupImageView()
        setupCloseButton()
        backgroundColor = UIColor.clearColor()
    }
    
    private func setupImageView() {
        imageView = UIImageView(frame: CGRectMake(0,0,100,100))
        imageView.contentMode = .ScaleAspectFit
        imageView.clipsToBounds = true
        imageView.alpha = 0.0
        addSubviewAndFullScreenConstraints(imageView)
    }
    
    private func setupBackgroundView() {
        backgroundView = UIView()
        backgroundView.alpha = 0.0
        backgroundView.backgroundColor = UIColor.blackColor()
        addSubviewAndFullScreenConstraints(backgroundView)
    }
    
    private func setupCloseButton() {
        closeButton = UIButton(type: UIButtonType.RoundedRect)
        closeButton.alpha = 0.0
        closeButton.setTitle(NSLocalizedString("Close", comment: ""), forState: UIControlState.Normal)
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        closeButton.backgroundColor = UIColor.whiteColor()
        addSubview(closeButton)
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("[closeButton(88)]-20-|", options: NSLayoutFormatOptions.AlignAllLeft, metrics: nil, views: ["closeButton" : closeButton]))
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-20-[closeButton(44)]", options: NSLayoutFormatOptions.AlignAllLeft, metrics: nil, views: ["closeButton" : closeButton]))
    }
    
    private func addSubviewAndFullScreenConstraints(subview: UIView) {
        subview.translatesAutoresizingMaskIntoConstraints = false
        addSubview(subview)
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("|[subview]|", options: NSLayoutFormatOptions.AlignAllLeft, metrics: nil, views: ["subview" : subview]))
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[subview]|", options: NSLayoutFormatOptions.AlignAllLeft, metrics: nil, views: ["subview" : subview]))
    }


}