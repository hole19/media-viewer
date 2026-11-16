import Testing

@testable import H19MediaViewer

@Suite
struct MediaGalleryStateTests {
    @Test
    func initialIndexIsClampedIntoRange() {
        #expect(MediaGalleryState(itemCount: 3, initialIndex: 10).selectedIndex == 2)
        #expect(MediaGalleryState(itemCount: 3, initialIndex: -4).selectedIndex == .zero)
    }

    @Test
    func pageCounterIsHiddenForASingleItem() {
        #expect(MediaGalleryState(itemCount: 1, initialIndex: .zero).pageCounter == nil)
        #expect(MediaGalleryState(itemCount: .zero, initialIndex: .zero).pageCounter == nil)
    }

    @Test
    func pageCounterFollowsSelectionAndItemCount() {
        var state = MediaGalleryState(itemCount: 3, initialIndex: 1)
        #expect(state.pageCounter == MediaGalleryPageCounter(current: 2, total: 3))
        #expect(state.pageCounter?.text == "2/3")

        state.updateItemCount(5)
        state.select(4)
        #expect(state.pageCounter == MediaGalleryPageCounter(current: 5, total: 5))
    }

    @Test
    func emptyGalleryAlwaysSelectsZero() {
        var state = MediaGalleryState(itemCount: .zero, initialIndex: 5)
        state.select(2)

        #expect(state.selectedIndex == .zero)
    }

    @Test
    func selectClampsToRange() {
        var state = MediaGalleryState(itemCount: 4, initialIndex: .zero)
        state.select(3)
        #expect(state.selectedIndex == 3)

        state.select(9)
        #expect(state.selectedIndex == 3)
    }

    @Test
    func chromeStartsVisibleAndToggles() {
        var state = MediaGalleryState(itemCount: 2, initialIndex: .zero)
        #expect(state.isChromeVisible)

        state.toggleChrome()
        #expect(state.isChromeVisible == false)

        state.toggleChrome()
        #expect(state.isChromeVisible)
    }

    @Test
    func hideChromeIsIdempotent() {
        var state = MediaGalleryState(itemCount: 2, initialIndex: .zero)
        state.hideChrome()
        state.hideChrome()

        #expect(state.isChromeVisible == false)
    }

    @Test
    func loadsMoreWhenNearTheEnd() {
        var state = MediaGalleryState(itemCount: 5, initialIndex: .zero)
        #expect(state.shouldLoadMore(hasMoreItems: true, isLoading: false) == false)

        state.select(3)
        #expect(state.shouldLoadMore(hasMoreItems: true, isLoading: false))
    }

    @Test
    func doesNotLoadMoreWithoutMoreItemsOrWhileLoading() {
        var state = MediaGalleryState(itemCount: 5, initialIndex: 4)
        #expect(state.shouldLoadMore(hasMoreItems: false, isLoading: false) == false)
        #expect(state.shouldLoadMore(hasMoreItems: true, isLoading: true) == false)
    }

    @Test
    func updatingItemCountKeepsSelectionInRange() {
        var state = MediaGalleryState(itemCount: 5, initialIndex: 4)
        state.updateItemCount(3)

        #expect(state.selectedIndex == 2)
    }
}
