
import UIKit

class MediaViewerAuthorInfoOverlayView: MediaViewerInfoOverlayView {
    
    // MARK: properties

    var authorImageView: UIImageView!
    var authorTitleLablel: UILabel!
    var takenByTitle: UILabel!
    
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
    
    // MARK: public
    
    // MARK: private
    
    private func setupView() {
        setupImageView()
        setupAuthorTitleLabel()
        setupTakenByLabel()
    }
    
    private func setupImageView() {
        authorImageView = UIImageView(frame: CGRectMake(0,0,100,100))
        authorImageView.contentMode = .ScaleAspectFit
        authorImageView.clipsToBounds = true
        authorImageView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(authorImageView)
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("|-8-[authorImageView(26.0)]", options: NSLayoutFormatOptions.AlignAllLeft, metrics: nil, views: ["authorImageView" : authorImageView]))
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-39-[authorImageView(26.0)]", options: NSLayoutFormatOptions.AlignAllLeft, metrics: nil, views: ["authorImageView" : authorImageView]))
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
        takenByTitle.text = NSLocalizedString("klMediaViewer_TakenBy", comment: "")
        addSubview(takenByTitle)
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("|-8-[takenByTitle]-8-|", options: NSLayoutFormatOptions.AlignAllLeft, metrics: nil, views: ["takenByTitle" : takenByTitle]))
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-13-[takenByTitle]", options: NSLayoutFormatOptions.AlignAllLeft, metrics: nil, views: ["takenByTitle" : takenByTitle]))
    }
}
