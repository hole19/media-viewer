
import UIKit
import AssetsLibrary
import Photos

enum MediaViewerImageActionType {
    case Custom, SaveToLibrary
}

class MediaViewerImageAction {
   
    // MARK: properties
    
    var title: String
    var taskHandler: (UIImage) -> Void
    
    var type = MediaViewerImageActionType.Custom

    // MARK: init
    
    init(title: String, handler: (UIImage) -> Void) {
        self.title = title
        self.taskHandler = handler
    }
    
    // MARK: class
    
    class func taskWithType(actionType: MediaViewerImageActionType) -> MediaViewerImageAction {
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
    
    private class func saveToLibraryTaskHandler() -> (UIImage) -> Void {
        return { image in
            PHPhotoLibrary.sharedPhotoLibrary().performChanges({
                PHAssetChangeRequest.creationRequestForAssetFromImage(image)
            }) { (fin, error) in
                NSLog("Error")
            }
        }
    }
}