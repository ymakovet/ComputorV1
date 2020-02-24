//
//  ComputorV1ViewController.swift
//  ComputorV1
//
//  Created by Yuliia MAKOVETSKAYA on 5/4/19.
//  Copyright © 2019 Yuliia MAKOVETSKAYA. All rights reserved.
//

import UIKit

final class ComputorV1ViewController: UIViewController {

    @IBOutlet weak var inputTextField: UITextField!
    
    @IBOutlet weak var resultView: UIView!
    @IBOutlet weak var calculateButtonOutlet: UIButton!
    
    @IBOutlet weak var reducedFormLabel: UILabel!
    @IBOutlet weak var polynomialDegreeLabel: UILabel!
    
    @IBOutlet weak var discriminantStatusLabel: UILabel!
    @IBOutlet weak var solutionsLabel: UILabel!
    
    @IBOutlet weak var firstShortcutWithX: UIButton!
    @IBOutlet weak var powerShortcutWith: UIButton!
    @IBOutlet weak var plusShortcut: UIButton!
    @IBOutlet weak var minusShortcut: UIButton!
    @IBOutlet weak var multiplicationShortcut: UIButton!
    @IBOutlet weak var equalShortcutWith: UIButton!
    
    
    private var radius: CGFloat = 10
    private let reducedFormText = "Reduced form: "
    private let polynomialDegreeText = "Polynomial degree: "
    private let discriminantPositiveText = "Discriminant is strictly positive, the two solutions are: "
    private let discriminantNegativeText = "The discriminant is strictly negative, there is no solution."
    
    //"5 + 4 * X + X^2= X^2"
    //"5 * X^0 + 4 * X^1 = 4 * X^0"
    //"5 * X^0 + 4 * X^1 - 9.3 * X^2 = 1 * X^0"
    //"5 * X^0 + 4 * X^1 = 4 * X^0
    //42 * X^0 = 42 * X^0
    private var reducedForm = ""
    private var discriminantStatusText = "The solution is:"
    private var solutionText = ""
  
    private var discriminant: Float?
    private var polynomialDegree = 0
    
    private let zero: Float = 0
    
    private var solutioner: Comp!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        solutioner = Comp(delegate: self)
        inputTextField.keyboardType = .numberPad
       setupButtons()
    }
    
    
    private func setupButtons() {
        calculateButtonOutlet.setTitleColor(UIColor.black, for: .normal)
        calculateButtonOutlet.layer.cornerRadius = radius
        resultView.layer.cornerRadius = radius
        firstShortcutWithX.layer.cornerRadius = radius
        plusShortcut.layer.cornerRadius = radius
        minusShortcut.layer.cornerRadius = radius
        powerShortcutWith.layer.cornerRadius = radius
        multiplicationShortcut.layer.cornerRadius = radius
        equalShortcutWith.layer.cornerRadius = radius
    }
    
 
    
    @IBAction func didTapFirstShortcutWithX(_ sender: Any) {
        if inputTextField.text!.count > 0 {
             inputTextField.text = inputTextField.text! + "*X^"
        }
    }
    
    @IBAction func didTapPowerShortcutWith(_ sender: Any) {
        inputTextField.text = (inputTextField.text ?? "") + "X^"
    }
    
    @IBAction func didTapPlusShortcut(_ sender: Any) {
        inputTextField.text = (inputTextField.text ?? "") + "+"
    }
    
    @IBAction func didTapMinusShortcut(_ sender: Any) {
        inputTextField.text = (inputTextField.text ?? "") + "-"
    }
    
    @IBAction func didTapMultiplicationShortcut(_ sender: Any) {
        inputTextField.text = (inputTextField.text ?? "") + "*"
    }
    
    @IBAction func didTapEqualShortcutWith(_ sender: Any) {
        inputTextField.text = (inputTextField.text ?? "") + "="
    }
    
    @IBAction func calculateButtonAction(_ sender: Any) {
        guard let inputString = inputTextField.text, inputString != "" else { return }
        
        solutioner.findSolution(input: inputString)
    }
    
    func clean() {
        reducedForm = ""
        solutionText = ""
        discriminant = nil
        polynomialDegree = 0
        discriminantStatusText = "The solution is:"
        discriminantStatusLabel.text = ""
    }
    
}

extension Float {
    var clean: String {
        return self.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", self) : String(self)
    }
}


// MARK: - UITextFieldDelegate

extension ComputorV1ViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}

// MARK: - ShowResultDelegate

extension ComputorV1ViewController: ShowResultDelegate {
    func show(redusedForm: String) {
        var redused = redusedForm
//        if redused.first == "+" {
//            redused.removeFirst()
//        }
        reducedFormLabel.text = reducedFormText + redused
    }
    
    func show(polynomialDegree: String) {
         polynomialDegreeLabel.text = polynomialDegreeText + String(polynomialDegree)
    }
    
    func show(discriminant: Discriminant) {
        switch discriminant {
        case .negative:
            discriminantStatusLabel.text = discriminantNegativeText
        case .positive:
            discriminantStatusLabel.text = discriminantPositiveText
        case .zero:
            discriminantStatusLabel.text = discriminantStatusText
        case .error:
            discriminantStatusLabel.text = "All the real numbers are solution"
        case .empty:
            discriminantStatusLabel.text = ""
        }
    }
    
    func show(solution: String) {
        solutionsLabel.text = solution
    }
}


extension String {
    func countOf(char: Character) -> Int {
        return self.filter { $0 == char }.count
    }
    
    func splitToString(separator: Character) -> [String] {
        let arraySubString = self.split(separator: separator)
        return arraySubString.map { (str) -> String in
            String(str)
        }
    }
}
