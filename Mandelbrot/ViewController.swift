//
//  ViewController.swift
//  Mandelbrot
//
//  Created by Richard Simko on 2017-02-15.
//  Copyright © 2017 Richard Simko. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet var mandelbrotView:MandelbrotView!;
    @IBOutlet var zoomSlider:UISlider!;
    @IBOutlet var scrollView:UIScrollView!;
    @IBOutlet var contentView:UIView!;
    
    var preventScrollAnimation = false;
    
    override func viewDidLoad() {
        super.viewDidLoad();
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print(self.scrollView.contentSize);
        self.scrollView.scrollRectToVisible(self.mandelbrotView.convert(self.mandelbrotView.bounds, to: self.scrollView), animated: false);
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.contentView;
    }
    
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        NSObject.cancelPreviousPerformRequests(withTarget: self);
//        self.perform(#selector(self.scrollViewDidEndScrollingAnimation(_:)), with: nil, afterDelay: 0.3);
//    }
//    
//    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
//        if(self.preventScrollAnimation == true){
//            self.preventScrollAnimation = false;
//        } else {
//            NSObject.cancelPreviousPerformRequests(withTarget: self);
////            self.mandelbrotView.zoomToScale(scale: self.scrollView.zoomScale);
//            self.scrollView.zoomScale = 1.0;
//            self.preventScrollAnimation = true;
//        }
//    }
}

