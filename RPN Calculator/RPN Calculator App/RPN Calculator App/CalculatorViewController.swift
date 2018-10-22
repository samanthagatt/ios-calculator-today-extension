//
//  CalculatorViewController.swift
//  Calculator
//

import UIKit
import RPN_Calculator

class CalculatorViewController: UIViewController, UITextFieldDelegate {
	
	@IBOutlet var textField: UITextField!
	
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
