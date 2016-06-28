
import UIKit

@objc public protocol MediaViewerImageModel {
    var image: UIImage? { get }
    var imageURL: NSURL? { get }
    var sourceImageView: UIImageView? { get }
    
    var infoOverlayViewClass: MediaViewerInfoOverlayView.Type { get }
    var overlayInfoModel: AnyObject? { get }
}

public class MediaViewerImage: NSObject, MediaViewerImageModel {
    
    // MARK: properties
    
    public var infoOverlayViewClass: MediaViewerInfoOverlayView.Type
    public var image: UIImage?
    public var imageURL: NSURL?
    public weak var sourceImageView: UIImageView?
    
    public var overlayInfoModel: AnyObject?
    
    // MARK: init
    
    override public init() {
        self.infoOverlayViewClass = MediaViewerInfoOverlayView.self
    }
    
    public init(image: UIImage?, sourceImageView: UIImageView? = nil, infoOverlayViewClass: MediaViewerInfoOverlayView.Type = MediaViewerInfoOverlayView.self) {
        self.image = image
        self.sourceImageView = sourceImageView
        self.infoOverlayViewClass = infoOverlayViewClass
    }
    
    public init(imageURL: NSURL, sourceImageView: UIImageView? = nil, infoOverlayViewClass: MediaViewerInfoOverlayView.Type = MediaViewerInfoOverlayView.self) {
        self.imageURL = imageURL
        self.sourceImageView = sourceImageView
        self.infoOverlayViewClass = infoOverlayViewClass
    }
    
    convenience public init(image: UIImage?, imageURL: NSURL?, sourceImageView: UIImageView? = nil, infoOverlayViewClass: MediaViewerInfoOverlayView.Type = MediaViewerInfoOverlayView.self) {
        self.init(image: image, sourceImageView: sourceImageView, infoOverlayViewClass: infoOverlayViewClass)
        self.imageURL = imageURL
    }
}
