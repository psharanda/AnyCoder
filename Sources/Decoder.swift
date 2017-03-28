//
//  Created by Pavel Sharanda on 29.09.16.
//  Copyright © 2016 Pavel Sharanda. All rights reserved.
//

import Foundation


public protocol Decodable {
    init?(decoder: Decoder) throws
}

private enum DecodingResult<T> {
    case usingDefaultValue(T)
    case usingDecoder(Decoder)
}

public final class Decoder {
    
    public let value: Any
    private let keyPath: [String]

    private init(value: Any, keyPath: [String] = []) {
        self.value = value
        self.keyPath = keyPath
    }
    
    public init(value: Any) {
        self.value = value
        self.keyPath = []
    }
    
    //MARK:- cast cache
    
    private var dictionary: [String: Any]?
    private var array: [Any]?
    private var dictionaryOfArrays: [String: [Any]]?
    
    private func asDictionary() throws -> [String: Any] {
        if let dictionary = dictionary {
            return dictionary
        } else {
            let dictionary = try extractValue() as [String: Any]
            self.dictionary = dictionary
            return dictionary
        }
    }
    
    private func asArray() throws -> [Any] {
        if let array = array {
            return array
        } else {
            let array = try extractValue() as [Any]
            self.array = array
            return array
        }
    }
    
    private func asDictionaryOfArrays() throws -> [String: [Any]] {
        if let dictionaryOfArrays = dictionaryOfArrays {
            return dictionaryOfArrays
        } else {
            let dictionaryOfArrays = try extractValue() as [String: [Any]]
            self.dictionaryOfArrays = dictionaryOfArrays
            return dictionaryOfArrays
        }
    }
    
    //MARK:- utils

    public func extractValue<T>() throws -> T {
        if let value = value as? T {
            return value
        } else {
            throw DecoderError.invalidType(keyPath: keyPath, type: T.self, value: value)
        }
    }
    
    public func decoder(forKey key: String) throws -> Decoder {
        
        guard let value = try asDictionary()[key] else {
            throw DecoderError.missing(keyPath: keyPath + [key])
        }
        return Decoder(value: value, keyPath: keyPath + [key])
    }
    
    public func decoder(forKey key: String, nilIfMissing: Bool = false) throws -> Decoder? {
        
        guard let value = try asDictionary()[key] else {
            if nilIfMissing {
                return nil
            }
            throw DecoderError.missing(keyPath: keyPath + [key])
        }
        return Decoder(value: value, keyPath: keyPath + [key])
    }
    
    private func decodingResultForKey<T>(_ key: String, defaultValue: T) throws -> DecodingResult<T> {
        guard let value = try asDictionary()[key] else {
            return .usingDefaultValue(defaultValue)
        }
        return .usingDecoder(Decoder(value: value, keyPath: keyPath + [key]))
    }
    
    
    //MARK:- decode self
    private func decodeSelf<T: Decodable>() throws -> T {
        if let value = try T.init(decoder: self) {
            return value
        } else {
            throw DecoderError.failed(keyPath: keyPath, type: T.self, value: value)
        }
    }
    
    private func doAndThrowIfNullWasFound<T>(action: () throws ->T) throws -> T {
        do {
            return try action()
        }
        catch (let error as DecoderError) {
            if value is NSNull {
                throw DecoderError.nonnullable(keyPath: keyPath)
            } else {
                throw error
            }
        }
        catch {
            throw error
        }
    }
    
    private func doAndReturnNilIfNullWasFound<T>(action: () throws ->T) throws -> T? {
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
    
    public func decode<T: Decodable>() throws -> T {
        return try doAndThrowIfNullWasFound {
            try decodeSelf()
        }
    }
    
    public func decode<T: Decodable>() throws -> T? {
        return try doAndReturnNilIfNullWasFound {
            try decodeSelf()
        }
    }
    
    //MARK:- decode self as array
    public func decode<T: Decodable>() throws -> [T] {
        return try doAndThrowIfNullWasFound {
            try asArray().map { try Decoder(value: $0, keyPath: keyPath).decode() }
        }
    }
    
    public func decode<T: Decodable>() throws -> [T]? {
        return try doAndReturnNilIfNullWasFound {
            try asArray().map { try Decoder(value: $0, keyPath: keyPath).decode() }
        }
        
    }
    
    //MARK:- decode self as map
    public func decode<T: Decodable>() throws -> [String: T] {
        return try doAndThrowIfNullWasFound {
            try asDictionary().map { try Decoder(value: $0, keyPath: keyPath).decode() }
        }
    }
    
    public func decode<T: Decodable>() throws -> [String: T]? {
        return try doAndReturnNilIfNullWasFound {
            try asDictionary().map { try Decoder(value: $0, keyPath: keyPath).decode() }
        }
    }
    
    //MARK:- decode self as map of arrays
    public func decode<T: Decodable>() throws -> [String: [T]] {
        return try doAndThrowIfNullWasFound {
            return try asDictionaryOfArrays().map { try Decoder(value: $0 as Any, keyPath: keyPath).decode() }
        }
    }
    
    public func decode<T: Decodable>() throws -> [String: [T]]? {
        return try doAndReturnNilIfNullWasFound {
            try asDictionaryOfArrays().map { try Decoder(value: $0 as Any, keyPath: keyPath).decode() }
        }
    }
    
    //MARK:- decode self as set
    public func decode<T: Decodable & Hashable>() throws -> Set<T> {
        return try doAndThrowIfNullWasFound {
            return try Set(asArray().map { try Decoder(value: $0 as Any, keyPath: keyPath).decode() })
        }
    }
    
    public func decode<T: Decodable & Hashable>() throws -> Set<T>? {
        return try doAndReturnNilIfNullWasFound {
            return try Set(asArray().map { try Decoder(value: $0 as Any, keyPath: keyPath).decode() })
        }
    }
    
    //MARK:- decode value at key
    public func decode<T: Decodable>(key: String) throws -> T {
        return try decoder(forKey: key).decode()
    }
    
    public func decode<T: Decodable>(key: String,  nilIfMissing: Bool = false) throws -> T? {
        return try decoder(forKey: key, nilIfMissing: nilIfMissing)?.decode() as T?
    }
    
    public func decode<T: Decodable>(key: String, defaultValue: T) throws -> T {
        switch try decodingResultForKey(key, defaultValue: defaultValue) {
        case .usingDecoder(let decoder):
            return try decoder.decode()
        case .usingDefaultValue(let value):
            return value
        }
    }
    
    public func decode<T: Decodable>(key: String, defaultValue: T?) throws -> T? {
        switch try decodingResultForKey(key, defaultValue: defaultValue) {
        case .usingDecoder(let decoder):
            return try decoder.decode() as T?
        case .usingDefaultValue(let value):
            return value
        }
    }
    
    //MARK:- decode self as array
    public func decode<T: Decodable>(key: String) throws -> [T] {
        return try decoder(forKey: key).decode()
    }
    
    public func decode<T: Decodable>(key: String, nilIfMissing: Bool = false) throws -> [T]? {
        return try decoder(forKey: key, nilIfMissing: nilIfMissing)?.decode() as [T]?
    }
    
    public func decode<T: Decodable>(key: String, defaultValue: [T]) throws -> [T] {
        switch try decodingResultForKey(key, defaultValue: defaultValue) {
        case .usingDecoder(let decoder):
            return try decoder.decode()
        case .usingDefaultValue(let value):
            return value
        }
    }
    
    public func decode<T: Decodable>(key: String, defaultValue: [T]?) throws -> [T]? {
        switch try decodingResultForKey(key, defaultValue: defaultValue) {
        case .usingDecoder(let decoder):
            return try decoder.decode() as [T]?
        case .usingDefaultValue(let value):
            return value
        }
    }
    
    //MARK:- decode self as map
    public func decode<T: Decodable>(key: String) throws -> [String: T] {
        return try decoder(forKey: key).decode()
    }
    
    public func decode<T: Decodable>(key: String, nilIfMissing: Bool = false) throws -> [String: T]? {
        return try decoder(forKey: key, nilIfMissing: nilIfMissing)?.decode() as [String: T]?
    }
    
    public func decode<T: Decodable>(key: String, defaultValue: [String: T]) throws -> [String: T] {
        switch try decodingResultForKey(key, defaultValue: defaultValue) {
        case .usingDecoder(let decoder):
            return try decoder.decode()
        case .usingDefaultValue(let value):
            return value
        }
    }
    
    public func decode<T: Decodable>(key: String, defaultValue: [String: T]?) throws -> [String: T]? {
        switch try decodingResultForKey(key, defaultValue: defaultValue) {
        case .usingDecoder(let decoder):
            return try decoder.decode() as [String: T]?
        case .usingDefaultValue(let value):
            return value
        }
    }
    
    //MARK:- decode self as map of arrays
    public func decode<T: Decodable>(key: String) throws -> [String: [T]] {
        return try decoder(forKey: key).decode()
    }
    
    public func decode<T: Decodable>(key: String, nilIfMissing: Bool = false) throws -> [String: [T]]? {
        return try decoder(forKey: key, nilIfMissing: nilIfMissing)?.decode() as [String: [T]]?
    }
    
    public func decode<T: Decodable>(key: String, defaultValue: [String: [T]]) throws -> [String: [T]] {
        switch try decodingResultForKey(key, defaultValue: defaultValue) {
        case .usingDecoder(let decoder):
            return try decoder.decode()
        case .usingDefaultValue(let value):
            return value
        }
    }
    
    public func decode<T: Decodable>(key: String, defaultValue: [String: [T]]?) throws -> [String: [T]]? {
        switch try decodingResultForKey(key, defaultValue: defaultValue) {
        case .usingDecoder(let decoder):
            return try decoder.decode() as [String: [T]]?
        case .usingDefaultValue(let value):
            return value
        }
    }
    
    //MARK:- decode self as set
    public func decode<T: Decodable & Hashable>(key: String) throws -> Set<T> {
        return try decoder(forKey: key).decode()
    }
    
    public func decode<T: Decodable & Hashable>(key: String) throws ->  Set<T>? {
        return try decoder(forKey: key).decode() as Set<T>?
    }
    
    public func decode<T: Decodable & Hashable>(key: String, defaultValue:  Set<T>) throws ->  Set<T> {
        switch try decodingResultForKey(key, defaultValue: defaultValue) {
        case .usingDecoder(let decoder):
            return try decoder.decode()
        case .usingDefaultValue(let value):
            return value
        }
    }
    
    public func decode<T: Decodable & Hashable>(key: String, defaultValue: Set<T>?) throws -> Set<T>? {
        switch try decodingResultForKey(key, defaultValue: defaultValue) {
        case .usingDecoder(let decoder):
            return try decoder.decode() as Set<T>?
        case .usingDefaultValue(let value):
            return value
        }
    }
}


