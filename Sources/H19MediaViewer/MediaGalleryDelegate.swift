import UIKit

@MainActor
public protocol MediaGalleryDelegate: AnyObject {
    /// The thumbnail to animate to when dismissing. Defaults to `mediaGallery(sourceImageViewFor:)`.
    func mediaGallery(sourceFor item: MediaGalleryItem) -> MediaGallerySource?
    func mediaGallery(sourceImageViewFor item: MediaGalleryItem) -> UIImageView?
    func mediaGallery(didShowItemAt index: Int)
    var mediaGalleryHasMoreItems: Bool { get }
    func mediaGalleryLoadMoreItems() async -> [MediaGalleryItem]
}

public extension MediaGalleryDelegate {
    func mediaGallery(sourceFor item: MediaGalleryItem) -> MediaGallerySource? {
        mediaGallery(sourceImageViewFor: item).map(MediaGallerySource.imageView)
    }

    func mediaGallery(sourceImageViewFor item: MediaGalleryItem) -> UIImageView? { nil }
    func mediaGallery(didShowItemAt index: Int) {}
    var mediaGalleryHasMoreItems: Bool { false }
    func mediaGalleryLoadMoreItems() async -> [MediaGalleryItem] { [] }
}
