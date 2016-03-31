
import XCTest
@testable import hole19v2
import Nimble

class MediaViewerMultipleImageScrollViewTests: XCTestCase {
    
    var sut: MediaViewerMultipleImageScrollView!
    
    override func setUp() {
        super.setUp()
        sut = MediaViewerMultipleImageScrollView(frame: CGRect(x:0, y: 0, width: 200, height: 200))
    }
    
    override func tearDown() {
        super.tearDown()
        sut = nil
    }
    
    func testThatItHasScrollView() {
        expect(self.sut.scrollView) != nil
    }
    
    func testThatScrollViewHasCorrectWidth() {
        sut.layoutIfNeeded()
        expect(self.sut.scrollView.frame.size.width) == 200
    }
    
    func testThatScrollViewHasCorrectHeight() {
        sut.layoutIfNeeded()
        expect(self.sut.scrollView.frame.size.height) == 200
    }
    
    func testThatScrollViewHasCorrectMinimumZoomScale() {
        expect(self.sut.scrollView.minimumZoomScale) == 1.0
    }
    
    func testThatScrollViewHasCorrectMaximumZoomScale() {
        expect(self.sut.scrollView.maximumZoomScale) == 1.0
    }
    
    func testThatScrollViewHasPagingEnabled() {
        expect(self.sut.scrollView.pagingEnabled) == true
    }
    
    func setupSUTWithImages() -> [UIImage] {
        sut.layoutIfNeeded()

        let image1 = UIImage()
        let image2 = UIImage()
        
        let images = [image1, image2]
        sut.images = images
        return images
    }
    
    func testThatSettingTheImagesWillSetupCorrectContentViewSize() {
        setupSUTWithImages()
        
        expect(self.sut.scrollView.contentSize) == CGSize(width: 200.0 * 2, height: 200.0)
    }
    
    func testThatSettingTheImagesWillSetupCorrectNumberOfInnerContentViews() {
        setupSUTWithImages()
        expect(self.sut.contentViews.count) == 2
    }
    
    func testThatSettingTheImagesWillSetupCorrectFirstInnerContentViewImage() {
        let images = setupSUTWithImages()
        
        expect(self.sut.contentViews[0].imageView.image) == images[0]
    }
    
    func testThatSettingTheImagesWillSetupCorrectSecondInnerContentViewOrigin() {
        setupSUTWithImages()
        
        expect(self.sut.contentViews[1].frame.origin.x) == 200.0
    }
    
    func testThatSettingTheImagesWillSetupCorrectSecondInnerContentViewSuperview() {
        setupSUTWithImages()
        
        expect(self.sut.contentViews[1].superview) == sut.scrollView
    }
    
    func testThatItHasCorrectCurrentImageView() {
        setupSUTWithImages()
        
        expect(self.sut.currentImageView()) == sut.contentViews[0]
    }
    
}


