//
//  Operators.swift
//  Demo
//
//  Created by Maria Fossli on 20.11.2016.
//  Copyright © 2016 Acme. All rights reserved.
//

import XCTest
import amoeba

class OperatorsTest: XCTestCase {
    
    func testBasics() {
        let solver = Solver()
        let v = Variable()
        try solver.add(constraint: v + 2)
    }
    
}
