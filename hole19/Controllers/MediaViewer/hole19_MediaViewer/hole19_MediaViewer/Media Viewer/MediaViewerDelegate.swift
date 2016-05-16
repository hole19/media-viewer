
import UIKit

@objc protocol MediaViewerDelegate {
    func imageViewForImage(image: MediaViewerImage) -> UIImageView?
    func scrollImageviewsContainer() -> UIScrollView
    optional func hasMoreImagesToLoad(withImages: [MediaViewerImage]) -> Bool
    optional func loadMoreImages(withImages images: [MediaViewerImage], completition: (newImages: [MediaViewerImage], error: NSError?) -> Void) -> NSOperation?
}