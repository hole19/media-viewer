
import XCTest
@testable import hole19v2
import Nimble

class MediaViewerImageTests: XCTestCase {
    
    var sut: MediaViewerImage!
    
    override func setUp() {
        super.setUp()
        sut = MediaViewerImage()
    }
    
    override func tearDown() {
        super.tearDown()
        sut = nil
    }
    
    func testThatItHasDefaultInfoOverlayViewClass() {
        expect(self.sut.infoOverlayViewClass) === MediaViewerInfoOverlayView.self
    }
    
    func testThatItInitsWithImageView() {
        let image = UIImage()
        sut = MediaViewerImage(image: image)
        
        expect(self.sut.image) === image
    }
    
    func testThatItInitsWithImageURL() {
        let imageURL = NSURL(fileURLWithPath: "some")
        
        sut = MediaViewerImage(imageURL: imageURL)
        
        expect(self.sut.imageURL) == imageURL
    }
    
    func testThatItInitsWithImageAndImageURL() {
        let imageURL = NSURL(fileURLWithPath: "some")
        let image = UIImage()
        
        sut = MediaViewerImage(image:image, imageURL:imageURL)
        
        expect(self.sut.image) == image
        expect(self.sut.imageURL) == imageURL
    }
    
    func testThatItInitsWithImageAndImageURLAndOverlayViewClass() {
        let imageURL = NSURL(fileURLWithPath: "some")
        let image = UIImage()
        
        sut = MediaViewerImage(image:image, imageURL:imageURL, infoOverlayViewClass: MediaViewerAuthorInfoOverlayView.self)
        
        expect(self.sut.infoOverlayViewClass) === MediaViewerAuthorInfoOverlayView.self
    }
}
