//
//  ImNumber.swift
//  RestExperiment
//
//  Created by Richard Simko on 2017-02-15.
//  Copyright © 2017 Richard Simko. All rights reserved.
//

import Foundation

protocol ImNumberDelegate: class {
    func didFinishCalculations(sender: ImNumber, iterations: Int);
}

class ImNumber : NSObject {
    
    weak var delegate:ImNumberDelegate?;
    
    static let MAX_ITERATIONS:Int = 100;
    
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
    
    func checkMandelbrot() {
        var z_n = self.add(other: self.square());
        if(z_n.abs() >= 4)
        {
            self.delegate?.didFinishCalculations(sender: self, iterations: 1);
            return;
        }
        for var i in 0...ImNumber.MAX_ITERATIONS {
            z_n = self.add(other: z_n.square());
            if(z_n.abs() >= 4)
            {
                self.delegate?.didFinishCalculations(sender: self, iterations: i);
                return;
            }
        }
        self.delegate?.didFinishCalculations(sender: self, iterations: ImNumber.MAX_ITERATIONS);
    }
}
