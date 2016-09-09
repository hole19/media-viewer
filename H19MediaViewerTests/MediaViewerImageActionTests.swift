
import XCTest
@testable import H19MediaViewer
import Nimble
import AssetsLibrary
import Photos

class MockPhotoLibrary: PHPhotoLibrary {
    var numberOfTimesPerformChangesWasCalled = 0
    
    override func performChanges(_ changeBlock: @escaping () -> Swift.Void, completionHandler: ((Bool, Error?) -> Swift.Void)? = nil) {
        changeBlock()
        numberOfTimesPerformChangesWasCalled += 1
    }

}

class MediaViewerImageActionTests: XCTestCase {
    
    var sut: MediaViewerImageAction!
    
    override func setUp() {
        super.setUp()
        sut = MediaViewerImageAction(title: "", handler: {image in})
    }
    
    override func tearDown() {
        super.tearDown()
        sut = nil
    }
    
    func testThatItInitsWithTitle() {
        let title = "title"
        sut = MediaViewerImageAction(title: title, handler: {image in})
        
        expect(self.sut.title) == title
    }
    
    func testThatCreatesDefaultCustomTask() {
        sut = MediaViewerImageAction.taskWithType(.custom)
        
        expect(self.sut.title) == "Change me"
    }
    
    func testThatCreatesDefaultCustomTaskHandler() {
        sut = MediaViewerImageAction.taskWithType(.custom)
        
        expect(self.sut.taskHandler(UIImage())).notTo(raiseException())
    }
    
    func testThatCreatesDefaultSaveToLibraryTaskWithCorrectTitle() {
        sut = MediaViewerImageAction.taskWithType(.saveToLibrary)
        
        expect(self.sut.title) == "Save to Library"
    }
    
    func testThatCreatesDefaultSaveToLibraryTaskWithCorrectType() {
        sut = MediaViewerImageAction.taskWithType(.saveToLibrary)
        
        expect(self.sut.type) == MediaViewerImageActionType.saveToLibrary
    }
    
//    func testThatSaveToLibraryTaskHandlerSavesToLibrary() {
//        let mockPhotoLibrary = MockPhotoLibrary()
//        let handler = MediaViewerImageAction.saveToLibraryTaskHandler(MockPhotoLibrary())
//        
//        handler(UIImage())
//        
//        expect(mockPhotoLibrary.numberOfTimesPerformChangesWasCalled) == 1
//    }
    
    func testThatDefaultTypeIsCustom() {
        expect(self.sut.type) == MediaViewerImageActionType.custom
    }
    
}

