import Foundation

/// A "2/3" position in the gallery; `current` is 1-based.
struct MediaGalleryPageCounter: Equatable {
    let current: Int
    let total: Int

    var text: String {
        "\(current)/\(total)"
    }
}

struct MediaGalleryState: Equatable {
    private enum Constants {
        static let prefetchDistance = 1
    }

    private(set) var selectedIndex: Int
    private(set) var isChromeVisible = true
    private(set) var itemCount: Int

    init(itemCount: Int, initialIndex: Int) {
        self.itemCount = itemCount
        self.selectedIndex = Self.clamped(initialIndex, itemCount: itemCount)
    }

    mutating func select(_ index: Int) {
        selectedIndex = Self.clamped(index, itemCount: itemCount)
    }

    mutating func updateItemCount(_ itemCount: Int) {
        self.itemCount = itemCount
        selectedIndex = Self.clamped(selectedIndex, itemCount: itemCount)
    }

    mutating func toggleChrome() {
        isChromeVisible.toggle()
    }

    mutating func hideChrome() {
        isChromeVisible = false
    }

    /// The counter for the selected item, or `nil` when there's only one item to show.
    var pageCounter: MediaGalleryPageCounter? {
        guard itemCount > 1
        else { return nil }
        return MediaGalleryPageCounter(current: selectedIndex + 1, total: itemCount)
    }

    func shouldLoadMore(hasMoreItems: Bool, isLoading: Bool) -> Bool {
        hasMoreItems && isLoading == false && selectedIndex >= itemCount - 1 - Constants.prefetchDistance
    }

    private static func clamped(_ index: Int, itemCount: Int) -> Int {
        guard itemCount > .zero
        else { return .zero }
        return min(max(index, .zero), itemCount - 1)
    }
}
