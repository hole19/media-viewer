import UIKit

public protocol MediaViewerInteractiveImageViewDelegate: class {
    func hideControls()
}

public class MediaViewerInteractiveImageView: UIView {

    // MARK: properties

    public weak var delegate: MediaViewerInteractiveImageViewDelegate?
    public var imageModel: MediaViewerImageModel? {
        didSet {
            updateViewWithModel(imageModel)
        }
    }

    public var maximumZoomScale: CGFloat = 4.0 {
        didSet {
            scrollView.maximumZoomScale = maximumZoomScale
        }
    }

    public var imageView = UIImageView()
    public let activityIndicator = UIActivityIndicatorView(style: .whiteLarge)

    public lazy var scrollView = { return UIScrollView(frame: bounds) }()

    public var zoomDoubleTapGestureRecogniser: UITapGestureRecognizer = {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(viewDoubleTapped(_:)))
        gesture.numberOfTapsRequired = 2
        return gesture
    }()

    // MARK: private properties

    var previousZoomScale: CGFloat = 1.0

    // MARK: init

    override public init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }

    // MARK: public

    public func zoomOut(animated: Bool = true) {
        if scrollView.zoomScale > 1.0 {
            scrollView.setZoomScale(1.0, animated: animated)
        }
    }

    // MARK: public - selectors

    @objc public func viewDoubleTapped(_ sender: UITapGestureRecognizer) {
        if scrollView.zoomScale <= 1.01 {
            let zoomPoint = sender.location(in: scrollView)

            //derive the size of the region to zoom to
            let zoomSize = CGSize(width: scrollView.bounds.size.width / maximumZoomScale,
                                  height: scrollView.bounds.size.height / maximumZoomScale)

            //offset the zoom rect so the actual zoom point is in the middle of the rectangle
            let zoomRect = CGRect(x: zoomPoint.x - zoomSize.width / 2.0,
                                  y: zoomPoint.y - zoomSize.height / 2.0,
                                  width: zoomSize.width,
                                  height: zoomSize.height)

            scrollView.zoom(to: zoomRect, animated: true)
        } else {
            scrollView.setZoomScale(1.0, animated: true)
        }
    }

    // MARK: private

    private func setupView() {
        setupScrollView()
        setupImageView()
        setupTapGestureRecogniser()
        setupActivityIndicatorView()
        backgroundColor = UIColor.clear
    }

    private func setupImageView() {
        imageView.frame = scrollView.bounds
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        scrollView.addSubview(imageView)
        scrollView.contentSize = imageView.bounds.size
    }

    private func setupScrollView() {
        scrollView.clipsToBounds = false
        scrollView.isUserInteractionEnabled = true
        scrollView.backgroundColor = UIColor.clear
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = maximumZoomScale
        scrollView.zoomScale = 1.0
        scrollView.delegate = self
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        addSubviewWithFullScreenConstraints(scrollView)
    }

    private func setupActivityIndicatorView() {
        activityIndicator.isHidden = true
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        addSubview(activityIndicator)
        addConstraint(NSLayoutConstraint(item: activityIndicator,
                                         attribute: .centerX,
                                         relatedBy: .equal,
                                         toItem: self,
                                         attribute: .centerX,
                                         multiplier: 1.0, constant: 0.0)
        )
        addConstraint(NSLayoutConstraint(item: activityIndicator,
                                         attribute: .centerY,
                                         relatedBy: .equal,
                                         toItem: self,
                                         attribute: .centerY,
                                         multiplier: 1.0, constant: 0.0)
        )
    }

    private func setupTapGestureRecogniser() {
        addGestureRecognizer(zoomDoubleTapGestureRecogniser)
    }

    private func updateViewWithModel(_ imageModel: MediaViewerImageModel?) {
        imageView.image = imageModel?.image
        if let url = imageModel?.imageURL {
            imageView.sd_setImage(with: url, placeholderImage: imageModel?.image)
        }
    }
}

extension MediaViewerInteractiveImageView: UIScrollViewDelegate {
    public func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }

    public func scrollViewDidZoom(_ scrollView: UIScrollView) {
        if scrollView.zoomScale > previousZoomScale {
            delegate?.hideControls()
        }
        previousZoomScale = scrollView.zoomScale
    }
}
