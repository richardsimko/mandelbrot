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
    func mandelbrotViewDidStartRendering();
}

class MandelbrotView: UIView, ImNumberDelegate {
    
    weak var delegate:MandelbrotViewDelegate?
    
    var currentCenterX = 0.0;
    var currentCenterY = 0.0;
    var currentWidth = 4.0;
    var currentHeight = 4.0;
    
    var lastScale:CGFloat = 1.0;
    
    var numbers:[[Int]] = [[]];
    
    /**
     * Transforms coordinates from the view's coordinate system to the complex coordinate system
     */
    func transformCoordinates(x:Int, y:Int) -> ImNumber {
        // Figure out the scale between the Imaginary coordinate frame and the size of the view
        let xScale = Double(self.bounds.size.width) / self.currentWidth;
        let yScale = Double(self.bounds.size.height) / self.currentHeight;
        // Scale the X and Y values by the relevant scale and then move them according to what part of the coordinate system we're viewing.
        return ImNumber(x: Double(x) / Double(xScale) - currentWidth/2.0 + currentCenterX, y: currentHeight/2.0 - Double(y) / Double(yScale) + currentCenterY);
    }
    
    /**
     * Transforms an imaginary number to the view's coordinate system.
     */
    func transformImNumber(imNumber: ImNumber) -> CGPoint {
        let xScale = Double(self.bounds.size.width) / self.currentWidth;
        let yScale = Double(self.bounds.size.height) / self.currentHeight;
        let x = imNumber.re * xScale + Double(self.bounds.size.width) / 2.0 - self.currentCenterX * Double(self.bounds.size.width) / self.currentWidth;
        let y = Double(self.bounds.size.height) / 2.0 + self.currentCenterY * yScale - Double(self.bounds.size.height) * imNumber.im / self.currentHeight
        return CGPoint.init(x: x, y: y);
    }
    
    /**
     * Zooms the view to a specific scale.
     */
    func zoomToScale(scale: CGFloat){
        // Since scale increases when zooming in but we want to reduce the area we're showing it has to be inverted
        self.currentWidth = 1 / Double(scale) * self.currentWidth;
        self.currentHeight = 1 / Double(scale) * self.currentHeight;
    }
    
    /**
     * Scrolls the view to a specific coordinate
     */
    func scrollTo(x: CGFloat, y: CGFloat){
        self.currentCenterX += self.currentWidth * (Double(x) / Double(self.bounds.size.width));
        self.currentCenterY += self.currentHeight * (Double(y) / Double(self.bounds.size.height));
    }
    
    override func draw(_ rect: CGRect) {
        for i in 0...Int(self.bounds.size.width) {
            for j in 0...Int(self.bounds.size.height) {
                if(self.numbers.count == 0 || self.numbers.count <= i || self.numbers[i].count == 0 || self.numbers[i].count <= j)
                {
                    continue;
                }
                let iterations = self.numbers[i][j];
                let context = UIGraphicsGetCurrentContext()!;
                if(iterations == ImNumber.MAX_ITERATIONS) {
                    context.setFillColor(red: 0, green: 0, blue: 0, alpha: 1.0);
                    let rectangle = CGRect(x: i, y: j, width: 1, height: 1);
                    context.fill(rectangle);
                }
                else {
                    let factor = sqrt(Double(iterations) / Double(ImNumber.MAX_ITERATIONS));
                    context.setFillColor(red: 0, green: 1-CGFloat(factor), blue: sqrt(CGFloat(factor)), alpha: 1.0);
                    let rectangle = CGRect(x: i, y: j, width: 1, height: 1);
                    context.fill(rectangle);
                }
                
            }
        }
        return super.draw(rect);
    }
    
    func reload(){
        self.delegate?.mandelbrotViewDidStartRendering();
        self.numbers = Array(repeating: Array(repeating: ImNumber.MAX_ITERATIONS, count: Int(self.bounds.size.height)+1), count: Int(self.bounds.size.width)+1);
        let background = DispatchQueue.init(label: "test");
        background.async {
            for i in 0...Int(self.bounds.size.width) {
                for j in 0...Int(self.bounds.size.height) {
                    let imnumber = self.transformCoordinates(x: j, y: i);
                    imnumber.delegate = self;
                    imnumber.checkMandelbrot();
                }
            }
        }
    }
    
    func pinch(sender: UIPinchGestureRecognizer) {
        self.transform = CGAffineTransform.init(scaleX: sender.scale, y: sender.scale);
        if sender.state == UIGestureRecognizerState.ended {
            self.lastScale = sender.scale;
            self.zoomToScale(scale: sender.scale);
            self.reload();
        }
    }
    
    func didFinishCalculations(sender: ImNumber, iterations: Int) {
        let point = self.transformImNumber(imNumber: sender);
        let x = Int(round(point.x));
        let y = Int(round(point.y));
            self.numbers[x][y] = iterations;
        if(x == self.numbers.count - 1 && y == self.numbers[x].count - 1)
        {
            DispatchQueue.main.async {
                self.setNeedsDisplay();
                self.transform = CGAffineTransform.init(scaleX: 1.0, y: 1.0);
                self.delegate?.mandelbrotViewDidFinishRendering();
            }
        }
        
    }
}
