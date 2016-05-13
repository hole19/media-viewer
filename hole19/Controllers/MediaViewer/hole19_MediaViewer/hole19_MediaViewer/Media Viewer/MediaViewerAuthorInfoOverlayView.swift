
import UIKit

protocol MediaViewerAuthorInfoOverlayViewModel {
    var authorImageURL: NSURL { get }
    var authorTitle: String { get }
    var datePictureWasTaken: NSDate { get }
}

class MediaViewerAuthorInfoOverlayView: MediaViewerInfoOverlayView {
    
    // MARK: properties

    var authorImageView: UIImageView!
    var authorTitleLablel: UILabel!
    var takenByTitle: UILabel!
    var blurBackground: UIVisualEffectView!
    
    // MARK: init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    // MARK: MediaViewerInfoOverlayView
    
    override func defaultHeight() -> CGFloat {
        return 80.0
    }
    
    override func updateViewWithModel(model: Any?) {
        if let model = model as? MediaViewerAuthorInfoOverlayViewModel {
            authorTitleLablel.text = model.authorTitle
            authorImageView.sd_setImageWithURL(model.authorImageURL)
        }
    }
    
    // MARK: public
    
    // MARK: private
    
    private func setupView() {
        setupBlurView()
        setupImageView()
        setupAuthorTitleLabel()
        setupTakenByLabel()
        updateViewWithModel(model)
    }
    
    private func setupImageView() {
        authorImageView = UIImageView(frame: CGRectMake(0,0,100,100))
        authorImageView.contentMode = .ScaleAspectFit
        authorImageView.clipsToBounds = true
        authorImageView.translatesAutoresizingMaskIntoConstraints = false
        authorImageView.layer.cornerRadius = 3.0
        addSubview(authorImageView)
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("|-8-[authorImageView(26.0)]", options: NSLayoutFormatOptions.AlignAllLeft, metrics: nil, views: ["authorImageView" : authorImageView]))
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-39-[authorImageView(26.0)]", options: NSLayoutFormatOptions.AlignAllLeft, metrics: nil, views: ["authorImageView" : authorImageView]))
    }
    
    private func setupBlurView() {
        blurBackground = UIVisualEffectView(frame: CGRectMake(0,0,100,100))
        blurBackground.translatesAutoresizingMaskIntoConstraints = false
        blurBackground.effect = UIBlurEffect(style: UIBlurEffectStyle.Light)
        addSubview(blurBackground)
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("|[blurBackground]|", options: NSLayoutFormatOptions.AlignAllLeft, metrics: nil, views: ["blurBackground" : blurBackground]))
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[blurBackground]|", options: NSLayoutFormatOptions.AlignAllLeft, metrics: nil, views: ["blurBackground" : blurBackground]))
    }
    
    private func setupAuthorTitleLabel() {
        authorTitleLablel = UILabel(frame: CGRectMake(0,0,100,100))
        authorTitleLablel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(authorTitleLablel)
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("|-44-[authorTitleLablel]-8-|", options: NSLayoutFormatOptions.AlignAllLeft, metrics: nil, views: ["authorTitleLablel" : authorTitleLablel]))
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-34-[authorTitleLablel]", options: NSLayoutFormatOptions.AlignAllLeft, metrics: nil, views: ["authorTitleLablel" : authorTitleLablel]))
    }
    
    private func setupTakenByLabel() {
        takenByTitle = UILabel(frame: CGRectMake(0,0,100,100))
        takenByTitle.translatesAutoresizingMaskIntoConstraints = false
//        takenByTitle.text = NSLocalizedString("klMediaViewer_TakenBy", comment: "")
        takenByTitle.text = "TAKEN BY"
        addSubview(takenByTitle)
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("|-8-[takenByTitle]-8-|", options: NSLayoutFormatOptions.AlignAllLeft, metrics: nil, views: ["takenByTitle" : takenByTitle]))
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-13-[takenByTitle]", options: NSLayoutFormatOptions.AlignAllLeft, metrics: nil, views: ["takenByTitle" : takenByTitle]))
    }
    
}
