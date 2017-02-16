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
    @IBOutlet var scrollView:UIScrollView!;
    @IBOutlet var contentView:UIView!;
    @IBOutlet var spinner:UIActivityIndicatorView!;
    
    var originalScrollPosition:CGPoint?;
    
    var preventScrollAnimation = false;
    
    override func viewDidLoad() {
        super.viewDidLoad();
        self.mandelbrotView.delegate = self;
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.preventScrollAnimation = true;
        self.scrollView.scrollRectToVisible(self.mandelbrotView.convert(self.mandelbrotView.bounds, to: self.scrollView), animated: false);
        self.originalScrollPosition = self.scrollView.contentOffset;
        self.mandelbrotView.addGestureRecognizer(UIPinchGestureRecognizer.init(target: self.mandelbrotView, action: #selector(self.mandelbrotView.pinch(sender:))));
        self.mandelbrotView.reload();
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func resetZoom(){
        self.mandelbrotView.reset();
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.contentView;
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        NSObject.cancelPreviousPerformRequests(withTarget: self);
        self.perform(#selector(self.scrollViewDidEndScrollingAnimation(_:)), with: nil, afterDelay: 0.3);
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        if(self.preventScrollAnimation == true){
            self.preventScrollAnimation = false;
        } else {
            NSObject.cancelPreviousPerformRequests(withTarget: self);
            let xOffset = self.scrollView.contentOffset.x - (self.originalScrollPosition?.x)!;
            let yOffset = (self.originalScrollPosition?.y)! - self.scrollView.contentOffset.y;
            self.mandelbrotView.scrollTo(x: xOffset, y: yOffset);
            self.mandelbrotView.reload();
        }
    }
    
    internal func mandelbrotViewDidFinishRendering() {
        if(self.originalScrollPosition?.x != self.scrollView.contentOffset.x || self.originalScrollPosition?.y != self.scrollView.contentOffset.y){
            self.scrollView.scrollRectToVisible(self.mandelbrotView.convert(self.mandelbrotView.bounds, to: self.scrollView), animated: false);
            self.originalScrollPosition = self.scrollView.contentOffset;
            self.preventScrollAnimation = true;
        }
        self.scrollView.isUserInteractionEnabled = true;
        self.mandelbrotView.isUserInteractionEnabled = true;
        self.spinner.stopAnimating();
    }
    
    internal func mandelbrotViewDidStartRendering(){
        self.scrollView.isUserInteractionEnabled = false;
        self.mandelbrotView.isUserInteractionEnabled = false;
        self.spinner.startAnimating();
    }
}

