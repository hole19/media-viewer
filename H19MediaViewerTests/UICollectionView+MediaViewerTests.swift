
import XCTest
@testable import H19MediaViewer
import Nimble

class UICollectionView_MediaViewerTests: XCTestCase {
    
    var sut: UICollectionView!
    var sutDataSource: MockCollectionViewDataSource!
    
    class MockCollectionViewDataSource: NSObject, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
        func numberOfSectionsInCollectionView(in collectionView: UICollectionView) -> Int {
            return 2
        }
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return 10;
        }
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            return collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath as IndexPath)
        }
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            return CGSize(width: 30.0, height: 30.0)
        }
    }
    
    override func setUp() {
        super.setUp()
        sut = UICollectionView(frame: CGRect(x:0, y: 0, width: 200, height: 200), collectionViewLayout: UICollectionViewFlowLayout())

        sutDataSource = MockCollectionViewDataSource()
        sut.delegate = sutDataSource
        sut.dataSource = sutDataSource
        sut.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        
        sut.reloadData()
        sut.setNeedsLayout()
    }
    
    override func tearDown() {
        super.tearDown()
        sut = nil
    }
    
    func testThatItWillScrollToItem0() {
        sut.scrollToItemWithIndex(0)
        
        expect(self.sut.contentOffset) == CGPoint(x: 0, y: 0)
    }
    
    func testThatItWillScrollToItem2() {
        sut.scrollToItemWithIndex(2)
        
        expect(self.sut.contentOffset) == CGPoint(x: 0, y: 0)
    }
    
    func testThatItWillScrollToItem12() {
        sut.scrollToItemWithIndex(12)
        
        expect(self.sut.contentOffset) == CGPoint(x: 0, y: 0)
    }
}

