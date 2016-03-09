
import XCTest
@testable import hole19v2
import Nimble

class MediaViewerTests: XCTestCase {
    
    var sut: MediaViewer!
    
    override func setUp() {
        super.setUp()
        sut = MediaViewer()
        let _ = sut.view
    }
    
    override func tearDown() {
        super.tearDown()
        sut = nil
    }
    
    func testThatItsModalPresentationStyleIsOverCurrentContext() {
        sut = MediaViewer(mediaURL: NSURL(), sourceImageView: UIImageView())
        expect(self.sut.modalPresentationStyle) == UIModalPresentationStyle.OverCurrentContext
    }
    
    func testThatItInitsWithMediaURL() {
        let exampleURL = NSURL(string: "myexample.com")!
        sut = MediaViewer(mediaURL: exampleURL, sourceImageView: UIImageView())
        expect(self.sut.mediaURL) == exampleURL
    }
    
    func testThatItInitsWithSourceImageView() {
        let imageView = UIImageView()
        sut = MediaViewer(mediaURL: NSURL(), sourceImageView: imageView)
        expect(self.sut.sourceImageView) == imageView
    }
    
    func testThatItHasImageView() {
        expect(self.sut.imageView) != nil
    }
    
    func testThatItHasBackgroundView() {
        expect(self.sut.backgroundView) != nil
    }
    
    func testThatImageViewCoversTheWholeView() {
        let view = sut.view
        sut.view.layoutIfNeeded()
        expect(self.sut.imageView.frame.size) == CGSizeMake(view.frame.size.width, view.frame.size.height)
    }
    
    func testThatImageViewHasContentModeAspectFit() {
        expect(self.sut.imageView.contentMode) == UIViewContentMode.ScaleAspectFit
    }
    
    func testThatItHasTransitionAnimatior() {
        sut = MediaViewer(mediaURL: NSURL(), sourceImageView: UIImageView())
        let _ = sut.view
        expect(self.sut.transitionAnimator) != nil
    }
    
    func testThatItHasTransitionAnimatiorWithCorrectSourceImageView() {
        let imageView = UIImageView()
        sut = MediaViewer(mediaURL: NSURL(), sourceImageView: imageView)
        let _ = sut.view
        expect(self.sut.transitionAnimator?.sourceImageView) == imageView
    }
    
    func testThatItHasTransitionAnimatiorWithCorrectBackgroundView() {
        sut = MediaViewer(mediaURL: NSURL(), sourceImageView: UIImageView())
        let _ = sut.view
        expect(self.sut.transitionAnimator?.backgroundView) == self.sut.backgroundView
    }
    
    class MockMediaViewerTransitionAnimator: MediaViewerTransitionAnimator {
        
        var numberOfTimesTransitionWasCalled = 0
        
        override func transitionToDestinationImageView(animated: Bool, withCompletition completition: () -> (Void) = {}) {
            numberOfTimesTransitionWasCalled++
        }
    }
    
    func testThatItBeginsTransitionOnViewDidLoad() {
        sut = MediaViewer(mediaURL: NSURL(), sourceImageView: UIImageView())
        let mockTransition = MockMediaViewerTransitionAnimator(sourceImageView: UIImageView(), destinationImageView: UIImageView(), backgroundView: nil)
        sut.transitionAnimator = mockTransition
        let _ = sut.view
        
        expect(mockTransition.numberOfTimesTransitionWasCalled) == 1
    }
    
}

