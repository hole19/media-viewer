# H19MediaViewer — Development Guide

A SwiftUI, SPM-only full-screen photo gallery for iOS, consumed by the Hole19 iOS app (`hole19/h19-iphone-v2`, see its `agent-docs/media_viewer.md`). The public entry point is `MediaGalleryComposer`; everything else is internal.

## Constraints

- iOS 18, Swift 6.1. SPM only: do not add a Podfile, podspec, fastlane or Gemfile, and do not commit an Xcode project. The one exception is the generated, git-ignored `Sandbox/Sandbox.xcodeproj` (see Sandbox app).
- No dependencies at all. This repo cannot import the app's packages (`DesignSystem`, `H19Localization`, `AccessibilityIdentifiers`), so use SwiftUI and SF Symbols directly and keep spacing and sizes in a private `Constants` enum.
- The package ships no strings. Anything user-facing or localized is injected through `MediaGalleryConfiguration`.
- Accessibility identifiers live in `MediaGalleryAccessibilityID`; the app and its UI tests read them from there.

## Build and test

`swift build` and `swift test` do not work: the package is UIKit-only and macOS is not a target. Use a simulator:

```bash
xcodebuild -scheme H19MediaViewer -destination id=<UDID> test
```

Pick a booted simulator with `xcrun simctl list devices available`. Tests use Swift Testing (`import Testing`, `@Suite`, `@Test`, `#expect`); do not add XCTest. Keep logic in small testable types (`MediaGalleryState`, `MediaGalleryDismissPolicy`, `MediaGalleryGeometry`, `MediaGalleryModel`) and keep views thin.

## Sandbox app

`Sandbox/` is a manual test app, not part of the package: SPM never builds it. Only `Sandbox/project.yml` and `Sandbox/Sources` are committed; generate the project with `cd Sandbox && xcodegen generate` and build the `Sandbox` scheme on a simulator. When you change public API or gallery behavior, keep the sandbox compiling and exercising it.

## Code style

Match the Hole19 app so code reads the same on both sides:

- Use `.zero` for any type that has it, never a raw `0`. Write `== false` instead of the `!` prefix.
- Descriptive names, no single-letter variables. Split a call or definition with 3 or more parameters onto one line each.
- Comments only for a hidden constraint or a non-obvious trade-off, 2 to 3 lines at most.
- Put numeric values in a private `Constants` enum instead of scattering literals.
- Add a `#Preview` next to every new view. Preview data comes from `MediaGalleryPreviewSupport` and must not hit the network.

## Layout and memory

- Lay out from the container, never from `UIScreen` or the device orientation, so rotation, split view and window resizes work.
- Closures stored on long-lived objects capture `self` weakly, and delegates are held weakly. Cache loaded images in `NSCache`, not a dictionary.

## Public API and releases

- Anything `public` is a contract with the app. A breaking change needs a new major version; update the README example in the same PR.
- Release flow: open a PR, merge it, tag the release, then the app bumps its pin (`exactVersion` in `project.pbxproj` and both `Package.resolved` files). Until a tag exists the app may pin a branch, so do not force-push or delete a branch the app points at.
- Changes to the paging, zoom, transition or pagination behavior affect both the feed and the course profile screens in the app; say so in the PR description.
