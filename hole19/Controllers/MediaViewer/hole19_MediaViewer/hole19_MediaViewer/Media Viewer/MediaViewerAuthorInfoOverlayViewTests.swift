
import XCTest
@testable import hole19v2
import Nimble

class MediaViewerAuthorInfoOverlayViewTests: XCTestCase {
    
    var sut: MediaViewerAuthorInfoOverlayView!
    
    override func setUp() {
        super.setUp()
        sut = MediaViewerAuthorInfoOverlayView(frame: CGRectMake(0,0,300,80))
    }
    
    override func tearDown() {
        super.tearDown()
        sut = nil
    }
    
    func testThatItHasCorrectDefaultHeight() {
        expect(self.sut.defaultHeight()) == 80.0
    }

    func testThatItHasImageView() {
        expect(self.sut.authorImageView) != nil
    }
    
    func testThatImageViewHasCorrectWidth() {
        sut.layoutIfNeeded()
        expect(self.sut.authorImageView.frame.size.width) == 26.0
    }
    
    func testThatImageViewHasCorrectHeight() {
        sut.layoutIfNeeded()
        expect(self.sut.authorImageView.frame.size.height) == 26.0
    }
    
    func testThatItHasAuthorTitleLabel() {
        expect(self.sut.authorTitleLablel) != nil
    }
    
    func testThatItHasTakenByLabel() {
        expect(self.sut.takenByTitle) != nil
    }
    
    func testThatTakenByLabelHasCorrectText() {
        expect(self.sut.takenByTitle.text) == NSLocalizedString("TAKEN BY", comment: "")
    }
    
    func testThatItHasBlurBackgroundView() {
        expect(self.sut.blurBackground) != nil
    }
    
    func testThatBlurBackgroundViewHasVisualEffectBlur() {
        expect(self.sut.blurBackground.effect as? UIBlurEffect) != nil
    }

    func testThatImageViewHasCorrectCornerRadius() {
        expect(self.sut.authorImageView.layer.cornerRadius) == 3.0
    }
    
    func testThatItHasDateLabel() {
        expect(self.sut.dateTakenLabel) != nil
    }
    
    func testThatItSetsCorrectDateLabelText() {
        let date = NSDate()
        let model = MediaViewerAuthorInfoOverlayViewModel(authorImageURL: NSURL(), authorTitle: "title", datePictureWasTaken: date)
        
        sut.model = model
        
        expect(self.sut.dateTakenLabel.text) == date.defaultString()
    }

}

