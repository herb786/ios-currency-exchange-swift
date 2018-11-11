//
//  TinButton.swift
//  XRateTinSwift
//
//  Created by Herbert Caller on 13/12/2017.
//  Copyright © 2017 hacaller. All rights reserved.
//

import UIKit

@IBDesignable
class TinButton: UIButton {
    
    @IBInspectable var startColor:UIColor = UIColor.blue
    @IBInspectable var endColor:UIColor = UIColor.blue
    @IBInspectable var borderColor:UIColor = UIColor.blue
    @IBInspectable var lineWidth:CGFloat = 0.0
    @IBInspectable var cornerRadius:CGFloat = 0.0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //TODO: Code for our button
    }

    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        if (lineWidth > 0){
            self.layer.borderWidth = lineWidth
        }
        
        if (cornerRadius > 0){
            self.layer.cornerRadius = cornerRadius
            self.clipsToBounds = true
        }
        
        //let comps = UnsafeMutablePointer<CGFloat>.allocate(capacity: 8)
        //startColor.getRed(comps.advanced(by: 0), green: comps.advanced(by: 1), blue: comps.advanced(by: 2), alpha: comps.advanced(by: 3))
        //endColor.getRed(comps.advanced(by: 4), green: comps.advanced(by: 5), blue: comps.advanced(by: 6), alpha: comps.advanced(by: 7))
        
        var r1: CGFloat = 0, g1: CGFloat = 0, b1: CGFloat = 0, a1: CGFloat = 0
        var r2: CGFloat = 0, g2: CGFloat = 0, b2: CGFloat = 0, a2: CGFloat = 0
        endColor.getRed(&r1, green: &g1, blue: &b1, alpha: &a1)
        startColor.getRed(&r2, green: &g2, blue: &b2, alpha: &a2)
        let colors: [CGFloat] = [r1, g1, b1, a1, r2, g2, b2, a2]
        //colors.append(contentsOf: [r1, g1, b1, a1, r2, g2, b2, a2])
        let location: [CGFloat] = [CGFloat.init(0.0), CGFloat.init(1.0)]
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let gradient = CGGradient.init(colorSpace: colorSpace, colorComponents: colors, locations: location, count: 2)
        self.layer.borderColor = borderColor.cgColor
        let ctx = UIGraphicsGetCurrentContext()!
        let rect : CGRect = self.bounds
        let center = CGPoint.init(x: rect.midX, y: rect.midY)
        let radius: CGFloat = min(rect.maxX, rect.maxY)
        ctx.drawRadialGradient(gradient!, startCenter: center, startRadius: 0, endCenter: center, endRadius: radius, options: CGGradientDrawingOptions.drawsAfterEndLocation)
        let glayer = CAGradientLayer()
        glayer.frame = rect
        self.layer.insertSublayer(glayer, at: 0)
        
    }
 

}
