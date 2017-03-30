//
//  Created by Pavel Sharanda on 29.09.16.
//  Copyright © 2016 Pavel Sharanda. All rights reserved.
//

import Foundation


public protocol Decodable {
    init?(decoder: Decoder) throws
}

public protocol AnyDecodable {
    init?(anyValue: Any) throws
}

public protocol Decoder {
    func anyValue(forKey: String) -> Any?
}

public protocol ArrayDecoder {
    func anyMap<T>(_ transform: ((offset: Int, element: Any)) throws -> T) rethrows -> [T]
}

extension Decoder {
    
    public func decoder(forKey key: String) throws -> Decoder {        
        if let value = anyValue(forKey: key) {
            return try castValue(value) { $0 }
        } else {
            throw DecoderErrorType.missing.error
        }
    }
    
    public func decode<T: Decodable>() throws -> T {
        if let value = try T.init(decoder: self) {
            return value
        } else {
            throw DecoderErrorType.invalidType(T.self, self).error
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
    
    private func handleObjectDecode<T, U>(key: String, nilIfMissing: Bool, action: (T) throws -> U) throws -> U? {
        return try commitAction(path: .key(key)) {
            if let value = anyValue(forKey: key) {
                return try doActionHandlingNull(value: value) {
                    return try castValue(value, action: action)
                }
            } else {
                if nilIfMissing {
                    return nil
                } else {
                    throw DecoderErrorType.missing.error
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
    
    private func handleObjectDecode<T, U>(key: String, valueIfMissingOrNull: U?, action: (T) throws -> U) throws -> U? {
        return try commitAction(path: .key(key)) {
            if let value = anyValue(forKey: key) {
                return try doActionHandlingNull(value: value) {
                    return try castValue(value, action: action)
                }
            } else {
                return valueIfMissingOrNull
            }
        }
    }
    
    //MARK: - object - object
    public func decode<T: Decodable>(key: String) throws -> T {
        return try handleObjectDecode(key: key) { (decoder: Decoder) -> T in
            try decoder.decode()
        }
    }

    public func decode<T: Decodable>(key: String,  nilIfMissing: Bool = false) throws -> T? {
        return try handleObjectDecode(key: key, nilIfMissing: nilIfMissing) { (decoder: Decoder) -> T in
            try decoder.decode()
        }
    }
    
    public func decode<T: Decodable>(key: String, valueIfMissing: T) throws -> T {
        return try handleObjectDecode(key: key, valueIfMissing: valueIfMissing) { (decoder: Decoder) -> T in
            try decoder.decode()
        }
    }
    
    public func decode<T: Decodable>(key: String, valueIfMissing: T?) throws -> T? {
        return try handleObjectDecode(key: key, valueIfMissingOrNull: valueIfMissing) { (decoder: Decoder) -> T in
            try decoder.decode()
        }
    }
    
    //MARK: - object - value
    public func decode<T: AnyDecodable>(key: String) throws -> T {
        return try handleObjectDecode(key: key) { (value: Any) -> T in
            try Decoding.decode(value)
        }
    }
    
    public func decode<T: AnyDecodable>(key: String,  nilIfMissing: Bool = false) throws -> T? {
        return try handleObjectDecode(key: key, nilIfMissing: nilIfMissing) { (value: Any) -> T in
            try Decoding.decode(value)
        }
    }
    
    public func decode<T: AnyDecodable>(key: String, valueIfMissing: T) throws -> T {
        return try handleObjectDecode(key: key, valueIfMissing: valueIfMissing) { (value: Any) -> T in
            try Decoding.decode(value)
        }
    }
    
    public func decode<T: AnyDecodable>(key: String, valueIfMissing: T?) throws -> T? {
        return try handleObjectDecode(key: key, valueIfMissingOrNull: valueIfMissing) { (value: Any) -> T in
            try Decoding.decode(value)
        }
    }
    
    //MARK: - array - object
    public func decode<T: Decodable>(key: String) throws -> [T] {
        return try handleObjectDecode(key: key) { (decoder: ArrayDecoder) -> [T] in
            try decoder.decode()
        }
    }
    
    public func decode<T: Decodable>(key: String,  nilIfMissing: Bool = false) throws -> [T]? {
        return try handleObjectDecode(key: key, nilIfMissing: nilIfMissing) { (decoder: ArrayDecoder) -> [T] in
            try decoder.decode()
        }
    }
    
    public func decode<T: Decodable>(key: String, valueIfMissing: [T]) throws -> [T] {
        return try handleObjectDecode(key: key, valueIfMissing: valueIfMissing) { (decoder: ArrayDecoder) -> [T] in
            try decoder.decode()
        }
    }
    
    public func decode<T: Decodable>(key: String, valueIfMissing: [T]?) throws -> [T]? {
        return try handleObjectDecode(key: key, valueIfMissingOrNull: valueIfMissing) { (decoder: ArrayDecoder) -> [T] in
            try decoder.decode()
        }
    }
    
    //MARK: - array - value
    public func decode<T: AnyDecodable>(key: String) throws -> [T] {
        return try handleObjectDecode(key: key) { (decoder: ArrayDecoder) -> [T] in
            try decoder.decode()
        }
    }
    
    public func decode<T: AnyDecodable>(key: String,  nilIfMissing: Bool = false) throws -> [T]? {
        return try handleObjectDecode(key: key, nilIfMissing: nilIfMissing) { (decoder: ArrayDecoder) -> [T] in
            try decoder.decode()
        }
    }
    
    public func decode<T: AnyDecodable>(key: String, valueIfMissing: [T]) throws -> [T] {
        return try handleObjectDecode(key: key, valueIfMissing: valueIfMissing) { (decoder: ArrayDecoder) -> [T] in
            try decoder.decode()
        }
    }
    
    public func decode<T: AnyDecodable>(key: String, valueIfMissing: [T]?) throws -> [T]? {
        return try handleObjectDecode(key: key, valueIfMissingOrNull: valueIfMissing) { (decoder: ArrayDecoder) -> [T] in
            try decoder.decode()
        }
    }

    //MARK: - nulllable array
    
    public func decode<T: Decodable>(key: String) throws -> [T?] {
        return try handleObjectDecode(key: key) { (decoder: ArrayDecoder) -> [T?] in
            try decoder.decode()
        }
    }
    
    public func decode<T: Decodable>(key: String,  nilIfMissing: Bool = false) throws -> [T?]? {
        return try handleObjectDecode(key: key, nilIfMissing: nilIfMissing) { (decoder: ArrayDecoder) -> [T?] in
            try decoder.decode()
        }
    }
    
    public func decode<T: Decodable>(key: String, valueIfMissing: [T?]) throws -> [T?] {
        return try handleObjectDecode(key: key, valueIfMissing: valueIfMissing) { (decoder: ArrayDecoder) -> [T?] in
            try decoder.decode()
        }
    }
    
    public func decode<T: Decodable>(key: String, valueIfMissing: [T?]?) throws -> [T?]? {
        return try handleObjectDecode(key: key, valueIfMissingOrNull: valueIfMissing) { (decoder: ArrayDecoder) -> [T?] in
            try decoder.decode()
        }
    }
    
    public func decode<T: AnyDecodable>(key: String) throws -> [T?] {
        return try handleObjectDecode(key: key) { (decoder: ArrayDecoder) -> [T?] in
            try decoder.decode()
        }
    }
    
    public func decode<T: AnyDecodable>(key: String,  nilIfMissing: Bool = false) throws -> [T?]? {
        return try handleObjectDecode(key: key, nilIfMissing: nilIfMissing) { (decoder: ArrayDecoder) -> [T?] in
            try decoder.decode()
        }
    }
    
    public func decode<T: AnyDecodable>(key: String, valueIfMissing: [T?]) throws -> [T?] {
        return try handleObjectDecode(key: key, valueIfMissing: valueIfMissing) { (decoder: ArrayDecoder) -> [T?] in
            try decoder.decode()
        }
    }
    
    public func decode<T: AnyDecodable>(key: String, valueIfMissing: [T?]?) throws -> [T?]? {
        return try handleObjectDecode(key: key, valueIfMissingOrNull: valueIfMissing) { (decoder: ArrayDecoder) -> [T?] in
            try decoder.decode()
        }
    }

    //MARK: - dictionary
    
    public func decode<T: Decodable>(key: String) throws -> [String: T] {
        return try handleObjectDecode(key: key) { (decoder: [String: Any]) -> [String: T] in
            try decoder.decode()
        }
    }
    
    public func decode<T: Decodable>(key: String,  nilIfMissing: Bool = false) throws -> [String: T]? {
        return try handleObjectDecode(key: key, nilIfMissing: nilIfMissing) { (decoder: [String: Any]) -> [String: T] in
            try decoder.decode()
        }
    }
    
    public func decode<T: Decodable>(key: String, valueIfMissing: [String: T]) throws -> [String: T] {
        return try handleObjectDecode(key: key, valueIfMissing: valueIfMissing) { (decoder: [String: Any]) -> [String: T] in
            try decoder.decode()
        }
    }
    
    public func decode<T: Decodable>(key: String, valueIfMissing: [String: T]?) throws -> [String: T]? {
        return try handleObjectDecode(key: key, valueIfMissingOrNull: valueIfMissing) { (decoder: [String: Any]) -> [String: T] in
            try decoder.decode()
        }
    }
    
    public func decode<T: AnyDecodable>(key: String) throws -> [String: T] {
        return try handleObjectDecode(key: key) { (decoder: [String: Any]) -> [String: T] in
            try decoder.decode()
        }
    }
    
    public func decode<T: AnyDecodable>(key: String,  nilIfMissing: Bool = false) throws -> [String: T]? {
        return try handleObjectDecode(key: key, nilIfMissing: nilIfMissing) { (decoder: [String: Any]) -> [String: T] in
            try decoder.decode()
        }
    }
    
    public func decode<T: AnyDecodable>(key: String, valueIfMissing: [String: T]) throws -> [String: T] {
        return try handleObjectDecode(key: key, valueIfMissing: valueIfMissing) { (decoder: [String: Any]) -> [String: T] in
            try decoder.decode()
        }
    }
    
    public func decode<T: AnyDecodable>(key: String, valueIfMissing: [String: T]?) throws -> [String: T]? {
        return try handleObjectDecode(key: key, valueIfMissingOrNull: valueIfMissing) { (decoder: [String: Any]) -> [String: T] in
            try decoder.decode()
        }
    }
    
    //MARK: nulllable dictionary
    
    public func decode<T: Decodable>(key: String) throws -> [String: T?] {
        return try handleObjectDecode(key: key) { (decoder: [String: Any]) -> [String: T?] in
            try decoder.decode()
        }
    }
    
    public func decode<T: Decodable>(key: String,  nilIfMissing: Bool = false) throws -> [String: T?]? {
        return try handleObjectDecode(key: key, nilIfMissing: nilIfMissing) { (decoder: [String: Any]) -> [String: T?] in
            try decoder.decode()
        }
    }
    
    public func decode<T: Decodable>(key: String, valueIfMissing: [String: T?]) throws -> [String: T?] {
        return try handleObjectDecode(key: key, valueIfMissing: valueIfMissing) { (decoder: [String: Any]) -> [String: T?] in
            try decoder.decode()
        }
    }
    
    public func decode<T: Decodable>(key: String, valueIfMissing: [String: T?]?) throws -> [String: T?]? {
        return try handleObjectDecode(key: key, valueIfMissingOrNull: valueIfMissing) { (decoder: [String: Any]) -> [String: T?] in
            try decoder.decode()
        }
    }
    
    public func decode<T: AnyDecodable>(key: String) throws -> [String: T?] {
        return try handleObjectDecode(key: key) { (decoder: [String: Any]) -> [String: T?] in
            try decoder.decode()
        }
    }
    
    public func decode<T: AnyDecodable>(key: String,  nilIfMissing: Bool = false) throws -> [String: T?]? {
        return try handleObjectDecode(key: key, nilIfMissing: nilIfMissing) { (decoder: [String: Any]) -> [String: T?] in
            try decoder.decode()
        }
    }
    
    public func decode<T: AnyDecodable>(key: String, valueIfMissing: [String: T?]) throws -> [String: T?] {
        return try handleObjectDecode(key: key, valueIfMissing: valueIfMissing) { (decoder: [String: Any]) -> [String: T?] in
            try decoder.decode()
        }
    }
    
    public func decode<T: AnyDecodable>(key: String, valueIfMissing: [String: T?]?) throws -> [String: T?]? {
        return try handleObjectDecode(key: key, valueIfMissingOrNull: valueIfMissing) { (decoder: [String: Any]) -> [String: T?] in
            try decoder.decode()
        }
    }
}

extension ArrayDecoder {
    public func decode<T: Decodable>() throws -> [T] {
        return try anyMap { el in
            try commitAction(path: .index(el.offset)) {
                return try Decoding.decode(el.element)
            }
        }
    }
    
    public func decode<T: Decodable>() throws -> [T?] {
        return try anyMap { el in
            try commitAction(path: .index(el.offset)) {
                return try doActionHandlingNull(value: el.element) {
                    return try Decoding.decode(el.element)
                }
            }
        }
    }
    
    public func decode<T: AnyDecodable>() throws -> [T] {
        return try anyMap { el in
            try commitAction(path: .index(el.offset)) {
                try Decoding.decode(el.element)
            }
        }
    }
    
    public func decode<T: AnyDecodable>() throws -> [T?] {
        return try anyMap { el in
            try commitAction(path: .index(el.offset)) {
                return try doActionHandlingNull(value: el.element) {
                    return try Decoding.decode(el.element)
                }
            }
        }
    }
}

extension Dictionary where Key == String, Value == Any {
    public func decode<T: Decodable>() throws -> [String: T] {
        return try map { (key, value) in
            try commitAction(path: .key(key)) {
                return try Decoding.decode(value)
            }
        }
    }
    
    public func decode<T: Decodable>() throws -> [String: T?] {
        return try map { (key, value) in
            try commitAction(path: .key(key)) {
                return try doActionHandlingNull(value: value) {
                    return try Decoding.decode(value)
                }
            }
        }
    }
    
    public func decode<T: AnyDecodable>() throws -> [String: T] {
        return try map { (key, value) in
            try commitAction(path: .key(key)) {
                try Decoding.decode(value)
            }
        }
    }
    
    public func decode<T: AnyDecodable>() throws -> [String: T?] {
        return try map { (key, value) in
            try commitAction(path: .key(key)) {
                return try doActionHandlingNull(value: value) {
                    return try Decoding.decode(value)
                }
            }
        }
    }
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



fileprivate func castValue<T, U>(_ value: Any, action: (T) throws ->U) throws -> U {
    if let target = value as? T {
        return try action(target)
    } else {
        throw DecoderErrorType.invalidType(T.self, value).error
    }
}

public struct Decoding {
    public static func decode<T: AnyDecodable>(_ value: Any) throws -> T {
        if let value = try T.init(anyValue: value) {
            return value
        } else {
            throw DecoderErrorType.invalidType(T.self, value).error
        }
    }
    
    public static func decode<T: Decodable>(_ value: Any) throws -> T {
        return try castValue(value) { (decoder: Decoder) in
            try decoder.decode()
        }
    }
    
    public static func decode<T: Decodable>(_ value: Any) throws -> [T] {
        return try castValue(value) { (decoder: ArrayDecoder) in
            try decoder.decode()
        }
    }
    
    public static func decode<T: Decodable>(_ value: Any) throws -> [T?] {
        return try castValue(value) { (decoder: ArrayDecoder) in
            try decoder.decode()
        }
    }
    
    public static func decode<T: Decodable>(_ value: Any) throws -> [String: T] {
        return try castValue(value) { (decoder: [String: Any]) in
            try decoder.decode()
        }
    }
    
    public static func decode<T: Decodable>(_ value: Any) throws -> [String: T?] {
        return try castValue(value) { (decoder: [String: Any]) in
            try decoder.decode()
        }
    }
}


