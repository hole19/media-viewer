import SwiftUI
import UIKit

struct ZoomableImageView: UIViewRepresentable {
    let image: UIImage
    let onSingleTap: () -> Void
    let onZoomChange: (Bool) -> Void
    let onLongPress: (UIImage) -> Void

    func makeCoordinator() -> Coordinator {
        Coordinator(image: image)
    }

    func makeUIView(context: Context) -> UIScrollView {
        let coordinator = context.coordinator
        let scrollView = ZoomScrollView()
        scrollView.delegate = coordinator
        scrollView.minimumZoomScale = Constants.minimumZoomScale
        scrollView.maximumZoomScale = Constants.maximumZoomScale
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.contentInsetAdjustmentBehavior = .never
        scrollView.backgroundColor = .clear

        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFit
        scrollView.addSubview(imageView)
        coordinator.imageView = imageView
        scrollView.imageView = imageView

        let doubleTap = UITapGestureRecognizer(target: coordinator, action: #selector(Coordinator.handleDoubleTap(_:)))
        doubleTap.numberOfTapsRequired = 2
        scrollView.addGestureRecognizer(doubleTap)

        let singleTap = UITapGestureRecognizer(target: coordinator, action: #selector(Coordinator.handleSingleTap))
        singleTap.require(toFail: doubleTap)
        scrollView.addGestureRecognizer(singleTap)

        let longPress = UILongPressGestureRecognizer(target: coordinator, action: #selector(Coordinator.handleLongPress(_:)))
        scrollView.addGestureRecognizer(longPress)

        return scrollView
    }

    func updateUIView(_ scrollView: UIScrollView, context: Context) {
        let coordinator = context.coordinator
        coordinator.onSingleTap = onSingleTap
        coordinator.onZoomChange = onZoomChange
        coordinator.onLongPress = onLongPress
    }

    private enum Constants {
        static let minimumZoomScale: CGFloat = 1
        static let maximumZoomScale: CGFloat = 4
        static let doubleTapZoomScale: CGFloat = 2.5
        static let zoomedThreshold: CGFloat = 1.01
    }

    final class ZoomScrollView: UIScrollView {
        var imageView: UIImageView?
        private var laidOutSize: CGSize = .zero

        override func layoutSubviews() {
            super.layoutSubviews()
            guard bounds.size != laidOutSize
            else { return }
            laidOutSize = bounds.size
            zoomScale = Constants.minimumZoomScale
            contentInset = .zero
            imageView?.frame = CGRect(origin: .zero, size: bounds.size)
            contentSize = bounds.size
            contentOffset = .zero
        }
    }

    final class Coordinator: NSObject, UIScrollViewDelegate {
        let image: UIImage
        var imageView: UIImageView?
        var onSingleTap: () -> Void = {}
        var onZoomChange: (Bool) -> Void = { _ in }
        var onLongPress: (UIImage) -> Void = { _ in }

        init(image: UIImage) {
            self.image = image
        }

        func viewForZooming(in scrollView: UIScrollView) -> UIView? {
            imageView
        }

        func scrollViewDidZoom(_ scrollView: UIScrollView) {
            guard let imageView
            else { return }
            let horizontalInset = max((scrollView.bounds.width - imageView.frame.width) / 2, .zero)
            let verticalInset = max((scrollView.bounds.height - imageView.frame.height) / 2, .zero)
            scrollView.contentInset = UIEdgeInsets(
                top: verticalInset,
                left: horizontalInset,
                bottom: verticalInset,
                right: horizontalInset
            )
            onZoomChange(scrollView.zoomScale > Constants.zoomedThreshold)
        }

        @objc func handleSingleTap() {
            onSingleTap()
        }

        @objc func handleLongPress(_ gesture: UILongPressGestureRecognizer) {
            guard gesture.state == .began
            else { return }
            onLongPress(image)
        }

        @objc func handleDoubleTap(_ gesture: UITapGestureRecognizer) {
            guard let scrollView = gesture.view as? UIScrollView
            else { return }

            guard scrollView.zoomScale <= Constants.minimumZoomScale
            else {
                scrollView.setZoomScale(Constants.minimumZoomScale, animated: true)
                return
            }

            let location = gesture.location(in: imageView)
            let zoomSize = CGSize(
                width: scrollView.bounds.width / Constants.doubleTapZoomScale,
                height: scrollView.bounds.height / Constants.doubleTapZoomScale
            )
            let zoomRect = CGRect(
                x: location.x - zoomSize.width / 2,
                y: location.y - zoomSize.height / 2,
                width: zoomSize.width,
                height: zoomSize.height
            )
            scrollView.zoom(to: zoomRect, animated: true)
        }
    }
}

#Preview("Zoomable image") {
    ZoomableImageView(
        image: MediaGalleryPreviewSupport.image(index: 1),
        onSingleTap: {},
        onZoomChange: { _ in },
        onLongPress: { _ in }
    )
    .background(Color.black)
}
