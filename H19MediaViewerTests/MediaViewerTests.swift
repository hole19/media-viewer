
import XCTest
@testable import H19MediaViewer
import Nimble

class MediaViewerTests: XCTestCase {
    
    var sut: MediaViewer!
    
    override func setUp() {
        super.setUp()
        let image = MediaViewerImage(image: UIImage(named: "minion8", in: Bundle(for: self.classForCoder), compatibleWith: nil)!)
        image.sourceImageView = UIImageView()
        sut = MediaViewer(image: image, allImages: nil)
    }
    
    override func tearDown() {
        super.tearDown()
        sut = nil
    }
    
    func testThatItsModalPresentationStyleIsOverCurrentContext() {
        expect(self.sut.modalPresentationStyle) == UIModalPresentationStyle.overCurrentContext
    }
    
    func setupSutWithImageView() -> UIImageView {
        let imageView = UIImageView()
        let image = MediaViewerImage(image: UIImage(named: "minion8", in: Bundle(for: self.classForCoder), compatibleWith: nil)!)
        image.sourceImageView = imageView
        sut = MediaViewer(image: image, allImages: nil)
        return imageView
    }
    
    func testThatItInitsWithSourceImageView() {
        let imageView = setupSutWithImageView()
        expect(self.sut.sourceImageView) == imageView
    }
    
    func testThatItHasMediaViewerContentsView() {
        let _ = sut.view

        expect(self.sut.contentsView) != nil
    }
    
    func testThatContentViewCoversTheWholeView() {
        let view = sut.view!
        sut.view.layoutIfNeeded()
        expect(self.sut.contentsView.frame.size) == CGSize(width: view.frame.size.width, height: view.frame.size.height)
    }
    
    func testThatItHasTransitionAnimatior() {
        let _ = sut.view

        expect(self.sut.transitionAnimator) != nil
    }
    
    func testThatItHasTransitionAnimatiorWithCorrectSourceImageView() {
        let imageView = setupSutWithImageView()
        let _ = sut.view
        expect(self.sut.transitionAnimator?.sourceImageView) == imageView
    }
    
    func testThatItHasTransitionAnimatiorWithCorrectContentsView() {
        let _ = sut.view
        expect(self.sut.transitionAnimator?.contentsView) == self.sut.contentsView
    }
    
    func testThatItHasAllowLandscapeDismissalProperyDefaultToFalse() {
        expect(self.sut.allowLandscapeDismissal) == false
    }
    
    func testThatItSetsAllowLandscapeDismissalProperyOnContentsView() {
        sut.allowLandscapeDismissal = true
        let _ = sut.view
       
        expect(self.sut.contentsView.allowLandscapeDismissal) == true
    }
    
    class MockMediaViewerTransitionAnimator: MediaViewerTransitionAnimator {
        
        var numberOfTimesTransitionWasCalled = 0
        var numberOfTimesSetupTransitionWasCalled = 0
        var numberOfTimesTransitionBackWasCalled = 0
        
        var transitionBackCompletition = {}
        
        override func transitionToDestinationImageView(_ animated: Bool, withCompletition completition: () -> (Void) = {}) {
            numberOfTimesTransitionWasCalled += 1
        }
        
        override func setupTransitionToDestinationImageView() {
            numberOfTimesTransitionWasCalled += 1
        }
        
        override func transitionBackToSourceImageView(_ animated: Bool, withCompletition completition: () -> (Void) = {}) {
            numberOfTimesTransitionBackWasCalled += 1
            transitionBackCompletition = completition
        }
    }
    
    func testThatItBeginsTransitionOnViewDidAppear() {
        let mockTransition = MockMediaViewerTransitionAnimator(sourceImageView: UIImageView(), contentsView: MediaViewerContentsView(frame: CGRect.zero))
        sut.transitionAnimator = mockTransition
        let _ = sut.view
        sut.viewDidAppear(false)
        
        expect(mockTransition.numberOfTimesTransitionWasCalled) == 1
    }
    
    func testThatCloseTriggersTransitionBack() {
        let mockTransition = MockMediaViewerTransitionAnimator(sourceImageView: UIImageView(), contentsView: MediaViewerContentsView(frame: CGRect.zero))
        sut.transitionAnimator = mockTransition
        let _ = sut.view
        sut.close(sut.contentsView.closeButton)
        
        expect(mockTransition.numberOfTimesTransitionBackWasCalled) == 1
    }
    
    func testThatItSetsPanningModelDelegate() {
        let _ = sut.view

        expect(self.sut.contentsView.pannedViewModel.delegate === self.sut) == true
    }
    
    class MockTransitionAnimator: MediaViewerTransitionAnimator {
        var numberOfTimesTransitionBackWasCalled = 0
        
        override func transitionBackToSourceImageView(_ animated: Bool, withCompletition completition: () -> (Void) = {}) {
            numberOfTimesTransitionBackWasCalled += 1
        }
    }
    
    func testThatDismissViewWillCallTransitionBack() {
        let mockTransition = MockTransitionAnimator(sourceImageView: UIImageView(), contentsView: MediaViewerContentsView(frame: CGRect.zero))
        sut.transitionAnimator = mockTransition
        
        sut.dismissView()
        
        expect(mockTransition.numberOfTimesTransitionBackWasCalled) == 1
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
        let _ = sut.view

        expect(self.sut.contentsView.delegate) === sut
    }
    
    func testThatItHasImageTaskHandler() {
        expect(self.sut.imageTaskHandler).notTo(beNil())
    }
    
    class MockImageTaskHandler: MediaViewerImageActionsHandler {
        
        var numberOfTimesActionSheetWasCalled = 0
        
        override func actionSheetWithAllTasksForImage(_ image: UIImage) -> UIAlertController {
            numberOfTimesActionSheetWasCalled += 1
            return UIAlertController()
        }
        
    }
    
    class StubScroll: MediaViewerMultipleImageScrollView {
        override func currentImageView() -> MediaViewerInteractiveImageView? {
            let image = MediaViewerInteractiveImageView(frame: CGRect.zero)
            image.imageView.image = UIImage()
            return image
        }
    }
    
    func testThatItWillCreateAlertOnLongPress() {
        let mock = MockImageTaskHandler()
        sut.imageTaskHandler = mock

        let _ = sut.view
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
        
        sut.viewWillTransition(to: CGSize(width: 0,height: 0), with: MockTransitionCoordinator())
        
        expect(mockScroll.numerOfTimesLayoutSubviewsWasCalled) == 1
    }
    
    class MockContentsView: MediaViewerContentsView {
        
        var numerOfTimesUpdateWitLandscapeWasCalled = 0
        
        override func updateViewStateWithLandscape(_ landscape: Bool) {
            numerOfTimesUpdateWitLandscapeWasCalled += 1
        }
    }
    
    func testThatOnViewWillTransitionToSizeMediaViewerWillUpdateContentsViewWithLandscape() {
        let _ = sut.view
        let mockContents = MockContentsView(frame: CGRect.zero)
        sut.contentsView = mockContents
        
        let coordin = MockTransitionCoordinator()
        sut.viewWillTransition(to: CGSize(width: 0,height: 0), with:coordin )
        
        coordin.animateAlongsideTransitionBlock?(coordin)
        
        expect(mockContents.numerOfTimesUpdateWitLandscapeWasCalled) == 1
    }
    
    func testThatPresentWillCreateForegroundWindow() {
        sut.present()
        
        expect(self.sut.foregroundWindow) != nil
    }
    
    func testThatPresentWillCreateForegroundWindowWithStatusBarLevel() {
        sut.present()
        
        expect(self.sut.foregroundWindow!.windowLevel) == UIWindowLevelStatusBar
    }
    
    func testThatPresentWillCreateForegroundWindowWithSUTAsRoot() {
        sut.present()
        
        expect(self.sut.foregroundWindow!.rootViewController) == sut
    }
    
    func testThatOnTransitionBackWindowIsRemoved() {
        let mockTransition = MockMediaViewerTransitionAnimator(sourceImageView: UIImageView(), contentsView: MediaViewerContentsView(frame: CGRect.zero))
        sut.transitionAnimator = mockTransition
        let _ = sut.view
        
        sut.dismissView()
        mockTransition.transitionBackCompletition()
        
        expect(self.sut.foregroundWindow).to(beNil())
    }
}

