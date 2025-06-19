//
//  CustomTransition.swift
//  Demo
//
//  Created by David Walter on 22.06.25.
//

import UIKit

final class CustomTransition: NSObject, UIViewControllerTransitioningDelegate {
    private let presentAnimator = PresentAnimator()
    private let dismissAnimator = DismissAnimator()

    override init() {
        super.init()
        print("CustomTransition.init")
    }

    deinit {
        print("CustomTransition.deinit")
    }

    func animationController(
        forPresented presented: UIViewController,
        presenting: UIViewController,
        source: UIViewController
    ) -> UIViewControllerAnimatedTransitioning? {
        presentAnimator
    }

    func animationController(
        forDismissed dismissed: UIViewController
    ) -> UIViewControllerAnimatedTransitioning? {
        dismissAnimator
    }

    final class PresentAnimator: NSObject, UIViewControllerAnimatedTransitioning {
        private let duration: TimeInterval = 0.45

        func transitionDuration(using ctx: UIViewControllerContextTransitioning?) -> TimeInterval {
            duration
        }

        func animateTransition(using ctx: UIViewControllerContextTransitioning) {
            guard let toVC = ctx.viewController(forKey: .to) else { return }
            let container = ctx.containerView

            let finalFrame = ctx.finalFrame(for: toVC)

            toVC.view.frame = finalFrame.offsetBy(dx: 0, dy: -container.bounds.height)
            container.addSubview(toVC.view)

            UIView.animate(withDuration: duration, delay: 0, options: [.curveEaseInOut]) {
                toVC.view.frame = finalFrame
            } completion: { finished in
                ctx.completeTransition(finished)
            }
        }
    }

    final class DismissAnimator: NSObject, UIViewControllerAnimatedTransitioning {
        private let duration: TimeInterval = 0.45

        func transitionDuration(using ctx: UIViewControllerContextTransitioning?) -> TimeInterval {
            duration
        }

        func animateTransition(using ctx: UIViewControllerContextTransitioning) {
            guard let fromVC = ctx.viewController(forKey: .from) else { return }
            let container = ctx.containerView

            let initialFrame = ctx.initialFrame(for: fromVC)

            UIView.animate(withDuration: duration, delay: 0, options: [.curveEaseInOut]) {
                fromVC.view.frame = initialFrame.offsetBy(dx: 0, dy: -container.bounds.height)
            } completion: { finished in
                ctx.completeTransition(finished)
            }
        }
    }
}
