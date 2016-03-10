
import XCTest
@testable import hole19v2
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
    
    func testThatItInitsWithSourceImageView() {
        let imageView = UIImageView()
        sut = MediaViewerTransitionAnimator(sourceImageView:imageView, contentsView: MediaViewerContentsView())
        expect(self.sut.sourceImageView) == imageView
    }
    
    func testThatItInitsWithContentsView() {
        let contentsView = MediaViewerContentsView()
        sut = MediaViewerTransitionAnimator(sourceImageView: UIImageView(), contentsView: contentsView)
        expect(self.sut.contentsView) == contentsView
    }
    
    func testThatItInitsWithContentsViewWitBackground() {
        let contentsView = MediaViewerContentsView(frame: CGRectZero)
        sut = MediaViewerTransitionAnimator(sourceImageView: UIImageView(), contentsView: contentsView)
        expect(self.sut.contentsView.backgroundView) == contentsView.backgroundView
    }
    
    func setupSUTWithTwoImageViewsInsideContainers() -> UIImageView {
        let view1 = UIView(frame: CGRectMake(40, 80, 400, 600))
        let imageView1 = UIImageView(frame: CGRectMake(20, 20, 40, 60))
        view1.addSubview(imageView1)
        originContainer = view1
        contentsView = MediaViewerContentsView(frame: CGRectMake(0, 0, 400, 600))
        sut = MediaViewerTransitionAnimator(sourceImageView: imageView1, contentsView: contentsView!)
        return contentsView!.imageView
    }
    
    func testThatTransitionToDestinationInitialBackgroundAlphaIs0() {
        setupSUTWithTwoImageViewsInsideContainers()
        
        sut.setupTransitionToDestinationImageView()
        
        expect(self.contentsView?.backgroundView.alpha) == 0.0
    }
    
    func testThatTransitionToDestinationSetupHidesSourceImage() {
        setupSUTWithTwoImageViewsInsideContainers()
        
        sut.setupTransitionToDestinationImageView()
        
        expect(self.sut.sourceImageView.hidden) == true
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
        
        expect(imageView2.frame.origin.x) == 0.0
    }
    
    func testThatTransitionToDestinationFinalValueYIsEqalToDestinationImageView() {
        let imageView2 = setupSUTWithTwoImageViewsInsideContainers()
        
        sut.transitionToDestinationImageView(false)
        
        expect(imageView2.frame.origin.y) == 0.0
    }
    
    func testThatTransitionToDestinationFinalWidthIsEqalToDestinationImageView() {
        let imageView2 = setupSUTWithTwoImageViewsInsideContainers()
        
        sut.transitionToDestinationImageView(false)
        
        expect(imageView2.frame.size.width) == 400.0
    }
    
    func testThatTransitionToDestinationFinalHeightIsEqalToDestinationImageView() {
        let imageView2 = setupSUTWithTwoImageViewsInsideContainers()
        
        sut.transitionToDestinationImageView(false)
        
        expect(imageView2.frame.size.height) == 600.0
    }
    
    func testThatTransitionToDestinationFinalBackgroundAlphaIs1() {
        setupSUTWithTwoImageViewsInsideContainers()
        
        sut.transitionToDestinationImageView(false)
        
        expect(self.contentsView?.backgroundView.alpha) == 1.0
    }

}

