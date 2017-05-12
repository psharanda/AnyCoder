//
//  Created by Pavel Sharanda on 29.09.16.
//  Copyright © 2016 Pavel Sharanda. All rights reserved.
//

import Foundation


public protocol Decodable {
    init?(decoder: Decoder) throws
}

public protocol ValueDecodable {
    associatedtype ValueType
    init?(value: ValueType) throws
}

//MARK: - Decoder

public protocol Decoder {
    func anyValue(forKey: String) -> Any?
}

extension Dictionary: Decoder {
    public func anyValue(forKey key: String) -> Any? {
        if let key = key as? Key {
            return self[key]
        } else {
            return nil
        }
    }
}

extension NSDictionary: Decoder {
    public func anyValue(forKey key: String) -> Any? {
        return self[key]
    }
}

extension Decoder {
    
    public func decoder(forKey key: String) throws -> Decoder {
        if let value = anyValue(forKey: key) {
            return try castValue(value) { $0 }
        } else {
            throw DecoderErrorType.missing.error
        }
    }
    
    public func decoder(forKey key: String, throwIfMissing: Bool = false) throws -> Decoder? {
        if let value = anyValue(forKey: key) {            
            return try doActionHandlingNull(value: value) {
                return try castValue(value) { $0 }
            }
        } else {
            if throwIfMissing {
                throw DecoderErrorType.missing.error
            } else {
                return nil
            }
        }
    }
    
    public func decode<T: Decodable>() throws -> T {
        return try decode(transform: T.init)
    }
    
    public func decode<T>(transform: (Decoder) throws ->T? ) throws -> T {
        if let value = try transform(self) {
            return value
        } else {
            throw DecoderErrorType.failed(T.self, self).error
        }
    }
    
    //MARK:- handle object decode
    
    private func handleObjectDecode<T, U>(key: String, action: (T) throws -> U) throws -> U {
        return try commitAction(path: .key(key)) {
            if let value = anyValue(forKey: key) {
                return try castValue(value, action: action)
            } else {
                throw DecoderErrorType.missing.error
            }
        }
    }
    
    private func handleObjectDecode<T, U>(key: String, throwIfMissing: Bool, action: (T) throws -> U) throws -> U? {
        return try commitAction(path: .key(key)) {
            if let value = anyValue(forKey: key) {
                return try doActionHandlingNull(value: value) {
                    return try castValue(value, action: action)
                }
            } else {
                if throwIfMissing {
                    throw DecoderErrorType.missing.error
                } else {
                    return nil
                }
            }
        }
    }
    
    private func handleObjectDecode<T, U>(key: String, valueIfMissing: U, action: (T) throws -> U) throws -> U {
        return try commitAction(path: .key(key)) {
            if let value = anyValue(forKey: key) {
                return try castValue(value, action: action)
            } else {
                return valueIfMissing
            }
        }
    }

    
    //MARK: - object - object
    public func decode<T: Decodable>(key: String) throws -> T {
        return try decode(key: key, transform: T.init)
    }
    
    public func decode<T>(key: String, transform: (Decoder) throws ->T?) throws -> T {
        return try handleObjectDecode(key: key) { (decoder: Decoder) -> T in
            try decoder.decode(transform: transform)
        }
    }

    public func decode<T: Decodable>(key: String,  throwIfMissing: Bool = false) throws -> T? {
        return try decode(key: key, throwIfMissing: throwIfMissing, transform: T.init)
    }
    
    public func decode<T>(key: String,  throwIfMissing: Bool = false, transform: (Decoder) throws ->T?) throws -> T? {
        return try handleObjectDecode(key: key, throwIfMissing: throwIfMissing) { (decoder: Decoder) -> T in
            try decoder.decode(transform: transform)
        }
    }
    
    public func decode<T: Decodable>(key: String, valueIfMissing: T) throws -> T {
        return try decode(key: key, valueIfMissing: valueIfMissing, transform: T.init)
    }
    
    public func decode<T>(key: String, valueIfMissing: T, transform: (Decoder) throws ->T?) throws -> T {
        return try handleObjectDecode(key: key, valueIfMissing: valueIfMissing) { (decoder: Decoder) -> T in
            try decoder.decode(transform: transform)
        }
    }
    
    //MARK: - object - value
    
    public func decode<T: ValueDecodable>(key: String) throws -> T {
        return try decode(key: key, transform: T.init)
    }
    
    public func decode<T, ValueType>(key: String, transform: (ValueType) throws ->T?) throws -> T {
        return try handleObjectDecode(key: key) { (value: Any) -> T in
            try Decoding.decode(value, transform: transform)
        }
    }
    
    public func decode<T: ValueDecodable>(key: String,  throwIfMissing: Bool = false) throws -> T? {
        return try decode(key: key, throwIfMissing: throwIfMissing, transform: T.init)
    }
    
    public func decode<T, ValueType>(key: String,  throwIfMissing: Bool = false, transform: (ValueType) throws ->T?) throws -> T? {
        return try handleObjectDecode(key: key, throwIfMissing: throwIfMissing) { (value: Any) -> T in
            try Decoding.decode(value, transform: transform)
        }
    }
    
    public func decode<T: ValueDecodable>(key: String, valueIfMissing: T) throws -> T {
        return try decode(key: key, valueIfMissing: valueIfMissing, transform: T.init)
    }
    
    public func decode<T, ValueType>(key: String, valueIfMissing: T, transform: (ValueType) throws ->T?) throws -> T {
        return try handleObjectDecode(key: key, valueIfMissing: valueIfMissing) { (value: Any) -> T in
            try Decoding.decode(value, transform: transform)
        }
    }
    
    //MARK: - array - object
    public func decode<T: Decodable>(key: String) throws -> [T] {
        return try decode(key: key, transform: T.init)
    }
    
    public func decode<T>(key: String, transform: (Decoder) throws ->T?) throws -> [T] {
        return try handleObjectDecode(key: key) { (decoder: ArrayDecoder) -> [T] in
            try decoder.decode(transform: transform)
        }
    }
    
    public func decode<T: Decodable>(key: String,  throwIfMissing: Bool = false) throws -> [T]? {
        return try decode(key: key, throwIfMissing: throwIfMissing, transform: T.init)
    }
    
    public func decode<T>(key: String,  throwIfMissing: Bool = false, transform: (Decoder) throws ->T?) throws -> [T]? {
        return try handleObjectDecode(key: key, throwIfMissing: throwIfMissing) { (decoder: ArrayDecoder) -> [T] in
            try decoder.decode(transform: transform)
        }
    }
    
    public func decode<T: Decodable>(key: String, valueIfMissing: [T]) throws -> [T] {
        return try decode(key: key, valueIfMissing: valueIfMissing, transform: T.init)
    }
    
    public func decode<T>(key: String, valueIfMissing: [T], transform: (Decoder) throws ->T?) throws -> [T] {
        return try handleObjectDecode(key: key, valueIfMissing: valueIfMissing) { (decoder: ArrayDecoder) -> [T] in
            try decoder.decode(transform: transform)
        }
    }
    
    //MARK: - array - value
    public func decode<T: ValueDecodable>(key: String) throws -> [T] {
        return try decode(key: key, transform: T.init)
    }
    
    public func decode<T, ValueType>(key: String, transform: (ValueType) throws ->T?) throws -> [T] {
        return try handleObjectDecode(key: key) { (decoder: ArrayDecoder) -> [T] in
            try decoder.decode(transform: transform)
        }
    }
    
    public func decode<T: ValueDecodable>(key: String,  throwIfMissing: Bool = false) throws -> [T]? {
        return try decode(key: key, throwIfMissing: throwIfMissing, transform: T.init)
    }
    
    public func decode<T, ValueType>(key: String,  throwIfMissing: Bool = false, transform: (ValueType) throws ->T?) throws -> [T]? {
        return try handleObjectDecode(key: key, throwIfMissing: throwIfMissing) { (decoder: ArrayDecoder) -> [T] in
            try decoder.decode(transform: transform)
        }
    }
    
    public func decode<T: ValueDecodable>(key: String, valueIfMissing: [T]) throws -> [T] {
        return try decode(key: key, valueIfMissing: valueIfMissing, transform: T.init)
    }
    
    public func decode<T, ValueType>(key: String, valueIfMissing: [T], transform: (ValueType) throws ->T?) throws -> [T] {
        return try handleObjectDecode(key: key, valueIfMissing: valueIfMissing) { (decoder: ArrayDecoder) -> [T] in
            try decoder.decode(transform: transform)
        }
    }
    
    //MARK: - nulllable array - object
    
    public func decode<T: Decodable>(key: String) throws -> [T?] {
        return try decode(key: key, transform: T.init)
    }
    
    public func decode<T>(key: String, transform: (Decoder) throws ->T?) throws -> [T?] {
        return try handleObjectDecode(key: key) { (decoder: ArrayDecoder) -> [T?] in
            try decoder.decode(transform: transform)
        }
    }
    
    public func decode<T: Decodable>(key: String,  throwIfMissing: Bool = false) throws -> [T?]? {
        return try decode(key: key, throwIfMissing: throwIfMissing, transform: T.init)
    }
    
    public func decode<T>(key: String,  throwIfMissing: Bool = false, transform: (Decoder) throws ->T?) throws -> [T?]? {
        return try handleObjectDecode(key: key, throwIfMissing: throwIfMissing) { (decoder: ArrayDecoder) -> [T?] in
            try decoder.decode(transform: transform)
        }
    }
    
    public func decode<T: Decodable>(key: String, valueIfMissing: [T?]) throws -> [T?] {
        return try decode(key: key, valueIfMissing: valueIfMissing, transform: T.init)
    }
    
    public func decode<T>(key: String, valueIfMissing: [T?], transform: (Decoder) throws ->T?) throws -> [T?] {
        return try handleObjectDecode(key: key, valueIfMissing: valueIfMissing) { (decoder: ArrayDecoder) -> [T?] in
            try decoder.decode(transform: transform)
        }
    }
    
    //MARK: -  nulllable array - value
    
    public func decode<T: ValueDecodable>(key: String) throws -> [T?] {
        return try decode(key: key, transform: T.init)
    }
    
    public func decode<T, ValueType>(key: String, transform: (ValueType) throws ->T?) throws -> [T?] {
        return try handleObjectDecode(key: key) { (decoder: ArrayDecoder) -> [T?] in
            try decoder.decode(transform: transform)
        }
    }
    
    public func decode<T: ValueDecodable>(key: String,  throwIfMissing: Bool = false) throws -> [T?]? {
        return try decode(key: key, throwIfMissing: throwIfMissing, transform: T.init)
    }
    
    public func decode<T, ValueType>(key: String,  throwIfMissing: Bool = false, transform: (ValueType) throws ->T?) throws -> [T?]? {
        return try handleObjectDecode(key: key, throwIfMissing: throwIfMissing) { (decoder: ArrayDecoder) -> [T?] in
            try decoder.decode(transform: transform)
        }
    }
    
    public func decode<T: ValueDecodable>(key: String, valueIfMissing: [T?]) throws -> [T?] {
        return try decode(key: key, valueIfMissing: valueIfMissing, transform: T.init)
    }
    
    public func decode<T, ValueType>(key: String, valueIfMissing: [T?], transform: (ValueType) throws ->T?) throws -> [T?] {
        return try handleObjectDecode(key: key, valueIfMissing: valueIfMissing) { (decoder: ArrayDecoder) -> [T?] in
            try decoder.decode(transform: transform)
        }
    }

    //MARK: - dictionary - object
    
    public func decode<T: Decodable>(key: String) throws -> [String: T] {
        return try decode(key: key, transform: T.init)
    }
    
    public func decode<T>(key: String, transform: (Decoder) throws ->T?) throws -> [String: T] {
        return try handleObjectDecode(key: key) { (decoder: [String: Any]) -> [String: T] in
            try decoder.decode(transform: transform)
        }
    }
    
    public func decode<T: Decodable>(key: String,  throwIfMissing: Bool = false) throws -> [String: T]? {
        return try decode(key: key, throwIfMissing: throwIfMissing, transform: T.init)
    }
    
    public func decode<T>(key: String,  throwIfMissing: Bool = false, transform: (Decoder) throws ->T?) throws -> [String: T]? {
        return try handleObjectDecode(key: key, throwIfMissing: throwIfMissing) { (decoder: [String: Any]) -> [String: T] in
            try decoder.decode(transform: transform)
        }
    }
    
    public func decode<T: Decodable>(key: String, valueIfMissing: [String: T]) throws -> [String: T] {
        return try decode(key: key, valueIfMissing: valueIfMissing, transform: T.init)
    }
    
    public func decode<T>(key: String, valueIfMissing: [String: T], transform: (Decoder) throws ->T?) throws -> [String: T] {
        return try handleObjectDecode(key: key, valueIfMissing: valueIfMissing) { (decoder: [String: Any]) -> [String: T] in
            try decoder.decode(transform: transform)
        }
    }
    
    //MARK: - dictionary - value
    
    public func decode<T: ValueDecodable>(key: String) throws -> [String: T] {
        return try decode(key: key, transform: T.init)
    }
    
    public func decode<T, ValueType>(key: String, transform: (ValueType) throws ->T?) throws -> [String: T] {
        return try handleObjectDecode(key: key) { (decoder: [String: Any]) -> [String: T] in
            try decoder.decode(transform: transform)
        }
    }
    
    public func decode<T: ValueDecodable>(key: String,  throwIfMissing: Bool = false) throws -> [String: T]? {
        return try decode(key: key, throwIfMissing: throwIfMissing, transform: T.init)
    }
    
    public func decode<T, ValueType>(key: String,  throwIfMissing: Bool = false, transform: (ValueType) throws ->T?) throws -> [String: T]? {
        return try handleObjectDecode(key: key, throwIfMissing: throwIfMissing) { (decoder: [String: Any]) -> [String: T] in
            try decoder.decode(transform: transform)
        }
    }
    
    public func decode<T: ValueDecodable>(key: String, valueIfMissing: [String: T]) throws -> [String: T] {
        return try decode(key: key, valueIfMissing: valueIfMissing, transform: T.init)
    }
    
    public func decode<T, ValueType>(key: String, valueIfMissing: [String: T], transform: (ValueType) throws ->T?) throws -> [String: T] {
        return try handleObjectDecode(key: key, valueIfMissing: valueIfMissing) { (decoder: [String: Any]) -> [String: T] in
            try decoder.decode(transform: transform)
        }
    }
    
    //MARK: - nulllable dictionary - object
    
    public func decode<T: Decodable>(key: String) throws -> [String: T?] {
        return try decode(key: key, transform: T.init)
    }
    
    public func decode<T>(key: String, transform: (Decoder) throws ->T?) throws -> [String: T?] {
        return try handleObjectDecode(key: key) { (decoder: [String: Any]) -> [String: T?] in
            try decoder.decode(transform: transform)
        }
    }
    
    public func decode<T: Decodable>(key: String,  throwIfMissing: Bool = false) throws -> [String: T?]? {
        return try decode(key: key, throwIfMissing: throwIfMissing, transform: T.init)
    }
    
    public func decode<T>(key: String,  throwIfMissing: Bool = false, transform: (Decoder) throws ->T?) throws -> [String: T?]? {
        return try handleObjectDecode(key: key, throwIfMissing: throwIfMissing) { (decoder: [String: Any]) -> [String: T?] in
            try decoder.decode(transform: transform)
        }
    }
    
    public func decode<T: Decodable>(key: String, valueIfMissing: [String: T?]) throws -> [String: T?] {
        return try decode(key: key, valueIfMissing: valueIfMissing, transform: T.init)
    }
    
    public func decode<T>(key: String, valueIfMissing: [String: T?], transform: (Decoder) throws ->T?) throws -> [String: T?] {
        return try handleObjectDecode(key: key, valueIfMissing: valueIfMissing) { (decoder: [String: Any]) -> [String: T?] in
            try decoder.decode(transform: transform)
        }
    }
    
    //MARK: - nulllable dictionary - value
    
    public func decode<T: ValueDecodable>(key: String) throws -> [String: T?] {
        return try decode(key: key, transform: T.init)
    }
    
    public func decode<T, ValueType>(key: String, transform: (ValueType) throws ->T?) throws -> [String: T?] {
        return try handleObjectDecode(key: key) { (decoder: [String: Any]) -> [String: T?] in
            try decoder.decode(transform: transform)
        }
    }
    
    public func decode<T: ValueDecodable>(key: String,  throwIfMissing: Bool = false) throws -> [String: T?]? {
        return try decode(key: key, throwIfMissing: throwIfMissing, transform: T.init)
    }
    
    public func decode<T, ValueType>(key: String,  throwIfMissing: Bool = false, transform: (ValueType) throws ->T?) throws -> [String: T?]? {
        return try handleObjectDecode(key: key, throwIfMissing: throwIfMissing) { (decoder: [String: Any]) -> [String: T?] in
            try decoder.decode(transform: transform)
        }
    }
    
    public func decode<T: ValueDecodable>(key: String, valueIfMissing: [String: T?]) throws -> [String: T?] {
        return try decode(key: key, valueIfMissing: valueIfMissing, transform: T.init)
    }
    
    public func decode<T, ValueType>(key: String, valueIfMissing: [String: T?], transform: (ValueType) throws ->T?) throws -> [String: T?] {
        return try handleObjectDecode(key: key, valueIfMissing: valueIfMissing) { (decoder: [String: Any]) -> [String: T?] in
            try decoder.decode(transform: transform)
        }
    }
}

//MARK: - Dictionary

extension Dictionary where Key == String, Value == Any {
    //objects dict
    public func decode<T: Decodable>() throws -> [String: T] {
        return try decode(transform: T.init)
    }
    
    public func decode<T>(transform: (Decoder) throws ->T?) throws -> [String: T] {
        return try map { (key, value) in
            try commitAction(path: .key(key)) {
                return try Decoding.decode(value, transform: transform)
            }
        }
    }
    
    //optional objects dict
    public func decode<T: Decodable>() throws -> [String: T?] {
        return try decode(transform: T.init)
    }
    
    public func decode<T>(transform: (Decoder) throws ->T?) throws -> [String: T?] {
        return try map { (key, value) in
            try commitAction(path: .key(key)) {
                return try doActionHandlingNull(value: value) {
                    return try Decoding.decode(value, transform: transform)
                }
            }
        }
    }
    
    //values dict
    public func decode<T: ValueDecodable>() throws -> [String: T] {
        return try decode(transform: T.init)
    }
    
    public func decode<T, ValueType>(transform: (ValueType) throws ->T?) throws -> [String: T] {
        return try map { (key, value) in
            try commitAction(path: .key(key)) {
                try Decoding.decode(value, transform: transform)
            }
        }
    }
    
    //optional values dict
    public func decode<T: ValueDecodable>() throws -> [String: T?] {
        return try decode(transform: T.init)
    }
    
    public func decode<T, ValueType>(transform: (ValueType) throws ->T?) throws -> [String: T?] {
        return try map { (key, value) in
            try commitAction(path: .key(key)) {
                return try doActionHandlingNull(value: value) {
                    return try Decoding.decode(value, transform: transform)
                }
            }
        }
    }
}

//MARK: - ArrayDecoder

public protocol ArrayDecoder {
    func anyMap<T>(_ transform: ((offset: Int, element: Any)) throws -> T) rethrows -> [T]
}

extension Array: ArrayDecoder {
    public func anyMap<T>(_ transform: ((offset: Int, element: Any)) throws -> T) rethrows -> [T] {
        return try enumerated().map(transform)
    }
}

extension NSArray: ArrayDecoder {
    public func anyMap<T>(_ transform: ((offset: Int, element: Any)) throws -> T) rethrows -> [T] {
        return try enumerated().map(transform)
    }
}

extension ArrayDecoder {
    
    //objects array
    public func decode<T: Decodable>() throws -> [T] {
        return try decode(transform: T.init)
    }
    
    public func decode<T>(transform: (Decoder) throws ->T?) throws -> [T] {
        return try anyMap { el in
            try commitAction(path: .index(el.offset)) {
                return try Decoding.decode(el.element, transform: transform)
            }
        }
    }
    
    //objects optionals array
    public func decode<T: Decodable>() throws -> [T?] {
        return try decode(transform: T.init)
    }
    
    public func decode<T>(transform: (Decoder) throws ->T?) throws -> [T?] {
        return try anyMap { el in
            try commitAction(path: .index(el.offset)) {
                return try doActionHandlingNull(value: el.element) {
                    return try Decoding.decode(el.element, transform: transform)
                }
            }
        }
    }
    
    //values array
    public func decode<T: ValueDecodable>() throws -> [T] {
        return try decode(transform: T.init)
    }
    
    public func decode<T, ValueType>(transform: (ValueType) throws ->T?) throws -> [T] {
        return try anyMap { el in
            try commitAction(path: .index(el.offset)) {
                try Decoding.decode(el.element, transform: transform)
            }
        }
    }
    
    //values optionals array
    public func decode<T: ValueDecodable>() throws -> [T?] {
        return try decode(transform: T.init)
    }
    
    public func decode<T, ValueType>(transform: (ValueType) throws ->T?) throws -> [T?] {
        return try anyMap { el in
            try commitAction(path: .index(el.offset)) {
                return try doActionHandlingNull(value: el.element) {
                    return try Decoding.decode(el.element, transform: transform)
                }
            }
        }
    }
}

//MARK: - Decoding

public struct Decoding {
    
    //value
    public static func decode<T: ValueDecodable>(_ value: Any) throws -> T {
        return try decode(value, transform: T.init)
    }
    
    public static func decode<T, ValueType>(_ value: Any, transform: (ValueType) throws ->T? ) throws -> T {
        if let value = try castValue(value) { try transform($0)} {
            return value
        } else {
            throw DecoderErrorType.failed(T.self, value).error
        }
    }
    
    //object
    public static func decode<T: Decodable>(_ value: Any) throws -> T {
        return try decode(value, transform: T.init)
    }
    
    public static func decode<T>(_ value: Any, transform: (Decoder) throws ->T?) throws -> T {
        return try castValue(value) { (decoder: Decoder) in
            try decoder.decode(transform: transform)
        }
    }
    
    //objects array
    public static func decode<T: Decodable>(_ value: Any) throws -> [T] {
        return try decode(value, transform: T.init)
    }
    
    public static func decode<T>(_ value: Any, transform: (Decoder) throws ->T?) throws -> [T] {
        return try castValue(value) { (decoder: ArrayDecoder) in
            try decoder.decode(transform: transform)
        }
    }
    
    // optional objects array
    public static func decode<T: Decodable>(_ value: Any) throws -> [T?] {
        return try decode(value, transform: T.init)
    }
    
    public static func decode<T>(_ value: Any, transform: (Decoder) throws ->T?) throws -> [T?] {
        return try castValue(value) { (decoder: ArrayDecoder) in
            try decoder.decode(transform: transform)
        }
    }
    
    // objects dict
    public static func decode<T: Decodable>(_ value: Any) throws -> [String: T] {
        return try decode(value, transform: T.init)
    }
    
    public static func decode<T>(_ value: Any, transform: (Decoder) throws ->T?) throws -> [String: T] {
        return try castValue(value) { (decoder: [String: Any]) in
            try decoder.decode(transform: transform)
        }
    }
    
    // optional objects dict
    public static func decode<T: Decodable>(_ value: Any) throws -> [String: T?] {
        return try decode(value, transform: T.init)
    }
    
    public static func decode<T>(_ value: Any, transform: (Decoder) throws ->T?) throws -> [String: T?] {
        return try castValue(value) { (decoder: [String: Any]) in
            try decoder.decode(transform: transform)
        }
    }
}

fileprivate func castValue<T, U>(_ value: Any, action: (T) throws ->U) throws -> U {
    if let target = value as? T {
        let res = try action(target)
        return res
    } else {
        throw DecoderErrorType.invalidType(T.self, value).error
    }
}

//MARK: - utils
fileprivate func commitAction<U>(path: DecoderErrorPathComponent, action: () throws ->U) throws -> U {
    do {
        return try action()
    }
    catch (let error as DecoderError) {
        throw error.backtraceError(path: path)
    }
    catch {
        throw error
    }
}

fileprivate func doActionHandlingNull<U>(value: Any, action: () throws ->U) throws -> U? {
    do {
        return try action()
    }
    catch (let error as DecoderError) {
        if value is NSNull {
            return nil
        } else {
            throw error
        }
    }
    catch {
        throw error
    }
}


