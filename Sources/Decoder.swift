//
//  Created by Pavel Sharanda on 29.09.16.
//  Copyright © 2016 Pavel Sharanda. All rights reserved.
//

import Foundation

public protocol Decodable {
    init?(decoder: Decoder) throws
}

public struct Decoder {
    
    public let value: Any

    public init(value: Any) {
        self.value = value
    }
    
    private func asDictionary() throws -> [String: Any] {
        return try extractValue() as [String: Any]
    }
    
    private func asArray() throws -> [Any] {
        return try extractValue() as [Any]
    }
    
    private func asDictionaryOfArrays() throws -> [String: [Any]] {
        return try extractValue() as [String: [Any]]
    }
    
    //MARK:- utils

    public func extractValue<T>() throws -> T {
        if let value = value as? T {
            return value
        } else {
            throw DecoderErrorType.invalidType(T.self, value).error
        }
    }
    
    public func decoder(forKey key: String) throws -> Decoder {
        
        guard let value = try asDictionary()[key] else {
            throw DecoderErrorType.missing.error
        }
        return Decoder(value: value)
    }
    
    public func decoder(forKey key: String, nilIfMissing: Bool = false) throws -> Decoder? {
        
        guard let value = try asDictionary()[key] else {
            if nilIfMissing {
                return nil
            }
            throw DecoderErrorType.missing.error
        }
        return Decoder(value: value)
    }
    
    //MARK:- helpers
    
    private func handleAction<U>(path: DecoderErrorPathComponent, action: () throws ->U) throws -> U {
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
    
    private func handleNullableDecode<T>(action: () throws ->T?) throws -> T? {
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
    
    private func handleDefaultableDecode<U>(key: String, defaultValue: U, action: (Decoder) throws ->U) throws -> U {
        if let value = try asDictionary()[key] {
            return try handleAction(path: .key(key)) {
                try action(Decoder(value: value))
            }
        } else {
            return defaultValue
        }
    }
    
    //MARK:- decode self as decodable
    
    public func decode<T: Decodable>() throws -> T {
        if let value = try T.init(decoder: self) {
            return value
        } else {
            throw DecoderErrorType.failed(T.self, value).error
        }
    }
    
    public func decode<T: Decodable>() throws -> T? {
        return try handleNullableDecode {
            try decode() as T
        }
    }
    
    //MARK:- decode self as array
    public func decode<T: Decodable>() throws -> [T] {
        return try asArray().enumerated().map { el in
            return try handleAction(path: .index(el.offset)) {
                return try Decoder(value: el.element).decode()
            }
        }
    }
    
    public func decode<T: Decodable>() throws -> [T]? {
        return try handleNullableDecode {
            try decode() as [T]
        }
        
    }
    
    //MARK:- decode self as map
    public func decode<T: Decodable>() throws -> [String: T] {
        return try asDictionary().map { el in
            return try handleAction(path: .key(el.0)) {
                return try Decoder(value: el.1).decode()
            }
        }
    }
    
    public func decode<T: Decodable>() throws -> [String: T]? {
        return try handleNullableDecode {
            try decode() as [String: T]
        }
    }
    
    //MARK:- decode self as map of arrays
    public func decode<T: Decodable>() throws -> [String: [T]] {
        return try asDictionaryOfArrays().map { el in
            return try handleAction(path: .key(el.0)) {
                return try Decoder(value: el.1).decode()
            }
        }
    }
    
    public func decode<T: Decodable>() throws -> [String: [T]]? {
        return try handleNullableDecode {
            try decode() as  [String: [T]]
        }
    }
    
    //MARK:- decode self as set
    public func decode<T: Decodable & Hashable>() throws -> Set<T> {
        return try Set(asArray().enumerated().map { el in
            return try handleAction(path: .index(el.offset)) {
                return try Decoder(value: el.element).decode()
            }
        })
    }
    
    public func decode<T: Decodable & Hashable>() throws -> Set<T>? {
        return try handleNullableDecode {
            try decode() as Set<T>
        }
    }
    
    //MARK:- decode value at key
    
    public func decode<T: Decodable>(key: String) throws -> T {
        return try handleAction(path: .key(key)) {
            try decoder(forKey: key).decode()
        }
    }
    
    public func decode<T: Decodable>(key: String,  nilIfMissing: Bool = false) throws -> T? {
        
        return try handleAction(path: .key(key)) {
            try decoder(forKey: key, nilIfMissing: nilIfMissing)?.decode()
        }
    }
    
    public func decode<T: Decodable>(key: String, defaultValue: T) throws -> T {
        return try handleDefaultableDecode(key: key, defaultValue: defaultValue) { decoder in
            try decoder.decode()
        }
    }
    
    public func decode<T: Decodable>(key: String, defaultValue: T?) throws -> T? {
        return try handleDefaultableDecode(key: key, defaultValue: defaultValue) { decoder in
            try decoder.decode()
        }
    }
    
    //MARK:- decode self as array
    public func decode<T: Decodable>(key: String) throws -> [T] {
        return try handleAction(path: .key(key)) {
            try  decoder(forKey: key).decode()
        }
    }
    
    public func decode<T: Decodable>(key: String, nilIfMissing: Bool = false) throws -> [T]? {
        return try handleAction(path: .key(key)) {
            try  decoder(forKey: key, nilIfMissing: nilIfMissing)?.decode() as [T]?
        }
    }
    
    public func decode<T: Decodable>(key: String, defaultValue: [T]) throws -> [T] {
        return try handleDefaultableDecode(key: key, defaultValue: defaultValue) { decoder in
            try decoder.decode()
        }
    }
    
    public func decode<T: Decodable>(key: String, defaultValue: [T]?) throws -> [T]? {
        return try handleDefaultableDecode(key: key, defaultValue: defaultValue) { decoder in
            try decoder.decode()
        }
    }
    
    //MARK:- decode self as map
    public func decode<T: Decodable>(key: String) throws -> [String: T] {
        return try handleAction(path: .key(key)) {
            try  decoder(forKey: key).decode()
        }
    }
    
    public func decode<T: Decodable>(key: String, nilIfMissing: Bool = false) throws -> [String: T]? {
        return try handleAction(path: .key(key)) {
            try  decoder(forKey: key, nilIfMissing: nilIfMissing)?.decode()
        }
    }
    
    public func decode<T: Decodable>(key: String, defaultValue: [String: T]) throws -> [String: T] {
        return try handleDefaultableDecode(key: key, defaultValue: defaultValue) { decoder in
            try decoder.decode()
        }
    }
    
    public func decode<T: Decodable>(key: String, defaultValue: [String: T]?) throws -> [String: T]? {
        return try handleDefaultableDecode(key: key, defaultValue: defaultValue) { decoder in
            try decoder.decode()
        }
    }
    
    //MARK:- decode self as map of arrays
    public func decode<T: Decodable>(key: String) throws -> [String: [T]] {
        return try handleAction(path: .key(key)) {
            try  decoder(forKey: key).decode()
        }
    }
    
    public func decode<T: Decodable>(key: String, nilIfMissing: Bool = false) throws -> [String: [T]]? {
        return try handleAction(path: .key(key)) {
            try  decoder(forKey: key, nilIfMissing: nilIfMissing)?.decode()
        }
    }
    
    public func decode<T: Decodable>(key: String, defaultValue: [String: [T]]) throws -> [String: [T]] {
        return try handleDefaultableDecode(key: key, defaultValue: defaultValue) { decoder in
            try decoder.decode()
        }
    }
    
    public func decode<T: Decodable>(key: String, defaultValue: [String: [T]]?) throws -> [String: [T]]? {
        return try handleDefaultableDecode(key: key, defaultValue: defaultValue) { decoder in
            try decoder.decode()
        }
    }
    
    //MARK:- decode self as set
    public func decode<T: Decodable & Hashable>(key: String) throws -> Set<T> {
        return try handleAction(path: .key(key)) {
            try  decoder(forKey: key).decode()
        }
    }
    
    public func decode<T: Decodable & Hashable>(key: String) throws ->  Set<T>? {
        return try handleAction(path: .key(key)) {
            try  decoder(forKey: key).decode()
        }
    }
    
    public func decode<T: Decodable & Hashable>(key: String, defaultValue:  Set<T>) throws ->  Set<T> {
        return try handleDefaultableDecode(key: key, defaultValue: defaultValue) { decoder in
            try decoder.decode()
        }
    }
    
    public func decode<T: Decodable & Hashable>(key: String, defaultValue: Set<T>?) throws -> Set<T>? {
        return try handleDefaultableDecode(key: key, defaultValue: defaultValue) { decoder in
            try decoder.decode()
        }
    }
}




