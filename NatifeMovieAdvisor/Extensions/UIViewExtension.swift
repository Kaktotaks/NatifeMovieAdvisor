//
//  CALayerManager.swift
//  NatifeMovieAdvisor
//
//  Created by Леонід Шевченко on 16.03.2023.
//

import UIKit

extension UIView {
    func makeShadow() -> UIView {
        let layer: CALayer = self.layer
        layer.shadowColor = UIColor.label.cgColor
        layer.shadowOffset = CGSize(width: 5.0, height: 5.0)
        layer.shadowOpacity = 0.5
        layer.shadowRadius = 10.0
        return self
    }
}
