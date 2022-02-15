//
//  PushAnimate.swift
//  VK
//
//  Created by Екатерина on 03.12.2021.
//

import UIKit

class PushAnimate: NSObject, UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 2
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let source = transitionContext.viewController(forKey: .from),
              let destination = transitionContext.viewController(forKey: .to)
        else { return }
        let containerViewFrame = transitionContext.containerView.frame
        
        let sourceViewFrame = CGRect(
                     x: -containerViewFrame.height,
                     y: 0,
                     width: source.view.frame.height,
                     height: source.view.frame.width
                 )
        
        transitionContext.containerView.addSubview(destination.view)
        let destinationViewFrame = source.view.frame
        destination.view.transform = CGAffineTransform(rotationAngle: -(.pi / 2))
        
        destination.view.frame = CGRect(
                    x: containerViewFrame.width,
                    y: 0,
                    width: source.view.frame.height,
                    height: source.view.frame.width
                )
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext) / 2,
                       animations: {
                            source.view.transform = CGAffineTransform(rotationAngle: .pi/2)
                            source.view.frame = sourceViewFrame
                            destination.view.transform = .identity
                            destination.view.frame = destinationViewFrame
                        }) { isFinishedSuccessfully in
                            if isFinishedSuccessfully {
                                    transitionContext.completeTransition(isFinishedSuccessfully)
                            }
                        }
    }
}
