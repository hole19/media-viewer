
import UIKit

public class MediaViewerAuthorInfoOverlayViewModel: MediaViewerAuthorInfoOverlayViewModelProtocol {
    public var authorImageURL: URL
    public var authorTitle: String
    public var datePictureWasTaken: Date?

    public init(authorImageURL: URL?, authorTitle: String?, datePictureWasTaken: Date? = nil) {
        self.authorImageURL = authorImageURL!
        self.authorTitle = authorTitle ?? ""
        self.datePictureWasTaken = datePictureWasTaken
    }
}

public protocol MediaViewerAuthorInfoOverlayViewModelProtocol {
    var authorImageURL: URL { get }
    var authorTitle: String { get }
    var datePictureWasTaken: Date? { get }
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
    
    override public func updateViewWithModel(_ model: Any?) {
        if let model = model as? MediaViewerAuthorInfoOverlayViewModelProtocol {
            authorTitleLablel.text = model.authorTitle
            authorImageView.sd_setImage(with: model.authorImageURL)
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
        authorImageView = UIImageView(frame: CGRect(x: 0,y: 0,width: 100,height: 100))
        authorImageView.contentMode = .scaleAspectFill
        authorImageView.clipsToBounds = true
        authorImageView.translatesAutoresizingMaskIntoConstraints = false
        authorImageView.layer.cornerRadius = 3.0
        addSubview(authorImageView)
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "|-8-[authorImageView(26.0)]", options: NSLayoutFormatOptions.alignAllLeft, metrics: nil, views: ["authorImageView" : authorImageView]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-39-[authorImageView(26.0)]", options: NSLayoutFormatOptions.alignAllLeft, metrics: nil, views: ["authorImageView" : authorImageView]))
    }
    
    private func setupBlurView() {
        blurBackground = UIVisualEffectView(frame: CGRect(x: 0,y: 0,width: 100,height: 100))
        blurBackground.translatesAutoresizingMaskIntoConstraints = false
        blurBackground.effect = UIBlurEffect(style: UIBlurEffectStyle.dark)
        addSubview(blurBackground)
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "|[blurBackground]|", options: NSLayoutFormatOptions.alignAllLeft, metrics: nil, views: ["blurBackground" : blurBackground]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[blurBackground]|", options: NSLayoutFormatOptions.alignAllLeft, metrics: nil, views: ["blurBackground" : blurBackground]))
    }
    
    private func setupAuthorTitleLabel() {
        authorTitleLablel = addLabelSubviewWithFont(UIFont.boldSystemFont(ofSize: 14.0), color: UIColor.white())
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "|-44-[authorTitleLablel]-8-|", options: NSLayoutFormatOptions.alignAllLeft, metrics: nil, views: ["authorTitleLablel" : authorTitleLablel]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-36-[authorTitleLablel]", options: NSLayoutFormatOptions.alignAllLeft, metrics: nil, views: ["authorTitleLablel" : authorTitleLablel]))
    }
    
    private func setupTakenByLabel() {
        takenByTitle = addLabelSubviewWithFont(UIFont.boldSystemFont(ofSize: 11.0), color: UIColor(red:155.0/255.0, green:155.0/255.0, blue:155.0/255.0, alpha:1.00))
        //        takenByTitle.text = NSLocalizedString("klMediaViewer_TakenBy", comment: "")
        takenByTitle.text = "TAKEN BY"
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "|-8-[takenByTitle]-8-|", options: NSLayoutFormatOptions.alignAllLeft, metrics: nil, views: ["takenByTitle" : takenByTitle]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-13-[takenByTitle]", options: NSLayoutFormatOptions.alignAllLeft, metrics: nil, views: ["takenByTitle" : takenByTitle]))
    }
    
    private func setupDateTakenLabel() {
        dateTakenLabel = addLabelSubviewWithFont(UIFont.systemFont(ofSize: 12.0), color: UIColor(red:0.64, green:0.64, blue:0.64, alpha:1.00))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "|-44-[dateTakenLabel]-8-|", options: NSLayoutFormatOptions.alignAllLeft, metrics: nil, views: ["dateTakenLabel" : dateTakenLabel]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-53-[dateTakenLabel]", options: NSLayoutFormatOptions.alignAllLeft, metrics: nil, views: ["dateTakenLabel" : dateTakenLabel]))
    }
}
