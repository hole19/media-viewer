
import UIKit

@objc protocol MediaViewerTransitionDelegate {
    func imageViewForImage(image: MediaViewerImage) -> UIImageView?
    func scrollImageviewsContainer() -> UIScrollView
}