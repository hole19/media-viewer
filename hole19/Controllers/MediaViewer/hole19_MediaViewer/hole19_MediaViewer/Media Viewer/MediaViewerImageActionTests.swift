
import XCTest
@testable import hole19v2
import Nimble
import AssetsLibrary
import Photos

class MockPhotoLibrary: PHPhotoLibrary {
    var numberOfTimesPerformChangesWasCalled = 0
    
    public override func performChanges(changeBlock: dispatch_block_t, completionHandler: ((Bool, NSError?) -> Void)?) {
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
        sut = MediaViewerImageAction.taskWithType(.Custom)
        
        expect(self.sut.title) == "Change me"
    }
    
    func testThatCreatesDefaultCustomTaskHandler() {
        sut = MediaViewerImageAction.taskWithType(.Custom)
        
        expect(self.sut.taskHandler(UIImage())).notTo(raiseException())
    }
    
    func testThatCreatesDefaultSaveToLibraryTaskWithCorrectTitle() {
        sut = MediaViewerImageAction.taskWithType(.SaveToLibrary)
        
        expect(self.sut.title) == "Save to Library"
    }
    
    func testThatCreatesDefaultSaveToLibraryTaskWithCorrectType() {
        sut = MediaViewerImageAction.taskWithType(.SaveToLibrary)
        
        expect(self.sut.type) == MediaViewerImageActionType.SaveToLibrary
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
        expect(self.sut.type) == MediaViewerImageActionType.Custom
    }
    
}

