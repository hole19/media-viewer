
import XCTest
@testable import hole19v2
import Nimble

class MediaViewerTests: XCTestCase {
    
    var sut: MediaViewer!
    
    override func setUp() {
        super.setUp()
        sut = MediaViewer(image: MediaViewerImage(image: UIImage(named: "minion8")!), sourceImageView: UIImageView(),allImages: nil)
        let _ = sut.view
    }
    
    override func tearDown() {
        super.tearDown()
        sut = nil
    }
    
    func testThatItsModalPresentationStyleIsOverCurrentContext() {
        sut = MediaViewer(image: MediaViewerImage(image: UIImage(named: "minion8")!), sourceImageView: UIImageView(),allImages: nil)
        expect(self.sut.modalPresentationStyle) == UIModalPresentationStyle.OverCurrentContext
    }
    
    func testThatItInitsWithSourceImageView() {
        let imageView = UIImageView()
        sut = MediaViewer(image: MediaViewerImage(image: UIImage(named: "minion8")!), sourceImageView: imageView,allImages: nil)
        expect(self.sut.sourceImageView) == imageView
    }
    
    func testThatItHasMediaViewerContentsView() {
        expect(self.sut.contentsView) != nil
    }
    
    func testThatContentViewCoversTheWholeView() {
        let view = sut.view
        sut.view.layoutIfNeeded()
        expect(self.sut.contentsView.frame.size) == CGSizeMake(view.frame.size.width, view.frame.size.height)
    }
    
    func testThatItHasTransitionAnimatior() {
        sut = MediaViewer(image: MediaViewerImage(image: UIImage(named: "minion8")!), sourceImageView: UIImageView(),allImages: nil)
        let _ = sut.view
        expect(self.sut.transitionAnimator) != nil
    }
    
    func testThatItHasTransitionAnimatiorWithCorrectSourceImageView() {
        let imageView = UIImageView()
        sut = MediaViewer(image: MediaViewerImage(image: UIImage(named: "minion8")!), sourceImageView: imageView,allImages: nil)
        let _ = sut.view
        expect(self.sut.transitionAnimator?.sourceImageView) == imageView
    }
    
    func testThatItHasTransitionAnimatiorWithCorrectContentsView() {
        sut = MediaViewer(image: MediaViewerImage(image: UIImage(named: "minion8")!), sourceImageView: UIImageView(),allImages: nil)
        let _ = sut.view
        expect(self.sut.transitionAnimator?.contentsView) == self.sut.contentsView
    }
    
    class MockMediaViewerTransitionAnimator: MediaViewerTransitionAnimator {
        
        var numberOfTimesTransitionWasCalled = 0
        var numberOfTimesSetupTransitionWasCalled = 0
        var numberOfTimesTransitionBackWasCalled = 0
        
        override func transitionToDestinationImageView(animated: Bool, withCompletition completition: () -> (Void) = {}) {
            numberOfTimesTransitionWasCalled += 1
        }
        
        override func setupTransitionToDestinationImageView() {
            numberOfTimesTransitionWasCalled += 1
        }
        
        override func transitionBackToSourceImageView(animated: Bool, withCompletition completition: () -> (Void) = {}) {
            numberOfTimesTransitionBackWasCalled += 1
        }
    }
    
    func testThatItBeginsTransitionOnViewDidAppear() {
        sut = MediaViewer(image: MediaViewerImage(image: UIImage(named: "minion8")!), sourceImageView: UIImageView(),allImages: nil)
        let mockTransition = MockMediaViewerTransitionAnimator(sourceImageView: UIImageView(), contentsView: MediaViewerContentsView())
        sut.transitionAnimator = mockTransition
        let _ = sut.view
        sut.viewDidAppear(false)
        
        expect(mockTransition.numberOfTimesTransitionWasCalled) == 1
    }
    
    func testThatCloseTriggersTransitionBack() {
        sut = MediaViewer(image: MediaViewerImage(image: UIImage(named: "minion8")!), sourceImageView: UIImageView(),allImages: nil)
        let mockTransition = MockMediaViewerTransitionAnimator(sourceImageView: UIImageView(), contentsView: MediaViewerContentsView())
        sut.transitionAnimator = mockTransition
        let _ = sut.view
        sut.close(sut.contentsView.closeButton)
        
        expect(mockTransition.numberOfTimesTransitionBackWasCalled) == 1
    }
    
    func testThatItSetsPanningModelDelegate() {
        expect(self.sut.contentsView.pannedViewModel.delegate === self.sut) == true
    }
    
    class MockTransitionAnimator: MediaViewerTransitionAnimator {
        var numberOfTimesTransitionBackWasCalled = 0
        
        override func transitionBackToSourceImageView(animated: Bool, withCompletition completition: () -> (Void) = {}) {
            numberOfTimesTransitionBackWasCalled += 1
        }
    }
    
    func testThatDismissViewWillCallTransitionBack() {
        let mockTransition = MockTransitionAnimator(sourceImageView: UIImageView(), contentsView: MediaViewerContentsView())
        sut.transitionAnimator = mockTransition
        
        sut.dismissView()
        
        expect(mockTransition.numberOfTimesTransitionBackWasCalled) == 1
    }
    
    func testThatItConformsToMediaViewerActionsDelegate() {
        expect((self.sut as? MediaViewerContentsViewActionsDelegate) != nil) == true
    }
    
    class MockScrollView: MediaViewerMultipleImageScrollView {
        
        let imageView = UIImageView()
        let image = UIImage()
        
        override func currentImageView() -> MediaViewerInteractiveImageView? {
            imageView.image = image
            let interactiveImageView = MediaViewerInteractiveImageView()
            interactiveImageView.imageView = imageView
            return interactiveImageView
        }
    }
    
    func testThatItIsDelegateOfTheContentsView() {
        expect(self.sut.contentsView.delegate) === sut
    }
    
    func testThatItHasImageTaskHandler() {
        expect(self.sut.imageTaskHandler).notTo(beNil())
    }
    
    class MockImageTaskHandler: MediaViewerImageActionsHandler {
        
        var numberOfTimesActionSheetWasCalled = 0
        
        override func actionSheetWithAllTasksForImage(image: UIImage) -> UIAlertController {
            numberOfTimesActionSheetWasCalled += 1
            return UIAlertController()
        }
        
    }
    
    class StubScroll: MediaViewerMultipleImageScrollView {
        override func currentImageView() -> MediaViewerInteractiveImageView? {
            let image = MediaViewerInteractiveImageView(frame: CGRectZero)
            image.imageView.image = UIImage()
            return image
        }
    }
    
    func testThatItWillCreateAlertOnLongPress() {
        let mock = MockImageTaskHandler()
        sut.imageTaskHandler = mock
        sut.contentsView.scrollView = StubScroll()
        
        sut.longPressActionDetectedInContentView(sut.contentsView)
        
        expect(mock.numberOfTimesActionSheetWasCalled) == 1
    }
    
    class MockImageScroll: MediaViewerMultipleImageScrollView {
        
        var numerOfTimesLayoutSubviewsWasCalled = 0
        
        override func layoutSubviews() {
            super.layoutSubviews()
            numerOfTimesLayoutSubviewsWasCalled += 1
        }
    }
        
    func testThatOnViewWillTransitionToSizeMediaViewerWillForceScrollViewLayout() {
        let _ = sut.view
        let mockScroll = MockImageScroll()
        sut.contentsView.scrollView = mockScroll
        
        sut.viewWillTransitionToSize(CGSize(width: 0,height: 0), withTransitionCoordinator: MockTransitionCoordinator())
        
        expect(mockScroll.numerOfTimesLayoutSubviewsWasCalled) == 1
    }
}

