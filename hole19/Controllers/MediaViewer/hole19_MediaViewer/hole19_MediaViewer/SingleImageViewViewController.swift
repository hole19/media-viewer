
import UIKit

class SingleImageViewViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!

    @IBAction func imageViewTapped(sender: UITapGestureRecognizer) {
        let mediaViewer = MediaViewer(mediaURL: NSURL(), sourceImageView: imageView, allImages: nil)
        presentViewController(mediaViewer, animated: false, completion: nil)
    }
}

