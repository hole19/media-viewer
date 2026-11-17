import UIKit

/// Where the zoom transition starts and ends for an item: the thumbnail the user tapped.
///
/// Use `.imageView(_:)` for UIKit thumbnails, or `.frame(_:image:cornerRadius:)` when there is no
/// `UIImageView` to point at, e.g. a SwiftUI grid.
@MainActor
public struct MediaGallerySource {
    let image: () -> UIImage?
    let frame: (_ container: UIView) -> CGRect?
    let cornerRadius: () -> CGFloat
    let setHidden: (Bool) -> Void

    /// Reads the image, frame and corner radius from the image view when the transition runs,
    /// and hides it while the gallery covers it. The image view is held weakly.
    public static func imageView(_ imageView: UIImageView) -> MediaGallerySource {
        MediaGallerySource(
            image: { [weak imageView] in imageView?.image },
            frame: { [weak imageView] container in
                guard let imageView, let superview = imageView.superview, imageView.window != nil
                else { return nil }
                return superview.convert(imageView.frame, to: container)
            },
            cornerRadius: { [weak imageView] in imageView?.layer.cornerRadius ?? .zero },
            setHidden: { [weak imageView] isHidden in imageView?.isHidden = isHidden }
        )
    }

    /// A thumbnail at `frame`, in window coordinates (SwiftUI's `.global` space).
    /// Without an `image` the gallery fades in instead of zooming.
    public static func frame(
        _ frame: CGRect,
        image: UIImage?,
        cornerRadius: CGFloat = .zero
    ) -> MediaGallerySource {
        MediaGallerySource(
            image: { image },
            frame: { container in container.convert(frame, from: nil) },
            cornerRadius: { cornerRadius },
            setHidden: { _ in }
        )
    }
}
