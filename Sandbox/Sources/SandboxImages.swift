import UIKit
import H19MediaViewer

enum SandboxImages {
    private static let sizes = [
        CGSize(width: 1200, height: 800),
        CGSize(width: 800, height: 1200),
        CGSize(width: 1000, height: 1000),
        CGSize(width: 2400, height: 800)
    ]
    private static let names = ["Alex Fairway", "Sam Birdie", "Jo Bogey", "Kim Eagle"]

    static func author(index: Int) -> MediaGalleryAuthor {
        MediaGalleryAuthor(
            avatarURL: nil,
            name: names[index % names.count],
            date: Date(timeIntervalSinceNow: -Double(index) * 86_400)
        )
    }

    @MainActor private static var cache: [Int: UIImage] = [:]

    @MainActor
    static func image(index: Int) -> UIImage {
        if let cached = cache[index] { return cached }
        let size = sizes[index % sizes.count]
        let hue = CGFloat(index % 10) / 10
        let image = UIGraphicsImageRenderer(size: size).image { context in
            let colors = [
                UIColor(hue: hue, saturation: 0.6, brightness: 0.9, alpha: 1).cgColor,
                UIColor(hue: hue + 0.1, saturation: 0.8, brightness: 0.5, alpha: 1).cgColor
            ]
            guard let gradient = CGGradient(colorsSpace: nil, colors: colors as CFArray, locations: nil) else { return }
            context.cgContext.drawLinearGradient(gradient, start: .zero, end: CGPoint(x: size.width, y: size.height), options: [])
            let label = String(index + 1) as NSString
            let attributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: size.height / 3, weight: .bold),
                .foregroundColor: UIColor.white.withAlphaComponent(0.85)
            ]
            let labelSize = label.size(withAttributes: attributes)
            label.draw(
                at: CGPoint(x: (size.width - labelSize.width) / 2, y: (size.height - labelSize.height) / 2),
                withAttributes: attributes
            )
        }
        cache[index] = image
        return image
    }
}
