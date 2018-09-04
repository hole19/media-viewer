import UIKit

public class MediaViewerImageActionsHandler {

    // MARK: properties

    public var tasks = [MediaViewerImageAction]()

    // MARK: init

    public init() {
        setupDefaultTasks()
    }

    // MARK: public

    public func actionSheetWithAllTasksForImage(_ image: UIImage, tintColor: UIColor? = nil) -> UIAlertController {
        let alert = UIAlertController()
        if let tintColor = tintColor {
            alert.view.tintColor = tintColor
        }

        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
        for task in tasks {
            alert.addAction(UIAlertAction(title: task.title, style: UIAlertAction.Style.default, handler: { (action) in
                task.taskHandler(image)
            }))
        }
        return alert
    }

    // MARK: private

    private func setupDefaultTasks() {
        tasks.append(MediaViewerImageAction.taskWithType(.saveToLibrary))
    }
}
