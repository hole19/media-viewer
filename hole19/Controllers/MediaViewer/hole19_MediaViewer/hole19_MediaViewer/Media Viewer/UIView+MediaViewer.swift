
import UIKit

extension UIView {
    
    func addSubviewWithFullScreenConstraints(subview: UIView, sideMargins: CGFloat = 0.0) {
        subview.translatesAutoresizingMaskIntoConstraints = false
        addSubview(subview)
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("|-margin-[subview]-margin-|", options: NSLayoutFormatOptions.AlignAllLeft, metrics: ["margin": sideMargins], views: ["subview" : subview]))
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[subview]|", options: NSLayoutFormatOptions.AlignAllLeft, metrics: nil, views: ["subview" : subview]))
    }
    
}