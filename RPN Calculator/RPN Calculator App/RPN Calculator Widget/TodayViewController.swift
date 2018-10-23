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
    
    // MARK: - UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.extensionContext?.widgetLargestAvailableDisplayMode = .expanded
        
        let value = groupUserDefaults.double(forKey: "LastDoubleOnStack")
        calculator.push(number: value)
    }
    
    
    // MARK: - NCWidgetProviding
    
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
    
    
    // MARK: - Private Properties
    
    private let groupUserDefaults = UserDefaults(suiteName: "group.com.SamanthaGatt.RPN_Calculator")!
    
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
    
    // MARK: - Outlets
    
    @IBOutlet private var textField: UITextField!
    @IBOutlet private weak var firstStackView: UIStackView!
    @IBOutlet private weak var secondStackView: UIStackView!
    @IBOutlet private weak var thirdStackView: UIStackView!
    @IBOutlet private weak var fourthStackView: UIStackView!
    
    
    // MARK: - Actions
    
    @IBAction private func numberButtonTapped(_ sender: UIButton) {
        try? digitAccumulator.add(digit: .number(sender.tag))
    }
    
    @IBAction private func decimalButtonTapped(_ sender: UIButton) {
        try? digitAccumulator.add(digit: .decimalPoint)
    }
    
    @IBAction private func returnButtonTapped(_ sender: UIButton) {
        if let value = digitAccumulator.value() {
            calculator.push(number: value)
        }
        digitAccumulator.clear()
    }
    
    @IBAction private func divideButtonTapped(_ sender: UIButton) {
        returnButtonTapped(sender)
        calculator.push(operator: .divide)
    }
    
    @IBAction private func multiplyButtonTapped(_ sender: UIButton) {
        returnButtonTapped(sender)
        calculator.push(operator: .multiply)
    }
    
    @IBAction private func subtractButtonTapped(_ sender: UIButton) {
        returnButtonTapped(sender)
        calculator.push(operator: .subtract)
    }
    
    @IBAction private func plusButtonTapped(_ sender: UIButton) {
        returnButtonTapped(sender)
        calculator.push(operator: .add)
    }
    
    private func textFieldShouldClear(_ textField: UITextField) -> Bool {
        calculator.clear()
        digitAccumulator.clear()
        return true
    }
    
    @IBAction func copyToPasteboard(_ sender: Any) {
        guard let number = textField.text, number != "" else { return }
        let pasteboard = UIPasteboard.general
        pasteboard.string = number
    }
}
