
import UIKit

class SingleImageViewViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!

    @IBAction func imageViewTapped(sender: UITapGestureRecognizer) {
        let image = MediaViewerImage(image: imageView.image!, sourceImageView: imageView)
        let mediaViewer = MediaViewer(image: image)
        mediaViewer.allowLandscapeDismissal = true
        presentViewController(mediaViewer, animated: false, completion: nil)
    }
}

