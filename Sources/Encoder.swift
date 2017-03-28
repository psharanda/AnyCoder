//
//  Created by Pavel Sharanda on 29.09.16.
//  Copyright © 2016 Pavel Sharanda. All rights reserved.
//

import Foundation

public protocol Encodable {
    func encode() -> Any
}

public final class Encoder {
    private var _dictionary: [String: Any] = [:]
    
    public init() { }
    
    public var dictionary: [String: Any] {
        return _dictionary
    }
    
    //MARK: value
    public func encode<T: Encodable>(_ value: T, key: String) {
        _dictionary[key] = Encoder.encode(value)
    }
    
    public func encode<T: Encodable>(_ value: T?, key: String, skipIfNil: Bool = false) {
        _dictionary[key] = Encoder.encode(value, skipIfNil: skipIfNil)
    }
    
    //MARK: array
    public func encode<T: Encodable>(_ value: [T], key: String) {
        _dictionary[key] = Encoder.encode(value)
    }
    
    public func encode<T: Encodable>(_ value: [T]?, key: String, skipIfNil: Bool = false) {
        _dictionary[key] = Encoder.encode(value, skipIfNil: skipIfNil)
    }
    
    //MARK: dict
    public func encode<T: Encodable>(_ value: [String: T], key: String) {
        _dictionary[key] = Encoder.encode(value)
    }
    
    public func encode<T: Encodable>(_ value: [String: T]?, key: String, skipIfNil: Bool = false) {
        _dictionary[key] = Encoder.encode(value, skipIfNil: skipIfNil)
    }
    
    //MARK: dict of arrays
    public func encode<T: Encodable>(_ value: [String: [T]], key: String) {
        _dictionary[key] = Encoder.encode(value)
    }
    
    public func encode<T: Encodable>(_ value: [String: [T]]?, key: String, skipIfNil: Bool = false) {
        _dictionary[key] = Encoder.encode(value, skipIfNil: skipIfNil)
    }
    
    //MARK: set
    public func encode<T: Encodable & Hashable>(_ value: Set<T>, key: String) {
        _dictionary[key] = Encoder.encode(value)
    }
    
    public func encode<T: Encodable & Hashable>(_ value: Set<T>?, key: String, skipIfNil: Bool = false) {
        _dictionary[key] = Encoder.encode(value, skipIfNil: skipIfNil)
    }
    
    //MARK: static
    //MARK: value
    public static func encode<T: Encodable>(_ value: T) -> Any {
        return value.encode()
    }
    
    public static func encode<T: Encodable>(_ value: T?, skipIfNil: Bool = false) -> Any? {
        return value.flatMap { $0.encode() } ?? (skipIfNil ? nil : NSNull())
    }
    
    //MARK: array
    public static func encode<T: Encodable>(_ value: [T]) -> Any {
        return value.map { $0.encode() }
    }
    
    public static func encode<T: Encodable>(_ value: [T]?, skipIfNil: Bool = false) -> Any? {
        return value.flatMap { $0.map { $0.encode() } } ?? (skipIfNil ? nil : NSNull())
    }
    
    //MARK: dict
    public static func encode<T: Encodable>(_ value: [String: T]) -> Any {
        return value.map { $0.encode() }
    }
    
    public static func encode<T: Encodable>(_ value: [String: T]?, skipIfNil: Bool = false) -> Any? {
        return value.flatMap { $0.map { $0.encode() } } ?? (skipIfNil ? nil : NSNull())
    }
    
    //MARK: dict of arrays
    public static func encode<T: Encodable>(_ value: [String: [T]]) -> Any {
        return value.map { $0.map { $0.encode() } }
    }
    
    public static func encode<T: Encodable>(_ value: [String: [T]]?, skipIfNil: Bool = false) -> Any? {
        return value.flatMap { $0.map { $0.map { $0.encode() } } } ?? (skipIfNil ? nil : NSNull())
    }
    
    //MARK: set
    public static func encode<T: Encodable & Hashable>(_ value: Set<T>) -> Any {
        return value.map { $0.encode() }
    }
    
    public static func encode<T: Encodable>(_ value: Set<T>?, skipIfNil: Bool = false) -> Any? {
        return value.flatMap { $0.map { $0.encode() } } ?? (skipIfNil ? nil : NSNull())
    }
    
    //inplace
    
    public func encode(encoder: Encoder) {
        _dictionary.merge(with: encoder.dictionary)
    }
    
    public func encode(encoder: Encoder, key: String) {
        _dictionary["key"] = encoder.dictionary
    }
}
