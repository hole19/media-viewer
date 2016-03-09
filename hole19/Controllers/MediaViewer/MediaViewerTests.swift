
import XCTest
@testable import hole19v2
import Nimble

class MediaViewerTests: XCTestCase {
    
    var sut: MediaViewer!
    
    override func setUp() {
        super.setUp()
        sut = MediaViewer()
    }
    
    override func tearDown() {
        super.tearDown()
        sut = nil
    }
    
    func testThatItInitsWithMediaURL() {
        let exampleURL = NSURL(string: "myexample.com")!
         sut = MediaViewer(mediaURL: exampleURL)
        expect(self.sut.mediaURL).to(equal(exampleURL))
    }
    
    func testThatItHasImageView() {
        let _ = sut.view
        expect(self.sut.imageView) != nil
    }
    
    func testThatImageViewCoversTheWholeView() {
        let view = sut.view
        sut.view.layoutIfNeeded()
        expect(self.sut.imageView.frame.size) == CGSizeMake(view.frame.size.width, view.frame.size.height)
    }
    
    func testThatImageViewHasContentModeAspectFit() {
        let _ = sut.view
        expect(self.sut.imageView.contentMode) == UIViewContentMode.ScaleAspectFit
    }
    
}

