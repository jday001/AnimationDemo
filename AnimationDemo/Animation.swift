//
//  Animation.swift
//  AnimationDemo
//
//  The MIT License (MIT)
//
//  Copyright (c) 2016 Jeff Day
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//

import Foundation
import UIKit


enum AnimationOption {
    case CurveEaseInOut
    case CurveEaseIn
    case CurveEaseOut
    case CurveLinear
    
    static let allValues = [CurveEaseInOut, CurveEaseIn, CurveEaseOut, CurveLinear]
    
    func toString() -> String {
        switch self {
        case .CurveEaseInOut: return "CurveEaseInOut"
        case .CurveEaseIn:    return "CurveEaseIn"
        case .CurveEaseOut:   return "CurveEaseOut"
        case .CurveLinear:    return "CurveLinear"
        }
    }
    
    // hacky but will work for now
    func animationType() -> UIViewAnimationOptions {
        switch self {
        case .CurveEaseInOut: return UIViewAnimationOptions.CurveEaseInOut
        case .CurveEaseIn:    return UIViewAnimationOptions.CurveEaseIn
        case .CurveEaseOut:   return UIViewAnimationOptions.CurveEaseOut
        case .CurveLinear:    return UIViewAnimationOptions.CurveLinear
        }
    }
}


class Animation {
    
    typealias AnimationBlock = (() -> Void)
    
    var tag: String
    var delay: NSTimeInterval
    var duration: NSTimeInterval
    var options: UIViewAnimationOptions
    var animationBlock: AnimationBlock
    var preparationBlock: AnimationBlock?
    
    
    init(tag: String,
        duration: NSTimeInterval,
        options: UIViewAnimationOptions,
        animation: AnimationBlock,
        preparationBlock: AnimationBlock?) {
            self.tag = tag
            self.delay = 0
            self.duration = duration
            self.options = options
            self.animationBlock = animation
            self.preparationBlock = preparationBlock
    }
    
    init(tag: String,
        delay: NSTimeInterval,
        duration: NSTimeInterval,
        options: UIViewAnimationOptions,
        animation: AnimationBlock,
        preparationBlock: AnimationBlock?) {
            self.tag = tag
            self.delay = delay
            self.duration = duration
            self.options = options
            self.animationBlock = animation
            self.preparationBlock = preparationBlock
    }
    
    
    func perform() {
        if let prep = preparationBlock {
            prep()
        }
        
        if let animation = self as? SpringAnimation {
            UIView.animateWithDuration(duration,
                delay: delay,
                usingSpringWithDamping: animation.damping,
                initialSpringVelocity: animation.initialVelocity,
                options: options,
                animations: animationBlock,
                completion: nil)
        } else {
            UIView.animateWithDuration(duration,
                delay: delay,
                options: options,
                animations: animationBlock,
                completion: nil)
        }
    }
}



class SpringAnimation: Animation {
    
    
    var damping: CGFloat
    var initialVelocity: CGFloat
    
    init(tag: String,
        duration: NSTimeInterval,
        options: UIViewAnimationOptions,
        animation: AnimationBlock,
        preparationBlock: AnimationBlock?,
        springDamping: CGFloat,
        springInitialVelocity: CGFloat) {
            self.damping = springDamping
            self.initialVelocity = springInitialVelocity
            
            super.init(tag: tag, duration: duration, options: options, animation: animation, preparationBlock: preparationBlock)
    }
    
    init(tag: String,
        delay: NSTimeInterval,
        duration: NSTimeInterval,
        options: UIViewAnimationOptions,
        animation: AnimationBlock,
        preparationBlock: AnimationBlock?,
        springDamping: CGFloat,
        springInitialVelocity: CGFloat) {
            self.damping = springDamping
            self.initialVelocity = springInitialVelocity
            
            super.init(tag: tag, delay: delay, duration: duration, options: options, animation: animation, preparationBlock: preparationBlock)
    }
}
