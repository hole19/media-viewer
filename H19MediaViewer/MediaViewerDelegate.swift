import UIKit

@objc public protocol MediaViewerDelegate {
    func imageViewForImage(_ image: MediaViewerImageModel) -> UIImageView?
    func scrollImageviewsContainer() -> MediaViewerMultipleImageScrollViewDelegate
    @objc optional func hasMoreImagesToLoad(_ withImages: [MediaViewerImageModel]) -> Bool
    @objc optional func loadMoreImages(
        withImages images: [MediaViewerImageModel],
        completition: (_ newImages: [MediaViewerImageModel]?, _ error: NSError?) -> Void) -> Operation?
}
