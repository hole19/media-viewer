import UIKit

@MainActor
public protocol MediaGalleryDelegate: AnyObject {
    func mediaGallery(sourceImageViewFor item: MediaGalleryItem) -> UIImageView?
    func mediaGallery(didShowItemAt index: Int)
    var mediaGalleryHasMoreItems: Bool { get }
    func mediaGalleryLoadMoreItems() async -> [MediaGalleryItem]
}

public extension MediaGalleryDelegate {
    func mediaGallery(sourceImageViewFor item: MediaGalleryItem) -> UIImageView? { nil }
    func mediaGallery(didShowItemAt index: Int) {}
    var mediaGalleryHasMoreItems: Bool { false }
    func mediaGalleryLoadMoreItems() async -> [MediaGalleryItem] { [] }
}
