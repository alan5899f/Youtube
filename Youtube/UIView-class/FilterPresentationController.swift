//
//  FilterPresentationController.swift
//  FilterPresentationController
//
//  Created by 陳韋綸 on 2022/5/17.
//

import Foundation
import UIKit

class FilterPresentationController: UIPresentationController {
    
    private let label: UILabel = {
        let label = UILabel()
        label.backgroundColor = .systemGray3
        label.layer.cornerRadius = 2
        label.layer.masksToBounds = true
        return label
    }()
    
    let blurEffectView: UIVisualEffectView!
    var tapGestureRecognizer: UITapGestureRecognizer = UITapGestureRecognizer()
    var frameOriginY: CGFloat = 0.0
    var frameHeight: CGFloat = 0.0
    
    override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
        let blurEffect = UIBlurEffect(style: .dark)
        blurEffectView = UIVisualEffectView(effect: blurEffect)
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
        tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissController))
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.blurEffectView.isUserInteractionEnabled = true
        self.blurEffectView.addGestureRecognizer(tapGestureRecognizer)
        swipe()
    }
    
    override var frameOfPresentedViewInContainerView: CGRect {
        CGRect(origin: CGPoint(x: 0, y: frameOriginY), size: CGSize(width: self.containerView!.frame.width, height: frameHeight))
    }
               
    override func presentationTransitionWillBegin() {
        self.blurEffectView.alpha = 0
        self.containerView?.addSubview(blurEffectView)
        self.presentedView?.addSubview(label)
        self.presentedViewController.transitionCoordinator?.animate(alongsideTransition: { _ in
            self.blurEffectView.alpha = 0.7
        }, completion: nil)
        setupLayout()
    }
    
    private func setupLayout() {
        label.frame.origin = CGPoint(x: presentedView!.center.x - 40, y: 10)
        label.frame.size = CGSize(width: 80, height: 4)
        presentedView?.frame = frameOfPresentedViewInContainerView
        blurEffectView.frame = containerView!.bounds
    }
    
    override func dismissalTransitionWillBegin() {
        self.presentedViewController.transitionCoordinator?.animate(alongsideTransition: { _ in
            self.blurEffectView.alpha = 0
        }, completion: { _ in
            self.blurEffectView.removeFromSuperview()
        })
    }
    
    override func containerViewWillLayoutSubviews() {
        super.containerViewWillLayoutSubviews()
        presentedView!.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        presentedView!.layer.cornerRadius = 22
    }
    
    @objc private func dismissController() {
        self.presentedViewController.dismiss(animated: true, completion: nil)
    }
}

extension FilterPresentationController {
    
    private func swipe() {
        let pan = UIPanGestureRecognizer(target: self, action: #selector(didTapPan))
        presentedView!.addGestureRecognizer(pan)
    }
    
    @objc private func didTapPan(gresture: UIPanGestureRecognizer) {
        let translation = gresture.translation(in: presentedView)
        if gresture.state == .changed {
            self.handleChanged(translation: translation)
        }
        else if gresture.state == .ended {
            self.handleEnded(translation: translation)
        }
    }
    
    private func handleChanged(translation: CGPoint) {
        let rotateTranslation = CGAffineTransform(translationX: 0, y: translation.y)
        presentedView!.transform = rotateTranslation
    }
    
    private func handleEnded(translation: CGPoint) {
        if translation.y < 0 {
            self.frameOriginY = 10
        }
        else if translation.y > 0 {
            self.frameOriginY = 300
        }
    }
}
