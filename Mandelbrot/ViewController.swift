//
//  ViewController.swift
//  Mandelbrot
//
//  Created by Richard Simko on 2017-02-15.
//  Copyright © 2017 Richard Simko. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIScrollViewDelegate, MandelbrotViewDelegate {
    
    @IBOutlet var mandelbrotView:MandelbrotView!;
    @IBOutlet var zoomSlider:UISlider!;
    @IBOutlet var scrollView:UIScrollView!;
    @IBOutlet var contentView:UIView!;
    @IBOutlet var spinner:UIActivityIndicatorView!;
    
    var originalScrollPosition:CGPoint?;
    
    var preventScrollAnimation = false;
    
    override func viewDidLoad() {
        super.viewDidLoad();
        self.spinner.startAnimating();
        self.mandelbrotView.delegate = self;
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.preventScrollAnimation = true;
        self.scrollView.scrollRectToVisible(self.mandelbrotView.convert(self.mandelbrotView.bounds, to: self.scrollView), animated: false);
        self.originalScrollPosition = self.scrollView.contentOffset;
        //        TODO: 1. When scroll is done, figure out where we are in relation to where we started, apply that to the panning in the MandelbrotView and reset the scroll position in the UIScrollView. Same for zoom.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.contentView;
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        NSObject.cancelPreviousPerformRequests(withTarget: self);
        self.perform(#selector(self.scrollViewDidEndScrollingAnimation(_:)), with: nil, afterDelay: 0.3);
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        print("end scrolling \(self.preventScrollAnimation) \(self.scrollView.zoomScale)");
        if(self.preventScrollAnimation == true){
            self.preventScrollAnimation = false;
        } else {
            NSObject.cancelPreviousPerformRequests(withTarget: self);
            self.mandelbrotView.zoomToScale(scale: self.scrollView.zoomScale);
            var xOffset = self.scrollView.contentOffset.x - (self.originalScrollPosition?.x)!;
            var yOffset = (self.originalScrollPosition?.y)! - self.scrollView.contentOffset.y;
            print(self.scrollView.contentOffset);
            self.mandelbrotView.scrollTo(x: xOffset, y: yOffset);
            self.mandelbrotView.setNeedsDisplay();
        }
    }
    
    internal func mandelbrotViewDidFinishRendering() {
        //        self.scrollView.zoomScale = 1.0;
        self.scrollView.scrollRectToVisible(self.mandelbrotView.convert(self.mandelbrotView.bounds, to: self.scrollView), animated: false);
        self.originalScrollPosition = self.scrollView.contentOffset;
        self.preventScrollAnimation = true;
        self.spinner.stopAnimating();
    }
}

