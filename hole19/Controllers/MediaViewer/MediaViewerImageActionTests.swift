
import XCTest
@testable import hole19v2
import Nimble

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
    
    func testThatCreatesDefaultSaveToLibraryTaskWithCorrectTitle() {
        sut = MediaViewerImageAction.taskWithType(.SaveToLibrary)
        
        expect(self.sut.title) == "Save to Library"
    }
    
    func testThatCreatesDefaultSaveToLibraryTaskWithCorrectType() {
        sut = MediaViewerImageAction.taskWithType(.SaveToLibrary)
        
        expect(self.sut.type) == MediaViewerImageActionType.SaveToLibrary
    }
    
    func testThatDefaultTypeIsCustom() {
        expect(self.sut.type) == MediaViewerImageActionType.Custom
    }
    
}

