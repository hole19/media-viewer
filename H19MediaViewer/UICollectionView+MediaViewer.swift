
import UIKit

extension UICollectionView: MediaViewerMultipleImageScrollViewDelegate {
    public func scrollToItemWithIndex(_ index: Int) {
        var numberOfItemsInCollectionView = 0
        for i in 0..<numberOfSections {
            numberOfItemsInCollectionView += numberOfItems(inSection: i)
        }
        if index < numberOfItemsInCollectionView {
            var currentSection = 0
            var currentIndex = 0
            while currentIndex + numberOfItems(inSection: currentSection) < index  {
                currentIndex += numberOfItems(inSection: currentSection)
                currentSection += 1
            }
            let indexInSection = (index - currentIndex)
            let indexPath = IndexPath(row: indexInSection, section: currentSection)
            scrollToItem(at: indexPath, at: UICollectionViewScrollPosition.centeredVertically, animated: false)
        }
    }
}
