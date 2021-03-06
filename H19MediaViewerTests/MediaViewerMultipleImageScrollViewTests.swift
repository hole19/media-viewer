import XCTest
@testable import H19MediaViewer
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
        expect(self.sut.scrollView).toNot(beNil())
    }

    func testThatScrollViewHasCorrectWidth() {
        sut.layoutIfNeeded()
        expect(self.sut.scrollView.frame.size.width) == 204
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
        expect(self.sut.scrollView.isPagingEnabled) == true
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
        _ = setupSUTWithImages()

        expect(self.sut.scrollView.contentSize) == CGSize(width: 204.0 * 2, height: 200.0)
    }

    func testThatSettingTheImagesWillSetupCorrectNumberOfInnerContentViews() {
        _ = setupSUTWithImages()

        expect(self.sut.contentViews.count) == 2
    }

    func testThatSettingTheImagesWillSetupCorrectFirstInnerContentViewImage() {
        let images = setupSUTWithImages()

        expect(self.sut.contentViews[0].imageView.image) == images[0].image
    }

    func testThatSettingTheImagesWillSetupCorrectSecondInnerContentViewOrigin() {
        _ = setupSUTWithImages()

        expect(self.sut.contentViews[1].frame.origin.x) == 206.0
    }

    func testThatSettingTheImagesWillSetupCorrectSecondInnerContentViewSuperview() {
        _ = setupSUTWithImages()

        expect(self.sut.contentViews[1].superview) == sut.scrollView
    }

    func testThatItHasCorrectCurrentImageView() {
        _ = setupSUTWithImages()

        expect(self.sut.currentImageView()) == sut.contentViews[0]
    }

    func testThatOnScrollViewDidEndDeceleratingCurrentPageIsUpdated() {
        _ = setupSUTWithImages()

        sut.scrollView.contentOffset = CGPoint(x: 208.0, y: 0.0)

        sut.scrollViewDidEndDecelerating(sut.scrollView)

        expect(self.sut.currentPage) == 1
    }

    func testThatOnScrollViewDidEndDeceleratingItSetsViewRecogniserToFail() {
        _ = setupSUTWithImages()

        let mockTap = TapGestureRecogniserMock()
        sut.singleTapGestureRecogniserThatReqiresFailure = mockTap
        mockTap.requireGestureRecognizerToFailCallCount = 0

        sut.scrollViewDidEndDecelerating(sut.scrollView)

        expect(mockTap.requireGestureRecognizerToFailCallCount) == 1
        expect(mockTap.requireGestureRecognizerToFailRecogniser) == self.sut.currentImageView()!.zoomDoubleTapGestureRecognizer
    }

    class ImageDelegate: MediaViewerInteractiveImageViewDelegate {
        func hideControls() { }
    }

    func testThatItSetsImageViewDelegateOnAllImageViews() {
        _ = setupSUTWithImages()

        let delegate = ImageDelegate()

        sut.imageViewActionsDelgate = delegate

        expect(self.sut.contentViews[0].delegate!) === delegate
        expect(self.sut.contentViews[1].delegate!) === delegate
    }

    class MockInteractiveImageView: MediaViewerInteractiveImageView {

        var numerOfTimesZoomOutWasCalled = 0

        override func zoomOut(animated: Bool = true) {
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

        expect(self.sut.scrollView.contentOffset) == CGPoint(x: 206.0, y: 0.0)
    }

    func testThatItWillSetCorrectCurrentPagesetOnSetImagesWithSelectedOne() {
        let image = MediaViewerImage(image: UIImage())
        let images = [MediaViewerImage(image: UIImage()), image, MediaViewerImage(image: UIImage())]
        sut.setImages(images, withSelectedOne: image)

        expect(self.sut.currentPage) == 1
    }

    class MockMediaViewerDelegate: NSObject, MediaViewerDelegate {
        var hasMoreImages = true

        func scrollImageviewsContainer() -> MediaViewerMultipleImageScrollViewDelegate {
            return UICollectionView()
        }
        func imageViewForImage(_ image: MediaViewerImageModel) -> UIImageView? {
            return UIImageView()
        }
         func hasMoreImagesToLoad(_ withImages: [MediaViewerImageModel]) -> Bool {
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
