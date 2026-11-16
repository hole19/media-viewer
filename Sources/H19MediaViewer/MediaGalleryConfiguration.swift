import Foundation

public struct MediaGalleryConfiguration: Sendable {
    public var closeAccessibilityLabel: String
    /// Shows a "2/3" counter in the navigation bar when there's more than one item.
    public var showsPageCounter: Bool
    /// What VoiceOver reads for the counter, given the 1-based current position and the total, e.g. "Photo 2 of 3".
    /// The counter's text is read as is when `nil`.
    public var pageCounterAccessibilityLabel: (@Sendable (_ current: Int, _ total: Int) -> String)?

    public init(
        closeAccessibilityLabel: String = "Close",
        showsPageCounter: Bool = false,
        pageCounterAccessibilityLabel: (@Sendable (_ current: Int, _ total: Int) -> String)? = nil
    ) {
        self.closeAccessibilityLabel = closeAccessibilityLabel
        self.showsPageCounter = showsPageCounter
        self.pageCounterAccessibilityLabel = pageCounterAccessibilityLabel
    }
}
