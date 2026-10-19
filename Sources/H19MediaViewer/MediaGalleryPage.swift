import SwiftUI
import UIKit

struct MediaGalleryPage: View {
    let model: MediaGalleryModel
    let item: MediaGalleryItem

    @State private var image: UIImage?

    var body: some View {
        ZStack {
            if let image {
                ZoomableImageView(
                    image: image,
                    onSingleTap: { withAnimation { model.toggleChrome() } },
                    onZoomChange: { isZoomed in
                        model.isZoomed = isZoomed
                        if isZoomed {
                            withAnimation { model.hideChrome() }
                        }
                    },
                    onLongPress: { model.onShare?($0) }
                )
            } else {
                if let placeholder = model.placeholder(for: item) {
                    Image(uiImage: placeholder)
                        .resizable()
                        .scaledToFit()
                }
                ProgressView()
                    .tint(.white)
            }
        }
        .task(id: item.id) {
            image = await resolveImage()
        }
    }

    private func resolveImage() async -> UIImage? {
        if let existing = model.image(for: item) {
            return existing
        }
        guard case .url(let url) = item.source,
            let loaded = await model.loadImage(url)
        else { return nil }
        model.didLoad(loaded, for: item)
        return loaded
    }
}
