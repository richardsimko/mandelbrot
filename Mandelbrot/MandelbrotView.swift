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
    var currentHeight = 4.0;
    
    var lastScale:CGFloat = 1.0;
    
    func transformCoordinates(x:Int, y:Int, height: CGFloat, width: CGFloat) -> ImNumber {
        let midX = Double(width) / self.currentWidth;
        let midY = Double(height) / self.currentHeight;
        return ImNumber(x: Double(x) / Double(midX) - currentWidth/2.0 + currentCenterX, y: currentHeight/2.0 - Double(y) / Double(midY) + currentCenterY);
    }
    
    func zoomToScale(scale: CGFloat){
        self.lastScale *= scale;
        currentWidth = (1 / Double(self.lastScale)) * 4.0;
        currentHeight = (1 / Double(self.lastScale)) * 4.0;
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
    
    func pinch(sender: UIPinchGestureRecognizer) {
        if (sender.state == UIGestureRecognizerState.began) {
            self.lastScale = 1.0;
        }
        let scale = 1.0 - (lastScale - sender.scale);
        self.transform = CGAffineTransform.init(scaleX: scale, y: scale);
        self.lastScale = sender.scale;
        self.setNeedsLayout();
//        if(recognizer.state == UIGestureRecognizerState.changed){
//            let recogScale = recognizer.scale;
//            let newScale = recognizer.scale * self.lastScale;
//            let transform = CGAffineTransform.init(scaleX: newScale, y: newScale);
//            self.transform = transform;
//        } else if(recognizer.state == UIGestureRecognizerState.ended){
//            print("end");
//            self.lastScale = recognizer.scale;
//        }
    }
}
