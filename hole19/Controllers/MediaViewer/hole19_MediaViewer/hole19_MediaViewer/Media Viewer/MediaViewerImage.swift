
import UIKit

@objc protocol MediaViewerImageModel {
    var infoOverlayViewClass: MediaViewerInfoOverlayView.Type { get set }
    var image: UIImage? { get set }
    var imageURL: NSURL? { get set }
    var sourceImageView: UIImageView? { get set }
    
    var overlayInfoModel: AnyObject? { get set }
}

class MediaViewerImage: NSObject, MediaViewerImageModel {
    
    // MARK: properties
    
    var infoOverlayViewClass: MediaViewerInfoOverlayView.Type
    var image: UIImage?
    var imageURL: NSURL?
    var sourceImageView: UIImageView?
    
    var overlayInfoModel: AnyObject?
    
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
