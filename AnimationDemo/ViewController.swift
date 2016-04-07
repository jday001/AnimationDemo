//
//  ViewController.swift
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

import UIKit


class ViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    @IBOutlet weak var imageDistanceFromCenter: NSLayoutConstraint!
    
    
    var animationDuration: NSTimeInterval = 1.0
    
    var animations: [Animation] = []

    
    
    
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupAnimations()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        setupSegmentedControl()
    }
    
    
    
    
    // MARK: - IBActions
    
    @IBAction func editButtonTapped(sender: AnyObject) {
        guard let editVC = storyboard?.instantiateViewControllerWithIdentifier("EditVC") as? EditViewController else{
            return
        }
        
        editVC.animations = animations
        editVC.startingIndex = segmentedControl.selectedSegmentIndex
        presentViewController(editVC, animated: true, completion: nil)
    }
    
    @IBAction func animateButtonTapped(sender: AnyObject) {
        resetView()
        animations[segmentedControl.selectedSegmentIndex].perform()
    }
    
    @IBAction func segmentedControlChanged(sender: AnyObject) {
    }
    
    
    
    
    // MARK: - Private Functions
    
    private func resetView() {
        imageView.transform = CGAffineTransformIdentity
        
        imageDistanceFromCenter.constant = (UIScreen.mainScreen().bounds.size.width / 2)
            + imageView.bounds.size.width
        
        self.view.layoutIfNeeded()
    }
    
    private func setupAnimations() {
        animations = [
            firstAnimation(),
            secondAnimation(),
            firstSpringAnimation(),
            secondSpringAnimation()
        ]
    }
    
    private func setupSegmentedControl() {
        for (index, animation) in animations.enumerate() {
            segmentedControl.setTitle(animation.tag, forSegmentAtIndex: index)
        }
    }
    
    
    
    
    // MARK: - Animation Definitions
    
    private func firstAnimation() -> Animation {
        let animationBlock = {
            self.imageDistanceFromCenter.constant = 0
            self.view.layoutIfNeeded()
        }
    
        let animation = Animation(tag: "First",
            duration: 1.0,
            options: [],
            animation: animationBlock,
            preparationBlock: nil)
        return animation
    }
    
    private func secondAnimation() -> Animation {
        let preparationBlock = {
            let rotateTransform = CGAffineTransformMakeRotation(CGFloat(-M_PI_2))
            let scaleTransform = CGAffineTransformMakeScale(0.25, 0.25)
            
            let transform = CGAffineTransformConcat(rotateTransform, scaleTransform)
            self.imageView.transform = transform
        }
        
        let animationBlock = {
            let rotateTransform = CGAffineTransformMakeRotation(0)
            let scaleTransform = CGAffineTransformMakeScale(1.0, 1.0)
            let transform = CGAffineTransformConcat(rotateTransform, scaleTransform)
            self.imageView.transform = transform
            
            self.imageDistanceFromCenter.constant = 0
            self.view.layoutIfNeeded()
        }
        
        let animation = Animation(tag: "Second",
            duration: 1.0,
            options: [],
            animation: animationBlock,
            preparationBlock: preparationBlock)
        return animation
    }
    
    private func firstSpringAnimation() -> Animation {
        let animationBlock = {
            self.imageDistanceFromCenter.constant = 0
            self.view.layoutIfNeeded()
        }
        
        let springAnimation = SpringAnimation(tag: "Spring1",
            duration: 1.0,
            options: .CurveEaseInOut,
            animation: animationBlock,
            preparationBlock: nil,
            springDamping: 0.6,
            springInitialVelocity: 0.7)
        return springAnimation
    }
    
    private func secondSpringAnimation() -> Animation {
        let preparationBlock = {
            let rotateTransform = CGAffineTransformMakeRotation(CGFloat(-M_PI_2))
            let scaleTransform = CGAffineTransformMakeScale(0.25, 0.25)
            
            let transform = CGAffineTransformConcat(rotateTransform, scaleTransform)
            self.imageView.transform = transform
        }
        
        let animationBlock = {
            let rotateTransform = CGAffineTransformMakeRotation(0)
            let scaleTransform = CGAffineTransformMakeScale(1.0, 1.0)
            let transform = CGAffineTransformConcat(rotateTransform, scaleTransform)
            self.imageView.transform = transform
            
            self.imageDistanceFromCenter.constant = 0
            self.view.layoutIfNeeded()
        }
        
        
        let springAnimation = SpringAnimation(tag: "Spring2",
            duration: 1.0,
            options: .CurveEaseInOut,
            animation: animationBlock,
            preparationBlock: preparationBlock,
            springDamping: 0.6,
            springInitialVelocity: 0.7)
        return springAnimation
    }
}
