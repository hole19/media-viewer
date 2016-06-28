
import UIKit

public class MediaViewerImageActionsHandler {
    
    // MARK: properties
    
    public var tasks = [MediaViewerImageAction]()
    
    // MARK: init
    
    public init() {
        setupDefaultTasks()
    }
    
    // MARK: public
    
    public func actionSheetWithAllTasksForImage(image: UIImage) -> UIAlertController {
        let alert = UIAlertController()
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil))
        for task in tasks {
            alert.addAction(UIAlertAction(title: task.title, style: UIAlertActionStyle.Default, handler: { (action) in
                task.taskHandler(image)
            }))
        }
        return alert
    }

    // MARK: private

    private func setupDefaultTasks() {
        tasks.append(MediaViewerImageAction.taskWithType(.SaveToLibrary))
    }
}