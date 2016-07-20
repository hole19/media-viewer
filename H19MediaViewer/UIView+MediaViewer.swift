
import UIKit

extension UIView {
    
    public func addSubviewWithFullScreenConstraints(_ subview: UIView, sideMargins: CGFloat = 0.0) {
        subview.translatesAutoresizingMaskIntoConstraints = false
        addSubview(subview)
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "|-margin-[subview]-margin-|", options: NSLayoutFormatOptions.alignAllLeft, metrics: ["margin": sideMargins], views: ["subview" : subview]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[subview]|", options: NSLayoutFormatOptions.alignAllLeft, metrics: nil, views: ["subview" : subview]))
    }
    
    
    public func addLabelSubviewWithFont(_ font: UIFont, color: UIColor, translateAutoresizingMask: Bool = false) -> UILabel {
        let label = UILabel(frame: CGRect(x: 0,y: 0,width: 100,height: 100))
        label.translatesAutoresizingMaskIntoConstraints = translateAutoresizingMask
        label.textColor = color
        label.font = font
        addSubview(label)
        return label
    }

}
