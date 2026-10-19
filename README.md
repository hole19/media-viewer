# H19MediaViewer

[![License: MIT](https://img.shields.io/badge/license-MIT-green.svg?style=flat)](LICENSE)

A full-screen photo gallery for iOS, written in SwiftUI. It supports paging, pinch and double-tap zoom, a hero transition from the tapped image, drag-to-dismiss, a share/save sheet on long press, an optional author overlay, and paginated loading of more photos.

Requires iOS 18 and Swift 6.1. Distributed through Swift Package Manager only.

## Installation

Add the package in Xcode (File → Add Package Dependencies) with the URL `https://github.com/hole19/media-viewer`, or in `Package.swift`:

```swift
.package(url: "https://github.com/hole19/media-viewer", from: "27.0.0")
```

then depend on the `H19MediaViewer` product.

## Usage

```swift
import H19MediaViewer

let items = urls.map { url in
    MediaGalleryItem(
        id: url.absoluteString,
        source: .url(url),
        author: MediaGalleryAuthor(avatarURL: avatarURL, name: "Alex", date: .now)
    )
}

let gallery = MediaGalleryComposer.compose(
    items: items,
    initialIndex: tappedIndex,
    sourceImageView: tappedImageView,
    delegate: self,
    configuration: MediaGalleryConfiguration(closeAccessibilityLabel: String(localized: "Close"))
)
present(gallery, animated: true)
```

`compose` returns a `UINavigationController` configured for full-screen presentation with the custom transition. Present it from any view controller.

### Items

`MediaGalleryItem.source` is either `.url(URL)` (loaded with `MediaGalleryImageLoader`, or a loader you pass as `loadImage:`) or `.image(UIImage)`. `author` is optional; when set, a blurred bar with the name and date shows at the bottom.

### Delegate

Every method of `MediaGalleryDelegate` has a default implementation, so implement only what you need:

| Method | Purpose |
|---|---|
| `mediaGallery(sourceImageViewFor:)` | The image view to animate to when dismissing, so the transition lands on the right thumbnail after the user paged |
| `mediaGallery(didShowItemAt:)` | Called when the visible page changes, e.g. to scroll the screen underneath |
| `mediaGalleryHasMoreItems` | Whether more items can be loaded |
| `mediaGalleryLoadMoreItems()` | Returns the next batch; called when the user nears the last page |

### Layout

The gallery lays out from its container, not the screen, so it follows rotation, split view and window resizes.

### Localization and accessibility

The package ships no strings. Pass the localized close label through `MediaGalleryConfiguration`. Accessibility identifiers are exposed as `MediaGalleryAccessibilityID` for UI tests.

## Development

```
swift package resolve
xcodebuild -scheme H19MediaViewer -destination 'platform=iOS Simulator,name=iPhone 16' test
```

SwiftUI previews live next to the views.

## License

MIT, see [LICENSE](LICENSE).
