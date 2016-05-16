
import UIKit

class ImageCollectionViewViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    // MARK: properties
    
    var imageNames = ["minion1", "minion2", "minion3", "minion4", "minion5", "minion6", "minion7", "minion8", "minion9"]
    var allImages = [MediaViewerImage]()
    
    var hasMoreImagesToLoad = true
    
    // MARK: UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let imageURL1 = NSURL(string: "https://www.hole19golf.com/img/team/anthony.jpg")!
        let authorInfo1 = MediaViewerAuthorInfoOverlayViewModel(authorImageURL: imageURL1, authorTitle: "Anthony", datePictureWasTaken: NSDate())
        let imageURL2 = NSURL(string: "https://media.licdn.com/mpr/mpr/shrinknp_200_200/AAEAAQAAAAAAAAZYAAAAJDc5MzUwZDJiLWUyMzMtNDNkNC1hMjgyLTZlNDBhYmZmZGNlMw.jpg")!
        let authorInfo2 = MediaViewerAuthorInfoOverlayViewModel(authorImageURL: imageURL2, authorTitle: "Rafa", datePictureWasTaken: NSDate())
        
        var useInfoOne = true
        for name in imageNames {
            let image = MediaViewerImage(image: UIImage(named: name)!, infoOverlayViewClass: MediaViewerAuthorInfoOverlayView.self)
            image.overlayInfoModel = useInfoOne ? authorInfo1 : authorInfo2
            allImages.append(image)
            useInfoOne = !useInfoOne
        }
    }
    
    // MARK: private
    
    private func moreImages() -> [MediaViewerImage] {
        var newImages = [MediaViewerImage]()
        let imageURL1 = NSURL(string: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSS9iDRjjy2UraGtLdE9DHLkBQjussZvqXXhYjtXbR4a6VSgzLr")!
        let authorInfo1 = MediaViewerAuthorInfoOverlayViewModel(authorImageURL: imageURL1, authorTitle: "Tiger", datePictureWasTaken: NSDate())

        let imagePaths = ["http://www.soncaliu.com/images/golf3/a1ccesorios-de-golf.jpg", "http://www.lacianella.com/wp-content/uploads/2012/04/golf.png", "http://golfcentralbne.com.au/wp-content/uploads/2014/03/Lady-Golf-2.jpg", "http://classic.als.net/images/pictures/charityclassic-golf-960x410.jpg", "http://pop.h-cdn.co/assets/16/02/980x490/landscape-1452785573-callaway-lede.jpg"]
        for path in imagePaths {
            let image = MediaViewerImage(imageURL: NSURL(string: path)!, infoOverlayViewClass: MediaViewerAuthorInfoOverlayView.self)
            image.overlayInfoModel = authorInfo1
            newImages.append(image)
        }
        return newImages
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
        let width = (collectionView.frame.size.width - 1 * margin)/2.0
        let height = (collectionView.frame.size.height - 2 * margin)/2.33
        return CGSize(width: width, height: height)
    }

    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let selectedImage = allImages[indexPath.row]
        selectedImage.sourceImageView = (collectionView.cellForItemAtIndexPath(indexPath) as! ImageCell).imageView
        let mediaViewer = MediaViewer(image: selectedImage, allImages: allImages, transitionDelegate: self)
        presentViewController(mediaViewer, animated: false, completion: nil)
    }
}

extension ImageCollectionViewViewController: MediaViewerDelegate {
    func imageViewForImage(image: MediaViewerImage) -> UIImageView? {
        if let index = allImages.indexOf(image), let collectionView = collectionView {
            let indexPath = NSIndexPath(forRow: index, inSection: 0)
            if let cell = collectionView.cellForItemAtIndexPath(indexPath) as? ImageCell {
                return cell.imageView
            }
        }
        return nil
    }
    func scrollImageviewsContainer() -> UIScrollView {
        return collectionView!
    }
    func hasMoreImagesToLoad(withImages: [MediaViewerImage]) -> Bool {
        return hasMoreImagesToLoad
    }
    func loadMoreImages(withImages images: [MediaViewerImage], completition: (newImages: [MediaViewerImage], error: NSError?) -> Void) -> NSOperation? {
        hasMoreImagesToLoad = false
        completition(newImages: moreImages(), error: nil)
        return NSOperation()
    }
}
