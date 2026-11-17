import Testing
import UIKit

@testable import H19MediaViewer

@Suite
@MainActor
struct MediaGallerySourceTests {
    private final class ImageViewDelegate: MediaGalleryDelegate {
        let imageView: UIImageView?

        init(imageView: UIImageView?) {
            self.imageView = imageView
        }

        func mediaGallery(sourceImageViewFor item: MediaGalleryItem) -> UIImageView? {
            imageView
        }
    }

    private let item = MediaGalleryItem(id: "photo", source: .image(UIImage()))

    @Test
    func frameSourceConvertsWindowCoordinatesIntoTheContainer() {
        let window = UIWindow(frame: CGRect(x: 0, y: 0, width: 400, height: 800))
        let container = UIView(frame: CGRect(x: 0, y: 100, width: 400, height: 700))
        window.addSubview(container)

        let source = MediaGallerySource.frame(CGRect(x: 10, y: 150, width: 50, height: 50), image: nil, cornerRadius: 3)

        #expect(source.frame(container) == CGRect(x: 10, y: 50, width: 50, height: 50))
        #expect(source.cornerRadius() == 3)
        #expect(source.image() == nil)
    }

    @Test
    func imageViewSourceHasNoFrameOutsideAWindow() {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        UIView().addSubview(imageView)

        #expect(MediaGallerySource.imageView(imageView).frame(UIView()) == nil)
    }

    @Test
    func imageViewSourceReadsAndHidesTheImageView() {
        let image = UIImage()
        let window = UIWindow(frame: CGRect(x: 0, y: 0, width: 400, height: 800))
        let imageView = UIImageView(image: image)
        imageView.frame = CGRect(x: 20, y: 30, width: 50, height: 50)
        imageView.layer.cornerRadius = 4
        window.addSubview(imageView)
        let source = MediaGallerySource.imageView(imageView)

        source.setHidden(true)

        #expect(imageView.isHidden)
        #expect(source.image() === image)
        #expect(source.cornerRadius() == 4)
        #expect(source.frame(window) == CGRect(x: 20, y: 30, width: 50, height: 50))
    }

    @Test
    func delegateSourceFallsBackToTheSourceImageView() {
        let imageView = UIImageView(image: UIImage())

        #expect(ImageViewDelegate(imageView: imageView).mediaGallery(sourceFor: item)?.image() === imageView.image)
        #expect(ImageViewDelegate(imageView: nil).mediaGallery(sourceFor: item) == nil)
    }
}
