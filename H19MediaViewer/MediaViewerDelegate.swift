
import UIKit

@objc public protocol MediaViewerDelegate {
    func imageViewForImage(image: MediaViewerImageModel) -> UIImageView?
    func scrollImageviewsContainer() -> MediaViewerMultipleImageScrollViewDelegate
    optional func hasMoreImagesToLoad(withImages: [MediaViewerImageModel]) -> Bool
    optional func loadMoreImages(withImages images: [MediaViewerImageModel], completition: (newImages: [MediaViewerImageModel]?, error: NSError?) -> Void) -> NSOperation?
}