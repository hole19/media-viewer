import CoreGraphics

enum MediaGalleryDismissPolicy {
    private static let distanceFraction: CGFloat = 0.15
    private static let flickVelocity: CGFloat = 900
    private static let fadeDistanceFraction: CGFloat = 0.6
    private static let minimumBackdropAlpha: CGFloat = 0.3

    static func shouldDismiss(translation: CGFloat, velocity: CGFloat, height: CGFloat) -> Bool {
        let isFlick = abs(velocity) > flickVelocity && translation * velocity >= .zero
        return abs(translation) > height * distanceFraction || isFlick
    }

    static func backdropAlpha(translation: CGFloat, height: CGFloat) -> CGFloat {
        guard height > .zero
        else { return 1 }
        let progress = abs(translation) / (height * fadeDistanceFraction)
        return min(1, max(minimumBackdropAlpha, 1 - progress))
    }
}
