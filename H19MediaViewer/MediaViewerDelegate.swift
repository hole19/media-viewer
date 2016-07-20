
import UIKit

@objc public protocol MediaViewerDelegate {
    func imageViewForImage(_ image: MediaViewerImageModel) -> UIImageView?
    func scrollImageviewsContainer() -> MediaViewerMultipleImageScrollViewDelegate
    @objc optional func hasMoreImagesToLoad(_ withImages: [MediaViewerImageModel]) -> Bool
    @objc optional func loadMoreImages(withImages images: [MediaViewerImageModel], completition: (newImages: [MediaViewerImageModel]?, error: NSError?) -> Void) -> Operation?
}
