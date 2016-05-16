
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
        expect(self.sut.scrollView.frame.size.width) == 208
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
    
    func setupSUTWithImages() -> [MediaViewerImage] {
        sut.layoutIfNeeded()

        let image1 = UIImage()
        let image2 = UIImage()
        
        let images = [MediaViewerImage(image: image1), MediaViewerImage(image: image2)]
        sut.images = images
        return images
    }
    
    func testThatSettingTheImagesWillSetupCorrectContentViewSize() {
        setupSUTWithImages()
        
        expect(self.sut.scrollView.contentSize) == CGSize(width: 208.0 * 2, height: 200.0)
    }
    
    func testThatSettingTheImagesWillSetupCorrectNumberOfInnerContentViews() {
        setupSUTWithImages()
        expect(self.sut.contentViews.count) == 2
    }
    
    func testThatSettingTheImagesWillSetupCorrectFirstInnerContentViewImage() {
        let images = setupSUTWithImages()
        
        expect(self.sut.contentViews[0].imageView.image) == images[0].image
    }
    
    func testThatSettingTheImagesWillSetupCorrectSecondInnerContentViewOrigin() {
        setupSUTWithImages()
        
        expect(self.sut.contentViews[1].frame.origin.x) == 212.0
    }
    
    func testThatSettingTheImagesWillSetupCorrectSecondInnerContentViewSuperview() {
        setupSUTWithImages()
        
        expect(self.sut.contentViews[1].superview) == sut.scrollView
    }
    
    func testThatItHasCorrectCurrentImageView() {
        setupSUTWithImages()
        
        expect(self.sut.currentImageView()) == sut.contentViews[0]
    }
    
    func testThatOnScrollViewDidEndDeceleratingCurrentPageIsUpdated() {
        setupSUTWithImages()
        
        sut.scrollView.contentOffset = CGPoint(x: 208.0, y: 0.0)
            
        sut.scrollViewDidEndDecelerating(sut.scrollView)
        
        expect(self.sut.currentPage) == 1
    }
    
    func testThatOnScrollViewDidEndDeceleratingItSetsViewRecogniserToFail() {
        setupSUTWithImages()
        
        let mockTap = TapGestureRecogniserMock()
        sut.singleTapGestureRecogniserThatReqiresFailure = mockTap
        mockTap.requireGestureRecognizerToFailCallCount = 0
        
        sut.scrollViewDidEndDecelerating(sut.scrollView)
        
        expect(mockTap.requireGestureRecognizerToFailCallCount) == 1
        expect(mockTap.requireGestureRecognizerToFailRecogniser) == self.sut.currentImageView()!.zoomDoubleTapGestureRecogniser
    }
    
    class ImageDelegate: MediaViewerInteractiveImageViewDelegate {
        func hideControls() { }
    }
    
    func testThatItSetsImageViewDelegateOnAllImageViews() {
        setupSUTWithImages()
        let delegate = ImageDelegate()
        
        sut.imageViewActionsDelgate = delegate
        
        expect(self.sut.contentViews[0].delegate!) === delegate
        expect(self.sut.contentViews[1].delegate!) === delegate
    }
    
    class MockInteractiveImageView: MediaViewerInteractiveImageView {
        
        var numerOfTimesZoomOutWasCalled = 0
        
        override func zoomOut(animated animated: Bool = true) {
            numerOfTimesZoomOutWasCalled += 1
        }
    }
    
    func testThatZoomOutWillCallZoomOutOnCurrentImage() {
        let mockImage = MockInteractiveImageView()
        sut.contentViews = [mockImage]
        
        sut.zoomOut()
        
        expect(mockImage.numerOfTimesZoomOutWasCalled) == 1
    }
    
    func testThatSetImagesWithSelectedOneSetsImagesCorrectly() {
        let image = MediaViewerImage(image: UIImage())
        let images = [MediaViewerImage(image: UIImage()), image, MediaViewerImage(image: UIImage())]
        sut.setImages(images, withSelectedOne: image)
        
        expect(self.sut.images?.count) == images.count
    }
    
    func testThatSetImagesWithSelectedOneSetsSelectedImageCorrectly() {
        let image = MediaViewerImage(image: UIImage())
        let images = [MediaViewerImage(image: UIImage()), image, MediaViewerImage(image: UIImage())]
        sut.setImages(images, withSelectedOne: image)
        
        expect(self.sut.selectedImage) === image
    }
    
    func testThatItWillSetCorrectContentOffsetOnSetImagesWithSelectedOne() {
        let image = MediaViewerImage(image: UIImage())
        let images = [MediaViewerImage(image: UIImage()), image, MediaViewerImage(image: UIImage())]
        sut.setImages(images, withSelectedOne: image)
        
        expect(self.sut.scrollView.contentOffset) == CGPoint(x: 208.0, y: 0.0)
    }
    
    func testThatItWillSetCorrectCurrentPagesetOnSetImagesWithSelectedOne() {
        let image = MediaViewerImage(image: UIImage())
        let images = [MediaViewerImage(image: UIImage()), image, MediaViewerImage(image: UIImage())]
        sut.setImages(images, withSelectedOne: image)
        
        expect(self.sut.currentPage) == 1
    }
    
    class MockMediaViewerDelegate: NSObject, MediaViewerDelegate {
        var hasMoreImages = true
        
        func scrollImageviewsContainer() -> UIScrollView {
            return UIScrollView()
        }
        func imageViewForImage(image: MediaViewerImage) -> UIImageView? {
            return UIImageView()
        }
        func hasMoreImagesToLoad(withImages: [MediaViewerImage]) -> Bool {
            return hasMoreImages
        }
    }
    
    func testThatItWillAddOneMorePageIfDelegateNeedsLazyLoading() {
        let image = MediaViewerImage(image: UIImage())
        let images = [MediaViewerImage(image: UIImage()), image, MediaViewerImage(image: UIImage())]
        let mockDelegate = MockMediaViewerDelegate()
        sut.mediaViewerDelegate = mockDelegate
        
        sut.setImages(images, withSelectedOne: image)
        
        expect(self.sut.contentViews.count) == 4
    }
    
    func testThatItWillNotAddOneMorePageIfDelegateDoesntNeedLazyLoading() {
        let image = MediaViewerImage(image: UIImage())
        let images = [MediaViewerImage(image: UIImage()), image, MediaViewerImage(image: UIImage())]
        let mockDelegate = MockMediaViewerDelegate()
        mockDelegate.hasMoreImages = false
        sut.mediaViewerDelegate = mockDelegate
        
        sut.setImages(images, withSelectedOne: image)
        
        expect(self.sut.contentViews.count) == 3
    }

}


