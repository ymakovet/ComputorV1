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
    //"5 * X^0 + 4 * X^1 + 9.3 * X^2 = 1 * X^0"
    //"5 * X^0 + 4 * X^1 = 4 * X^0
    var reducedForm = ""
    var discriminantStatusText = "The solution is:"
    var a: Float?
    var b: Float?
    var c: Float?
    var polynomialDegree = 0
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
        let left = inputArr[0].split(separator: "+")
//        let neR = inputArr[1].replacingOccurrences(of: " ", with: "")
        let right = inputArr[1].split(separator: "*")
        let multiplicandsRight = String(right[0])
        let multiplierRight = String(right[1])
        print("newString", newString)
        print("inputArr", inputArr)
        print("left", left)
        print("right", right)
        print("multiplicandsRight, multiplierRight", multiplicandsRight, multiplierRight)
        
        for item in left {
            let mult = item.split(separator: "*")
            let degree =  String(mult[1])

            switch degree {
            case "X^0":
                self.c = Float(mult[0])
            case "X^1":
                self.b = Float(mult[0])
                polynomialDegree = polynomialDegree < 1 ? 1 : polynomialDegree
            case "X^2":
                self.a = Float(mult[0])
                polynomialDegree = polynomialDegree < 2 ? 2 : polynomialDegree
            default:
                let errorText = "The polynomial degree is stricly greater than 2, I can't solve."
                return (false, errorText, nil, nil)
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
        return "\(a!) * X^2 + \(b!) * X^1 + \(c!) * X^0 = 0"
    }
    
    private func solution(discriminant: Float) {
        //-b + \d /2a //-b - \d /2a
        var negativeB = 0 - b!
        var sqrtD = sqrtf(discriminant)
        let x1 = (negativeB + sqrtD) / (2 * a!)
        print(x1)
        if discriminant > 0 {
            let x2 = 0 - b! - sqrtf(discriminant) / 2 * a!
            print(x2)
        }
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
    
    @IBAction func calculateButtonAction(_ sender: Any) {
        guard let inputString = inputTextField.text, inputString != "" else { return }
        
        let isParsing = parsingEquation(input: inputString)
        if isParsing.result == true {
            reducedForm = equationReduction(multiplicands: isParsing.multiplicands!, multiplier: isParsing.multiplier!)
            let discriminant = findDiscriminant()
            if discriminant >= 0 {
                solution(discriminant: discriminant)
            }
        } else {
            ReducedFormLabel.text = reducedFormText
            polynomialDegreeLabel.text = polynomialDegreeText
            discriminantStatusLabel.text = isParsing.error
            solutionsLabel.text = ""
        }
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}


//            let forMinus = inputArr[0].split(separator: "-")
//            var forPlus: [Substring] = []
//            var ostatok: Substring = ""
//            if forMinus[0].contains("+") {
//                forPlus = forMinus[0].split(separator: "+")
//                ostatok = forMinus[1]
//            } else if forMinus[1].contains("+") {
//                forPlus = forMinus[1].split(separator: "+")
//                ostatok = forMinus[0]
//            }
//            if forPlus.count > 0 {
//                forPlus.append(ostatok)
//
//            }
