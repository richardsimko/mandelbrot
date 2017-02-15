//
//  ViewController.swift
//  Mandelbrot
//
//  Created by Richard Simko on 2017-02-15.
//  Copyright © 2017 Richard Simko. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var mandelbrotView:MandelbrotView!;
    @IBOutlet var zoomSlider:UISlider!;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func panUp(){
        self.mandelbrotView.currentCenterY += 0.1;
        self.mandelbrotView.setNeedsDisplay();
    }
    
    @IBAction func panDown(){
        self.mandelbrotView.currentCenterY -= 0.1;
        self.mandelbrotView.setNeedsDisplay();
    }
    
    @IBAction func panLeft(){
        self.mandelbrotView.currentCenterX -= 0.1;
        self.mandelbrotView.setNeedsDisplay();
    }
    
    @IBAction func panRight(){
        self.mandelbrotView.currentCenterX += 0.1;
        self.mandelbrotView.setNeedsDisplay();
    }
    
    @IBAction func zoomIn(){
        self.mandelbrotView.currentHeight -= 0.1;
        self.mandelbrotView.currentWidth -= 0.1;
        self.mandelbrotView.setNeedsDisplay();
    }
    
    @IBAction func zoomOut(){
        self.mandelbrotView.currentHeight += 0.1;
        self.mandelbrotView.currentWidth += 0.1;
        self.mandelbrotView.setNeedsDisplay();
    }
    
    @IBAction func zoomScaleChanged(){
        self.mandelbrotView.zoomToScale(scale: Double(self.zoomSlider.value));
    }
}

