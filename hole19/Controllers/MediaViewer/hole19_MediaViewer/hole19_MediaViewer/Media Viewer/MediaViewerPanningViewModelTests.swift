
import XCTest
@testable import hole19v2
import Nimble

class MediaViewerPanningViewModelTests: XCTestCase {
    
    var sut: MediaViewerPanningViewModel!
    
    override func setUp() {
        super.setUp()
        sut = MediaViewerPanningViewModel(backgroundView: UIView(), containerView: MediaViewerContentsView(frame: CGRectZero))
    }
    
    override func tearDown() {
        super.tearDown()
        sut = nil
    }
    
    func testThatItInitsWithBackgroundViewCorrectly() {
        let view = UIView()
        
        sut = MediaViewerPanningViewModel(backgroundView:view, containerView: MediaViewerContentsView(frame: CGRectZero))
        
        expect(self.sut.backgroundView) == view
    }
    
    func testThatItInitsWithContainerViewCorrectly() {
        let view = MediaViewerContentsView(frame: CGRectZero)
        
        sut = MediaViewerPanningViewModel(backgroundView:UIView(), containerView: view)
        
        expect(self.sut.containerView) == view
    }
    
//    func testThatViewPannedWillAddTranslationToViewCenter() {
//        let view = UIView()
//        let containerView = UIView()
//        let recognizer = UIPanGestureRecognizer()
//        view.addGestureRecognizer(recognizer)
//        view.center = CGPointMake(0, 0)
//        
//        sut = MediaViewerPanningViewModel(pannedView: view, backgroundView: UIView(), containerView: containerView)
//        recognizer.setTranslation(CGPointMake(20, 20), inView: containerView)
//        
//        sut.viewPanned(recognizer)
//        
//        expect(view.center) == CGPointMake(20, 20)
//    }
    
}

