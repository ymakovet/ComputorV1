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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        calculateButtonOutlet.layer.cornerRadius = 10
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func parsingEquation(input: String) {
        let string = "1234567890 X^*-+="
        
        for char in input {
            if string.contains(char) {
                continue
            }
            print("error")
            inputTextField.text?.removeAll()
            return
        }
        
        guard input.contains("=") else { return }
        
    }

    @IBAction func calculateButtonAction(_ sender: Any) {
        guard let inputString = inputTextField.text, inputString != "" else { return }
        
        parsingEquation(input: inputString)
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
