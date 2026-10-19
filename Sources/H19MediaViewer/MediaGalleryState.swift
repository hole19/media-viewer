import Foundation

struct MediaGalleryState: Equatable {
    private static let prefetchDistance = 1

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

    func shouldLoadMore(hasMoreItems: Bool, isLoading: Bool) -> Bool {
        hasMoreItems && isLoading == false && selectedIndex >= itemCount - 1 - Self.prefetchDistance
    }

    private static func clamped(_ index: Int, itemCount: Int) -> Int {
        guard itemCount > .zero
        else { return .zero }
        return min(max(index, .zero), itemCount - 1)
    }
}
