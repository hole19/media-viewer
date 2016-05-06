
import UIKit

class ImageCollectionViewViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    // MARK: properties
    
    var imageNames = ["minion1", "minion2", "minion3", "minion4", "minion5", "minion6", "minion7", "minion8", "minion9"]
    var allImages = [UIImage]()
    
    // MARK: UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for name in imageNames {
            allImages.append(UIImage(named: name)!)
        }
    }
    
    // MARK: private 
    
    // MARK: collection view
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageNames.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("imageCell", forIndexPath: indexPath) as! ImageCell
        cell.imageView.image = UIImage(named: imageNames[indexPath.row])
        return cell
    }

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let margin: CGFloat = 5.0
        let width = (collectionView.frame.size.width - 1 * margin)/2.0
        let height = (collectionView.frame.size.height - 2 * margin)/2.33
        return CGSize(width: width, height: height)
    }

    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let imageView = (collectionView.cellForItemAtIndexPath(indexPath) as! ImageCell).imageView
        let mediaViewer = MediaViewer(mediaURL: NSURL(), sourceImageView: imageView, allImages: allImages, transitionDelegate: self)
        presentViewController(mediaViewer, animated: false, completion: nil)
    }
}

extension ImageCollectionViewViewController: MediaViewerTransitionDelegate {
    func imageViewForImage(image: UIImage) -> UIImageView? {
        if let index = allImages.indexOf(image), let collectionView = collectionView {
            if let cell = collectionView.cellForItemAtIndexPath(NSIndexPath(forRow: index, inSection: 0)) as? ImageCell {
                return cell.imageView
            }
        }
        return nil
    }
}
