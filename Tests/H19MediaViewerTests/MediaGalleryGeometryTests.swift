import CoreGraphics
import Testing

@testable import H19MediaViewer

@Suite
struct MediaGalleryGeometryTests {
    private let bounds = CGRect(x: 0, y: 0, width: 400, height: 800)

    @Test
    func wideImageIsLetterboxedAndCentered() {
        let frame = MediaGalleryGeometry.aspectFitFrame(for: CGSize(width: 200, height: 100), in: bounds)

        #expect(frame == CGRect(x: 0, y: 300, width: 400, height: 200))
    }

    @Test
    func tallImageIsPillarboxedAndCentered() {
        let frame = MediaGalleryGeometry.aspectFitFrame(for: CGSize(width: 100, height: 400), in: bounds)

        #expect(frame == CGRect(x: 100, y: 0, width: 200, height: 800))
    }

    @Test
    func emptyImageSizeFallsBackToBounds() {
        #expect(MediaGalleryGeometry.aspectFitFrame(for: .zero, in: bounds) == bounds)
    }
}
