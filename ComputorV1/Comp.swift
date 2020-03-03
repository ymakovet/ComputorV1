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

enum TypeError {
    case none
    case syntaxis
    case lexical
    case wrongequation
    case degree
}

struct ComputorV1 {

    private var delegate: ShowResultDelegate!
    
    private var a: Float = 0
    private var b: Float = 0
    private var c: Float = 0
    
    private var degree = 0
    
    private var error: TypeError = .none
    
    init(delegate: ShowResultDelegate) {
        self.delegate = delegate
    }

    private mutating func checkingForTwoCharactersInARow(_ string: String) -> TypeError {
        var lastsign = ""
        for char in string {
            if lastsign == "^", char.isNumber == false {
                return .syntaxis
            }
            if "+-^=*".contains(char) {
                if "+-^=*".contains(lastsign) && (char != "-" || lastsign != "=") {
                    return .syntaxis
                }
                lastsign = String(char)
            } else {
                lastsign = ""
            }
        }
        return .none
    }
    
    private mutating func validation(_ string: String) -> TypeError {
        
        let characterset = CharacterSet(charactersIn: "1234567890 X^*-+=.")
        if string.rangeOfCharacter(from: characterset.inverted) != nil {
            print("string contains invalid special characters")
            return .lexical
        }
        
        print("CHAR = ", string.countOf(char: "="))
        if string.countOf(char: "=") != 1 {
            return .syntaxis
        }
        
        if string.last == "+" || string.last == "-" || string.last == "^" || string.last == "=" || string.last == "*" {
            return .syntaxis
        }
        
        if !string.contains("X") {
            return .syntaxis
        }
        
        return checkingForTwoCharactersInARow(string)
    }
    
    private func splitIntoOperands(_ input: String) -> [String] {
        
        let parsedString = input.replacingOccurrences(of: " ", with: "")
        let splitForPlus = parsedString.splitToString(separator: "+")
        
        var result: [String] = []
        for item in splitForPlus  {
            
            if !item.contains("-") {
                result.append(item)
                continue
            }
            
            let new = item.splitToString(separator: "-")
            if item.first == "-" {
                result.append("-" + new[0])
            } else {
                result.append(new[0])
            }
            if new.count > 1 {
                result.append("-" + new[1])
            }
            
        }
        
        print("RESULT - ", result)
        return result
    }
    
    private mutating func allocationOf(operands: [String]) {
        for operand in operands {
            let res = operand.splitToString(separator: "*")
            let number = String(res.first ?? "")
            let x = res.last
            let floatNumber: Float = Float(number) ?? 1
            
            if res.count == 1 && !number.contains("X") {
                c = floatNumber
                continue
            }
            if x == "X" {
                b = floatNumber
                continue
            }
            
            if let degree = Float(x!.splitToString(separator: "^").last!) {
  
                switch degree {
                case 0:
                    c = floatNumber
                case 1:
                    b = floatNumber
                case 2:
                    a = floatNumber
                case 2...:
                    self.degree = Int(degree)
                    error = .degree
                default:
                    break
                }
            }
        }
    }
    
    private mutating func reduction(equals: [String]) {
        for operand in equals {
            let res = operand.splitToString(separator: "*")
            var number = String(res.first ?? "")
            let x = res.last ?? ""
            
            var isNegative: Float = 1
            if number.contains("-") {
                number.removeFirst()
                isNegative = -1
            }
            
            var floatNumber: Float = Float(number) ?? 1
            floatNumber *= isNegative
            
            if Float(x) != nil {
                c += -floatNumber
                continue
            }
            
            guard let degree = Float(x.splitToString(separator: "^").last!) else {
                return
            }
            
            switch degree {
            case 0:
                c += -floatNumber
            case 1:
                b += -floatNumber
            case 2:
                a += -floatNumber
            case 2...:
                self.degree = Int(degree)
                error = .degree
            default:
                break
            }
        }
    }
    
    
    private mutating func equationReduction(operands: [String], equals: [String]) -> String {
        allocationOf(operands: operands)
        reduction(equals: equals)
        if error != .none {
            return ""
        }
        print("a - ", a, "b - ", b, "c - ", c)
        
        var redusedFormString = ""
        if a != 0 {
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
            redusedFormString = "0 = 0"
        } else {
            redusedFormString = redusedFormString + "=0"
            redusedFormString.addSpaces()
            print(redusedFormString)
        }
        return redusedFormString
    }
    
    private mutating func simpleEquationSolution() -> String {
        guard b != 0 else {
            error = .wrongequation
            return ""
        }
        c = c * (-1)
        let x = c / b
        return String(x.clean)
    }
    
    private func findDiscriminant() -> Float {
        // d = b^2 =4ac
        let discriminant: Float = powf(b, 2) - 4 * a * c
        print("discriminant - ", discriminant)

        return discriminant
    }
    
    private func quadraticEquationSolution(discriminant: Float) -> String {
        var solution = ""
        let negativeB = b * (-1)
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
    
    mutating func findSolution(input: String) {
        let validation = self.validation(input)
        if validation != .none {
            delegate.show(redusedForm: "")
            error = validation
            showResults(solution: "", discriminant: .empty, polynominalDegree: "")
            return
        }
        
        let splitForEquals = input.splitToString(separator: "=")
        let operands = splitIntoOperands(splitForEquals[0])
        let equals = splitIntoOperands(splitForEquals[1])
    
        let reducedForm = equationReduction(operands: operands, equals: equals)
        delegate.show(redusedForm: reducedForm)
        
        guard error == .none else {
            showResults(solution: "", discriminant: .empty, polynominalDegree: String(degree))
            return
        }
        
        guard reducedForm != "0 = 0"  else {
            showResults(solution: "", discriminant: .error, polynominalDegree: String(degree))
            return
        }
        
        if a == 0 {
            let result = simpleEquationSolution()
            showResults(solution: result, discriminant: .zero, polynominalDegree: String(degree))
        } else {
            let discriminant = findDiscriminant()
            
            if discriminant >= 0 {
                let solution = quadraticEquationSolution(discriminant: discriminant)
                showResults(solution: solution, discriminant: discriminant == 0 ? .zero : .positive, polynominalDegree: String(degree))
            } else {
                showResults(solution: "", discriminant: .negative, polynominalDegree: "")
            }
        }
    }
    
    private func showResults(solution: String, discriminant: Discriminant, polynominalDegree: String) {
        
        var text = ""
        var disc: Discriminant = .empty
        var degree = ""
        
        switch error {
        case .none:
            text = solution == "-0" ? "0" : solution
            disc = discriminant
            degree = polynominalDegree
        case .syntaxis:
            text = "Syntaxis error."
        case .lexical:
            text = "Lexical error."
        case .wrongequation:
            text = "Wrong equation."
        case .degree:
            text = "Degree more than two."
        }
        delegate.show(polynomialDegree: degree)
        delegate.show(discriminant: disc)
        delegate.show(solution: text)
    }
}
