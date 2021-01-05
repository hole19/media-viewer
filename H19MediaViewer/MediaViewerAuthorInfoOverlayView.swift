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

    private let contentView = UIView()
    private let authorImageView = UIImageView()
    private lazy var authorTitleLabel: UILabel = { return labelSubviewWithFont(Font.title, color: Color.title) }()
    private lazy var takenByTitle: UILabel = { return labelSubviewWithFont(Font.author, color: Color.author) }()
    private lazy var dateTakenLabel: UILabel = { return labelSubviewWithFont(Font.date, color: Color.date) }()
    private var blurBackground = UIVisualEffectView()

    // MARK: init

    required public init(frame: CGRect) {
        super.init(frame: frame)

        setupLayout()
        setupConstraints()

        updateViewWithModel(model)
    }

    required public init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: MediaViewerInfoOverlayView

    override public func updateViewWithModel(_ model: Any?) {
        if let model = model as? MediaViewerAuthorInfoOverlayViewModelProtocol {
            authorTitleLabel.text = model.authorTitle
            authorImageView.sd_setImage(with: model.authorImageURL)
            if let date = model.datePictureWasTaken {
                dateTakenLabel.text = date.defaultString()
            } else {
                dateTakenLabel.text = ""
            }
        } else {
            dateTakenLabel.text = ""
            authorTitleLabel.text = ""
            authorImageView.image = nil
        }
    }

    public override func updateSafeAreaBottomAnchor(_ anchor: NSLayoutYAxisAnchor?) {
        if let anchor = anchor {
            NSLayoutConstraint.activate([
                contentView.bottomAnchor.constraint(equalTo: anchor)
            ])
        }
    }

    // MARK: private

    private func setupLayout() {
        // Blur background
        blurBackground.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        blurBackground.translatesAutoresizingMaskIntoConstraints = false
        blurBackground.effect = UIBlurEffect(style: UIBlurEffect.Style.dark)
        addSubview(blurBackground)

        // Actual content
        addSubview(contentView)

        authorImageView.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        authorImageView.contentMode = .scaleAspectFill
        authorImageView.clipsToBounds = true
        authorImageView.layer.cornerRadius = 3.0
        authorImageView.backgroundColor = .white
        contentView.addSubview(authorImageView)

        contentView.addSubview(authorTitleLabel)

        takenByTitle.text = "TAKEN BY"
        contentView.addSubview(takenByTitle)

        contentView.addSubview(dateTakenLabel)
    }

    private func setupConstraints() {
        // Blur background
        blurBackground.setFullScreenConstraints()

        // Actual content
        contentView.translatesAutoresizingMaskIntoConstraints = false

         NSLayoutConstraint.activate([
            contentView.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: trailingAnchor),
            contentView.topAnchor.constraint(equalTo: topAnchor),
            contentView.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor),
            contentView.heightAnchor.constraint(equalToConstant: 80)
         ])

        authorImageView.translatesAutoresizingMaskIntoConstraints = false
        authorTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        takenByTitle.translatesAutoresizingMaskIntoConstraints = false
        dateTakenLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            // avatar
            authorImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            authorImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 39),
            authorImageView.widthAnchor.constraint(equalToConstant: 26),
            authorImageView.heightAnchor.constraint(equalTo: authorImageView.widthAnchor),

            // name
            authorTitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 44),
            authorTitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            authorTitleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 36),

            // taken by
            takenByTitle.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            takenByTitle.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            takenByTitle.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 13),

            // date taken
            dateTakenLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 44),
            dateTakenLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            dateTakenLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 53)
        ])
    }

    private func labelSubviewWithFont(_ font: UIFont, color: UIColor) -> UILabel {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        label.textColor = color
        label.font = font
        return label
    }
}
