//
//  Operators.swift
//  Demo
//
//  Created by Maria Fossli on 20.11.2016.
//  Copyright © 2016 Acme. All rights reserved.
//

import XCTest
@testable import amoeba

class OperatorsTest: XCTestCase {
    
    func testBasics() {
        do {
            let solver = Solver()
            let v = Variable()
            try solver.add(v + 2 == 0)
        } catch let error {
            XCTFail("Unexpected error \(error)")
        }
    }
    
}
