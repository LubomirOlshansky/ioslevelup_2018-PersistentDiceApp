//
//  DiceView.swift
//  Persistent Dice App
//
//  Created by Lubomir Olshansky on 25/04/2018.
//  Copyright © 2018 Lubomir Olshansky. All rights reserved.
//

import UIKit

class DiceView: UIView {
    
    private let dots: [UIView]
    private let lineLayer: CAShapeLayer = CAShapeLayer()
    
    var result: Int = 0 {
        didSet {
            result = max(0, min(6, result))
            setNeedsLayout()
        }
    }
    
    private class func generateDots() -> [UIView] {
        var dots: [UIView] = []
        for _ in 0..<6 {
            dots.append(UIView())
        }
        return dots
    }
    
    override init(frame: CGRect) {
        self.dots = DiceView.generateDots()
        super.init(frame: frame)
        setupLine()
        self.dots.forEach { self.addSubview($0) }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    private func setupLine() {
        lineLayer.strokeColor = UIColor.black.cgColor
        lineLayer.fillColor = nil
        layer.addSublayer(lineLayer)
    }
    
    private func offset(x: CGFloat, y: CGFloat) -> CGPoint {
        let maxOffset: CGFloat = 0.6
        let maxTranslation = min(bounds.height, bounds.width) * 0.5 * maxOffset
        return CGPoint(x: bounds.midX + x * maxTranslation, y: bounds.midY + y * maxTranslation)
    }
    
    private var zeroOffset: CGPoint { return offset(x: 0, y: 0) }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        lineLayer.lineWidth = round(bounds.width * 0.04)
        lineLayer.bounds = .zero
        lineLayer.position = zeroOffset
        lineLayer.path = UIBezierPath(roundedRect: bounds.offsetBy(dx: -bounds.width * 0.5, dy: -bounds.height * 0.5), cornerRadius: 4).cgPath
        let radius = round(min(bounds.width, bounds.height) * 0.07)
        resetDots(radius: radius, result: result)
        layout(dots: dots, result: result)
    }
    
    private func resetDots(radius: CGFloat, result: Int) {
        dots.enumerated().forEach { (index, dot) in
            dot.frame = CGRect(origin: .zero, size: CGSize(width: radius * 2, height: radius * 2))
            dot.center = self.zeroOffset
            dot.backgroundColor = .black
            dot.layer.cornerRadius = radius
            dot.isHidden = index >= result
        }
    }
    
    private func layout(dots: [UIView], result: Int) {
        let bigOffset: CGFloat = 1.0
        let smallOffset: CGFloat = 0.65
        switch result {
        case 0:
            return
        case 1:
            dots[0].center = zeroOffset
        case 2:
            dots[0].center = offset(x: -smallOffset, y: smallOffset)
            dots[1].center = offset(x: smallOffset, y: -smallOffset)
        case 3:
            dots[0].center = zeroOffset
            dots[1].center = offset(x: -bigOffset, y: -bigOffset)
            dots[2].center = offset(x: bigOffset, y: bigOffset)
        case 4:
            dots[0].center = offset(x: -smallOffset, y: smallOffset)
            dots[1].center = offset(x: -smallOffset, y: -smallOffset)
            dots[2].center = offset(x: smallOffset, y: smallOffset)
            dots[3].center = offset(x: smallOffset, y: -smallOffset)
        case 5:
            dots[0].center = zeroOffset
            dots[1].center = offset(x: -bigOffset, y: bigOffset)
            dots[2].center = offset(x: -bigOffset, y: -bigOffset)
            dots[3].center = offset(x: bigOffset, y: bigOffset)
            dots[4].center = offset(x: bigOffset, y: -bigOffset)
        case 6:
            dots[0].center = offset(x: -smallOffset, y: -bigOffset)
            dots[1].center = offset(x: -smallOffset, y: 0)
            dots[2].center = offset(x: -smallOffset, y: bigOffset)
            dots[3].center = offset(x: smallOffset, y: -bigOffset)
            dots[4].center = offset(x: smallOffset, y: 0)
            dots[5].center = offset(x: smallOffset, y: bigOffset)
        default:
            return
        }
    }
}


