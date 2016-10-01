import XCTest
@testable import H19MediaViewer
import Nimble

class MediaViewerTransitionAnimatorTests: XCTestCase {

    var sut: MediaViewerTransitionAnimator!

    var originContainer: UIView?
    var contentsView: MediaViewerContentsView?

    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
        sut = nil
        originContainer = nil
        contentsView = nil
    }


    // MARK: state and setup

    func testThatItInitsWithSourceImageView() {
        let imageView = UIImageView()
        sut = MediaViewerTransitionAnimator(sourceImageView:imageView, contentsView: MediaViewerContentsView(frame: CGRect.zero))
        expect(self.sut.sourceImageView) == imageView
    }

    func testThatItInitsWithContentsView() {
        let contentsView = MediaViewerContentsView(frame: CGRect.zero)
        sut = MediaViewerTransitionAnimator(sourceImageView: UIImageView(), contentsView: contentsView)
        expect(self.sut.contentsView) == contentsView
    }

    func testThatItInitsWithContentsViewWitBackground() {
        let contentsView = MediaViewerContentsView(frame: CGRect.zero)
        sut = MediaViewerTransitionAnimator(sourceImageView: UIImageView(), contentsView: contentsView)
        expect(self.sut.contentsView.backgroundView) == contentsView.backgroundView
    }


    // MARK: transition IN

    class MockMediaViewerMultipleImageScrollView: MediaViewerMultipleImageScrollView {

        var sourceImageView: UIImageView?

        override func currentImageView() -> MediaViewerInteractiveImageView? {
            if contentViews.count == 0 {
                self.images = [MediaViewerImage(image: UIImage(named: "minion8", in: Bundle(for: self.classForCoder), compatibleWith: nil)!, sourceImageView: sourceImageView)]
            }
            return contentViews[0]
        }
    }

    func setupSUTWithTwoImageViewsInsideContainers() -> UIImageView {
        let view1 = UIView(frame: CGRect(x: 40, y: 80, width: 400, height: 600))
        let imageView1 = UIImageView(frame: CGRect(x: 20, y: 20, width: 40, height: 60))
        imageView1.image = UIImage(named: "minion8")
        view1.addSubview(imageView1)
        originContainer = view1
        contentsView = MediaViewerContentsView(frame: CGRect(x: 0, y: 0, width: 400, height: 600))
        let mockScroll = MockMediaViewerMultipleImageScrollView(frame: contentsView!.bounds)
        mockScroll.sourceImageView = imageView1
        contentsView!.scrollView = mockScroll

        sut = MediaViewerTransitionAnimator(sourceImageView: imageView1, contentsView: contentsView!)
        return contentsView!.scrollView.currentImageView()!.imageView
    }

    func testThatTransitionToDestinationSourceImageContentModeIsAspectFill() {
        _ = setupSUTWithTwoImageViewsInsideContainers()

        sut.setupTransitionToDestinationImageView()

        expect(self.contentsView?.scrollView.currentImageView()!.imageView.contentMode) == UIViewContentMode.scaleAspectFill
    }

    func testThatTransitionToDestinationInitialBackgroundAlphaIs0() {
        _ = setupSUTWithTwoImageViewsInsideContainers()

        sut.setupTransitionToDestinationImageView()

        expect(self.contentsView?.backgroundView.alpha) == 0.0
    }

    func testThatTransitionToDestinationSetupHidesSourceImage() {
        _ = setupSUTWithTwoImageViewsInsideContainers()

        sut.setupTransitionToDestinationImageView()

        expect(self.sut.sourceImageView!.isHidden) == true
    }

    func testThatTransitionToDestinationInitialValueXIsEqalToSourceImageView() {
        let imageView2 = setupSUTWithTwoImageViewsInsideContainers()

        sut.setupTransitionToDestinationImageView()

        expect(imageView2.frame.origin.x) == 60
    }

    func testThatTransitionToDestinationInitialValueYIsEqalToSourceImageView() {
        let imageView2 = setupSUTWithTwoImageViewsInsideContainers()

        sut.setupTransitionToDestinationImageView()

        expect(imageView2.frame.origin.y) == 100
    }

    func testThatTransitionToDestinationInitialWidthIsEqalToSourceImageView() {
        let imageView2 = setupSUTWithTwoImageViewsInsideContainers()

        sut.setupTransitionToDestinationImageView()

        expect(imageView2.frame.size.width) == 40
    }

    func testThatTransitionToDestinationInitialHeightIsEqalToSourceImageView() {
        let imageView2 = setupSUTWithTwoImageViewsInsideContainers()

        sut.setupTransitionToDestinationImageView()

        expect(imageView2.frame.size.height) == 60
    }

    func testThatTransitionToDestinationFinalValueXIsEqalToDestinationImageView() {
        let imageView = setupSUTWithTwoImageViewsInsideContainers()

        sut.transitionToDestinationImageView(false)

        expect(imageView.frame.origin.x) == 0.0
    }

    func testThatTransitionToDestinationFinalValueYIsEqalToDestinationImageView() {
        let imageView2 = setupSUTWithTwoImageViewsInsideContainers()

        sut.transitionToDestinationImageView(false)

        expect(Double(imageView2.frame.origin.y)).to(beCloseTo(117.7, within: 0.5))
    }

    func testThatTransitionToDestinationFinalWidthIsEqalToDestinationImageView() {
        let imageView2 = setupSUTWithTwoImageViewsInsideContainers()

        sut.transitionToDestinationImageView(false)

        expect(imageView2.frame.size.width) == 400.0
    }

    func testThatTransitionToDestinationFinalHeightIsEqalToDestinationImageView() {
        let imageView2 = setupSUTWithTwoImageViewsInsideContainers()

        sut.transitionToDestinationImageView(false)

        expect(Double(imageView2.frame.size.height)).to(beCloseTo(364.5, within: 0.5))
    }

    func testThatTransitionToDestinationFinalBackgroundAlphaIs1() {
        _ = setupSUTWithTwoImageViewsInsideContainers()

        sut.transitionToDestinationImageView(false)

        expect(self.contentsView?.backgroundView.alpha) == 1.0
    }

    func testThatTransitionToInteractiveImageViewFinalBackgroundAlphaIs1() {
        _ = setupSUTWithTwoImageViewsInsideContainers()

        sut.transitionToDestinationImageView(false)

        expect(self.contentsView?.scrollView.alpha) == 1.0
    }


    // MARK: transition OUT

    func testThatTransitionSetupBackToSourceSourceImageViewHidden() {
        _ = setupSUTWithTwoImageViewsInsideContainers()

        sut.setupTransitionBackToSourceImageView(withImageView: sut.sourceImageView)

        expect(self.sut.sourceImageView!.isHidden) == true
    }

    func testThatTransitionBackFinalValueXIsEqalToSourceImageView() {
        let imageView2 = setupSUTWithTwoImageViewsInsideContainers()

        sut.transitionBackToSourceImageView(false)

        expect(imageView2.frame.origin.x) == 60
    }

    func testThatTransitionBackFinalValueYIsEqalToSourceImageView() {
        let imageView2 = setupSUTWithTwoImageViewsInsideContainers()

        sut.transitionBackToSourceImageView(false)

        expect(imageView2.frame.origin.y) == 100
    }

    func testThatTransitionBackFinalWidthIsEqalToSourceImageView() {
        let imageView2 = setupSUTWithTwoImageViewsInsideContainers()

        sut.transitionBackToSourceImageView(false)

        expect(imageView2.frame.size.width) == 40.0
    }

    func testThatTransitionBackFinalHeightIsEqalToDestinationImageView() {
        let imageView2 = setupSUTWithTwoImageViewsInsideContainers()

        sut.transitionBackToSourceImageView(false)

        expect(imageView2.frame.size.height) == 60.0
    }

    func testThatTransitionBackFinalBackgroundAlphaIs0() {
        _ = setupSUTWithTwoImageViewsInsideContainers()

        sut.transitionBackToSourceImageView(false)

        expect(self.contentsView?.backgroundView.alpha) == 0.0
    }

    func testThatTransitionBackWithoutSourceImageViewFrameIsCorrect() {
        let imageView2 = setupSUTWithTwoImageViewsInsideContainers()
        sut.sourceImageView = nil

        sut.transitionBackToSourceImageView(false)

        expect(imageView2.frame) == CGRect(x: 0, y: 600, width: 400, height: 600)
    }

    class MockMediaDelegate: MediaViewerDelegate {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 4000, height: 500))
        @objc func scrollImageviewsContainer() -> MediaViewerMultipleImageScrollViewDelegate {
            return UICollectionView()
        }
        @objc func imageViewForImage(_ image: MediaViewerImageModel) -> UIImageView? {
            let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 200, height: 400))
            view.addSubview(imageView)
            return imageView
        }
    }

    func testThatTransitionBackWitDelegateImageViewFrameIsCorrect() {
        let imageView2 = setupSUTWithTwoImageViewsInsideContainers()
        sut.sourceImageView = nil
        let mockDelegate = MockMediaDelegate()
        sut.transitionDelegate = mockDelegate

        sut.transitionBackToSourceImageView(false)

        expect(imageView2.frame) == CGRect(x: 0, y: 0, width: 200, height: 400)
    }

}
