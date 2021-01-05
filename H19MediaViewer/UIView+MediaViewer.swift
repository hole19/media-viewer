import UIKit

extension UIView {
    public func setFullScreenConstraints(relativeTo superview: UIView? = nil, sideMargins: CGFloat = 0.0) {
        guard let superview = superview ?? self.superview else {
            preconditionFailure("Cannot set full screen constraints. There's no superview!")
        }

        translatesAutoresizingMaskIntoConstraints = false

         NSLayoutConstraint.activate([
            leadingAnchor.constraint(equalTo: superview.leadingAnchor, constant: sideMargins),
            trailingAnchor.constraint(equalTo: superview.trailingAnchor, constant: -sideMargins),
            topAnchor.constraint(equalTo: superview.topAnchor),
            bottomAnchor.constraint(equalTo: superview.bottomAnchor)
         ])
    }
}
