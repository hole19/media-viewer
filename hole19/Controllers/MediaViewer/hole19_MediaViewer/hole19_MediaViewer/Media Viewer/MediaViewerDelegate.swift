
import UIKit

@objc protocol MediaViewerDelegate {
    func imageViewForImage(image: MediaViewerImageModel) -> UIImageView?
    func scrollImageviewsContainer() -> UIScrollView
    optional func hasMoreImagesToLoad(withImages: [MediaViewerImageModel]) -> Bool
    optional func loadMoreImages(withImages images: [MediaViewerImageModel], completition: (newImages: [MediaViewerImageModel]?, error: NSError?) -> Void) -> NSOperation?
}