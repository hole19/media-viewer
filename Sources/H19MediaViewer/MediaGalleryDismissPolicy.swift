import CoreGraphics

enum MediaGalleryDismissPolicy {
    private enum Constants {
        static let distanceFraction: CGFloat = 0.15
        static let flickVelocity: CGFloat = 900
        static let fadeDistanceFraction: CGFloat = 0.6
        static let minimumBackdropAlpha: CGFloat = 0.3
        static let fullBackdropAlpha: CGFloat = 1
    }

    static func shouldDismiss(
        translation: CGFloat,
        velocity: CGFloat,
        height: CGFloat
    ) -> Bool {
        let isFlick = abs(velocity) > Constants.flickVelocity && translation * velocity >= .zero
        return abs(translation) > height * Constants.distanceFraction || isFlick
    }

    static func backdropAlpha(translation: CGFloat, height: CGFloat) -> CGFloat {
        guard height > .zero
        else { return Constants.fullBackdropAlpha }
        let progress = abs(translation) / (height * Constants.fadeDistanceFraction)
        return min(
            Constants.fullBackdropAlpha,
            max(Constants.minimumBackdropAlpha, Constants.fullBackdropAlpha - progress)
        )
    }
}
