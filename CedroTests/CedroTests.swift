//
//  CedroTests.swift
//  CedroTests
//
//  Created by Gustavo Gomes de Oliveira on 12/05/18.
//  Copyright © 2018 Gustavo Gomes de Oliveira. All rights reserved.
//

import XCTest
@testable import Cedro


class CedroTests: XCTestCase {
    
    
    //Devido a problemas de code signing, no qual não consegui resolver, não foi possível
    //inserir os testes necessários
    
    func testaRecuperacaoDeSite() {
        let site = Site()
        site.urlSite =  site.recuperarURLSite(posicao: "0")
        XCTAssertNotNil(site.urlSite)
    }
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
