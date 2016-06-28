
import XCTest
@testable import H19MediaViewer
import Nimble

class MediaViewerImageActionsHandlerTests: XCTestCase {
    
    var sut: MediaViewerImageActionsHandler!
    
    override func setUp() {
        super.setUp()
        sut = MediaViewerImageActionsHandler()
    }
    
    override func tearDown() {
        super.tearDown()
        sut = nil
    }
    
    func testThatItSetsUpDefaultTasks() {
        expect(self.sut.tasks.count) == 1
    }
    
    func testThatItSetsUpDefaultTasksWithSaveToLibrary() {
        expect(self.sut.tasks[0].type) == MediaViewerImageActionType.SaveToLibrary
    }
    
    func testThatItSetsUpAlertControllerWithCancelAction() {
        let alert = sut.actionSheetWithAllTasksForImage(UIImage())
        
        var cancelAction: UIAlertAction? = nil
        for action in alert.actions {
            if action.style == UIAlertActionStyle.Cancel {
                cancelAction = action
                break
            }
        }
        
        expect(cancelAction).notTo(beNil())
    }
    
    func testThatItSetsUpAlertControllerWithCorrectNumberOfActions() {
        let alert = sut.actionSheetWithAllTasksForImage(UIImage())
        
        expect(alert.actions.count) == sut.tasks.count + 1
    }
    
    func testThatItSetsUpAlertControllerWithTypeActionSheet() {
        let alert = sut.actionSheetWithAllTasksForImage(UIImage())
        
        expect(alert.preferredStyle) == UIAlertControllerStyle.ActionSheet
    }

}

