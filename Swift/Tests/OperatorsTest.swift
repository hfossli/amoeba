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
        let solver = Solver(debug: true)
        do {
            let v = Variable()
            try solver.add(v + 2 == 0)
        } catch let error {
            XCTFail("Unexpected error \(error)")
            print("\(solver.allActions().joined(separator: ";\n"))")
        }
    }
    
    func testOverconstrained1() {
        let solver = Solver(debug: true)
        do {
            let v = Variable()
            try solver.add(v == 5)
            try solver.add(v == 10)
            XCTFail("Should not reach this line")
            print("\(solver.allActions().joined(separator: ";\n"))")
        } catch let error as AmoebaError {
            switch error {
            case .unsatisfied:
                break
            default:
                XCTFail("Didn't expect \(error)")
                break
            }
        } catch let error {
            XCTFail("Didn't expect \(error)")
        }
    }
    
    func testOverconstrained2() {
        let solver = Solver(debug: true)
        do {
            let v = Variable()
            try solver.add(v <= 10)
            try solver.add(v >= 20)
            XCTFail("Should not reach this line.")
            print("\(solver.allActions().joined(separator: ";\n"))")
        } catch let error as AmoebaError {
            switch error {
            case .unbound:
                break
            default:
                XCTFail("Didn't expect \(error)")
                break
            }
        } catch let error {
            XCTFail("Didn't expect \(error)")
        }
    }
    
    func testOverconstrained3() {
        let solver = Solver(debug: true)
        do {
            let v = Variable()
            try solver.add(v >= 10)
            try solver.add(v <= 20)
        } catch let error {
            XCTFail("Should not throw \(error).")
            print("\(solver.allActions().joined(separator: ";\n"))")
        }
    }
    
    func testOverconstrained4() {
        let solver = Solver(debug: true)
        do {
            let v = Variable()
            try solver.add(v == v)
            XCTFail("Should not reach this line. ")
            print("\(solver.allActions().joined(separator: ";\n"))")
        } catch let error as AmoebaError {
            switch error {
            case .unbound:
                break
            default:
                XCTFail("Didn't expect \(error)")
                break
            }
        } catch let error {
            XCTFail("Didn't expect \(error)")
        }
    }
    
}
