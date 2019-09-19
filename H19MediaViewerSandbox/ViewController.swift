import UIKit
import H19MediaViewer

class ViewController: UIViewController {
    lazy var imageViewAspectFill: UIImageView = {
        let view = UIImageView(image: UIImage(named: "vampeta")!)
        view.contentMode = .scaleAspectFill
        return view
    }()

    lazy var imageViewAspectFit: UIImageView = {
        let view = UIImageView(image: UIImage(named: "vampeta")!)
        view.contentMode = .scaleAspectFit
        return view
    }()

    lazy var imageViewFill: UIImageView = {
        let view = UIImageView(image: UIImage(named: "vampeta")!)
        view.contentMode = .scaleToFill
        return view
    }()

    private struct Constants {
        static let margin: CGFloat = 20
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

        let views: [UIView] = [imageViewAspectFill, imageViewAspectFit, imageViewFill]
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

    @objc func didTapImage(sender: UITapGestureRecognizer) {
        guard let imageView = sender.view as? UIImageView,
            let image = imageView.image
            else { return }

        let model = MediaViewerImage(image: image, sourceImageView: imageView)
        model.sourceImageView = imageView

        let viewer = MediaViewer(image: model)
        viewer.tintColor = .blue
        viewer.present()
    }
}
