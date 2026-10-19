import Testing
import UIKit

@testable import H19MediaViewer

@MainActor
@Suite
struct MediaGalleryModelTests {
    private func makeItems(_ ids: [String]) -> [MediaGalleryItem] {
        ids.map { MediaGalleryItem(id: $0, source: .image(UIImage())) }
    }

    private func makeModel(
        ids: [String],
        initialIndex: Int = .zero,
        delegate: (any MediaGalleryDelegate)? = nil
    ) -> MediaGalleryModel {
        MediaGalleryModel(
            items: makeItems(ids),
            initialIndex: initialIndex,
            delegate: delegate,
            loadImage: { _ in nil }
        )
    }

    @Test
    func currentItemFollowsSelection() {
        let model = makeModel(ids: ["a", "b", "c"], initialIndex: 1)
        #expect(model.currentItem?.id == "b")

        model.select(2)
        #expect(model.currentItem?.id == "c")
    }

    @Test
    func initialItemIDIsCapturedOnce() {
        let model = makeModel(ids: ["a", "b"], initialIndex: 1)
        model.select(.zero)

        #expect(model.initialItemID == "b")
    }

    @Test
    func selectNotifiesDelegateOnlyOnChange() {
        let delegate = SpyDelegate()
        let model = makeModel(ids: ["a", "b", "c"], delegate: delegate)

        model.select(.zero)
        model.select(2)

        #expect(delegate.shownIndexes == [2])
    }

    @Test
    func loadedURLImageIsRememberedForTheItem() {
        let item = MediaGalleryItem(id: "remote", source: .url(URL(string: "https://example.com/a.jpg")!))
        let model = MediaGalleryModel(items: [item], initialIndex: .zero, delegate: nil, loadImage: { _ in nil })
        #expect(model.image(for: item) == nil)

        let image = UIImage()
        model.didLoad(image, for: item)

        #expect(model.image(for: item) === image)
    }

    @Test
    func loadMoreAppendsOnlyUnknownItems() async {
        let delegate = SpyDelegate()
        delegate.hasMore = true
        delegate.moreItems = makeItems(["b", "c"])
        let model = makeModel(ids: ["a", "b"], initialIndex: 1, delegate: delegate)

        model.loadMoreIfNeeded()
        await delegate.waitUntilLoaded()
        await Task.yield()

        #expect(model.items.map(\.id) == ["a", "b", "c"])
        #expect(model.state.itemCount == 3)
    }
}

@MainActor
private final class SpyDelegate: MediaGalleryDelegate {
    var shownIndexes: [Int] = []
    var hasMore = false
    var moreItems: [MediaGalleryItem] = []
    private var loaded = false

    var mediaGalleryHasMoreItems: Bool { hasMore }

    func mediaGallery(didShowItemAt index: Int) {
        shownIndexes.append(index)
    }

    func mediaGalleryLoadMoreItems() async -> [MediaGalleryItem] {
        loaded = true
        hasMore = false
        return moreItems
    }

    func waitUntilLoaded() async {
        while loaded == false {
            await Task.yield()
        }
    }
}
