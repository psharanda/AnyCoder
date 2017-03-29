//
//  Created by Pavel Sharanda on 29.09.16.
//  Copyright © 2016 Pavel Sharanda. All rights reserved.
//

import Foundation

public typealias Decoder = [String: Any]

public protocol Decodable {
    init?(decoder: Decoder) throws
}

public protocol AnyDecodable {
    init?(anyValue: Any) throws
}

extension Dictionary where Key == String, Value == Any {
    
    public func decoder(forKey key: String) throws -> Decoder {        
        if let value = self[key] {
            if let target = value as? Decoder {
                return target
            } else {
                throw DecoderErrorType.invalidType(Decoder.self, value).error
            }
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
    
    //MARK:- decode value at key
    
    private func handleDecode<T, U>(key: String, action: (T) throws -> U) throws -> U {
        return try handleAction(path: .key(key)) {
            if let value = self[key] {
                if let target = value as? T {
                    return try action(target)
                } else {
                    throw DecoderErrorType.invalidType(T.self, self).error
                }
            } else {
                throw DecoderErrorType.missing.error
            }
        }
    }
    
    private func handleDecode<T, U>(key: String, nilIfMissing: Bool, action: (T) throws -> U) throws -> U? {
        return try handleAction(path: .key(key)) {
            if let value = self[key] {
                if value is NSNull {
                    return nil
                } else if let target = value as? T {
                    return try action(target)
                } else {
                    throw DecoderErrorType.invalidType(T.self, self).error
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
    
    private func handleDecode<T, U>(key: String, defaultValue: U, action: (T) throws -> U) throws -> U {
        return try handleAction(path: .key(key)) {
            if let value = self[key] {
                if let target = value as? T {
                    return (try? action(target)) ?? defaultValue
                } else {
                    throw DecoderErrorType.invalidType(T.self, self).error
                }
            } else {
                return defaultValue
            }
        }
    }
    
    private func handleDecode<T, U>(key: String, defaultValueOrNull: U?, action: (T) throws -> U) throws -> U? {
        return try handleAction(path: .key(key)) {
            if let value = self[key] {
                if value is NSNull {
                    return nil
                } else if let target = value as? T {
                    return (try? action(target)) ?? defaultValueOrNull
                } else {
                    throw DecoderErrorType.invalidType(T.self, self).error
                }
            } else {
                return defaultValueOrNull
            }
        }
    }
    
    
    //MARK: - object
    public func decode<T: Decodable>(key: String) throws -> T {
        return try handleDecode(key: key) { (decoder: Decoder) -> T in
            try decoder.decode()
        }
    }

    public func decode<T: Decodable>(key: String,  nilIfMissing: Bool = false) throws -> T? {
        return try handleDecode(key: key, nilIfMissing: nilIfMissing) { (decoder: Decoder) -> T in
            try decoder.decode()
        }
    }
    
    public func decode<T: Decodable>(key: String, defaultValue: T) throws -> T {
        return try handleDecode(key: key, defaultValue: defaultValue) { (decoder: Decoder) -> T in
            try decoder.decode()
        }
    }
    
    public func decode<T: Decodable>(key: String, defaultValue: T?) throws -> T? {
        return try handleDecode(key: key, defaultValueOrNull: defaultValue) { (decoder: Decoder) -> T in
            try decoder.decode()
        }
    }
    
    public func decode<T: AnyDecodable>(key: String) throws -> T {
        return try handleDecode(key: key) { (anyValue: Any) -> T in
            try decodeValue(anyValue)
        }
    }
    
    public func decode<T: AnyDecodable>(key: String,  nilIfMissing: Bool = false) throws -> T? {
        return try handleDecode(key: key, nilIfMissing: nilIfMissing) { (anyValue: Any) -> T in
            try decodeValue(anyValue)
        }
    }
    
    public func decode<T: AnyDecodable>(key: String, defaultValue: T) throws -> T {
        return try handleDecode(key: key, defaultValue: defaultValue) { (anyValue: Any) -> T in
            try decodeValue(anyValue)
        }
    }
    
    public func decode<T: AnyDecodable>(key: String, defaultValue: T?) throws -> T? {
        return try handleDecode(key: key, defaultValueOrNull: defaultValue) { (anyValue: Any) -> T in
            try decodeValue(anyValue)
        }
    }
    
    //MARK: - array
    
    public func decode<T: Decodable>(key: String) throws -> [T] {
        return try handleDecode(key: key) { (decoder: [Any]) -> [T] in
            try decoder.decode()
        }
    }
    
    public func decode<T: Decodable>(key: String,  nilIfMissing: Bool = false) throws -> [T]? {
        return try handleDecode(key: key, nilIfMissing: nilIfMissing) { (decoder: [Any]) -> [T] in
            try decoder.decode()
        }
    }
    
    public func decode<T: Decodable>(key: String, defaultValue: [T]) throws -> [T] {
        return try handleDecode(key: key, defaultValue: defaultValue) { (decoder: [Any]) -> [T] in
            try decoder.decode()
        }
    }
    
    public func decode<T: Decodable>(key: String, defaultValue: [T]?) throws -> [T]? {
        return try handleDecode(key: key, defaultValueOrNull: defaultValue) { (decoder: [Any]) -> [T] in
            try decoder.decode()
        }
    }
    
    public func decode<T: AnyDecodable>(key: String) throws -> [T] {
        return try handleDecode(key: key) { (anyValue: [Any]) -> [T] in
            try anyValue.decode()
        }
    }
    
    public func decode<T: AnyDecodable>(key: String,  nilIfMissing: Bool = false) throws -> [T]? {
        return try handleDecode(key: key, nilIfMissing: nilIfMissing) { (anyValue: [Any]) -> [T] in
            try anyValue.decode()
        }
    }
    
    public func decode<T: AnyDecodable>(key: String, defaultValue: [T]) throws -> [T] {
        return try handleDecode(key: key, defaultValue: defaultValue) { (anyValue: [Any]) -> [T] in
            try anyValue.decode()
        }
    }
    
    public func decode<T: AnyDecodable>(key: String, defaultValue: [T]?) throws -> [T]? {
        return try handleDecode(key: key, defaultValueOrNull: defaultValue) { (anyValue: [Any]) -> [T] in
            try anyValue.decode()
        }
    }

    //MARK: - nulllable array
    
    public func decode<T: Decodable>(key: String) throws -> [T?] {
        return try handleDecode(key: key) { (decoder: [Any]) -> [T?] in
            try decoder.decode()
        }
    }
    
    public func decode<T: Decodable>(key: String,  nilIfMissing: Bool = false) throws -> [T?]? {
        return try handleDecode(key: key, nilIfMissing: nilIfMissing) { (decoder: [Any]) -> [T?] in
            try decoder.decode()
        }
    }
    
    public func decode<T: Decodable>(key: String, defaultValue: [T?]) throws -> [T?] {
        return try handleDecode(key: key, defaultValue: defaultValue) { (decoder: [Any]) -> [T?] in
            try decoder.decode()
        }
    }
    
    public func decode<T: Decodable>(key: String, defaultValue: [T?]?) throws -> [T?]? {
        return try handleDecode(key: key, defaultValueOrNull: defaultValue) { (decoder: [Any]) -> [T?] in
            try decoder.decode()
        }
    }
    
    public func decode<T: AnyDecodable>(key: String) throws -> [T?] {
        return try handleDecode(key: key) { (anyValue: [Any]) -> [T?] in
            try anyValue.decode()
        }
    }
    
    public func decode<T: AnyDecodable>(key: String,  nilIfMissing: Bool = false) throws -> [T?]? {
        return try handleDecode(key: key, nilIfMissing: nilIfMissing) { (anyValue: [Any]) -> [T?] in
            try anyValue.decode()
        }
    }
    
    public func decode<T: AnyDecodable>(key: String, defaultValue: [T?]) throws -> [T?] {
        return try handleDecode(key: key, defaultValue: defaultValue) { (anyValue: [Any]) -> [T?] in
            try anyValue.decode()
        }
    }
    
    public func decode<T: AnyDecodable>(key: String, defaultValue: [T?]?) throws -> [T?]? {
        return try handleDecode(key: key, defaultValueOrNull: defaultValue) { (anyValue: [Any]) -> [T?] in
            try anyValue.decode()
        }
    }

    //MARK: - dictionary
    
    public func decode<T: Decodable>(key: String) throws -> [String: T] {
        return try handleDecode(key: key) { (decoder: [String: Any]) -> [String: T] in
            try decoder.decode()
        }
    }
    
    public func decode<T: Decodable>(key: String,  nilIfMissing: Bool = false) throws -> [String: T]? {
        return try handleDecode(key: key, nilIfMissing: nilIfMissing) { (decoder: [String: Any]) -> [String: T] in
            try decoder.decode()
        }
    }
    
    public func decode<T: Decodable>(key: String, defaultValue: [String: T]) throws -> [String: T] {
        return try handleDecode(key: key, defaultValue: defaultValue) { (decoder: [String: Any]) -> [String: T] in
            try decoder.decode()
        }
    }
    
    public func decode<T: Decodable>(key: String, defaultValue: [String: T]?) throws -> [String: T]? {
        return try handleDecode(key: key, defaultValueOrNull: defaultValue) { (decoder: [String: Any]) -> [String: T] in
            try decoder.decode()
        }
    }
    
    public func decode<T: AnyDecodable>(key: String) throws -> [String: T] {
        return try handleDecode(key: key) { (anyValue: [String: Any]) -> [String: T] in
            try anyValue.decode()
        }
    }
    
    public func decode<T: AnyDecodable>(key: String,  nilIfMissing: Bool = false) throws -> [String: T]? {
        return try handleDecode(key: key, nilIfMissing: nilIfMissing) { (anyValue: [String: Any]) -> [String: T] in
            try anyValue.decode()
        }
    }
    
    public func decode<T: AnyDecodable>(key: String, defaultValue: [String: T]) throws -> [String: T] {
        return try handleDecode(key: key, defaultValue: defaultValue) { (anyValue: [String: Any]) -> [String: T] in
            try anyValue.decode()
        }
    }
    
    public func decode<T: AnyDecodable>(key: String, defaultValue: [String: T]?) throws -> [String: T]? {
        return try handleDecode(key: key, defaultValueOrNull: defaultValue) { (anyValue: [String: Any]) -> [String: T] in
            try anyValue.decode()
        }
    }
    
    //MARK: nulllable dictionary
    
    public func decode<T: Decodable>(key: String) throws -> [String: T?] {
        return try handleDecode(key: key) { (decoder: [String: Any]) -> [String: T?] in
            try decoder.decode()
        }
    }
    
    public func decode<T: Decodable>(key: String,  nilIfMissing: Bool = false) throws -> [String: T?]? {
        return try handleDecode(key: key, nilIfMissing: nilIfMissing) { (decoder: [String: Any]) -> [String: T?] in
            try decoder.decode()
        }
    }
    
    public func decode<T: Decodable>(key: String, defaultValue: [String: T?]) throws -> [String: T?] {
        return try handleDecode(key: key, defaultValue: defaultValue) { (decoder: [String: Any]) -> [String: T?] in
            try decoder.decode()
        }
    }
    
    public func decode<T: Decodable>(key: String, defaultValue: [String: T?]?) throws -> [String: T?]? {
        return try handleDecode(key: key, defaultValueOrNull: defaultValue) { (decoder: [String: Any]) -> [String: T?] in
            try decoder.decode()
        }
    }
    
    public func decode<T: AnyDecodable>(key: String) throws -> [String: T?] {
        return try handleDecode(key: key) { (anyValue: [String: Any]) -> [String: T?] in
            try anyValue.decode()
        }
    }
    
    public func decode<T: AnyDecodable>(key: String,  nilIfMissing: Bool = false) throws -> [String: T?]? {
        return try handleDecode(key: key, nilIfMissing: nilIfMissing) { (anyValue: [String: Any]) -> [String: T?] in
            try anyValue.decode()
        }
    }
    
    public func decode<T: AnyDecodable>(key: String, defaultValue: [String: T?]) throws -> [String: T?] {
        return try handleDecode(key: key, defaultValue: defaultValue) { (anyValue: [String: Any]) -> [String: T?] in
            try anyValue.decode()
        }
    }
    
    public func decode<T: AnyDecodable>(key: String, defaultValue: [String: T?]?) throws -> [String: T?]? {
        return try handleDecode(key: key, defaultValueOrNull: defaultValue) { (anyValue: [String: Any]) -> [String: T?] in
            try anyValue.decode()
        }
    }
}

extension Array where Element == Any {
    public func decode<T: Decodable>() throws -> [T] {
        return try enumerated().map { el in
            try handleAction(path: .index(el.offset)) {
                if let dict = el.element as? Decoder {
                    return try dict.decode()
                } else {
                    throw DecoderErrorType.invalidType(T.self, $0).error
                }
            }
        }
    }
    
    public func decode<T: Decodable>() throws -> [T?] {
        return try enumerated().map { el in
            try handleAction(path: .index(el.offset)) {
                if let dict = el.element as? Decoder {
                    return try dict.decode()
                } else if el.element is NSNull {
                    return nil
                } else {
                    throw DecoderErrorType.invalidType(T.self, $0).error
                }
            }
        }
    }
    
    public func decode<T: AnyDecodable>() throws -> [T] {
        return try enumerated().map { el in
            try handleAction(path: .index(el.offset)) {
                try decodeValue(el.element)
            }
        }
    }
    
    public func decode<T: AnyDecodable>() throws -> [T?] {
        return try enumerated().map { el in
            try handleAction(path: .index(el.offset)) {
                if el.element is NSNull {
                    return nil
                } else {
                    return try decodeValue(el.element) as T?
                }
            }
        }
    }
}

extension Dictionary where Key == String, Value == Any {
    public func decode<T: Decodable>() throws -> [String: T] {
        return try map { (key, value) in
            try handleAction(path: .key(key)) {
                if let dict = value as? Decoder {
                    return try dict.decode()
                } else {
                    throw DecoderErrorType.invalidType(T.self, $0).error
                }
            }
        }
    }
    
    public func decode<T: Decodable>() throws -> [String: T?] {
        return try map { (key, value) in
            try handleAction(path: .key(key)) {
                if let dict = value as? Decoder {
                    return try dict.decode()
                } else if value is NSNull {
                    return nil
                } else {
                    throw DecoderErrorType.invalidType(T.self, $0).error
                }
            }
        }
    }
    
    public func decode<T: AnyDecodable>() throws -> [String: T] {
        return try map { (key, value) in
            try handleAction(path: .key(key)) {
                try decodeValue(value)
            }
        }
    }
    
    public func decode<T: AnyDecodable>() throws -> [String: T?] {
        return try map { (key, value) in
            try handleAction(path: .key(key)) {
                if value is NSNull {
                    return nil
                } else {
                    return try decodeValue(value) as T?
                }
            }
        }
    }
}

fileprivate func handleAction<U>(path: DecoderErrorPathComponent, action: () throws ->U) throws -> U {
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

fileprivate func decodeValue<T: AnyDecodable>(_ value: Any) throws -> T {
    if let value = try T.init(anyValue: value) {
        return value
    } else {
        throw DecoderErrorType.invalidType(T.self, value).error
    }
}

