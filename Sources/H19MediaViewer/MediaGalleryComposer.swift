import SwiftUI
import UIKit

public enum MediaGalleryComposer {
    @MainActor
    public static func compose(
        items: [MediaGalleryItem],
        initialIndex: Int = .zero,
        source: MediaGallerySource? = nil,
        delegate: (any MediaGalleryDelegate)? = nil,
        configuration: MediaGalleryConfiguration = MediaGalleryConfiguration(),
        loadImage: @escaping @Sendable (URL) async -> UIImage? = MediaGalleryImageLoader.load
    ) -> UIViewController {
        let model = MediaGalleryModel(
            items: items,
            initialIndex: initialIndex,
            delegate: delegate,
            initialPlaceholder: source?.image(),
            configuration: configuration,
            loadImage: loadImage
        )
        let transition = MediaGalleryTransition(model: model, initialSource: source)
        let presenterBox = PresenterBox()

        let hostingController = UIHostingController(
            rootView: MediaGalleryView(
                model: model,
                onClose: { presenterBox.presenter?.dismiss(animated: true) }
            )
        )
        hostingController.view.backgroundColor = .clear

        let navigationController = MediaGalleryNavigationController(
            rootViewController: hostingController,
            model: model,
            transition: transition
        )
        presenterBox.presenter = navigationController
        return navigationController
    }

    @MainActor
    public static func compose(
        items: [MediaGalleryItem],
        initialIndex: Int = .zero,
        sourceImageView: UIImageView?,
        delegate: (any MediaGalleryDelegate)? = nil,
        configuration: MediaGalleryConfiguration = MediaGalleryConfiguration(),
        loadImage: @escaping @Sendable (URL) async -> UIImage? = MediaGalleryImageLoader.load
    ) -> UIViewController {
        compose(
            items: items,
            initialIndex: initialIndex,
            source: sourceImageView.map(MediaGallerySource.imageView),
            delegate: delegate,
            configuration: configuration,
            loadImage: loadImage
        )
    }

    @MainActor
    private final class PresenterBox {
        weak var presenter: UIViewController?
    }
}
