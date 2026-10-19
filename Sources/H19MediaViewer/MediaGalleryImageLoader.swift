import UIKit

public enum MediaGalleryImageLoader {
    @Sendable
    public static func load(_ url: URL) async -> UIImage? {
        guard let (data, _) = try? await URLSession.shared.data(from: url)
        else { return nil }
        return UIImage(data: data)
    }
}
