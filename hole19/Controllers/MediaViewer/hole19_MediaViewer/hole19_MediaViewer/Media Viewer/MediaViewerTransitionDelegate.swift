
import UIKit

protocol MediaViewerTransitionDelegate {
    func imageViewForImage(image: UIImage) -> UIImageView?
    func scrollImageviewsContainer() -> UIScrollView
}