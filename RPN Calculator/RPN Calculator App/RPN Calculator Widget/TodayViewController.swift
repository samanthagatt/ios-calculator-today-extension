//
//  TodayViewController.swift
//  RPN Calculator Widget
//
//  Created by Samantha Gatt on 10/22/18.
//  Copyright © 2018 Samantha Gatt. All rights reserved.
//

import UIKit
import NotificationCenter
import RPN_Calculator

class TodayViewController: UIViewController, NCWidgetProviding {
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.extensionContext?.widgetLargestAvailableDisplayMode = .expanded
    }
    
    func widgetActiveDisplayModeDidChange(_ activeDisplayMode: NCWidgetDisplayMode, withMaximumSize maxSize: CGSize) {
        switch activeDisplayMode {
        case .compact:
            preferredContentSize = maxSize
            firstStackView.isHidden = true
            secondStackView.isHidden = true
            thirdStackView.isHidden = true
            fourthStackView.isHidden = true
        case .expanded:
            preferredContentSize = CGSize(width: maxSize.width, height: 300)
            firstStackView.isHidden = false
            secondStackView.isHidden = false
            thirdStackView.isHidden = false
            fourthStackView.isHidden = false
        }
    }
        
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        
        
        completionHandler(NCUpdateResult.newData)
    }
    
    
    @IBOutlet var textField: UITextField!
    @IBOutlet weak var firstStackView: UIStackView!
    @IBOutlet weak var secondStackView: UIStackView!
    @IBOutlet weak var thirdStackView: UIStackView!
    @IBOutlet weak var fourthStackView: UIStackView!
    
    private let numberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.allowsFloats = true
        formatter.maximumIntegerDigits = 20
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 20
        return formatter
    }()
    
    private var calculator = Calculator() {
        didSet {
            if let value = calculator.topValue {
                textField.text = numberFormatter.string(from: value as NSNumber)
            } else {
                textField.text = ""
            }
        }
    }
    
    private var digitAccumulator = DigitAccumulator() {
        didSet {
            if let value = digitAccumulator.value() {
                textField.text = numberFormatter.string(from: value as NSNumber)
            } else {
                textField.text = ""
            }
        }
    }
    
    @IBAction func numberButtonTapped(_ sender: UIButton) {
        try? digitAccumulator.add(digit: .number(sender.tag))
    }
    
    @IBAction func decimalButtonTapped(_ sender: UIButton) {
        try? digitAccumulator.add(digit: .decimalPoint)
    }
    
    @IBAction func returnButtonTapped(_ sender: UIButton) {
        if let value = digitAccumulator.value() {
            calculator.push(number: value)
        }
        digitAccumulator.clear()
    }
    
    @IBAction func divideButtonTapped(_ sender: UIButton) {
        returnButtonTapped(sender)
        calculator.push(operator: .divide)
    }
    
    @IBAction func multiplyButtonTapped(_ sender: UIButton) {
        returnButtonTapped(sender)
        calculator.push(operator: .multiply)
    }
    
    @IBAction func subtractButtonTapped(_ sender: UIButton) {
        returnButtonTapped(sender)
        calculator.push(operator: .subtract)
    }
    
    @IBAction func plusButtonTapped(_ sender: UIButton) {
        returnButtonTapped(sender)
        calculator.push(operator: .add)
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        calculator.clear()
        digitAccumulator.clear()
        return true
    }
}
