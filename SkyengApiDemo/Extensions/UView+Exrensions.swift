//
//  UView+Exrensions.swift
//  SkyengApiDemo
//
//  Created by Artur Ryzhikh on 18.12.2021.
//

import UIKit

//addes subviews into view and prepare those for autolayout
extension UIView {
    
    func insertSubviewForAutoLayout(_ subview: UIView, aboveSubview: UIView) {
        subview.translatesAutoresizingMaskIntoConstraints = false
        self.insertSubview(subview, aboveSubview: aboveSubview)
    }
    func addSubviewsForAutolayout(_ subviews: [UIView]) {
        subviews.forEach() { view in
            self.addSubviewForAutolayout(view)
        }
    }
    
    private func addSubviewForAutolayout(_ view: UIView) {
        view.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(view)
        
    }
    
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds,
                                byRoundingCorners: corners,
                                cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
        
    }
    
    func rotate(_ toValue: CGFloat, duration: CFTimeInterval = 0.2) {
        let animation = CABasicAnimation(keyPath: "transform.rotation")
        animation.toValue = toValue
        animation.duration = duration
        animation.isRemovedOnCompletion = false
        animation.fillMode = CAMediaTimingFillMode.forwards
        self.layer.add(animation, forKey: nil)
    }
    
    
}


