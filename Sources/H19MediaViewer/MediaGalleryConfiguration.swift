import Foundation

public struct MediaGalleryConfiguration: Sendable {
    public var closeAccessibilityLabel: String

    public init(closeAccessibilityLabel: String = "Close") {
        self.closeAccessibilityLabel = closeAccessibilityLabel
    }
}
