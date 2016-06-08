
import UIKit

class ImageCollectionViewViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    // MARK: properties
    
    var imageNames = ["minion1", "minion2", "minion3", "minion4", "minion5", "minion6", "minion7", "minion8", "minion9"]
    var allImages = [MediaViewerImage]()
    
    var hasMoreImagesToLoad = 2
    
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
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
        collectionView?.collectionViewLayout.invalidateLayout()
    }

    // MARK: private
    
    private func moreImages() -> [MediaViewerImage] {
        if hasMoreImagesToLoad == 1 {
            return moreImages1()
        } else {
            return moreImages2()
        }
    }
    
    private func moreImages1() -> [MediaViewerImage] {
        let imageURL1 = NSURL(string: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSS9iDRjjy2UraGtLdE9DHLkBQjussZvqXXhYjtXbR4a6VSgzLr")!
        let authorInfo1 = MediaViewerAuthorInfoOverlayViewModel(authorImageURL: imageURL1, authorTitle: "Tiger", datePictureWasTaken: NSDate())
        let imagePaths = ["https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQtTXKI9HG6ug0oWlkGaqyyXXAf0ekz4kJa9NWwx7T6rLusbUCV", "https://encrypted-tbn2.gstatic.com/images?q=tbn:ANd9GcQcHhEtanyjYWOeera7kmRg0RsHDg7g7Yzew8kTLtJgSzoL__adNA", "https://encrypted-tbn1.gstatic.com/images?q=tbn:ANd9GcT3M6ix9FP-l2YMDNqcS3U_Tp-R57E93qPzSFJRee1yleY9mX0s"]
        return createImagesWith(authorInfo1, imagePaths: imagePaths)
    }
    
    private func moreImages2() -> [MediaViewerImage] {
        let imageURL1 = NSURL(string: "https://naspiddu.files.wordpress.com/2012/05/budha-bali2.jpg")!
        let authorInfo1 = MediaViewerAuthorInfoOverlayViewModel(authorImageURL: imageURL1, authorTitle: "Budha", datePictureWasTaken: NSDate())
        let imagePaths = ["https://cdn.shopify.com/s/files/1/0190/8436/files/blog_viceroy-bali.jpg?17304909388870507138", "https://1.bp.blogspot.com/-CH2yEIPkKno/VpP_L-WLOlI/AAAAAAAABtc/slWh6cudyxg/s1600/Bali%2Bw1.jpg"]
        return createImagesWith(authorInfo1, imagePaths: imagePaths)
    }
    
    private func createImagesWith(author: MediaViewerAuthorInfoOverlayViewModel, imagePaths: [String]) -> [MediaViewerImage] {
        var newImages = [MediaViewerImage]()
        for path in imagePaths {
            let image = MediaViewerImage(imageURL: NSURL(string: path)!, infoOverlayViewClass: MediaViewerAuthorInfoOverlayView.self)
            image.overlayInfoModel = author
            newImages.append(image)
        }
        return newImages
    }
    
    // MARK: collection view
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return allImages.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("imageCell", forIndexPath: indexPath) as! ImageCell
        let imageModel = allImages[indexPath.row]
        cell.imageView.image = imageModel.image
        if let imageURL = imageModel.imageURL {
            cell.imageView.sd_setImageWithURL(imageURL)
        }
        return cell
    }

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let margin: CGFloat = 5.0
        let width = (collectionView.frame.size.width - 1 * margin)/2.0
//        let width = collectionView.frame.size.width
        let height = (collectionView.frame.size.height - 2 * margin)/2.33
        return CGSize(width: width, height: height)
    }

    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let selectedImage = allImages[indexPath.row]
        selectedImage.sourceImageView = (collectionView.cellForItemAtIndexPath(indexPath) as! ImageCell).imageView
        let mediaViewer = MediaViewer(image: selectedImage, allImages: allImages, delegate: self)
        mediaViewer.present()
    }
}

extension ImageCollectionViewViewController: MediaViewerDelegate {
    func imageViewForImage(image: MediaViewerImageModel) -> UIImageView? {
        if let mediaImage = image as? MediaViewerImage {
            if let index = allImages.indexOf(mediaImage), let collectionView = collectionView {
                let indexPath = NSIndexPath(forRow: index, inSection: 0)
                if let cell = collectionView.cellForItemAtIndexPath(indexPath) as? ImageCell {
                    return cell.imageView
                }
            }
        }
        return nil
    }
    func scrollImageviewsContainer() -> UIScrollView {
        return collectionView!
    }
    func hasMoreImagesToLoad(withImages: [MediaViewerImageModel]) -> Bool {
        return hasMoreImagesToLoad > 0
    }
    func loadMoreImages(withImages images: [MediaViewerImageModel], completition: (newImages: [MediaViewerImageModel]?, error: NSError?) -> Void) -> NSOperation? {
        hasMoreImagesToLoad -= 1
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(UInt64(2.0) * NSEC_PER_SEC)), dispatch_get_main_queue()) { () -> Void in
            let new = self.moreImages()
            completition(newImages: new, error: nil)
            self.allImages.appendContentsOf(new)
            self.collectionView?.reloadData()
        }
        return NSOperation()
    }
}
