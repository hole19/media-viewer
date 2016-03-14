
import Foundation

class MediaViewerAuthorInfoOverlayView: MediaViewerInfoOverlayView {
    
    // MARK: properties

    var authorImageView: UIImageView!
    var authorTitleLablel: UILabel!
    
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
        setupAuthorTitleLabel()
    }
    
    private func setupImageView() {
        authorImageView = UIImageView(frame: CGRectMake(0,0,100,100))
        authorImageView.contentMode = .ScaleAspectFit
        authorImageView.clipsToBounds = true
        authorImageView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(authorImageView)
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("|-[authorImageView(44)]", options: NSLayoutFormatOptions.AlignAllLeft, metrics: nil, views: ["authorImageView" : authorImageView]))
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-[authorImageView(44)]", options: NSLayoutFormatOptions.AlignAllLeft, metrics: nil, views: ["authorImageView" : authorImageView]))
    }
    
    private func setupAuthorTitleLabel() {
        authorTitleLablel = UILabel(frame: CGRectMake(0,0,100,100))
        authorTitleLablel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(authorTitleLablel)
//        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("|-[authorImageView(44)]", options: NSLayoutFormatOptions.AlignAllLeft, metrics: nil, views: ["authorImageView" : authorImageView]))
//        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-[authorImageView(44)]", options: NSLayoutFormatOptions.AlignAllLeft, metrics: nil, views: ["authorImageView" : authorImageView]))
    }
}

//extension MediaViewerAuthorInfoOverlayView: MediaViewerInfoOverlayView {
//    func defaultHeight() -> CGFloat {
//        return 88.0
//    }
//}
