//
//  MandelbrotView.swift
//  RestExperiment
//
//  Created by Richard Simko on 2017-02-14.
//  Copyright © 2017 Richard Simko. All rights reserved.
//

import Foundation
import UIKit

class MandelbrotView: UIView {
    
    let MAX_ITERATIONS = 100
    
    func transformCoordinates(x:Int, y:Int, height: CGFloat, width: CGFloat) -> ImNumber {
        let midX = width / 4.0;
        let midY = height / 4.0;
        return ImNumber(x: Double(x) / Double(midX) - 2, y: 2 - Double(y) / Double(midY));
    }
    
    override func draw(_ rect: CGRect) {
        let context:CGContext = UIGraphicsGetCurrentContext()!;
        for i in 0...Int(rect.height) {
            for j in 0...Int(rect.width) {
                let iterations = transformCoordinates(x: j, y: i, height: rect.height, width: rect.width).checkMandelbrot();
                if(iterations == MAX_ITERATIONS) {
                    context.setFillColor(red: 0, green: 0, blue: 0, alpha: 1.0);
                    let rectangle:CGRect = CGRect(x: j, y: i, width: 1, height: 1);
                    context.fill(rectangle);
                }
                else {
                    let factor = sqrt(Double(iterations) / Double(MAX_ITERATIONS));
                    context.setFillColor(red: 0, green: 1-CGFloat(factor), blue: CGFloat(factor), alpha: 1.0);
                    let rectangle:CGRect = CGRect(x: j, y: i, width: 1, height: 1);
                    context.fill(rectangle);
                }
            }
        }
        return super.draw(rect);
    }
}
