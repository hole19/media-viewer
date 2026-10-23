import UIKit

public struct MediaGalleryAuthor: Sendable, Equatable {
    public let avatarURL: URL?
    public let name: String
    public let date: Date?

    public init(
        avatarURL: URL?,
        name: String,
        date: Date? = nil
    ) {
        self.avatarURL = avatarURL
        self.name = name
        self.date = date
    }
}

public struct MediaGalleryItem: Identifiable, Sendable {
    public enum Source: Sendable {
        case url(URL)
        case image(UIImage)
    }

    public let id: String
    public let source: Source
    public let author: MediaGalleryAuthor?

    public init(
        id: String,
        source: Source,
        author: MediaGalleryAuthor? = nil
    ) {
        self.id = id
        self.source = source
        self.author = author
    }
}
