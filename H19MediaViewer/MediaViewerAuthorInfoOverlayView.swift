
import UIKit

public class MediaViewerAuthorInfoOverlayViewModel: MediaViewerAuthorInfoOverlayViewModelProtocol {
    public var authorImageURL: NSURL
    public var authorTitle: String
    public var datePictureWasTaken: NSDate?

    public init(authorImageURL: NSURL?, authorTitle: String?, datePictureWasTaken: NSDate? = nil) {
        self.authorImageURL = authorImageURL ?? NSURL()
        self.authorTitle = authorTitle ?? ""
        self.datePictureWasTaken = datePictureWasTaken
    }
}

public protocol MediaViewerAuthorInfoOverlayViewModelProtocol {
    var authorImageURL: NSURL { get }
    var authorTitle: String { get }
    var datePictureWasTaken: NSDate? { get }
}

public class MediaViewerAuthorInfoOverlayView: MediaViewerInfoOverlayView {
    
    // MARK: properties

    public var authorImageView: UIImageView!
    public var authorTitleLablel: UILabel!
    public var takenByTitle: UILabel!
    public var dateTakenLabel: UILabel!
    public var blurBackground: UIVisualEffectView!
    
    // MARK: init

    required public init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required public init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    // MARK: MediaViewerInfoOverlayView
    
    override public func defaultHeight() -> CGFloat {
        return 80.0
    }
    
    override public func updateViewWithModel(model: Any?) {
        if let model = model as? MediaViewerAuthorInfoOverlayViewModelProtocol {
            authorTitleLablel.text = model.authorTitle
            authorImageView.sd_setImageWithURL(model.authorImageURL)
            if let date = model.datePictureWasTaken {
                dateTakenLabel.text = date.defaultString()
            } else {
                dateTakenLabel.text = ""
            }
        } else {
            dateTakenLabel.text = ""
            authorTitleLablel.text = ""
            authorImageView.image = nil
        }
    }
    
    // MARK: public
    
    // MARK: private
    
    private func setupView() {
        setupBlurView()
        setupImageView()
        setupAuthorTitleLabel()
        setupTakenByLabel()
        setupDateTakenLabel()
        updateViewWithModel(model)
    }
    
    private func setupImageView() {
        authorImageView = UIImageView(frame: CGRectMake(0,0,100,100))
        authorImageView.contentMode = .ScaleAspectFill
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
        authorTitleLablel = addLabelSubviewWithFont(UIFont.boldSystemFontOfSize(14.0), color: UIColor.whiteColor())
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("|-44-[authorTitleLablel]-8-|", options: NSLayoutFormatOptions.AlignAllLeft, metrics: nil, views: ["authorTitleLablel" : authorTitleLablel]))
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-36-[authorTitleLablel]", options: NSLayoutFormatOptions.AlignAllLeft, metrics: nil, views: ["authorTitleLablel" : authorTitleLablel]))
    }
    
    private func setupTakenByLabel() {
        takenByTitle = addLabelSubviewWithFont(UIFont.boldSystemFontOfSize(11.0), color: UIColor(red:155.0/255.0, green:155.0/255.0, blue:155.0/255.0, alpha:1.00))
        //        takenByTitle.text = NSLocalizedString("klMediaViewer_TakenBy", comment: "")
        takenByTitle.text = "TAKEN BY"
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("|-8-[takenByTitle]-8-|", options: NSLayoutFormatOptions.AlignAllLeft, metrics: nil, views: ["takenByTitle" : takenByTitle]))
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-13-[takenByTitle]", options: NSLayoutFormatOptions.AlignAllLeft, metrics: nil, views: ["takenByTitle" : takenByTitle]))
    }
    
    private func setupDateTakenLabel() {
        dateTakenLabel = addLabelSubviewWithFont(UIFont.systemFontOfSize(12.0), color: UIColor(red:0.64, green:0.64, blue:0.64, alpha:1.00))
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("|-44-[dateTakenLabel]-8-|", options: NSLayoutFormatOptions.AlignAllLeft, metrics: nil, views: ["dateTakenLabel" : dateTakenLabel]))
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-53-[dateTakenLabel]", options: NSLayoutFormatOptions.AlignAllLeft, metrics: nil, views: ["dateTakenLabel" : dateTakenLabel]))
    }
}
