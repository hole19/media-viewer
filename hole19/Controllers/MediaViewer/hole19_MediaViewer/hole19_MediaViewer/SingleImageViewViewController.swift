
import UIKit

class SingleImageViewViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!

    @IBAction func imageViewTapped(sender: UITapGestureRecognizer) {
        let mediaViewer = MediaViewer(image: MediaViewerImage(image: imageView.image!), sourceImageView: imageView, allImages: nil)
        presentViewController(mediaViewer, animated: false, completion: nil)
    }
}

