//
//  MandelbrotView.swift
//  RestExperiment
//
//  Created by Richard Simko on 2017-02-14.
//  Copyright © 2017 Richard Simko. All rights reserved.
//

import Foundation
import UIKit

protocol MandelbrotViewDelegate: class{
    func mandelbrotViewDidFinishRendering();
}

class MandelbrotView: UIView {
    
    weak var delegate:MandelbrotViewDelegate?
    
    var currentCenterX = 0.0;
    var currentCenterY = 0.0;
    var currentWidth = 4.0;
    var currentHeight = 4.0;
    
    var lastScale:CGFloat = 1.0;
    
    func transformCoordinates(x:Int, y:Int, height: CGFloat, width: CGFloat) -> ImNumber {
        let midX = Double(width) / self.currentWidth;
        let midY = Double(height) / self.currentHeight;
        return ImNumber(x: Double(x) / Double(midX) - currentWidth/2.0 + currentCenterX, y: currentHeight/2.0 - Double(y) / Double(midY) + currentCenterY);
    }
    
    func zoomToScale(scale: CGFloat){
        self.currentWidth = 1 / Double(scale) * 4.0;
        self.currentHeight = 1 / Double(scale) * 4.0;
    }
    
    func scrollTo(x: CGFloat, y: CGFloat){
        self.currentCenterX += self.currentWidth * (Double(x) / Double(self.frame.size.width));
        self.currentCenterY += self.currentHeight * (Double(y) / Double(self.frame.size.height));
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
        self.delegate?.mandelbrotViewDidFinishRendering();
        return super.draw(rect);
    }
    
    func pinch(sender: UIPinchGestureRecognizer) {
        self.transform = CGAffineTransform.init(scaleX: sender.scale, y: sender.scale);
        self.zoomToScale(scale: sender.scale);
        if sender.state == UIGestureRecognizerState.ended {
            print("ended", sender.scale);
            self.transform = CGAffineTransform.init(scaleX: 1.0, y: 1.0);
            self.setNeedsDisplay();
        }
    }
}
