//
//  Extension+String.swift
//  ComputorV1
//
//  Created by Yuliia MAKOVETSKAYA on 2/26/20.
//  Copyright © 2020 Yuliia MAKOVETSKAYA. All rights reserved.
//

import Foundation

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
    
    mutating func addSpaces() {
        if self.first == "+" {
            self.removeFirst()
        }
        self = self.replacingOccurrences(of: "+", with: " + ")
        self = self.replacingOccurrences(of: "-", with: " - ")
        self = self.replacingOccurrences(of: "*", with: " * ")
        self = self.replacingOccurrences(of: "=", with: " = ")
        if self.first == " " {
            self.removeFirst()
            self.removeFirst()
            self.removeFirst()
            self = "-" + self
        }
    }
}
