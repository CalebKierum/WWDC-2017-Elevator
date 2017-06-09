//
//  Math.swift
//  Hotel
//
//  Created by Kierum Family Macbook on 8/17/16.
//  Copyright © 2016 Kierum Family Macbook. All rights reserved.
//

import Foundation
import SpriteKit

class Math
{
    static func linearForm(p1: CGPoint, p2: CGPoint, x: CGFloat) -> CGFloat
    {
        let m = (p2.y - p1.y) / (p2.x - p1.x)
        let b = p2.y - (m * p2.x)
        
        return m * x + b
    }
    
    static func rand2(_ firstNum: CGFloat, secondNum: CGFloat) -> CGFloat{
        //Random number between two numbers
        srand48(Int(NSDate().timeIntervalSince1970))
        return CGFloat(arc4random()) / CGFloat(UINT32_MAX) * abs(firstNum - secondNum) + min(firstNum, secondNum)
    }
}
