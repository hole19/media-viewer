import UIKit
import H19MediaViewer

class ViewController: UIViewController {
    private struct Media {
        let view: UIImageView
        let model: MediaViewerImageModel
    }

    private lazy var imageViewAspectFill: Media = {
        let view = UIImageView(image: UIImage(named: "vampeta")!)
        view.contentMode = .scaleAspectFill
        let overlay = MediaViewerAuthorInfoOverlayViewModel(authorImageURL: nil,
                                                          authorTitle: "Hulk Hogan",
                                                          datePictureWasTaken: Date())
        let model = MediaViewerImage(image: view.image,
                                     sourceImageView: view,
                                     infoOverlayViewClass: MediaViewerAuthorInfoOverlayView.self)
        model.overlayInfoModel = overlay
        return Media(view: view, model: model)
    }()

    private lazy var imageViewAspectFit: Media = {
        let view = UIImageView(image: UIImage(named: "vampeta")!)
        view.contentMode = .scaleAspectFit
        let overlay = MediaViewerAuthorInfoOverlayViewModel(authorImageURL: nil,
                                                          authorTitle: "The Undertaker",
                                                          datePictureWasTaken: Date())
        let model = MediaViewerImage(image: view.image,
                                     sourceImageView: view,
                                     infoOverlayViewClass: MediaViewerAuthorInfoOverlayView.self)
        model.overlayInfoModel = overlay
        return Media(view: view, model: model)
    }()

    private lazy var imageViewFill: Media = {
        let view = UIImageView(image: UIImage(named: "vampeta")!)
        view.contentMode = .scaleToFill
        let overlay = MediaViewerAuthorInfoOverlayViewModel(authorImageURL: nil,
                                                          authorTitle: "John Cena",
                                                          datePictureWasTaken: Date())
        let model = MediaViewerImage(image: view.image,
                                     sourceImageView: view,
                                     infoOverlayViewClass: MediaViewerAuthorInfoOverlayView.self)
        model.overlayInfoModel = overlay
        return Media(view: view, model: model)
    }()

    private lazy var imageViewMultiple: Media = {
        let view = UIImageView(image: UIImage(named: "vampeta")!)
        view.contentMode = .scaleAspectFill
        let overlay = MediaViewerAuthorInfoOverlayViewModel(authorImageURL: nil,
                                                          authorTitle: "Triple H",
                                                          datePictureWasTaken: Date())
        let model = MediaViewerImage(image: view.image,
                                     sourceImageView: view,
                                     infoOverlayViewClass: MediaViewerAuthorInfoOverlayView.self)
        model.overlayInfoModel = overlay
        return Media(view: view, model: model)
    }()

    private lazy var allImages: [Media] = {
        [imageViewAspectFill, imageViewAspectFit, imageViewFill, imageViewMultiple]
    }()

    private struct Constants {
        static let margin: CGFloat = 40
        static let spacing: CGFloat = 16
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        view.backgroundColor = .green

        let content = UIView()
        content.frame = CGRect(x: Constants.margin,
                               y: Constants.margin,
                               width: view.bounds.size.width - Constants.margin * 2,
                               height: view.bounds.size.height - Constants.margin * 2)
        view.addSubview(content)

        let views: [UIView] = allImages.map { $0.view }
        let count = CGFloat(views.count)
        let height = (content.frame.height - Constants.spacing * (count - 1)) / count

        for (index, view) in views.enumerated() {
            view.frame = CGRect(x: 0,
                                y: CGFloat(index) * (height + Constants.spacing),
                                width: content.frame.width,
                                height: height)
            view.clipsToBounds = true
            view.backgroundColor = .yellow
            view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.didTapImage(sender:))))
            view.isUserInteractionEnabled = true
            content.addSubview(view)
        }
    }

    @objc private func didTapImage(sender: UITapGestureRecognizer) {
        guard let imageView = sender.view as? UIImageView,
              let media = allImages.first(where: { $0.view == imageView })
            else { return }

        var allModels: [MediaViewerImageModel]?

        if imageView == imageViewMultiple.view {
            allModels = allImages.map { $0.model }
        }

        let viewer = MediaViewer(image: media.model, allImages: allModels, delegate: nil)
        viewer.tintColor = .blue
        viewer.present()
    }
}
