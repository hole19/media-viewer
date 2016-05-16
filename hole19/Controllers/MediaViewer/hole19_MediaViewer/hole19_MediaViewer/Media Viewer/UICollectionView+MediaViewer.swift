
import UIKit

extension UICollectionView {
    func scrollToItemWithIndex(index: Int) {
        var numberOfItemsInCollectionView = 0
        for var i = 0; i < numberOfSections(); i++ {
            numberOfItemsInCollectionView += numberOfItemsInSection(i)
        }
        if index < numberOfItemsInCollectionView {
            var currentSection = 0
            var currentIndex = 0
            while currentIndex + numberOfItemsInSection(currentSection) < index  {
                currentIndex += numberOfItemsInSection(currentSection)
                currentSection += 1
            }
            let indexInSection = (index - currentIndex)
            let indexPath = NSIndexPath(forRow: indexInSection, inSection: currentSection)
            scrollToItemAtIndexPath(indexPath, atScrollPosition: UICollectionViewScrollPosition.CenteredVertically, animated: false)
        }
    }
}