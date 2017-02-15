//
//  ImNumber.swift
//  RestExperiment
//
//  Created by Richard Simko on 2017-02-15.
//  Copyright © 2017 Richard Simko. All rights reserved.
//

import Foundation

class ImNumber : NSObject {
    
    var re:Double;
    var im:Double;
    
    init(x: Double, y: Double) {
        self.re = x;
        self.im = y;
    }
    
    func square() -> ImNumber {
        let newX = self.re * self.re - self.im * self.im;
        let newY = 2 * self.re * self.im;
        return ImNumber.init(x: newX, y: newY);
    }
    
    func add(other:ImNumber) -> ImNumber {
        let newRe  = self.re + other.re;
        let newIm = self.im + other.im;
        return ImNumber.init(x: newRe, y: newIm);
    }
    
    func abs() -> Double{
        return self.re * self.re  + self.im * self.im;
    }
    
    override var description: String {
        return "Re: \(self.re) Im: \(self.im)";
    }
    
    func checkMandelbrot() -> Int {
        var z_n = self.add(other: self.square());
        if(z_n.abs() >= 4)
        {
            return 1;
        }
        for var i in 0...100 {
            z_n = self.add(other: z_n.square());
            if(z_n.abs() >= 4)
            {
                return i;
            }
        }
        return 100;
    }
}
