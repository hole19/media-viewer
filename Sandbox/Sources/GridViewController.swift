import UIKit
import H19MediaViewer

final class GridViewController: UIViewController {
    private enum Constants {
        static let columns = 3
        static let spacing: CGFloat = 4
        static let initialCount = 12
        static let pageSize = 6
        static let maxCount = 30
        static let loadDelay: Duration = .seconds(1)
    }

    private var items: [MediaGalleryItem] = []
    private var showsAuthor = true
    private var paginates = true
    private var cells: [String: UIImageView] = [:]

    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = Constants.spacing
        layout.minimumLineSpacing = Constants.spacing
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(ThumbnailCell.self, forCellWithReuseIdentifier: ThumbnailCell.reuseIdentifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Media Viewer Sandbox"
        view.backgroundColor = .systemBackground
        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Options", menu: optionsMenu())
        reload()
    }

    override func viewWillTransition(to size: CGSize, with coordinator: any UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        collectionView.collectionViewLayout.invalidateLayout()
    }

    private func optionsMenu() -> UIMenu {
        UIMenu(children: [
            UIAction(title: "Author overlay", state: showsAuthor ? .on : .off) { [weak self] _ in
                guard let self else { return }
                showsAuthor.toggle()
                reload()
            },
            UIAction(title: "Paginated loading", state: paginates ? .on : .off) { [weak self] _ in
                guard let self else { return }
                paginates.toggle()
                reload()
            }
        ])
    }

    private func reload() {
        items = makeItems(range: .zero..<Constants.initialCount)
        cells.removeAll()
        navigationItem.rightBarButtonItem?.menu = optionsMenu()
        collectionView.reloadData()
    }

    private func makeItems(range: Range<Int>) -> [MediaGalleryItem] {
        range.map { index in
            MediaGalleryItem(
                id: String(index),
                source: .image(SandboxImages.image(index: index)),
                author: showsAuthor ? SandboxImages.author(index: index) : nil
            )
        }
    }
}

extension GridViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        items.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: ThumbnailCell.reuseIdentifier,
            for: indexPath
        )
        if let thumbnail = cell as? ThumbnailCell {
            let item = items[indexPath.item]
            thumbnail.configure(with: SandboxImages.image(index: indexPath.item))
            cells[item.id] = thumbnail.imageView
        }
        return cell
    }
}

extension GridViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let totalSpacing = Constants.spacing * CGFloat(Constants.columns - 1)
        let side = ((collectionView.bounds.width - totalSpacing) / CGFloat(Constants.columns)).rounded(.down)
        return CGSize(width: side, height: side)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let sourceImageView = (collectionView.cellForItem(at: indexPath) as? ThumbnailCell)?.imageView
        let gallery = MediaGalleryComposer.compose(
            items: items,
            initialIndex: indexPath.item,
            sourceImageView: sourceImageView,
            delegate: self
        )
        present(gallery, animated: true)
    }
}

extension GridViewController: MediaGalleryDelegate {
    func mediaGallery(sourceImageViewFor item: MediaGalleryItem) -> UIImageView? {
        guard let index = items.firstIndex(where: { $0.id == item.id }) else { return nil }
        let indexPath = IndexPath(item: index, section: .zero)
        if collectionView.cellForItem(at: indexPath) == nil {
            collectionView.scrollToItem(at: indexPath, at: .centeredVertically, animated: false)
            collectionView.layoutIfNeeded()
        }
        return (collectionView.cellForItem(at: indexPath) as? ThumbnailCell)?.imageView
    }

    func mediaGallery(didShowItemAt index: Int) {
        guard index < items.count else { return }
        collectionView.scrollToItem(at: IndexPath(item: index, section: .zero), at: .centeredVertically, animated: false)
    }

    var mediaGalleryHasMoreItems: Bool {
        paginates && items.count < Constants.maxCount
    }

    func mediaGalleryLoadMoreItems() async -> [MediaGalleryItem] {
        try? await Task.sleep(for: Constants.loadDelay)
        let start = items.count
        let end = min(start + Constants.pageSize, Constants.maxCount)
        let newItems = makeItems(range: start..<end)
        items.append(contentsOf: newItems)
        collectionView.reloadData()
        return newItems
    }
}
