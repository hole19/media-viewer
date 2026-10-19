import Observation
import UIKit

@MainActor
@Observable
final class MediaGalleryModel {
    private(set) var items: [MediaGalleryItem]
    private(set) var state: MediaGalleryState
    var isZoomed = false

    @ObservationIgnored let initialItemID: String?
    @ObservationIgnored let initialPlaceholder: UIImage?
    @ObservationIgnored let configuration: MediaGalleryConfiguration
    @ObservationIgnored let loadImage: @Sendable (URL) async -> UIImage?
    @ObservationIgnored weak var delegate: (any MediaGalleryDelegate)?
    @ObservationIgnored var onShare: ((UIImage) -> Void)?
    @ObservationIgnored private let loadedImages = NSCache<NSString, UIImage>()
    @ObservationIgnored private var isLoadingMore = false

    init(
        items: [MediaGalleryItem],
        initialIndex: Int,
        delegate: (any MediaGalleryDelegate)?,
        initialPlaceholder: UIImage? = nil,
        configuration: MediaGalleryConfiguration = MediaGalleryConfiguration(),
        loadImage: @escaping @Sendable (URL) async -> UIImage?
    ) {
        self.items = items
        self.state = MediaGalleryState(itemCount: items.count, initialIndex: initialIndex)
        self.initialItemID = items.indices.contains(initialIndex) ? items[initialIndex].id : items.first?.id
        self.delegate = delegate
        self.initialPlaceholder = initialPlaceholder
        self.configuration = configuration
        self.loadImage = loadImage
    }

    var currentItem: MediaGalleryItem? {
        items.indices.contains(state.selectedIndex) ? items[state.selectedIndex] : nil
    }

    var currentImage: UIImage? {
        currentItem.flatMap { image(for: $0) }
    }

    func image(for item: MediaGalleryItem) -> UIImage? {
        if case .image(let image) = item.source {
            return image
        }
        return loadedImages.object(forKey: item.id as NSString)
    }

    func placeholder(for item: MediaGalleryItem) -> UIImage? {
        item.id == initialItemID ? initialPlaceholder : nil
    }

    func didLoad(_ image: UIImage, for item: MediaGalleryItem) {
        loadedImages.setObject(image, forKey: item.id as NSString)
    }

    func select(_ index: Int) {
        guard index != state.selectedIndex
        else { return }
        state.select(index)
        delegate?.mediaGallery(didShowItemAt: state.selectedIndex)
        loadMoreIfNeeded()
    }

    func toggleChrome() {
        state.toggleChrome()
    }

    func hideChrome() {
        state.hideChrome()
    }

    func loadMoreIfNeeded() {
        guard let delegate,
            state.shouldLoadMore(hasMoreItems: delegate.mediaGalleryHasMoreItems, isLoading: isLoadingMore)
        else { return }

        isLoadingMore = true
        Task { [weak self, weak delegate] in
            let newItems = await delegate?.mediaGalleryLoadMoreItems() ?? []
            self?.append(newItems)
        }
    }

    private func append(_ newItems: [MediaGalleryItem]) {
        isLoadingMore = false
        let knownIDs = Set(items.map(\.id))
        let uniqueItems = newItems.filter { knownIDs.contains($0.id) == false }
        guard uniqueItems.isEmpty == false
        else { return }
        items.append(contentsOf: uniqueItems)
        state.updateItemCount(items.count)
    }
}
