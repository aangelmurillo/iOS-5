import UIKit

class CustomTransitioningDelegate: NSObject, UIViewControllerTransitioningDelegate {
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return SlideOutToRightAnimator()
    }
}
