//
//  Comp.swift
//  ComputorV1
//
//  Created by Yuliia MAKOVETSKAYA on 2/19/20.
//  Copyright © 2020 Yuliia MAKOVETSKAYA. All rights reserved.
//

import Foundation


protocol ShowResultDelegate {
    func show(redusedForm: String)
    func show(polynomialDegree: String)
    func show(discriminantText: String)
    func show(solution: String)
}

final class Comp {

    
    private var delegate: ShowResultDelegate!
    init(delegate: ShowResultDelegate) {
        self.delegate = delegate
    }
    
    let reducedFormText = "Reduced form:"
    let polynomialDegreeText = "Polynomial degree:"
    let discriminantPositiveText = "Discriminant is strictly positive, the two solutions are:"
    let discriminantNegativeText = "The discriminant is strictly negative, there is no solution:"

    var reducedForm = ""
    var discriminantStatusText = "The solution is:"
    var solutionText = ""
    
    var discriminant: Float?
    var polynomialDegree = 0
    
    let zero: Float = 0
    
    var a: Float?
    var b: Float?
    var c: Float?
    
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
    
    
    
    
    
    private func validation(input: String) -> Bool {
        let string = "1234567890 X^*-+=."
        
        for char in input {
            if string.contains(char) {
                continue
            }
            print("error")
            //            inputTextField.text?.removeAll()
            return false
        }
        
        guard input.contains("=") else {
            return false
        }
        return true
    }
    
    private func getPartOfEquation(input: String) -> (right: [Substring], left: [Substring]) {
        let newString = input.replacingOccurrences(of: " ", with: "")
        let inputArr = newString.split(separator: "=")
        
        let leftbyplus = inputArr[0].replacingOccurrences(of: "+", with: " +")
        let leftbyminus = leftbyplus.replacingOccurrences(of: "-", with: " -")
        let left = leftbyminus.split(separator: " ")
        let right = inputArr[1].split(separator: "*")
        return(right, left)
    }
    
    private func xWithMultiplicands(_ mult: [Substring]) -> Bool {
        
        let degree = String(mult[1])
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
            return false
        }
        return true
    }
    
    private func xWithOutMultiplicands(degree: String) -> Bool {
        //        var degree = String(mult[0])
        switch degree {
        case "X^0", "+X^0":
            self.c = 1
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
            return false
        }
        return true
    }
    
    private func parsingEquation(input: String) -> (result: Bool, error: String?, multiplicands: String?, multiplier: String?) {
        
        
        let parts = getPartOfEquation(input: input)
        let left = parts.left
        let right = parts.right
        
        var multiplicandsRight = ""
        var multiplierRight = ""
        
        if right.count > 1 {
            multiplicandsRight = String(right[0])
            multiplierRight = String(right[1])
        } else {
            multiplicandsRight = "1"
            multiplierRight = String(right[0])
        }
        print("left", left)
        print("right", right)
        print("multiplicandsRight, multiplierRight", multiplicandsRight, multiplierRight)
        
        for item in left {
            let mult = item.split(separator: "*")
            if mult.count > 1 {
                if xWithMultiplicands(mult) == false {
                    let errorText = "The polynomial degree is stricly greater than 2, I can't solve."
                    return (false, errorText, nil, nil)
                }
            } else {
                if xWithOutMultiplicands(degree: String(mult[0])) == false {
                    let errorText = "The polynomial degree is stricly greater than 2, I can't solve."
                    return (false, errorText, nil, nil)
                }
            }
        }
        print("a - ", a, "b  - ", b, "c - ", c)
        
        return (true, nil, multiplicandsRight, multiplierRight)
    }
    
    
    
    
    
    
    func findSolution(inputString: String) {
        guard validation(input: inputString) else {
            delegate.show(redusedForm: "")
            delegate.show(polynomialDegree: "")
            delegate.show(discriminantText: "Error")
            delegate.show(solution: "")
            return
        }
        
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
                
                delegate.show(discriminantText: discriminant! > zero ? discriminantPositiveText : discriminantNegativeText)
            }
            
            delegate.show(redusedForm: reducedForm)
            delegate.show(polynomialDegree: String(polynomialDegree))
            delegate.show(discriminantText: "discriminant")
            delegate.show(solution: solutionText)
            
        } else {
            
            delegate.show(redusedForm: "")
            delegate.show(polynomialDegree: "")
            delegate.show(discriminantText: isParsing.error ?? "error")
            delegate.show(solution: "")
            //            ReducedFormLabel.text = reducedFormText
            //            polynomialDegreeLabel.text = polynomialDegreeText
            //            discriminantStatusLabel.text = isParsi"ng.error
            //            solutionsLabel.text = ""
        }
    }
    
}
