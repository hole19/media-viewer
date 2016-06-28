
import UIKit

@objc protocol MediaViewerImageModel {
    var image: UIImage? { get }
    var imageURL: NSURL? { get }
    var sourceImageView: UIImageView? { get }
    
    var infoOverlayViewClass: MediaViewerInfoOverlayView.Type { get }
    var overlayInfoModel: AnyObject? { get }
}

class MediaViewerImage: NSObject, MediaViewerImageModel {
    
    // MARK: properties
    
    var infoOverlayViewClass: MediaViewerInfoOverlayView.Type
    var image: UIImage?
    var imageURL: NSURL?
    weak var sourceImageView: UIImageView?
    
    var overlayInfoModel: AnyObject?
    
    // MARK: init
    
    override init() {
        self.infoOverlayViewClass = MediaViewerInfoOverlayView.self
    }
    
    init(image: UIImage?, sourceImageView: UIImageView? = nil, infoOverlayViewClass: MediaViewerInfoOverlayView.Type = MediaViewerInfoOverlayView.self) {
        self.image = image
        self.sourceImageView = sourceImageView
        self.infoOverlayViewClass = infoOverlayViewClass
    }
    
    init(imageURL: NSURL, sourceImageView: UIImageView? = nil, infoOverlayViewClass: MediaViewerInfoOverlayView.Type = MediaViewerInfoOverlayView.self) {
        self.imageURL = imageURL
        self.sourceImageView = sourceImageView
        self.infoOverlayViewClass = infoOverlayViewClass
    }
    
    convenience init(image: UIImage?, imageURL: NSURL?, sourceImageView: UIImageView? = nil, infoOverlayViewClass: MediaViewerInfoOverlayView.Type = MediaViewerInfoOverlayView.self) {
        self.init(image: image, sourceImageView: sourceImageView, infoOverlayViewClass: infoOverlayViewClass)
        self.imageURL = imageURL
    }
}
