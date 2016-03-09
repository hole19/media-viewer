
import XCTest
@testable import hole19v2
import Nimble

class MediaViewerTransitionAnimatorTests: XCTestCase {
    
    var sut: MediaViewerTransitionAnimator!
    
    // property to retain containers between function calls
    var originContainer: UIView?
    var destinationContainer: UIView?
    var destinationBackgroundView: UIView?
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
        sut = nil
        originContainer = nil
        destinationBackgroundView = nil
        destinationContainer = nil
    }
    
    func testThatItInitsWithSourceImageView() {
        let imageView = UIImageView()
        sut = MediaViewerTransitionAnimator(sourceImageView:imageView, destinationImageView: UIImageView(), backgroundView: nil)
        expect(self.sut.sourceImageView) == imageView
    }
    
    func testThatItInitsWithDestinationImageView() {
        let imageView = UIImageView()
        sut = MediaViewerTransitionAnimator(sourceImageView:UIImageView(), destinationImageView: imageView, backgroundView: nil)
        expect(self.sut.destinationImageView) == imageView
    }
    
    func testThatItInitsWithBackgroundView() {
        let backgroundView = UIView()
        sut = MediaViewerTransitionAnimator(sourceImageView: UIImageView(), destinationImageView: UIImageView(), backgroundView: backgroundView)
        expect(self.sut.backgroundView) == backgroundView
    }
    
    func setupSUTWithTwoImageViewsInsideContainers() -> UIImageView {
        let view1 = UIView(frame: CGRectMake(40, 80, 400, 600))
        let imageView1 = UIImageView(frame: CGRectMake(20, 20, 40, 60))
        view1.addSubview(imageView1)
        originContainer = view1
        let view2 = UIView(frame: CGRectMake(0, 0, 400, 600))
        let view3 = UIView(frame: CGRectMake(0, 0, 400, 600))
        let imageView2 = UIImageView(frame: CGRectMake(200, 300, 100, 100))
        view2.addSubview(view3)
        view2.addSubview(imageView2)
        destinationContainer = view2
        sut = MediaViewerTransitionAnimator(sourceImageView: imageView1, destinationImageView: imageView2, backgroundView: view3)
        destinationBackgroundView = view3
        return imageView2
    }
    
    func testThatTransitionToDestinationInitialBackgroundAlphaIs0() {
        setupSUTWithTwoImageViewsInsideContainers()
        
        sut.setupTransitionToDestinationImageView()
        
        expect(self.destinationBackgroundView?.alpha) == 0.0
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
        let imageView2 = setupSUTWithTwoImageViewsInsideContainers()
        
        sut.transitionToDestinationImageView(false)
        
        expect(imageView2.frame.origin.x) == 200
    }
    
    func testThatTransitionToDestinationFinalValueYIsEqalToDestinationImageView() {
        let imageView2 = setupSUTWithTwoImageViewsInsideContainers()
        
        sut.transitionToDestinationImageView(false)
        
        expect(imageView2.frame.origin.y) == 300
    }
    
    func testThatTransitionToDestinationFinalWidthIsEqalToDestinationImageView() {
        let imageView2 = setupSUTWithTwoImageViewsInsideContainers()
        
        sut.transitionToDestinationImageView(false)
        
        expect(imageView2.frame.size.width) == 100
    }
    
    func testThatTransitionToDestinationFinalHeightIsEqalToDestinationImageView() {
        let imageView2 = setupSUTWithTwoImageViewsInsideContainers()
        
        sut.transitionToDestinationImageView(false)
        
        expect(imageView2.frame.size.height) == 100
    }
    
    func testThatTransitionToDestinationFinalBackgroundAlphaIs1() {
        setupSUTWithTwoImageViewsInsideContainers()
        
        sut.transitionToDestinationImageView(false)
        
        expect(self.destinationBackgroundView?.alpha) == 1.0
    }

}

