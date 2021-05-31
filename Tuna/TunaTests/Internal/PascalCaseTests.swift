//
//  PascalCaseTests.swift
//  TunaTests
//
//  Created by Guilherme Rambo on 18/03/21.
//

import XCTest
@testable import Tuna

final class PascalCaseTests: XCTestCase {
    
    private struct TestEntity: Codable, Hashable {
        let message: String
        let sessionId: String
        let sA: String
        let reallyLongKeyWithLotsOfWords: String
        
        static let testPayload: Data = {
            Data("""
            {"Message": "Test", "SessionId": "XXXXXXX", "SA": "1", "ReallyLongKeyWithLotsOfWords": "123"}
            """.utf8)
        }()
        
        static let expectedResult: TestEntity = {
            TestEntity(
                message: "Test",
                sessionId: "XXXXXXX",
                sA: "1",
                reallyLongKeyWithLotsOfWords: "123"
            )
        }()
    }
    
    func testConvertFromPascalCase() throws {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromPascalCase
        
        let parsedEntity = try decoder.decode(TestEntity.self, from: TestEntity.testPayload)
        
        XCTAssertEqual(parsedEntity, TestEntity.expectedResult)
    }
    
    func testConvertToPascalCase() throws {
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToPascalCase
        
        let convertedPayload = try encoder.encode(TestEntity.expectedResult)
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromPascalCase
        
        let parsedEntity = try decoder.decode(TestEntity.self, from: convertedPayload)
        
        XCTAssertEqual(parsedEntity, TestEntity.expectedResult)
    }
    
}
