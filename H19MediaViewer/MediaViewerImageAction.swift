
import UIKit
import AssetsLibrary
import Photos

public enum MediaViewerImageActionType {
    case Custom, SaveToLibrary
}

public class MediaViewerImageAction {
   
    // MARK: properties
    
    public var title: String
    public var taskHandler: (UIImage) -> Void
    
    public var type = MediaViewerImageActionType.Custom

    // MARK: init
    
    public init(title: String, handler: (UIImage) -> Void) {
        self.title = title
        self.taskHandler = handler
    }
    
    // MARK: class
    
    public class func taskWithType(actionType: MediaViewerImageActionType) -> MediaViewerImageAction {
        switch actionType {
        case .SaveToLibrary:
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
        task.type = .SaveToLibrary
        return task
    }
    
    class func saveToLibraryTaskHandler(photoLibrary: PHPhotoLibrary = PHPhotoLibrary.sharedPhotoLibrary()) -> (UIImage) -> Void {
        return { image in
            photoLibrary.performChanges({
                PHAssetChangeRequest.creationRequestForAssetFromImage(image)
            }) { (fin, error) in }
        }
    }
}