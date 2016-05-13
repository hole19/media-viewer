
import UIKit

class MediaViewerImage {
    
    // MARK: properties
    
    let infoOverlayViewClass: MediaViewerInfoOverlayView.Type
    var image: UIImage?
    var imageURL: NSURL?
    
    // MARK: init
    
    init() {
        self.infoOverlayViewClass = MediaViewerInfoOverlayView.self
    }
    
    init(image: UIImage, infoOverlayViewClass: MediaViewerInfoOverlayView.Type = MediaViewerInfoOverlayView.self) {
        self.image = image
        self.infoOverlayViewClass = infoOverlayViewClass
    }
    
    init(imageURL: NSURL, infoOverlayViewClass: MediaViewerInfoOverlayView.Type = MediaViewerInfoOverlayView.self) {
        self.imageURL = imageURL
        self.infoOverlayViewClass = infoOverlayViewClass
    }
    
    convenience init(image: UIImage, imageURL: NSURL, infoOverlayViewClass: MediaViewerInfoOverlayView.Type = MediaViewerInfoOverlayView.self) {
        self.init(image: image, infoOverlayViewClass: infoOverlayViewClass)
        self.imageURL = imageURL
    }
    
    // MARK: public
    
    // MARK: private
    

}