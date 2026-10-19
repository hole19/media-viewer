import SwiftUI
import UIKit

@MainActor
enum MediaGalleryPreviewSupport {
    static let author = MediaGalleryAuthor(
        avatarURL: nil,
        name: "Alex Fairway",
        date: Date(timeIntervalSince1970: 1_760_000_000)
    )

    static func items(count: Int = 4, withAuthor: Bool = true) -> [MediaGalleryItem] {
        (.zero..<count).map { index in
            MediaGalleryItem(
                id: String(index),
                source: .image(image(index: index)),
                author: withAuthor ? author : nil
            )
        }
    }

    static func model(
        count: Int = 4,
        initialIndex: Int = .zero,
        withAuthor: Bool = true
    ) -> MediaGalleryModel {
        MediaGalleryModel(
            items: items(count: count, withAuthor: withAuthor),
            initialIndex: initialIndex,
            delegate: nil,
            loadImage: { _ in nil }
        )
    }

    static func image(index: Int) -> UIImage {
        let sizes = [CGSize(width: 1200, height: 800), CGSize(width: 800, height: 1200), CGSize(width: 1000, height: 1000)]
        let size = sizes[index % sizes.count]
        let hue = CGFloat(index % 6) / 6
        return UIGraphicsImageRenderer(size: size).image { context in
            let colors = [
                UIColor(hue: hue, saturation: 0.6, brightness: 0.9, alpha: 1).cgColor,
                UIColor(hue: hue + 0.1, saturation: 0.8, brightness: 0.5, alpha: 1).cgColor
            ]
            guard let gradient = CGGradient(colorsSpace: nil, colors: colors as CFArray, locations: nil)
            else { return }
            context.cgContext.drawLinearGradient(
                gradient,
                start: .zero,
                end: CGPoint(x: size.width, y: size.height),
                options: []
            )
            let label = String(index + 1) as NSString
            label.draw(
                at: CGPoint(x: size.width / 2 - 60, y: size.height / 2 - 100),
                withAttributes: [
                    .font: UIFont.systemFont(ofSize: 200, weight: .bold),
                    .foregroundColor: UIColor.white.withAlphaComponent(0.8)
                ]
            )
        }
    }
}
