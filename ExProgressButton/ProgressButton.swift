//
//  ProgressButton.swift
//  ExProgressButton
//
//  Created by 김종권 on 2022/12/25.
//

import UIKit

final class ProgressButton: UIButton {
    static let durationSeconds = 3.0
    private let radius: CGFloat
    private let color: UIColor
    var completion: (() -> Void)?
    
    private lazy var circlePath: UIBezierPath = {
        let arcCenter = CGPoint(x: radius, y: radius)
        let circlePath = UIBezierPath(
            arcCenter: arcCenter,
            radius: radius,
            startAngle: 3 * .pi / 2,
            endAngle: -.pi / 2,
            clockwise: false
        )
        circlePath.lineWidth = 1
        return circlePath
    }()
    
    init(
        color: UIColor = .systemRed,
        radius: CGFloat = 16.0,
        completion: (() -> Void)? = nil
    ) {
        self.radius = radius
        self.color = color
        self.completion = completion
        
        super.init(frame: CGRect(x: 0, y: 0, width: radius * 2, height: radius * 2))
        
        backgroundColor = .clear
        tintColor = color
        
        imageView?.contentMode = .scaleAspectFit
        let image = UIImage(systemName: "xmark")?.withRenderingMode(.alwaysTemplate)
        setImage(image, for: .normal)
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func animate(startRatio: CGFloat) {
        cancel()
        
        // 1. 원 둘레 path 구하기
        let shapeLayer = CAShapeLayer()
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = UIColor.clear.cgColor
        shapeLayer.lineWidth = 1.0
        
        let circlePath = UIBezierPath(
            arcCenter: CGPoint(x: radius, y: radius),
            radius: radius,
            startAngle: 3 * .pi / 2,
            endAngle: -.pi / 2,
            clockwise: false
        )
        circlePath.lineWidth = 1
        shapeLayer.path = circlePath.cgPath
        
        // 2. 애니메이션 실행
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.fromValue = startRatio
        animation.toValue = 1.0
        animation.duration = CFTimeInterval(Self.durationSeconds * (1 - startRatio))
        animation.delegate = self
        
        // 3. 원 둘레 path에다 animation 추가
        shapeLayer.add(animation, forKey: "strokeEnd")
        
        // 4. 현재 layer에 추가하여 적용
        layer.addSublayer(shapeLayer)
    }
    
    func cancel() {
        layer.sublayers?.forEach { layer in
            if layer is CAShapeLayer {
                layer.removeAllAnimations()
                layer.removeFromSuperlayer()
            }
        }
    }
}

extension ProgressButton: CAAnimationDelegate {
    func animationDidStart(_ anim: CAAnimation) {
        let layer = layer.sublayers?.last as? CAShapeLayer
        layer?.strokeColor = color.cgColor
    }
    func animationDidStop(_ anim: CAAnimation, finished: Bool) {
        guard finished else { return }
        completion?()
    }
}
