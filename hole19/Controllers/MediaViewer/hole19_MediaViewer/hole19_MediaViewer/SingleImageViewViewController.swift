
import UIKit

class SingleImageViewViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!

    @IBAction func imageViewTapped(sender: UITapGestureRecognizer) {
        let image = MediaViewerImage(image: imageView.image!)
        image.sourceImageView = imageView
        let mediaViewer = MediaViewer(image: image, allImages: nil)
        presentViewController(mediaViewer, animated: false, completion: nil)
    }
}

