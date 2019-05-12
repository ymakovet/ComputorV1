//
//  ComputorV1ViewController.swift
//  ComputorV1
//
//  Created by Yuliia MAKOVETSKAYA on 5/4/19.
//  Copyright © 2019 Yuliia MAKOVETSKAYA. All rights reserved.
//

import UIKit

class ComputorV1ViewController: UIViewController {

    @IBOutlet weak var inputTextField: UITextField!
    
    @IBOutlet weak var calculateButtonOutlet: UIButton!
    
    @IBOutlet weak var ReducedFormLabel: UILabel!
    @IBOutlet weak var polynomialDegreeLabel: UILabel!
    
    @IBOutlet weak var discriminantStatusLabel: UILabel!
    @IBOutlet weak var solutionsLabel: UILabel!
    
    let reducedFormText = "Reduced form:"
    let polynomialDegreeText = "Polynomial degree:"
    let discriminantPositiveText = "Discriminant is strictly positive, the two solutions are:"
    let discriminantNegativeText = "The discriminant is strictly negative, there is no solution:"
    
    //"5 + 4 * X + X^2= X^2"
    //"5 * X^0 + 4 * X^1 = 4 * X^0"
    //"5 * X^0 + 4 * X^1 - 9.3 * X^2 = 1 * X^0"
    //"5 * X^0 + 4 * X^1 = 4 * X^0
    //42 * X^0 = 42 * X^0
    var reducedForm = ""
    var discriminantStatusText = "The solution is:"
    var solutionText = ""
    var a: Float?
    var b: Float?
    var c: Float?
    var discriminant: Float?
    var polynomialDegree = 0
    
    let zero: Float = 0
    override func viewDidLoad() {
        super.viewDidLoad()

        calculateButtonOutlet.layer.cornerRadius = 10
        calculateButtonOutlet.setTitleColor(UIColor.black, for: .normal)
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func parsingEquation(input: String) -> (result: Bool, error: String?, multiplicands: String?, multiplier: String?) {
        let string = "1234567890 X^*-+=."
        
        for char in input {
            if string.contains(char) {
                continue
            }
            print("error")
            inputTextField.text?.removeAll()
            return (false, "Error", nil, nil)
        }
        
        guard input.contains("=") else { return (false, "Error", nil, nil) }
        
        let newString = input.replacingOccurrences(of: " ", with: "")
        let inputArr = newString.split(separator: "=")
//        if inputArr[0].contains("-") {
//
//        }
        let leftbyplus = inputArr[0].replacingOccurrences(of: "+", with: " +")//inputArr[0].split(separator: "+")
        let leftbyminus = leftbyplus.replacingOccurrences(of: "-", with: " -")
        let left = leftbyminus.split(separator: " ")
        let right = inputArr[1].split(separator: "*")
        var multiplicandsRight = ""
        var multiplierRight = ""
        if right.count > 1 {
            multiplicandsRight = String(right[0])
            multiplierRight = String(right[1])
        } else {
            multiplicandsRight = "1"
            multiplierRight = String(right[0])
        }
        print("newString", newString)
        print("inputArr", inputArr)
        print("left", left)
        print("right", right)
        print("multiplicandsRight, multiplierRight", multiplicandsRight, multiplierRight)
        
        for item in left {
            let mult = item.split(separator: "*")
            var degree = ""
            if mult.count > 1 {
                degree =  String(mult[1])
                switch degree {
                case "X^0":
                    self.c = Float(mult[0])
                case "X^1", "X":
                    self.b = Float(mult[0])
                    polynomialDegree = polynomialDegree < 1 ? 1 : polynomialDegree
                case "X^2":
                    self.a = Float(mult[0])
                    polynomialDegree = polynomialDegree < 2 ? 2 : polynomialDegree
                default:
                    let errorText = "The polynomial degree is stricly greater than 2, I can't solve."
                    return (false, errorText, nil, nil)
                }
            } else {
                degree = String(mult[0])
                
                switch degree {
                case "X^0", "+X^0":
                    self.c = 1
//                    polynomialDegree = polynomialDegree < 0 ? 0 : polynomialDegree
                case "-X^0":
                    self.c = -1
                case "X^1", "X", "+X^1", "+X":
                    self.b = 1
                    polynomialDegree = polynomialDegree < 1 ? 1 : polynomialDegree
                case "-X^1", "-X":
                    self.b = -1
                    polynomialDegree = polynomialDegree < 1 ? 1 : polynomialDegree
                case "X^2", "+X^2":
                    self.a = 1
                    polynomialDegree = polynomialDegree < 2 ? 2 : polynomialDegree
                case "-X^2":
                    self.a = -1
                    polynomialDegree = polynomialDegree < 2 ? 2 : polynomialDegree
                default:
                    if (Float(degree) != nil) {
                        self.c = Float(degree)
                        break
                    }
                    let errorText = "The polynomial degree is stricly greater than 2, I can't solve."
                    return (false, errorText, nil, nil)
                }
                
            }
        }
        print("a", a, "b", b, "c", c)
        
       
        return (true, nil, multiplicandsRight, multiplierRight)
    }
    
    private func equationReduction(multiplicands: String, multiplier: String) -> String {
        switch multiplier {
        case "X^0":
            self.c! -= Float(multiplicands)!
        case "X^1":
            self.b! -= Float(multiplicands)!
        case "X^2":
            self.a! -= Float(multiplicands)!
        default:
           print("The polynomial degree is stricly greater than 2, I can't solve.")
            return ""
        }
        var result = ""
        if a != nil, a != 0 {
            result += a! != zero ? "\(a!.clean) * X^2" : ""
        }
        if b != nil {
            switch b! {
            case 1... :
                result += result.count > 0 ? " + " : ""
                result += "\(b!.clean) * X"
            case 1 :
                result += result.count > 0 ? " + " : ""
                result += "X"
            case -1 :
                result += result.count > 0 ? " - " : "-"
                result += "X"
            case ..<0 :
                result += result.count > 0 ? " - " : "-"
                let positiveB = b! * (-1)
                result += "\(positiveB.clean) * X"
            default:
                break
            }
        }
        if c != nil {
            switch c! {
            case 0... :
                result += result.count > 0 ? " + " : ""
                result += "\(c!.clean)"
            case ..<0 :
                result += result.count > 0 ? " - " : "-"
                let positiveC = c! * (-1)
                result += "\(positiveC.clean)"
            default:
                break
            }
        }
        result += result.count > 0 ? " = 0" : ""
        return result
    }
    
    private func findDiscriminant() -> Float {
        
        //d = b^2 =4ac
        let discriminant: Float = powf(b!, 2) - 4 * a! * c!
        print(discriminant)
        if discriminant > 0 {
            self.discriminantStatusText = discriminantPositiveText
        } else if discriminant < 0 {
            self.discriminantStatusText = discriminantNegativeText
        }
        return discriminant
    }
    
    private func quadraticEquationSolution(discriminant: Float) {
        //-b + \d /2a //-b - \d /2a
        let negativeB = 0 - b!
        let sqrtD = sqrtf(discriminant)
        let x1 = (negativeB + sqrtD) / (2 * a!)
        print("x1", x1)
        solutionText = x1.clean
        if discriminant > 0 {
            let x2 = (negativeB - sqrtD) / (2 * a!)
            print("x2", x2.clean)
            solutionText += "\n" + x2.clean
        }
    }
    
    private func simpleEquationSolution() {
        self.c = 0 - c!
        let x = c! / b!
        print("x", x)
        solutionText = x.clean
    }
    
    
    @IBAction func calculateButtonAction(_ sender: Any) {
        guard let inputString = inputTextField.text, inputString != "" else { return }
        
        let isParsing = parsingEquation(input: inputString)
        if isParsing.result == true {
            reducedForm = equationReduction(multiplicands: isParsing.multiplicands!, multiplier: isParsing.multiplier!)
            if polynomialDegree == 0, reducedForm == "0 = 0" {
                discriminantStatusText = "All the real numbers are solution"
            } else if self.a == nil || self.a == 0 {
                simpleEquationSolution()
            } else {
                discriminant = findDiscriminant()
                if discriminant! >= zero {
                    quadraticEquationSolution(discriminant: discriminant!)
                }
                discriminantStatusLabel.text = discriminant! > zero ? discriminantPositiveText : discriminantNegativeText
            }
            
            ReducedFormLabel.text = reducedFormText + " " + reducedForm
            polynomialDegreeLabel.text = polynomialDegreeText + " " + String(polynomialDegree)
            discriminantStatusLabel.text = discriminant == nil ? discriminantStatusText : discriminantStatusLabel.text
            solutionsLabel.text = solutionText
            
        } else {
            ReducedFormLabel.text = reducedFormText
            polynomialDegreeLabel.text = polynomialDegreeText
            discriminantStatusLabel.text = isParsing.error
            solutionsLabel.text = ""
        }
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
