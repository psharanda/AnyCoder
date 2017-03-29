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
    
    private func decodingResultForKey<T>(_ key: String, defaultValue: T) throws -> DecodingResult<T> {
        guard let value = try asDictionary()[key] else {
            return .usingDefaultValue(defaultValue)
        }
        return .usingDecoder(Decoder(value: value))
    }
    
    
    //MARK:- decode self
    private func decodeSelf<T: Decodable>() throws -> T {
        if let value = try T.init(decoder: self) {
            return value
        } else {
            throw DecoderErrorType.failed(T.self, value).error
        }
    }
    
    private func decodeSelf<T: Decodable>() throws -> T? {
        return try T.init(decoder: self)
    }

    
    private func doAndReturnNilIfNullWasFound<T>(action: () throws ->T?) throws -> T? {
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
        return try decodeSelf()
    }
    
    public func decode<T: Decodable>() throws -> T? {
        return try doAndReturnNilIfNullWasFound {
            try decodeSelf()
        }
    }
    
    //MARK:- decode self as array
    public func decode<T: Decodable>() throws -> [T] {
        return try asArray().enumerated().map {
            do {
                return try Decoder(value: $0.element).decode()
            }
            catch (let error as DecoderError) {
                throw error.backtraceError(path: .index($0.offset))
            }
            catch {
                throw error
            }
        }
    }
    
    public func decode<T: Decodable>() throws -> [T]? {
        return try doAndReturnNilIfNullWasFound {
            try asArray().enumerated().map {
                do {
                    return try Decoder(value: $0.element).decode()
                }
                catch (let error as DecoderError) {
                    throw error.backtraceError(path: .index($0.offset))
                }
                catch {
                    throw error
                }
            }
        }
        
    }
    
    //MARK:- decode self as map
    public func decode<T: Decodable>() throws -> [String: T] {
        return try asDictionary().map {
            do {
                return try Decoder(value: $0.1).decode()
            }
            catch (let error as DecoderError) {
                throw error.backtraceError(path: .key($0.0))
            }
            catch {
                throw error
            }
        }
    }
    
    public func decode<T: Decodable>() throws -> [String: T]? {
        return try doAndReturnNilIfNullWasFound {
            try asDictionary().map {
                do {
                    return try Decoder(value: $0.1).decode()
                }
                catch (let error as DecoderError) {
                    throw error.backtraceError(path: .key($0.0))
                }
                catch {
                    throw error
                }
            }
        }
    }
    
    //MARK:- decode self as map of arrays
    public func decode<T: Decodable>() throws -> [String: [T]] {
        return try asDictionaryOfArrays().map {
            do {
                return try Decoder(value: $0.1).decode()
            }
            catch (let error as DecoderError) {
                throw error.backtraceError(path: .key($0.0))
            }
            catch {
                throw error
            }
        }
    }
    
    public func decode<T: Decodable>() throws -> [String: [T]]? {
        return try doAndReturnNilIfNullWasFound {
            try asDictionaryOfArrays().map {
                do {
                    return try Decoder(value: $0.1).decode()
                }
                catch (let error as DecoderError) {
                    throw error.backtraceError(path: .key($0.0))
                }
                catch {
                    throw error
                }
            }
        }
    }
    
    //MARK:- decode self as set
    public func decode<T: Decodable & Hashable>() throws -> Set<T> {
        return try Set(asArray().enumerated().map {
            do {
                return try Decoder(value: $0.element).decode()
            }
            catch (let error as DecoderError) {
                throw error.backtraceError(path: .index($0.offset))
            }
            catch {
                throw error
            }
        })
    }
    
    public func decode<T: Decodable & Hashable>() throws -> Set<T>? {
        return try doAndReturnNilIfNullWasFound {
            return try Set(asArray().enumerated().map {
                do {
                    return try Decoder(value: $0.element).decode()
                }
                catch (let error as DecoderError) {
                    throw error.backtraceError(path: .index($0.offset))
                }
                catch {
                    throw error
                }
            })
        }
    }
    
    //MARK:- decode value at key
    
    private func doDecodeAndRethrowIfNeeded<T>(key: String, action: () throws ->T) throws -> T {
        do {
            return try action()
        }
        catch (let error as DecoderError) {
            throw error.backtraceError(path: .key(key))
        }
        catch {
            throw error
        }
    }
    
    public func decode<T: Decodable>(key: String) throws -> T {
        return try doDecodeAndRethrowIfNeeded(key: key) {
            try decoder(forKey: key).decode()
        }
    }
    
    public func decode<T: Decodable>(key: String,  nilIfMissing: Bool = false) throws -> T? {
        
        return try doDecodeAndRethrowIfNeeded(key: key) {
            try decoder(forKey: key, nilIfMissing: nilIfMissing)?.decode() as T?
        }
    }
    
    public func decode<T: Decodable>(key: String, defaultValue: T) throws -> T {
        switch try decodingResultForKey(key, defaultValue: defaultValue) {
        case .usingDecoder(let decoder):
            return try doDecodeAndRethrowIfNeeded(key: key) {
                try decoder.decode()
            }
        case .usingDefaultValue(let value):
            return value
        }
    }
    
    public func decode<T: Decodable>(key: String, defaultValue: T?) throws -> T? {
        switch try decodingResultForKey(key, defaultValue: defaultValue) {
        case .usingDecoder(let decoder):
            return try doDecodeAndRethrowIfNeeded(key: key) {
                try decoder.decode() as T?
            }
        case .usingDefaultValue(let value):
            return value
        }
    }
    
    //MARK:- decode self as array
    public func decode<T: Decodable>(key: String) throws -> [T] {
        return try doDecodeAndRethrowIfNeeded(key: key) {
            try  decoder(forKey: key).decode()
        }
    }
    
    public func decode<T: Decodable>(key: String, nilIfMissing: Bool = false) throws -> [T]? {
        return try doDecodeAndRethrowIfNeeded(key: key) {
            try  decoder(forKey: key, nilIfMissing: nilIfMissing)?.decode() as [T]?
        }
    }
    
    public func decode<T: Decodable>(key: String, defaultValue: [T]) throws -> [T] {
        switch try decodingResultForKey(key, defaultValue: defaultValue) {
        case .usingDecoder(let decoder):
            return try doDecodeAndRethrowIfNeeded(key: key) {
                try  decoder.decode()
            }
        case .usingDefaultValue(let value):
            return value
        }
    }
    
    public func decode<T: Decodable>(key: String, defaultValue: [T]?) throws -> [T]? {
        switch try decodingResultForKey(key, defaultValue: defaultValue) {
        case .usingDecoder(let decoder):
            return try doDecodeAndRethrowIfNeeded(key: key) {
                try  decoder.decode() as [T]?
            }
        case .usingDefaultValue(let value):
            return value
        }
    }
    
    //MARK:- decode self as map
    public func decode<T: Decodable>(key: String) throws -> [String: T] {
        return try doDecodeAndRethrowIfNeeded(key: key) {
            try  decoder(forKey: key).decode()
        }
    }
    
    public func decode<T: Decodable>(key: String, nilIfMissing: Bool = false) throws -> [String: T]? {
        return try doDecodeAndRethrowIfNeeded(key: key) {
            try  decoder(forKey: key, nilIfMissing: nilIfMissing)?.decode() as [String: T]?
        }
    }
    
    public func decode<T: Decodable>(key: String, defaultValue: [String: T]) throws -> [String: T] {
        switch try decodingResultForKey(key, defaultValue: defaultValue) {
        case .usingDecoder(let decoder):
            return try doDecodeAndRethrowIfNeeded(key: key) {
                try  decoder.decode()
            }
        case .usingDefaultValue(let value):
            return value
        }
    }
    
    public func decode<T: Decodable>(key: String, defaultValue: [String: T]?) throws -> [String: T]? {
        switch try decodingResultForKey(key, defaultValue: defaultValue) {
        case .usingDecoder(let decoder):
            return try doDecodeAndRethrowIfNeeded(key: key) {
                try  decoder.decode() as [String: T]?
            }
        case .usingDefaultValue(let value):
            return value
        }
    }
    
    //MARK:- decode self as map of arrays
    public func decode<T: Decodable>(key: String) throws -> [String: [T]] {
        return try doDecodeAndRethrowIfNeeded(key: key) {
            try  decoder(forKey: key).decode()
        }
    }
    
    public func decode<T: Decodable>(key: String, nilIfMissing: Bool = false) throws -> [String: [T]]? {
        return try doDecodeAndRethrowIfNeeded(key: key) {
            try  decoder(forKey: key, nilIfMissing: nilIfMissing)?.decode() as [String: [T]]?
        }
    }
    
    public func decode<T: Decodable>(key: String, defaultValue: [String: [T]]) throws -> [String: [T]] {
        switch try decodingResultForKey(key, defaultValue: defaultValue) {
        case .usingDecoder(let decoder):
            return try doDecodeAndRethrowIfNeeded(key: key) {
                try  decoder.decode()
            }
        case .usingDefaultValue(let value):
            return value
        }
    }
    
    public func decode<T: Decodable>(key: String, defaultValue: [String: [T]]?) throws -> [String: [T]]? {
        switch try decodingResultForKey(key, defaultValue: defaultValue) {
        case .usingDecoder(let decoder):
            return try doDecodeAndRethrowIfNeeded(key: key) {
                try  decoder.decode() as [String: [T]]?
            }
        case .usingDefaultValue(let value):
            return value
        }
    }
    
    //MARK:- decode self as set
    public func decode<T: Decodable & Hashable>(key: String) throws -> Set<T> {
        return try doDecodeAndRethrowIfNeeded(key: key) {
            try  decoder(forKey: key).decode()
        }
    }
    
    public func decode<T: Decodable & Hashable>(key: String) throws ->  Set<T>? {
        return try doDecodeAndRethrowIfNeeded(key: key) {
            try  decoder(forKey: key).decode() as Set<T>?
        }
    }
    
    public func decode<T: Decodable & Hashable>(key: String, defaultValue:  Set<T>) throws ->  Set<T> {
        switch try decodingResultForKey(key, defaultValue: defaultValue) {
        case .usingDecoder(let decoder):
            return try doDecodeAndRethrowIfNeeded(key: key) {
                try  decoder.decode()
            }
        case .usingDefaultValue(let value):
            return value
        }
    }
    
    public func decode<T: Decodable & Hashable>(key: String, defaultValue: Set<T>?) throws -> Set<T>? {
        switch try decodingResultForKey(key, defaultValue: defaultValue) {
        case .usingDecoder(let decoder):
            return try doDecodeAndRethrowIfNeeded(key: key) {
                try  decoder.decode() as Set<T>?
            }
        case .usingDefaultValue(let value):
            return value
        }
    }
}




