import CoreGraphics
import Testing

@testable import H19MediaViewer

@Suite
struct MediaGalleryDismissPolicyTests {
    private let height: CGFloat = 800

    @Test
    func dismissesPastDistanceThreshold() {
        #expect(MediaGalleryDismissPolicy.shouldDismiss(translation: 130, velocity: .zero, height: height))
        #expect(MediaGalleryDismissPolicy.shouldDismiss(translation: -130, velocity: .zero, height: height))
    }

    @Test
    func staysBelowDistanceThreshold() {
        #expect(MediaGalleryDismissPolicy.shouldDismiss(translation: 50, velocity: 100, height: height) == false)
    }

    @Test
    func dismissesOnFlickInDragDirection() {
        #expect(MediaGalleryDismissPolicy.shouldDismiss(translation: 40, velocity: 1_500, height: height))
    }

    @Test
    func ignoresFlickAgainstDragDirection() {
        #expect(MediaGalleryDismissPolicy.shouldDismiss(translation: 40, velocity: -1_500, height: height) == false)
    }

    @Test
    func backdropFadesButNeverBelowMinimum() {
        #expect(MediaGalleryDismissPolicy.backdropAlpha(translation: .zero, height: height) == 1)
        #expect(MediaGalleryDismissPolicy.backdropAlpha(translation: 10_000, height: height) == 0.3)
    }

    @Test
    func backdropAlphaHandlesZeroHeight() {
        #expect(MediaGalleryDismissPolicy.backdropAlpha(translation: 50, height: .zero) == 1)
    }
}
