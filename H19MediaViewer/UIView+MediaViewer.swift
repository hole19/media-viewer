import UIKit

extension UIView {
    public func addSubviewWithFullScreenConstraints(_ subview: UIView, sideMargins: CGFloat = 0.0) {
        subview.translatesAutoresizingMaskIntoConstraints = false
        addSubview(subview)

         NSLayoutConstraint.activate([
             subview.leadingAnchor.constraint(equalTo: leadingAnchor, constant: sideMargins),
             subview.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -sideMargins),
             subview.topAnchor.constraint(equalTo: topAnchor),
             subview.bottomAnchor.constraint(equalTo: bottomAnchor)
         ])
    }

    public func addLabelSubviewWithFont(_ font: UIFont, color: UIColor, translateAutoresizingMask: Bool = false) -> UILabel {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        label.translatesAutoresizingMaskIntoConstraints = translateAutoresizingMask
        label.textColor = color
        label.font = font
        addSubview(label)
        return label
    }
}
