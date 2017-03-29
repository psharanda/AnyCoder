//
//  Created by Pavel Sharanda on 10.03.17.
//  Copyright © 2017 Pavel Sharanda. All rights reserved.
//

import XCTest
import AnyCoder

#if os(macOS)
    public typealias Color = NSColor
#else
    public typealias Color = UIColor
#endif

class AnyCoderTests: XCTestCase {
    
    enum TestStringEnum: String, Encodable, Decodable {
        case first
        case second
        case third
    }
    
    enum TestIntEnum: Int, Encodable, Decodable {
        case first = 1
        case second = 2
        case third = 3
    }
    

    struct TestChild: Decodable, Encodable {
        let name: String
        
        init(decoder: Decoder) throws {
            name = try decoder.decode(key: "name")
        }
        
        func encode() -> Any {
            var encoder = Encoder()
            encoder.encode(name, key: "name")
            return encoder.dictionary
        }
    }
    
    struct TestParent: Decodable, Encodable {
        let normalInt: Int
        let optionalInt: Int?
        let normalFloat: Float
        let optionalFloat: Float?
        let normalCGFloat: CGFloat
        let optionalCGFloat: CGFloat?
        let normalDouble: Double
        let optionalDouble: Double?
        let normalBool: Bool
        let optionalBool: Bool?
        let normalColor: Color
        let optionalColor: Color?
        let normalDate: Date
        let optionalDate: Date?
        let normalUrl: URL
        let optionalUrl: URL?
        let normalStringEnum: TestStringEnum
        let optionalStringEnum: TestStringEnum?
        let normalIntEnum: TestIntEnum
        let optionalIntEnum: TestIntEnum?
        let normalChild: TestChild
        let optionalChild: TestChild?
        let normalChildArray: [TestChild]
        let optionalChildArray: [TestChild]?
        let normalChildDictionary: [String: TestChild]
        let optionalChildDictionary: [String: TestChild]?
        let normalChildDictionaryArray: [String: [TestChild]]
        let optionalChildDictionaryArray: [String: [TestChild]]?
        
        init?(decoder: Decoder) throws {
            normalInt = try decoder.decode(key: "normalInt")
            optionalInt = try decoder.decode(key: "optionalInt")
            normalFloat = try decoder.decode(key: "normalFloat")
            optionalFloat = try decoder.decode(key: "optionalFloat")
            normalCGFloat = try decoder.decode(key: "normalCGFloat")
            optionalCGFloat = try decoder.decode(key: "optionalCGFloat")
            normalDouble = try decoder.decode(key: "normalDouble")
            optionalDouble = try decoder.decode(key: "optionalDouble")
            normalBool = try decoder.decode(key: "normalBool")
            optionalBool = try decoder.decode(key: "optionalBool")
            normalColor = try decoder.decode(key: "normalColor")
            optionalColor = try decoder.decode(key: "optionalColor")
            normalDate = try decoder.decode(key: "normalDate")
            optionalDate = try decoder.decode(key: "optionalDate")
            normalUrl = try decoder.decode(key: "normalUrl")
            optionalUrl = try decoder.decode(key: "optionalUrl")
            normalStringEnum = try decoder.decode(key: "normalStringEnum")
            optionalStringEnum = try decoder.decode(key: "optionalStringEnum")
            normalIntEnum = try decoder.decode(key: "normalIntEnum")
            optionalIntEnum = try decoder.decode(key: "optionalIntEnum")
            normalChild = try decoder.decode(key: "normalChild")
            optionalChild = try decoder.decode(key: "optionalChild")
            normalChildArray = try decoder.decode(key: "normalChildArray")
            optionalChildArray = try decoder.decode(key: "optionalChildArray")
            normalChildDictionary = try decoder.decode(key: "normalChildDictionary")
            optionalChildDictionary = try decoder.decode(key: "optionalChildDictionary")
            normalChildDictionaryArray = try decoder.decode(key: "normalChildDictionaryArray")
            optionalChildDictionaryArray = try decoder.decode(key: "optionalChildDictionaryArray")
        }
        
        func encode() -> Any {
            var encoder = Encoder()
            encoder.encode(normalInt, key: "normalInt")
            encoder.encode(optionalInt, key: "optionalInt")
            encoder.encode(normalFloat, key: "normalFloat")
            encoder.encode(optionalFloat, key: "optionalFloat")
            encoder.encode(normalCGFloat, key: "normalCGFloat")
            encoder.encode(optionalCGFloat, key: "optionalCGFloat")
            encoder.encode(normalDouble, key: "normalDouble")
            encoder.encode(optionalDouble, key: "optionalDouble")
            encoder.encode(normalBool, key: "normalBool")
            encoder.encode(optionalBool, key: "optionalBool")
            encoder.encode(normalColor, key: "normalColor")
            encoder.encode(optionalColor, key: "optionalColor")
            encoder.encode(normalDate, key: "normalDate")
            encoder.encode(optionalDate, key: "optionalDate")
            encoder.encode(normalUrl, key: "normalUrl")
            encoder.encode(optionalUrl, key: "optionalUrl")
            encoder.encode(normalStringEnum, key: "normalStringEnum")
            encoder.encode(optionalStringEnum, key: "optionalStringEnum")
            encoder.encode(normalIntEnum, key: "normalIntEnum")
            encoder.encode(optionalIntEnum, key: "optionalIntEnum")
            encoder.encode(normalChild, key: "normalChild")
            encoder.encode(optionalChild, key: "optionalChild")
            encoder.encode(normalChildArray, key: "normalChildArray")
            encoder.encode(optionalChildArray, key: "optionalChildArray")
            encoder.encode(normalChildDictionary, key: "normalChildDictionary")
            encoder.encode(optionalChildDictionary, key: "optionalChildDictionary")
            encoder.encode(normalChildDictionaryArray, key: "normalChildDictionaryArray")
            encoder.encode(optionalChildDictionaryArray, key: "optionalChildDictionaryArray")
            return encoder.dictionary
        }
    }
    

    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testStrictModelWithNulls() {
        
        let strictJSONWithNulls: [String: Any] = [
            "normalInt":1341,
            "optionalInt":NSNull(),
            "normalFloat":24.3 as Float,
            "optionalFloat":NSNull(),
            "normalCGFloat":434.23 as CGFloat,
            "optionalCGFloat":NSNull(),
            "normalDouble":325235325.32,
            "optionalDouble":NSNull(),
            "normalBool":true,
            "optionalBool":NSNull(),
            "normalColor":"#434342",
            "optionalColor":NSNull(),
            "normalDate":423423432 as Double,
            "optionalDate":NSNull(),
            "normalUrl":"http://google.com",
            "optionalUrl":NSNull(),
            "normalStringEnum":"first",
            "optionalStringEnum":NSNull(),
            "normalIntEnum":1,
            "optionalIntEnum":NSNull(),
            "normalChild": ["name": "John"],
            "optionalChild":NSNull(),
            "normalChildArray":[["name": "John"], ["name": "Alexa"]],
            "optionalChildArray":NSNull(),
            "normalChildDictionary":["first": ["name": "John"], "second": ["name": "Alexa"]],
            "optionalChildDictionary":NSNull(),
            "normalChildDictionaryArray":["first": [["name": "John"], ["name": "Alexa"]], "second": [["name": "John"], ["name": "Alexa"]]],
            "optionalChildDictionaryArray":NSNull()
        ]
        
        let testParent = try! Decoder(value: strictJSONWithNulls).decode() as TestParent
        let testJson = testParent.encode()
        
        let testData = try! JSONSerialization.data(withJSONObject: testJson, options: [])
        let refData = try! JSONSerialization.data(withJSONObject: strictJSONWithNulls, options: [])
        XCTAssertEqual(testData, refData)
    }
    
    func testStrictModelNSNumberWithNulls() {
        
        let strictJSONWithNulls: [String: Any] = [
            "normalInt": NSNumber(value: 1341) as Any,
            "optionalInt": NSNull(),
            "normalFloat": NSNumber(value: 24.3) as Any,
            "optionalFloat": NSNull(),
            "normalCGFloat": NSNumber(value: 434.23) as Any,
            "optionalCGFloat": NSNull(),
            "normalDouble": NSNumber(value: 325235325.32) as Any,
            "optionalDouble":NSNull(),
            "normalBool":true,
            "optionalBool":NSNull(),
            "normalColor":"#434342",
            "optionalColor":NSNull(),
            "normalDate": NSNumber(value: 423423432) as Any,
            "optionalDate":NSNull(),
            "normalUrl":"http://google.com",
            "optionalUrl":NSNull(),
            "normalStringEnum":"first",
            "optionalStringEnum":NSNull(),
            "normalIntEnum":1,
            "optionalIntEnum":NSNull(),
            "normalChild": ["name": "John"],
            "optionalChild":NSNull(),
            "normalChildArray":[["name": "John"], ["name": "Alexa"]],
            "optionalChildArray":NSNull(),
            "normalChildDictionary":["first": ["name": "John"], "second": ["name": "Alexa"]],
            "optionalChildDictionary":NSNull(),
            "normalChildDictionaryArray":["first": [["name": "John"], ["name": "Alexa"]], "second": [["name": "John"], ["name": "Alexa"]]],
            "optionalChildDictionaryArray":NSNull()
        ]
        
        let testParent = try! Decoder(value: strictJSONWithNulls).decode() as TestParent
        let testJson = testParent.encode()
        
        let testData = try! JSONSerialization.data(withJSONObject: testJson, options: [])
        let refData = try! JSONSerialization.data(withJSONObject: strictJSONWithNulls, options: [])
        XCTAssertEqual(testData, refData)
    }
    
    func testStrictModelNSNumberWithoutNulls() {
        
        let strictJSONWithNulls: [String: Any] = [
            "normalInt": NSNumber(value: 1341) as Any,
            "optionalInt": NSNumber(value: 1341) as Any,
            "normalFloat": NSNumber(value: 24.3) as Any,
            "optionalFloat": NSNumber(value: 24.3) as Any,
            "normalCGFloat": NSNumber(value: 434.23) as Any,
            "optionalCGFloat": NSNumber(value: 434.23) as Any,
            "normalDouble": NSNumber(value: 325235325.32) as Any,
            "optionalDouble": NSNumber(value: 325235325.32) as Any,
            "normalBool":true,
            "optionalBool": true,
            "normalColor":"#434342",
            "optionalColor":"#434342",
            "normalDate": NSNumber(value: 423423432) as Any,
            "optionalDate":NSNumber(value: 423423432) as Any,
            "normalUrl":"http://google.com",
            "optionalUrl":"http://google.com",
            "normalStringEnum":"first",
            "optionalStringEnum":"first",
            "normalIntEnum":1,
            "optionalIntEnum":1,
            "normalChild": ["name": "John"],
            "optionalChild": ["name": "John"],
            "normalChildArray":[["name": "John"], ["name": "Alexa"]],
            "optionalChildArray":[["name": "John"], ["name": "Alexa"]],
            "normalChildDictionary":["first": ["name": "John"], "second": ["name": "Alexa"]],
            "optionalChildDictionary":["first": ["name": "John"], "second": ["name": "Alexa"]],
            "normalChildDictionaryArray":["first": [["name": "John"], ["name": "Alexa"]], "second": [["name": "John"], ["name": "Alexa"]]],
            "optionalChildDictionaryArray":["first": [["name": "John"], ["name": "Alexa"]], "second": [["name": "John"], ["name": "Alexa"]]]
        ]
        
        do {
            let testParent = try Decoder(value: strictJSONWithNulls).decode() as TestParent
            let testJson = testParent.encode()
            
            let testData = try JSONSerialization.data(withJSONObject: testJson, options: [])
            let refData = try JSONSerialization.data(withJSONObject: strictJSONWithNulls, options: [])
            XCTAssertEqual(testData, refData)
        }
        catch {
            XCTFail("Unexpected error thrown: \(error)")
        }
        
    }
    
    func testMissingKeyException() {
        
        let json: [String: Any] = ["nme": "John"]
        do {
            _ = try Decoder(value: json).decode() as TestChild
            
            XCTFail("Should have thrown")
        }
        catch (let error as DecoderError) {
            if case .missing = error.errorType {
                XCTAssert(true)
            } else {
                XCTFail("Unexpected error thrown: \(error)")
            }
        }
        catch {
            XCTFail("Unexpected error thrown: \(error)")
        }
    }
    
    func testInvalidTypeException() {
        
        let json: [String: Any] = ["name": 123]
        do {
            _ = try Decoder(value: json).decode() as TestChild
            
            XCTFail("Should have thrown")
        }
        catch (let error as DecoderError) {
            if case .invalidType = error.errorType {
                XCTAssert(true)
            } else {
                XCTFail("Unexpected error thrown: \(error)")
            }
        }
        catch {
            XCTFail("Unexpected error thrown: \(error)")
        }
    }
    
    func testFailedException() {
        
        struct TestColor: Decodable {
            let color: Color
            
            init(decoder: Decoder) throws {
                color = try decoder.decode(key: "color")
            }
        }
        
        let json: Any = ["color": "sfsfsdfsdf"]
        do {
            _ = try Decoder(value: json).decode() as TestColor
            
            XCTFail("Should have thrown")
        }
        catch (let error as DecoderError) {
            if case .failed = error.errorType {
                XCTAssert(true)
            } else {
                XCTFail("Unexpected error thrown: \(error)")
            }
        }
        catch {
            XCTFail("Unexpected error thrown: \(error)")
        }
    }
    
    func testFailedEnumException() {
        
        enum TestEnum: String, Decodable {
            case first
            case second
        }
        
        struct TestObject: Decodable {
            let e: TestEnum
            
            init(decoder: Decoder) throws {
                e = try decoder.decode(key: "e")
            }
        }
        
        let json: Any = ["e": "1"]
        do {
            _ = try Decoder(value: json).decode() as TestObject
            
            XCTFail("Should have thrown")
        }
        catch (let error as DecoderError) {
            if case .failed = error.errorType {
                XCTAssert(true)
            } else {
                XCTFail("Unexpected error thrown: \(error)")
            }
            
            return
        }
        catch {
            XCTFail("Unexpected error thrown: \(error)")
        }
    }
    
    func testFailedOptionalException() {
        
        struct TestColor: Decodable {
            let color: Color?
            
            init(decoder: Decoder) throws {
                color = try decoder.decode(key: "color")
            }
        }
        
        let json: Any = ["color": NSNull()]
        do {
            _ = try Decoder(value: json).decode() as TestColor
        }
        catch {
            XCTFail("Should haven't thrown")
        }
    }
    
    func testNilIfMissing() {
        
        struct Test: Decodable {
            let name: String?
            let names: [String]?
            let naming: [String:String]?
            let namingnames: [String:[String]]?
            
            init(decoder: Decoder) throws {
                name = try decoder.decode(key: "name", nilIfMissing: true)
                names = try decoder.decode(key: "names", nilIfMissing: true)
                naming = try decoder.decode(key: "naming", nilIfMissing: true)
                namingnames = try decoder.decode(key: "namingnames", nilIfMissing: true)
            }
        }
        
        let json: Any = [:]
        
        
        do {
            let t = try Decoder(value: json).decode() as Test
            XCTAssertEqual(nil, t.name)
        }
        catch {
            XCTFail("Unexpected error thrown: \(error)")
        }
    }
    
    func testInnerDecode() {
        
        struct InnerTest: Decodable {
            let name: String
            
            init(decoder: Decoder) throws {
                name = try decoder.decode(key: "name")
            }
        }
    
        struct Test: Decodable {
            let innerTest: InnerTest
            
            init(decoder: Decoder) throws {
                innerTest = try decoder.decode()
            }
        }
        
        let json: Any = ["name":"John"]
        
        
        do {
            let t = try Decoder(value: json).decode() as Test
            XCTAssertEqual("John", t.innerTest.name)
        }
        catch {
            XCTFail("Unexpected error thrown: \(error)")
        }
    }
    
    func testSet() {
        
        struct Test: Decodable {
            let set: Set<TestHash>
            
            init(decoder: Decoder) throws {
                set = try decoder.decode()
            }
        }
        
        let json: Any = [["name":"John"], ["name":"Alex"], ["name":"John"]]
        
        
        do {
            let t = try Decoder(value: json).decode() as Test
            XCTAssertEqual(Set(["John", "Alex"]), Set(t.set.map { $0.name }))
        }
        catch {
            XCTFail("Unexpected error thrown: \(error)")
        }
    }
    
    func testEncodingSkipIfNilFalse() {
        
        struct Test: Encodable {
            let name: String?
            
            func encode() -> Any {
                var encoder = Encoder()
                encoder.encode(name, key: "name")
                return encoder.dictionary
            }
        }
        
        let json: Any = ["name":NSNull()]
        
        let t = Test(name: nil)
        let testJson = t.encode()
        
        let testData = try! JSONSerialization.data(withJSONObject: testJson, options: [])
        let refData = try! JSONSerialization.data(withJSONObject: json, options: [])
        XCTAssertEqual(testData, refData)
    }
    
    func testEncodingSkipIfNilTrue() {
        
        struct Test: Encodable {
            let name: String?
            
            func encode() -> Any {
                var encoder = Encoder()
                encoder.encode(name, key: "name", skipIfNil: true)
                return encoder.dictionary
            }
        }
        
        let json: Any = [:]
        
        let t = Test(name: nil)
        let testJson = t.encode()
        
        let testData = try! JSONSerialization.data(withJSONObject: testJson, options: [])
        let refData = try! JSONSerialization.data(withJSONObject: json, options: [])
        XCTAssertEqual(testData, refData)
    }
    
    func testKeyPath() {
        
        struct A: Decodable {
            let b: B
            
            init?(decoder: Decoder) throws {
                b = try decoder.decode(key: "b")
            }
        }
        
        struct B: Decodable {
            let c: [C]
            
            init?(decoder: Decoder) throws {
                c = try decoder.decode(key: "c")
            }
        }
        
        struct C: Decodable {
            let d: String
            
            init?(decoder: Decoder) throws {
                d = try decoder.decode(key: "d")
            }
        }
        
        let json: Any = ["b": [
            "c": [ ["d":"1"],
                   ["d":"2"],
                   ["d":"3"],
                   ["d": NSNull()]
            ]
            ]
        ]
        
        do {
            _ = try Decoder(value: json).decode() as A
            
            XCTFail("Should have thrown")
        }
        catch (let error as DecoderError) {
            if case .invalidType = error.errorType {
                XCTAssert(true)
            } else {
                XCTFail("Unexpected error thrown: \(error)")
            }
            XCTAssertEqual("$.b.c[3].d", error.jsonPath)
            return
        }
        catch {
            XCTFail("Unexpected error thrown: \(error)")
        }
    }
    
}

struct TestHash: Decodable, Hashable {
    let name: String
    
    init(decoder: Decoder) throws {
        name = try decoder.decode(key: "name")
    }
    
    var hashValue: Int {
        return name.hashValue
    }
}

extension TestHash {
    static func ==(lhs: TestHash, rhs: TestHash) -> Bool {
        return lhs.name == rhs.name
    }
}

