//
//  MandelbrotCalculator.swift
//  Mandelbrot
//
//  Created by Richard Simko on 2017-02-16.
//  Copyright © 2017 Richard Simko. All rights reserved.
//

import Foundation

protocol MandelbrotCalculatorDelegate: class {
    func computedValue(number:ImNumber, numIterations:Int);
}

class MandelbrotCalculator {
    static func calculate(number:ImNumber) {
        
    }
}
