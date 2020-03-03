//
//  Extension+Float.swift
//  ComputorV1
//
//  Created by Yuliia MAKOVETSKAYA on 2/25/20.
//  Copyright © 2020 Yuliia MAKOVETSKAYA. All rights reserved.
//

import Foundation

extension Float {
    var clean: String {
        return self.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", self) : String(self)
    }
}
