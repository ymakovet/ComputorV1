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
    func show(discriminant: Discriminant)
    func show(solution: String)
}

enum Discriminant {
    case positive
    case negative
    case zero
    case error
    case empty
}

enum Status {
    case success
    case error
}

final class Comp {

    private var delegate: ShowResultDelegate!
    
    private var a: Float = 0
    private var b: Float = 0
    private var c: Float = 0
    
    private var degree = 0
    
    private var status: Status!
    private var errorText = ""
    
    init(delegate: ShowResultDelegate) {
        self.delegate = delegate
    }
    
    private func validation(_ string: String) -> Bool {
        
        let characterset = CharacterSet(charactersIn: "1234567890 X^*-+=.")
        if string.rangeOfCharacter(from: characterset.inverted) != nil {
            print("string contains invalid special characters")
            return false
        }
        
        print("CHAR = ", string.countOf(char: "="))
        if string.countOf(char: "=") != 1 {
            return false
        }
        
        return true
    }
    

    //5 * X^0 + 4 * X^1 - 9.3 * X^2 = 1 * X^0
    
    private func splitIntoOperands(_ input: String) -> [String] {
        
        let parsedString = input.replacingOccurrences(of: " ", with: "")
        let splitForEquals = parsedString.splitToString(separator: "=")
        let splitForPlus = splitForEquals[0].splitToString(separator: "+")
        var result: [String] = []
        for item in splitForPlus  {
            if item.contains("-") {
                let new = item.splitToString(separator: "-")
                if item.first == "-" {
                    result.append("-" + new[0])
                } else {
                    result.append(new[0])
                }
                if new.count > 1 {
                    result.append("-" + new[1])
                }
            } else {
                result.append(item)
            }
        }
        
        print("RESULT - ", result)
        return result
    }
    
    private func getEquals(_ input: String) -> String {
        let newStrInput = input.replacingOccurrences(of: " ", with: "")
        let splitForEquals = newStrInput.splitToString(separator: "=")
        return splitForEquals.last!
    }
    
    
    private func allocationOf(operands: [String]) {
        for operand in operands {
            let res = operand.splitToString(separator: "*")
            let number = String(res.first ?? "")
            let x = res.last
            
            let floatNumber: Float = Float(number) ?? 1
            guard let degreeStr = Float(x!.splitToString(separator: "^").last!) else {
                return
            }
            switch degreeStr {
            case 0:
                c = floatNumber
            case 1:
                b = floatNumber
            case 2:
                a = floatNumber
            case 2...:
                status = .error
                errorText = "Degree more than two"
            default:
                break
            }
        }
    }
    
    private func equationReduction(operands: [String], equals: String) -> String {
        allocationOf(operands: operands)
        
        let res = equals.splitToString(separator: "*")
        var number = String(res.first ?? "")
        let x = res.last
        
        var isNegative: Float = 1
        if number.contains("-") {
            number.removeFirst()
            isNegative = -1
        }
        var floatNumber: Float = Float(number) ?? 1
        floatNumber *= isNegative
        guard let degreeStr = Float(x!.splitToString(separator: "^").last!) else {
            return ""
        }
        switch degreeStr {
        case 0:
            c += -floatNumber
        case 1:
            b += -floatNumber
        case 2:
            a += -floatNumber
        case 2...:
            status = .error
            errorText = "Degree more than two"
            return "Degree more than two"
        default:
            break
        }
        var redusedFormString = ""
        if a != 0 { // a < 0 ? "-" : ""
            degree = 2
            redusedFormString = redusedFormString + (a < 0 ? "" : "+") + "\(a.clean)*X^2"
        }
        if b != 0 {
            degree = degree < 1 ? 1 : degree
            redusedFormString = redusedFormString + (b < 0 ? "" : "+") + "\(b.clean)*X^1"
        }
        if c != 0 {
            redusedFormString = redusedFormString + (c < 0 ? "" : "+") + "\(c.clean)*X^0"
        }
        
        if a == 0, b == 0, c == 0 {
            redusedFormString = "0 = 0"//"All the real numbers are solution"
        } else {
            
            redusedFormString = redusedFormString + "=0"
            print(redusedFormString)
            
            if redusedFormString.first == "+" {
                redusedFormString.removeFirst()
            }
            redusedFormString = redusedFormString.replacingOccurrences(of: "+", with: " + ")
            redusedFormString = redusedFormString.replacingOccurrences(of: "-", with: " - ")
            redusedFormString = redusedFormString.replacingOccurrences(of: "*", with: " * ")
            redusedFormString = redusedFormString.replacingOccurrences(of: "=", with: " = ")
            if redusedFormString.first == " " {
                redusedFormString.removeFirst()
                redusedFormString.removeFirst()
                redusedFormString.removeFirst()
                redusedFormString = "-" + redusedFormString
            }
        }
        return redusedFormString
    }
    
    private func simpleEquationSolution() -> String {
        guard b != 0 else {
            return "Wrong equation."
        }
        c = -c
        let x = c / b
        print("simple solution x - ", x)
//                solutionText = x.clean
        return String(x)
    }
    
    private func findDiscriminant() -> Float {
        // d = b^2 =4ac
        let discriminant: Float = powf(b, 2) - 4 * a * c
        print("discriminant - ", discriminant)

        return discriminant
    }
    
    private func quadraticEquationSolution(discriminant: Float) -> String {
        var solution = ""
        let negativeB = -b
        let sqrtD = sqrtf(discriminant)
        let x1 = (negativeB + sqrtD) / (2 * a)
        solution = String(x1.clean)
        print("x1 - ", x1)
        
        if discriminant > 0 {
            let x2 = (negativeB - sqrtD) / (2 * a)
            print("x2 - ", x2.clean)
            solution = solution + "\n" + String(x2.clean)
        }
        return solution
    }
    
    func findSolution(input: String) {
        a = 0
        b = 0
        c = 0
        degree = 0
        
        guard validation(input) else {
            return
        }
        let operands = splitIntoOperands(input)
        let equals = getEquals(input)
        let reducedForm = equationReduction(operands: operands, equals: equals)
        delegate.show(redusedForm: reducedForm)
        
        if status == .error {
            delegate.show(redusedForm: "")
            delegate.show(polynomialDegree: "")
            delegate.show(discriminant: .empty)
            delegate.show(solution: errorText)
        } else if reducedForm == "0 = 0" {
            delegate.show(polynomialDegree: String(degree))
            delegate.show(discriminant: .error)
            delegate.show(solution: "")
        } else if a == 0 {
            let result = simpleEquationSolution()
            delegate.show(discriminant: .zero)
            delegate.show(solution: result)
            delegate.show(polynomialDegree: String(degree))
            print(result)
        } else {
            let discriminant = findDiscriminant()
            
            if discriminant >= 0 {
               let solution = quadraticEquationSolution(discriminant: discriminant)

                delegate.show(polynomialDegree: String(degree))
                delegate.show(discriminant: discriminant == 0 ? .zero : .positive)
                delegate.show(solution: solution)
            } else {
                delegate.show(discriminant: .negative)
            }
        }
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
            
    //        if discriminant > 0 {
    //            self.discriminant = .positive
    //        } else if discriminant < 0 {
    //            self.discriminant = .negative
    //        } else {
    //            self.discriminant = .zero
    //        }
    
    
    
    
    
    
    
    
//
//    var reducedForm = ""
//    var discriminantStatusText = "The solution is: "
//    var solutionText = ""
//
//    var discriminant: Discriminant!
//    var polynomialDegree = 0
//
//    let zero: Float = 0
//
//    var a: Float = 0
//    var b: Float = 0
//    var c: Float = 0
//
//    private func quadraticEquationSolution(discriminant: Float) {
//        let negativeB = -b
//        let sqrtD = sqrtf(discriminant)
//        let x1 = (negativeB + sqrtD) / (2 * a)
//        print("x1", x1)
//        solutionText = x1.clean
//        if discriminant > 0 {
//            let x2 = (negativeB - sqrtD) / (2 * a)
//            print("x2", x2.clean)
//            solutionText += "\n" + x2.clean
//        }
//    }
//
//    private func simpleEquationSolution() {
//        self.c = -c
//        let x = c / b
//        print("x", x)
//        solutionText = x.clean
//    }
//
//    private func findDiscriminant() -> Float {
//
//        // d = b^2 =4ac
//        let discriminant: Float = powf(b, 2) - 4 * a * c
//        print(discriminant)
//
//        if discriminant > 0 {
//            self.discriminant = .positive
//        } else if discriminant < 0 {
//            self.discriminant = .negative
//        } else {
//            self.discriminant = .zero
//        }
//        return discriminant
//    }
//
//    private func equationReduction(multiplicands: String, multiplier: String) -> String {
//        switch multiplier {
//        case "X^0":
//            self.c -= Float(multiplicands)!
//        case "X^1":
//            self.b -= Float(multiplicands)!
//        case "X^2":
//            self.a -= Float(multiplicands)!
//        default:
//            print("The polynomial degree is stricly greater than 2, I can't solve.")
//            return ""
//        }
//        var result = ""
//        if a != 0 {
//            result += a != zero ? "\(a.clean) * X^2" : ""
//        }
//        if b != 0 {
//            switch b {
//            case 1... :
//                result += result.count > 0 ? " + " : ""
//                result += "\(b.clean) * X"
//            case 1 :
//                result += result.count > 0 ? " + " : ""
//                result += "X"
//            case -1 :
//                result += result.count > 0 ? " - " : "-"
//                result += "X"
//            case ..<0 :
//                result += result.count > 0 ? " - " : "-"
//                let positiveB = b * (-1)
//                result += "\(positiveB.clean) * X"
//            default:
//                break
//            }
//        }
//        if c != nil {
//            switch c {
//            case 0... :
//                result += result.count > 0 ? " + " : ""
//                result += "\(c.clean)"
//            case ..<0 :
//                result += result.count > 0 ? " - " : "-"
//                let positiveC = c * (-1)
//                result += "\(positiveC.clean)"
//            default:
//                break
//            }
//        }
//        result += result.count > 0 ? " = 0" : ""
//        return result
//    }
//
//    private func validation(input: String) -> Bool {
//        let string = "1234567890 X^*-+=."
//
//        for char in input {
//            if string.contains(char) {
//                continue
//            }
//            print("error")
//            //            inputTextField.text?.removeAll()
//            return false
//        }
//
//        guard input.contains("=") else {
//            return false
//        }
//        return true
//    }
//
//    private func getPartOfEquation(input: String) -> (right: [Substring], left: [Substring]) {
//        let newString = input.replacingOccurrences(of: " ", with: "")
//        let inputArr = newString.split(separator: "=")
//
//        let leftbyplus = inputArr[0].replacingOccurrences(of: "+", with: " +")
//        let leftbyminus = leftbyplus.replacingOccurrences(of: "-", with: " -")
//        let left = leftbyminus.split(separator: " ")
//        let right = inputArr[1].split(separator: "*")
//        return(right, left)
//    }
//
//    private func xWithMultiplicands(_ mult: [Substring]) -> Bool {
//
//        let degree = String(mult[1])
//        switch degree {
//        case "X^0":
//            self.c = Float(mult[0])!
//        case "X^1", "X":
//            self.b = Float(mult[0])!
//            polynomialDegree = polynomialDegree < 1 ? 1 : polynomialDegree
//        case "X^2":
//            self.a = Float(mult[0])!
//            polynomialDegree = polynomialDegree < 2 ? 2 : polynomialDegree
//        default:
//            return false
//        }
//        return true
//    }
//
//    private func xWithOutMultiplicands(degree: String) -> Bool {
//        //        var degree = String(mult[0])
//        switch degree {
//        case "X^0", "+X^0":
//            self.c = 1
//        case "-X^0":
//            self.c = -1
//        case "X^1", "X", "+X^1", "+X":
//            self.b = 1
//            polynomialDegree = polynomialDegree < 1 ? 1 : polynomialDegree
//        case "-X^1", "-X":
//            self.b = -1
//            polynomialDegree = polynomialDegree < 1 ? 1 : polynomialDegree
//        case "X^2", "+X^2":
//            self.a = 1
//            polynomialDegree = polynomialDegree < 2 ? 2 : polynomialDegree
//        case "-X^2":
//            self.a = -1
//            polynomialDegree = polynomialDegree < 2 ? 2 : polynomialDegree
//        default:
//            if let floatDegree = Float(degree) {
//                self.c = floatDegree
//                break
//            }
//            return false
//        }
//        return true
//    }
//
//    private func parsingEquation(input: String) -> (result: Bool, error: String?, multiplicands: String?, multiplier: String?) {
//        let parts = getPartOfEquation(input: input)
//        let left = parts.left
//        let right = parts.right
//
//        var multiplicandsRight = ""
//        var multiplierRight = ""
//
//        if right.count > 1 {
//            multiplicandsRight = String(right[0])
//            multiplierRight = String(right[1])
//        } else {
//            multiplicandsRight = "1"
//            multiplierRight = String(right[0])
//        }
//        print("left", left)
//        print("right", right)
//        print("multiplicandsRight, multiplierRight", multiplicandsRight, multiplierRight)
//
//        for item in left {
//            let mult = item.split(separator: "*")
//            if mult.count > 1 {
//                if xWithMultiplicands(mult) == false {
//                    let errorText = "The polynomial degree is stricly greater than 2, I can't solve."
//                    return (false, errorText, nil, nil)
//                }
//            } else {
//                if xWithOutMultiplicands(degree: String(mult[0])) == false {
//                    let errorText = "The polynomial degree is stricly greater than 2, I can't solve."
//                    return (false, errorText, nil, nil)
//                }
//            }
//        }
//        print("a - ", a, "b  - ", b, "c - ", c)
//
//        return (true, nil, multiplicandsRight, multiplierRight)
//    }
//
//    func findSolution(inputString: String) {
//        guard validation(input: inputString) else {
//            delegate.show(redusedForm: "Error Input")
//            delegate.show(polynomialDegree: "")
//            delegate.show(discriminant: .zero)
//            delegate.show(solution: "")
//            return
//        }
//
//        let isParsing = parsingEquation(input: inputString)
//
//        guard isParsing.result == true else {
//            delegate.show(redusedForm: isParsing.error ?? "Error Input")
//            delegate.show(polynomialDegree: "")
//            delegate.show(discriminant: .zero)
//            delegate.show(solution: "")
//            return
//        }
//
//        reducedForm = equationReduction(multiplicands: isParsing.multiplicands!, multiplier: isParsing.multiplier!)
//
//        if polynomialDegree == 0, reducedForm == "0 = 0" {
//            discriminantStatusText = "All the real numbers are solution"
//        } else if self.a == 0 {
//            simpleEquationSolution()
//            delegate.show(discriminant: .zero)
//        } else {
//            let disc = findDiscriminant()
//
//            if self.discriminant == .positive || self.discriminant == .zero {
//                quadraticEquationSolution(discriminant: disc)
//            }
//
//            delegate.show(discriminant: self.discriminant)
//        }
//        delegate.show(redusedForm: reducedForm)
//        delegate.show(polynomialDegree: String(polynomialDegree))
//        delegate.show(solution: solutionText)
//    }
//
}
