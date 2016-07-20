
import UIKit
import AssetsLibrary
import Photos

public enum MediaViewerImageActionType {
    case custom, saveToLibrary
}

public class MediaViewerImageAction {
   
    // MARK: properties
    
    public var title: String
    public var taskHandler: (UIImage) -> Void
    
    public var type = MediaViewerImageActionType.custom

    // MARK: init
    
    public init(title: String, handler: (UIImage) -> Void) {
        self.title = title
        self.taskHandler = handler
    }
    
    // MARK: class
    
    public class func taskWithType(_ actionType: MediaViewerImageActionType) -> MediaViewerImageAction {
        switch actionType {
        case .saveToLibrary:
            return saveToLibraryTask()
        default:
            return defaultTask()
        }
    }
    
    // MARK: private
    
    private class func defaultTask() -> MediaViewerImageAction {
        return MediaViewerImageAction(title: "Change me", handler: { image in })
    }
    
    private class func saveToLibraryTask() -> MediaViewerImageAction {
        let task = MediaViewerImageAction(title: "Save to Library", handler: saveToLibraryTaskHandler())
        task.type = .saveToLibrary
        return task
    }
    
    class func saveToLibraryTaskHandler(_ photoLibrary: PHPhotoLibrary = PHPhotoLibrary.shared()) -> (UIImage) -> Void {
        return { image in
            photoLibrary.performChanges({
                PHAssetChangeRequest.creationRequestForAsset(from: image)
            }) { (fin, error) in }
        }
    }
}
