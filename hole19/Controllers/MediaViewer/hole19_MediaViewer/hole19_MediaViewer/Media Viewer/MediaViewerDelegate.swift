
import UIKit

@objc protocol MediaViewerDelegate {
    func imageViewForImage(image: MediaViewerImage) -> UIImageView?
    func scrollImageviewsContainer() -> UIScrollView
}