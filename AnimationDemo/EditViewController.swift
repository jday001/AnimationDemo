//
//  EditViewController.swift
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

class EditViewController: UIViewController, UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate {
    
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var durationStepper: UIStepper!
    @IBOutlet weak var delayStepper: UIStepper!
    @IBOutlet weak var dampingStepper: UIStepper!
    @IBOutlet weak var velocityStepper: UIStepper!
    
    @IBOutlet weak var optionsPickerView: UIPickerView!
    @IBOutlet weak var optionsPickerViewHeight: NSLayoutConstraint!
    @IBOutlet weak var optionsTextField: UITextField!
    
    @IBOutlet weak var animationTagTextField: UITextField!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var delayLabel: UILabel!
    @IBOutlet weak var dampingLabel: UILabel!
    @IBOutlet weak var velocityLabel: UILabel!
    
    @IBOutlet weak var springOptionsContainer: UIView!
    
    var animations: [Animation]?
    var animationOptions: [AnimationOption] = AnimationOption.allValues
    var startingIndex: Int = 0
    
    
    private lazy var numberFormatter: NSNumberFormatter = {
        let formatter = NSNumberFormatter()
        formatter.numberStyle = .DecimalStyle
        formatter.minimumFractionDigits = 1
        formatter.maximumFractionDigits = 1
        return formatter
    }()
    
    
    
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        optionsPickerViewHeight.constant = 0
        optionsTextField.inputView = UIView()
        
        segmentedControl.selectedSegmentIndex = startingIndex
        
        showSpringContainerIfNeeded()
        populateInitialValues()
        setupSegmentedControl()
    }
    
    
    
    
    // MARK: - IBActions
    
    @IBAction func segmentedControlChanged(sender: AnyObject) {
        if let control = sender as? UISegmentedControl,
            let animation = animations?[control.selectedSegmentIndex] {
                showSpringContainerIfNeeded()
                populateAnimationFields(animation)
        }
    }
    
    @IBAction func durationStepperChanged(sender: AnyObject) {
        if let stepper = sender as? UIStepper,
            let animation = animations?[segmentedControl.selectedSegmentIndex] {
                animation.duration = NSTimeInterval(stepper.value)
                durationLabel.text = numberFormatter.stringFromNumber(stepper.value)
        }
    }
    
    @IBAction func delayStepperChanged(sender: AnyObject) {
        if let stepper = sender as? UIStepper,
            let animation = animations?[segmentedControl.selectedSegmentIndex] {
                animation.delay = NSTimeInterval(stepper.value)
                delayLabel.text = numberFormatter.stringFromNumber(stepper.value)
        }
    }
    
    @IBAction func dampingStepperChanged(sender: AnyObject) {
        if let stepper = sender as? UIStepper,
            let animation = animations?[segmentedControl.selectedSegmentIndex] as? SpringAnimation {
                animation.damping = CGFloat(stepper.value)
                dampingLabel.text = numberFormatter.stringFromNumber(stepper.value)
        }
    }
    
    @IBAction func velocityStepperChanged(sender: AnyObject) {
        if let stepper = sender as? UIStepper,
            let animation = animations?[segmentedControl.selectedSegmentIndex] as? SpringAnimation {
                animation.initialVelocity = CGFloat(stepper.value)
                velocityLabel.text = numberFormatter.stringFromNumber(stepper.value)
        }
    }
    
    @IBAction func doneButtonTapped(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    
    
    // MARK: - Private Functions
    
    private func showSpringContainerIfNeeded() {
        let isSpringAnimation = animations?[segmentedControl.selectedSegmentIndex] is SpringAnimation ?? false
        springOptionsContainer.hidden = !isSpringAnimation
    }
    
    private func setupSegmentedControl() {
        if let animationList = animations {
            for (index, animation) in animationList.enumerate() {
                segmentedControl.setTitle(animation.tag, forSegmentAtIndex: index)
            }
        }
    }
    
    private func populateInitialValues() {
        if let animation = animations?[segmentedControl.selectedSegmentIndex] {
            populateAnimationFields(animation)
        }
    }
    
    private func populateAnimationFields(animation: Animation) {
        animationTagTextField.text = animation.tag
        durationStepper.value = animation.duration
        durationLabel.text = numberFormatter.stringFromNumber(animation.duration)
        delayStepper.value = animation.delay
        delayLabel.text = numberFormatter.stringFromNumber(animation.delay)
        
        for option in AnimationOption.allValues {
            if animation.options == option.animationType() {
                optionsTextField.text = option.toString()
                break
            }
        }
        
        if let springAnimation = animation as? SpringAnimation {
            dampingStepper.value = Double(springAnimation.damping)
            dampingLabel.text = numberFormatter.stringFromNumber(springAnimation.damping)
            velocityStepper.value = Double(springAnimation.initialVelocity)
            velocityLabel.text = numberFormatter.stringFromNumber(springAnimation.initialVelocity)
        }
    }
    
    private func collapsePickerView() {
        optionsPickerView.hidden = true
        
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            UIView.animateWithDuration(0.5,
                delay: 0.0,
                usingSpringWithDamping: 0.8,
                initialSpringVelocity: 0.7,
                options: .CurveEaseInOut,
                animations: { () -> Void in
                    self.optionsPickerViewHeight.constant = 0
                    self.view.layoutIfNeeded()
                }, completion: { (finished) in
                    self.optionsTextField.resignFirstResponder()
            })
        }
    }
    
    
    
    
    // MARK: - UITextField Delegate
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        if textField == optionsTextField {
            optionsPickerView.hidden = false
            
            UIView.animateWithDuration(0.5,
                delay: 0.0,
                usingSpringWithDamping: 0.8,
                initialSpringVelocity: 0.7,
                options: .CurveEaseInOut,
                animations: { () -> Void in
                    self.optionsPickerViewHeight.constant = 160
                    self.view.layoutIfNeeded()
                }, completion: nil)
        }
        
        return true
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        if textField == animationTagTextField {
            if let animation = animations?[segmentedControl.selectedSegmentIndex] {
                animation.tag = textField.text ?? ""
                segmentedControl.setTitle(textField.text, forSegmentAtIndex: segmentedControl.selectedSegmentIndex)
            }
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    
    
    // MARK: - PickerView DataSource
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return animationOptions.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return animationOptions[row].toString()
    }
    
    
    
    
    // MARK: - PickerView Delegate
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        collapsePickerView()
        
        if let animation = animations?[segmentedControl.selectedSegmentIndex] {
            animation.options = [animationOptions[row].animationType()]
            optionsTextField.text = animationOptions[row].toString()
        }
    }
}
