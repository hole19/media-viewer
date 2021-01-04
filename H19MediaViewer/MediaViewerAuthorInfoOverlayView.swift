import UIKit

public class MediaViewerAuthorInfoOverlayViewModel: MediaViewerAuthorInfoOverlayViewModelProtocol {
    public var authorImageURL: URL
    public var authorTitle: String
    public var datePictureWasTaken: Date?

    public init(authorImageURL: URL?, authorTitle: String?, datePictureWasTaken: Date? = nil) {
        self.authorImageURL = authorImageURL ?? URL(fileURLWithPath: "")
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

    private struct Font {
        static let title = UIFont.boldSystemFont(ofSize: 14.0)
        static let author = UIFont.boldSystemFont(ofSize: 11.0)
        static let date = UIFont.systemFont(ofSize: 12.0)
    }

    private struct Color {
        static let title = UIColor.white
        static let author = UIColor(red:155.0/255.0, green:155.0/255.0, blue:155.0/255.0, alpha:1.00)
        static let date = UIColor(red:0.64, green:0.64, blue:0.64, alpha:1.00)
    }

    // MARK: properties

    public let authorImageView = UIImageView()
    public lazy var authorTitleLablel: UILabel = { return addLabelSubviewWithFont(Font.title, color: Color.title) }()
    public lazy var takenByTitle: UILabel = { return addLabelSubviewWithFont(Font.author, color: Color.author) }()
    public lazy var dateTakenLabel: UILabel = { return addLabelSubviewWithFont(Font.date, color: Color.date) }()
    public var blurBackground = UIVisualEffectView()

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
        authorImageView.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        authorImageView.contentMode = .scaleAspectFill
        authorImageView.clipsToBounds = true
        authorImageView.translatesAutoresizingMaskIntoConstraints = false
        authorImageView.layer.cornerRadius = 3.0
        authorImageView.backgroundColor = .white
        addSubview(authorImageView)

        NSLayoutConstraint.activate([
            authorImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            authorImageView.topAnchor.constraint(equalTo: topAnchor, constant: 39),
            authorImageView.widthAnchor.constraint(equalToConstant: 26),
            authorImageView.heightAnchor.constraint(equalTo: authorImageView.widthAnchor)
        ])
    }

    private func setupBlurView() {
        blurBackground.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        blurBackground.translatesAutoresizingMaskIntoConstraints = false
        blurBackground.effect = UIBlurEffect(style: UIBlurEffect.Style.dark)
        addSubviewWithFullScreenConstraints(blurBackground)
    }

    private func setupAuthorTitleLabel() {
        NSLayoutConstraint.activate([
            authorTitleLablel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 44),
            authorTitleLablel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            authorTitleLablel.topAnchor.constraint(equalTo: topAnchor, constant: 36)
        ])
    }

    private func setupTakenByLabel() {
        takenByTitle.text = "TAKEN BY"

        NSLayoutConstraint.activate([
            takenByTitle.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            takenByTitle.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            takenByTitle.topAnchor.constraint(equalTo: topAnchor, constant: 13)
        ])
    }

    private func setupDateTakenLabel() {
        NSLayoutConstraint.activate([
            dateTakenLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 44),
            dateTakenLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            dateTakenLabel.topAnchor.constraint(equalTo: topAnchor, constant: 53)
        ])
    }
}
