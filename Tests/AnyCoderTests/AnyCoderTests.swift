//
//  Created by Pavel Sharanda on 10.03.17.
//  Copyright © 2017 Pavel Sharanda. All rights reserved.
//

import XCTest
import AnyCoder

class AnyCoderTests: XCTestCase {
    
    enum TestStringEnum: String, AnyEncodable, AnyDecodable {
        case first
        case second
        case third
    }
    
    enum TestIntEnum: Int, AnyEncodable, AnyDecodable {
        case first = 1
        case second = 2
        case third = 3
    }
    

    struct TestChild: Decodable, Encodable {
        let name: String
        
        init(decoder: Decoder) throws {
            name = try decoder.decode(key: "name")
        }
        
        func encode() -> Encoder {
            var encoder = Encoder()
            encoder.encode(name, key: "name")
            return encoder
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
        let normalOptionalChildArray: [TestChild?]
        let optionalChildArray: [TestChild]?
        let optionalOptionalChildArray: [TestChild?]?
        let normalChildDictionary: [String: TestChild]
        let normalOptionalChildDictionary: [String: TestChild?]
        let optionalChildDictionary: [String: TestChild]?
        let optionalOptionalChildDictionary: [String: TestChild?]?
        
        let normalIntArray: [Int]
        let normalOptionalIntArray: [Int?]
        let optionalIntArray: [Int]?
        let optionalOptionalIntArray: [Int?]?
        let normalIntDictionary: [String: Int]
        let normalOptionalIntDictionary: [String: Int?]
        let optionalIntDictionary: [String: Int]?
        let optionalOptionalIntDictionary: [String: Int?]?
        
        
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
            normalOptionalChildArray = try decoder.decode(key: "normalOptionalChildArray")
            optionalChildArray = try decoder.decode(key: "optionalChildArray")
            optionalOptionalChildArray = try decoder.decode(key: "optionalOptionalChildArray")
            normalChildDictionary = try decoder.decode(key: "normalChildDictionary")
            normalOptionalChildDictionary = try decoder.decode(key: "normalOptionalChildDictionary")
            optionalChildDictionary = try decoder.decode(key: "optionalChildDictionary")
            optionalOptionalChildDictionary = try decoder.decode(key: "optionalOptionalChildDictionary")
            
            normalIntArray = try decoder.decode(key: "normalIntArray")
            normalOptionalIntArray = try decoder.decode(key: "normalOptionalIntArray")
            optionalIntArray = try decoder.decode(key: "optionalIntArray")
            optionalOptionalIntArray = try decoder.decode(key: "optionalOptionalIntArray")
            normalIntDictionary = try decoder.decode(key: "normalIntDictionary")
            normalOptionalIntDictionary = try decoder.decode(key: "normalOptionalIntDictionary")
            optionalIntDictionary = try decoder.decode(key: "optionalIntDictionary")
            optionalOptionalIntDictionary = try decoder.decode(key: "optionalOptionalIntDictionary")
        }
        
        func encode() -> Encoder {
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
            encoder.encode(normalOptionalChildArray, key: "normalOptionalChildArray")
            encoder.encode(optionalChildArray, key: "optionalChildArray")
            encoder.encode(optionalOptionalChildArray, key: "optionalOptionalChildArray")
            encoder.encode(normalChildDictionary, key: "normalChildDictionary")
            encoder.encode(normalOptionalChildDictionary, key: "normalOptionalChildDictionary")
            encoder.encode(optionalChildDictionary, key: "optionalChildDictionary")
            encoder.encode(optionalOptionalChildDictionary, key: "optionalOptionalChildDictionary")
            
            encoder.encode(normalIntArray, key: "normalIntArray")
            encoder.encode(normalOptionalIntArray, key: "normalOptionalIntArray")
            encoder.encode(optionalIntArray, key: "optionalIntArray")
            encoder.encode(optionalOptionalIntArray, key: "optionalOptionalIntArray")
            encoder.encode(normalIntDictionary, key: "normalIntDictionary")
            encoder.encode(normalOptionalIntDictionary, key: "normalOptionalIntDictionary")
            encoder.encode(optionalIntDictionary, key: "optionalIntDictionary")
            encoder.encode(optionalOptionalIntDictionary, key: "optionalOptionalIntDictionary")
            
            return encoder
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
        
        let json: [String: Any] = [
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
            "normalOptionalChildArray": [["name": "John"] as Any, ["name": "Alexa"] as Any, NSNull() as Any],
            "optionalChildArray":NSNull(),
            "optionalOptionalChildArray":NSNull(),
            "normalChildDictionary":["first": ["name": "John"], "second": ["name": "Alexa"]],
            "normalOptionalChildDictionary":["first": ["name": "John"] as Any, "second": ["name": "Alexa"] as Any, "third": NSNull() as Any],
            "optionalChildDictionary":NSNull(),
            "optionalOptionalChildDictionary":NSNull(),
            
            "normalIntArray":[23, 32],
            "normalOptionalIntArray": [22 as Any, 32 as Any, NSNull() as Any],
            "optionalIntArray":NSNull(),
            "optionalOptionalIntArray":NSNull(),
            "normalIntDictionary":["first": 22, "second": 33],
            "normalOptionalIntDictionary":["first": 22 as Any, "second": 222 as Any, "third": NSNull() as Any],
            "optionalIntDictionary":NSNull(),
            "optionalOptionalIntDictionary":NSNull()
        ]
        
        do {
            let testParent = try json.decode() as TestParent
            let testJson = testParent.encode()
            
            let testData = try JSONSerialization.data(withJSONObject: testJson, options: [])
            let refData = try JSONSerialization.data(withJSONObject: json, options: [])
            XCTAssertEqual(testData, refData)
        }
        catch {
            XCTFail("Unexpected error thrown: \(error)")
        }
    }
    
    func testStrictModelNSNumberWithNulls() {
        
        let json: [String: Any] = [
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
            "normalOptionalChildArray": [["name": "John"] as Any, ["name": "Alexa"] as Any, NSNull() as Any],
            "optionalChildArray":NSNull(),
            "optionalOptionalChildArray":NSNull(),
            "normalChildDictionary":["first": ["name": "John"], "second": ["name": "Alexa"]],
            "normalOptionalChildDictionary":["first": ["name": "John"] as Any, "second": ["name": "Alexa"] as Any, "third": NSNull() as Any],
            "optionalChildDictionary":NSNull(),
            "optionalOptionalChildDictionary":NSNull(),
            
            "normalIntArray":[NSNumber(value: 23), NSNumber(value: 23)],
            "normalOptionalIntArray": [NSNumber(value: 23) as Any, NSNumber(value: 23) as Any, NSNull() as Any],
            "optionalIntArray":NSNull(),
            "optionalOptionalIntArray":NSNull(),
            "normalIntDictionary":["first": NSNumber(value: 23), "second": NSNumber(value: 23)],
            "normalOptionalIntDictionary":["first": NSNumber(value: 23) as Any, "second": NSNumber(value: 23) as Any, "third": NSNull() as Any],
            "optionalIntDictionary":NSNull(),
            "optionalOptionalIntDictionary":NSNull()
        ]
        
        do {
            let testParent = try json.decode() as TestParent
            let testJson = testParent.encode()
            
            let testData = try JSONSerialization.data(withJSONObject: testJson, options: [])
            let refData = try JSONSerialization.data(withJSONObject: json, options: [])
            XCTAssertEqual(testData, refData)
        }
        catch {
            XCTFail("Unexpected error thrown: \(error)")
        }
    }
    
    func testStrictModelNSNumberWithoutNulls() {
        
        let json: [String: Any] = [
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
            "normalOptionalChildArray": [["name": "John"] as Any, ["name": "Alexa"] as Any, NSNull() as Any],
            "optionalChildArray":[["name": "John"], ["name": "Alexa"]],
            "optionalOptionalChildArray":[["name": "John"] as Any, ["name": "Alexa"] as Any, NSNull() as Any],
            "normalChildDictionary":["first": ["name": "John"], "second": ["name": "Alexa"]],
            "normalOptionalChildDictionary":["first": ["name": "John"] as Any, "second": ["name": "Alexa"] as Any, "third": NSNull() as Any],
            "optionalChildDictionary":["first": ["name": "John"], "second": ["name": "Alexa"]],
            "optionalOptionalChildDictionary":["third": NSNull() as Any],
            
            "normalIntArray":[23, 32],
            "normalOptionalIntArray": [22 as Any, 32 as Any, NSNull() as Any],
            "optionalIntArray":[23, 32],
            "optionalOptionalIntArray":[22 as Any, 32 as Any, NSNull() as Any],
            "normalIntDictionary":["first": 22, "second": 33],
            "normalOptionalIntDictionary":["first": 22 as Any, "second": 222 as Any, "third": NSNull() as Any],
            "optionalIntDictionary":["first": 22, "second": 33],
            "optionalOptionalIntDictionary":["first": 22 as Any, "second": 222 as Any, "third": NSNull() as Any]
        ]
        
        do {
            let testParent = try json.decode() as TestParent
            let testJson = testParent.encode()
            
            let testData = try JSONSerialization.data(withJSONObject: testJson, options: [])
            let refData = try JSONSerialization.data(withJSONObject: json, options: [])
            XCTAssertEqual(testData, refData)
        }
        catch {
            XCTFail("Unexpected error thrown: \(error)")
        }
        
    }
    
    func testMissingKeyException() {
        
        let json: [String: Any] = ["nme": "John"]
        do {
            _ = try json.decode() as TestChild
            
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
            _ = try json.decode() as TestChild
            
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
            let url: URL
            
            init(decoder: Decoder) throws {
                url = try decoder.decode(key: "url")
            }
        }
        
        let json: [String: Any] = ["url": 10]
        do {
            _ = try json.decode() as TestColor
            
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
    
    func testFailedEnumException() {
        
        enum TestEnum: String, AnyDecodable {
            case first
            case second
        }
        
        struct TestObject: Decodable {
            let e: TestEnum
            
            init(decoder: Decoder) throws {
                e = try decoder.decode(key: "e")
            }
        }
        
        let json: [String: Any] = ["e": "1"]
        do {
            _ = try json.decode() as TestObject
            
            XCTFail("Should have thrown")
        }
        catch (let error as DecoderError) {
            if case .invalidType = error.errorType {
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
        
        struct TestUrl: Decodable {
            let url: URL?
            
            init(decoder: Decoder) throws {
                url = try decoder.decode(key: "url")
            }
        }
        
        let json: [String: Any] = ["url": NSNull()]
        do {
            _ = try json.decode() as TestUrl
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
            
            init(decoder: Decoder) throws {
                name = try decoder.decode(key: "name", nilIfMissing: true)
                names = try decoder.decode(key: "names", nilIfMissing: true)
                naming = try decoder.decode(key: "naming", nilIfMissing: true)
            }
        }
        
        let json: [String: Any] = [:]
        
        
        do {
            let t = try json.decode() as Test
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
        
        let json: [String: Any] = ["name":"John"]
        
        
        do {
            let t = try json.decode() as Test
            XCTAssertEqual("John", t.innerTest.name)
        }
        catch {
            XCTFail("Unexpected error thrown: \(error)")
        }
    }
    
    func testSet() {
        
        struct Test: AnyDecodable {
            let set: Set<TestHash>
            
            init?(anyValue: Any) throws {
                if let a = anyValue as? [Any] {
                    set = try Set(a.decode() as [TestHash])
                } else {
                    return nil
                }
            }
        }
        
        let json: [Any] = [["name":"John"], ["name":"Alex"], ["name":"John"]]
        
        
        do {
            let t = try Test(anyValue: json)!
            XCTAssertEqual(Set(["John", "Alex"]), Set(t.set.map { $0.name }))
        }
        catch {
            XCTFail("Unexpected error thrown: \(error)")
        }
    }
    
    func testEncodingSkipIfNilFalse() {
        
        struct Test: Encodable {
            let name: String?
            
            func encode() -> Encoder {
                var encoder = Encoder()
                encoder.encode(name, key: "name")
                return encoder
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
            
            func encode() -> Encoder {
                var encoder = Encoder()
                encoder.encode(name, key: "name", skipIfNil: true)
                return encoder
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
        
        let json: [String: Any] = ["b": [
            "c": [ ["d":"1"],
                   ["d":"2"],
                   ["d":"3"],
                   ["d": NSNull()]
            ]
            ]
        ]
        
        do {
            _ = try json.decode() as A
            
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
    
    func testPerformance() {
        
        let dict = try! JSONSerialization.jsonObject(with: self.data, options: []) as! [String: Any]
        
        self.measure {
            let programs:[Program] = try! dict.decoder(forKey: "ProgramList").decode(key: "Programs")
            XCTAssert(programs.count > 1000)
        }
    }
    
    private lazy var data:Data = {
        let path = Bundle(for: type(of: self)).url(forResource: "Large", withExtension: "json")
        let data = try! Data(contentsOf: path!)
        return data
    }()
    
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

public struct Recording {
    enum Status: String, AnyDecodable {
        case None = "0"
        case Recorded = "-3"
        case Recording = "-2"
        case Unknown
    }
    
    enum RecGroup: String, AnyDecodable {
        case Deleted = "Deleted"
        case Default = "Default"
        case LiveTV = "LiveTV"
        case Unknown
    }
    
    let startTsStr:String
    let status:Status
    let recordId:String
    let recGroup:RecGroup
}

public struct Program {
    
    let title:String
    let chanId:String
    let description:String?
    let subtitle:String?
    let recording:Recording
    let season:String?
    let episode:String?
}

extension Recording: Decodable {
    
    public init?(decoder: Decoder) throws {
        startTsStr = try decoder.decode(key: "StartTs")
        recordId = try decoder.decode(key: "RecordId")
        status = (try? decoder.decode(key: "Status")) ?? .Unknown
        recGroup = (try? decoder.decode(key: "RecGroup")) ?? .Unknown
    }
}

extension Program: Decodable {
    
    public init?(decoder: Decoder) throws {
        title = try decoder.decode(key: "Title")
        chanId = try decoder.decoder(forKey: "Channel").decode(key: "ChanId")
        description = try decoder.decode(key: "Description", nilIfMissing: true)
        subtitle = try decoder.decode(key: "SubTitle", nilIfMissing: true)
        recording = try decoder.decode(key: "Recording")
        season = try decoder.decode(key: "Season", nilIfMissing: true)
        episode = try decoder.decode(key: "Episode", nilIfMissing: true)
        
    }
}

