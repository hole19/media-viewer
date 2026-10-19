import AVFoundation
import UIKit

enum MediaGalleryGeometry {
    static func aspectFitFrame(for imageSize: CGSize, in bounds: CGRect) -> CGRect {
        guard imageSize.width > .zero, imageSize.height > .zero
        else { return bounds }
        return AVMakeRect(aspectRatio: imageSize, insideRect: bounds)
    }
}
