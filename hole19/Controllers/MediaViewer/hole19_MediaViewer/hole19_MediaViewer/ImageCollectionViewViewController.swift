
import UIKit

class ImageCollectionViewViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    // MARK: properties
    
    var imageNames = ["minion2", "minion1", "minion4", "minion5", "minion5", "minion6", "minion9", "minion7", "minion3", "minion8", "minion9", "minion1", "minion2", "minion1", "minion4", "minion5", "minion5", "minion6", "minion9", "minion7", "minion3", "minion8", "minion9", "minion1", "minion2", "minion1", "minion4", "minion5", "minion5", "minion6", "minion9", "minion7", "minion3", "minion8", "minion9", "minion1"]
    
    // MARK: UIViewController
    
    // MARK: private 
    
    func allImages() -> [UIImage]{
        var images = [UIImage]()
        for name in imageNames {
            images.append(UIImage(named: name)!)
        }
        return images
    }
    
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
        let width = (collectionView.frame.size.width - 2 * margin)/3.0
        let height = (collectionView.frame.size.height - 4 * margin)/4.33
        return CGSize(width: width, height: height)
    }

    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let imageView = (collectionView.cellForItemAtIndexPath(indexPath) as! ImageCell).imageView
        let mediaViewer = MediaViewer(mediaURL: NSURL(), sourceImageView: imageView, allImages: allImages())
        presentViewController(mediaViewer, animated: false, completion: nil)
    }
}
