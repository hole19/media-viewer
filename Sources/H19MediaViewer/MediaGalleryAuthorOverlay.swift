import SwiftUI

struct MediaGalleryAuthorOverlay: View {
    let author: MediaGalleryAuthor

    var body: some View {
        HStack(spacing: Constants.contentSpacing) {
            avatarView
            VStack(alignment: .leading, spacing: Constants.textSpacing) {
                Text(author.name)
                    .font(.footnote.weight(.bold))
                    .foregroundStyle(.white)
                if let date = author.date {
                    Text(date, format: .dateTime.month(.abbreviated).day().year())
                        .font(.caption)
                        .foregroundStyle(.white.opacity(Constants.secondaryTextOpacity))
                }
            }
            Spacer(minLength: .zero)
        }
        .padding(.horizontal, Constants.horizontalPadding)
        .padding(.vertical, Constants.verticalPadding)
        .frame(maxWidth: .infinity)
        .background(.ultraThinMaterial, ignoresSafeAreaEdges: [.bottom, .horizontal])
        .environment(\.colorScheme, .dark)
        .accessibilityElement(children: .combine)
        .accessibilityIdentifier(MediaGalleryAccessibilityID.authorOverlayView)
    }

    private var avatarView: some View {
        AsyncImage(url: author.avatarURL) { phase in
            if let image = phase.image {
                image
                    .resizable()
                    .scaledToFill()
            } else {
                Color.white
            }
        }
        .frame(width: Constants.avatarSize, height: Constants.avatarSize)
        .clipShape(RoundedRectangle(cornerRadius: Constants.avatarCornerRadius))
        .accessibilityHidden(true)
    }

    private enum Constants {
        static let avatarSize: CGFloat = 26
        static let avatarCornerRadius: CGFloat = 4
        static let contentSpacing: CGFloat = 10
        static let textSpacing: CGFloat = 2
        static let horizontalPadding: CGFloat = 15
        static let verticalPadding: CGFloat = 10
        static let secondaryTextOpacity: Double = 0.65
    }
}

#Preview("Author overlay") {
    ZStack(alignment: .bottom) {
        Image(uiImage: MediaGalleryPreviewSupport.image(index: .zero))
            .resizable()
            .scaledToFill()
            .ignoresSafeArea()
        MediaGalleryAuthorOverlay(author: MediaGalleryPreviewSupport.author)
    }
}

#Preview("Author overlay, no date") {
    ZStack(alignment: .bottom) {
        Color.gray.ignoresSafeArea()
        MediaGalleryAuthorOverlay(author: MediaGalleryAuthor(avatarURL: nil, name: "Alex Fairway"))
    }
}
