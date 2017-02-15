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
    
    var currentCenterX = 0.0;
    var currentCenterY = 0.0;
    var currentWidth = 4.0;
    var currentHeight = 4.0
    
    func transformCoordinates(x:Int, y:Int, height: CGFloat, width: CGFloat) -> ImNumber {
        let midX = Double(width) / self.currentWidth;
        let midY = Double(height) / self.currentHeight;
        return ImNumber(x: Double(x) / Double(midX) - currentWidth/2.0 + currentCenterX, y: currentHeight/2.0 - Double(y) / Double(midY) + currentCenterY);
    }
    
    func zoomToScale(scale: Double){
        currentWidth = (1-scale) * 8.0;
        currentHeight = (1-scale) * 8.0;
        self.setNeedsDisplay();
    }
    
    override func draw(_ rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()!;
        for i in 0...Int(rect.height) {
            for j in 0...Int(rect.width) {
                let iterations = transformCoordinates(x: j, y: i, height: rect.height, width: rect.width).checkMandelbrot();
                if(iterations == ImNumber.MAX_ITERATIONS) {
                    context.setFillColor(red: 0, green: 0, blue: 0, alpha: 1.0);
                    let rectangle = CGRect(x: j, y: i, width: 1, height: 1);
                    context.fill(rectangle);
                }
                else {
                    let factor = sqrt(Double(iterations) / Double(ImNumber.MAX_ITERATIONS));
                    context.setFillColor(red: 0, green: 1-CGFloat(factor), blue: CGFloat(factor), alpha: 1.0);
                    let rectangle = CGRect(x: j, y: i, width: 1, height: 1);
                    context.fill(rectangle);
                }
            }
        }
        return super.draw(rect);
    }
}
