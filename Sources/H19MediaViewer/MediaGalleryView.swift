import SwiftUI
import UIKit

struct MediaGalleryView: View {
    let model: MediaGalleryModel
    let onClose: () -> Void

    @State private var position: String?

    var body: some View {
        pager
        .accessibilityIdentifier(MediaGalleryAccessibilityID.pagesView)
        .overlay(alignment: .bottom) { authorOverlay }
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button(action: onClose) {
                    Image(systemName: "xmark")
                }
                .accessibilityLabel(model.configuration.closeAccessibilityLabel)
                .accessibilityIdentifier(MediaGalleryAccessibilityID.closeButton)
            }
        }
        .toolbarBackground(.hidden, for: .navigationBar)
        .toolbarColorScheme(.dark, for: .navigationBar)
        .toolbar(model.state.isChromeVisible ? .visible : .hidden, for: .navigationBar)
        .statusBarHidden(model.state.isChromeVisible == false)
        .task { model.loadMoreIfNeeded() }
    }

    private var pager: some View {
        ScrollView(.horizontal) {
            LazyHStack(spacing: .zero) {
                ForEach(model.items) { item in
                    MediaGalleryPage(model: model, item: item)
                        .containerRelativeFrame([.horizontal, .vertical])
                        .id(item.id)
                }
            }
            .scrollTargetLayout()
        }
        .scrollTargetBehavior(.paging)
        .scrollPosition(id: $position)
        .scrollIndicators(.hidden)
        .scrollDisabled(model.isZoomed)
        .ignoresSafeArea()
        .onAppear { position = model.currentItem?.id }
        .onChange(of: position) { _, newID in
            guard let newID, let index = model.items.firstIndex(where: { $0.id == newID })
            else { return }
            model.select(index)
        }
        .onGeometryChange(for: CGSize.self, of: \.size) { _ in
            position = model.currentItem?.id
        }
    }

    @ViewBuilder
    private var authorOverlay: some View {
        if model.state.isChromeVisible, let author = model.currentItem?.author {
            MediaGalleryAuthorOverlay(author: author, loadImage: model.loadImage)
                .transition(.opacity)
        }
    }

}

#Preview("Gallery with author") {
    NavigationStack {
        MediaGalleryView(model: MediaGalleryPreviewSupport.model(), onClose: {})
    }
    .background(Color.black)
}

#Preview("Gallery without author") {
    NavigationStack {
        MediaGalleryView(model: MediaGalleryPreviewSupport.model(withAuthor: false), onClose: {})
    }
    .background(Color.black)
}

#Preview("Single photo") {
    NavigationStack {
        MediaGalleryView(model: MediaGalleryPreviewSupport.model(count: 1), onClose: {})
    }
    .background(Color.black)
}

#Preview("Landscape", traits: .landscapeLeft) {
    NavigationStack {
        MediaGalleryView(model: MediaGalleryPreviewSupport.model(initialIndex: 1), onClose: {})
    }
    .background(Color.black)
}

#Preview("Starting on last photo") {
    NavigationStack {
        MediaGalleryView(model: MediaGalleryPreviewSupport.model(count: 5, initialIndex: 4), onClose: {})
    }
    .background(Color.black)
}
