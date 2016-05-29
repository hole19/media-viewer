
import UIKit

class MediaViewerImage: NSObject {
    
    // MARK: properties
    
    let infoOverlayViewClass: MediaViewerInfoOverlayView.Type
    var image: UIImage?
    var imageURL: NSURL?
    var sourceImageView: UIImageView?
    
    var overlayInfoModel: Any?
    
    // MARK: init
    
    override init() {
        self.infoOverlayViewClass = MediaViewerInfoOverlayView.self
    }
    
    init(image: UIImage, sourceImageView: UIImageView? = nil, infoOverlayViewClass: MediaViewerInfoOverlayView.Type = MediaViewerInfoOverlayView.self) {
        self.image = image
        self.sourceImageView = sourceImageView
        self.infoOverlayViewClass = infoOverlayViewClass
    }
    
    init(imageURL: NSURL, sourceImageView: UIImageView? = nil, infoOverlayViewClass: MediaViewerInfoOverlayView.Type = MediaViewerInfoOverlayView.self) {
        self.imageURL = imageURL
        self.sourceImageView = sourceImageView
        self.infoOverlayViewClass = infoOverlayViewClass
    }
    
    convenience init(image: UIImage, imageURL: NSURL, sourceImageView: UIImageView? = nil, infoOverlayViewClass: MediaViewerInfoOverlayView.Type = MediaViewerInfoOverlayView.self) {
        self.init(image: image, sourceImageView: sourceImageView, infoOverlayViewClass: infoOverlayViewClass)
        self.imageURL = imageURL
    }
}
