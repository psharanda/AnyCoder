//
//  Created by Pavel Sharanda on 29.09.16.
//  Copyright © 2016 Pavel Sharanda. All rights reserved.
//

import Foundation

public protocol Encodable {
    func encode() -> Any
}

public struct Encoder {
    private var _dictionary: [String: Any] = [:]
    
    public init() { }
    
    public var dictionary: [String: Any] {
        return _dictionary
    }
    
    //MARK: value
    mutating public func encode<T: Encodable>(_ value: T, key: String) {
        _dictionary[key] = Encoder.encode(value)
    }
    
    mutating public func encode<T: Encodable>(_ value: T?, key: String, skipIfNil: Bool = false) {
        _dictionary[key] = Encoder.encode(value, skipIfNil: skipIfNil)
    }
    
    //MARK: array
    mutating public func encode<T: Encodable>(_ value: [T], key: String) {
        _dictionary[key] = Encoder.encode(value)
    }
    
    mutating public func encode<T: Encodable>(_ value: [T]?, key: String, skipIfNil: Bool = false) {
        _dictionary[key] = Encoder.encode(value, skipIfNil: skipIfNil)
    }
    
    //MARK: dict
    mutating public func encode<T: Encodable>(_ value: [String: T], key: String) {
        _dictionary[key] = Encoder.encode(value)
    }
    
    mutating public func encode<T: Encodable>(_ value: [String: T]?, key: String, skipIfNil: Bool = false) {
        _dictionary[key] = Encoder.encode(value, skipIfNil: skipIfNil)
    }
    
    //MARK: dict of arrays
    mutating public func encode<T: Encodable>(_ value: [String: [T]], key: String) {
        _dictionary[key] = Encoder.encode(value)
    }
    
    mutating public func encode<T: Encodable>(_ value: [String: [T]]?, key: String, skipIfNil: Bool = false) {
        _dictionary[key] = Encoder.encode(value, skipIfNil: skipIfNil)
    }
    
    //MARK: set
    mutating public func encode<T: Encodable & Hashable>(_ value: Set<T>, key: String) {
        _dictionary[key] = Encoder.encode(value)
    }
    
    mutating public func encode<T: Encodable & Hashable>(_ value: Set<T>?, key: String, skipIfNil: Bool = false) {
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
        return value.map { $0.1.encode() }
    }
    
    public static func encode<T: Encodable>(_ value: [String: T]?, skipIfNil: Bool = false) -> Any? {
        return value.flatMap { $0.map { $0.1.encode() } } ?? (skipIfNil ? nil : NSNull())
    }
    
    //MARK: dict of arrays
    public static func encode<T: Encodable>(_ value: [String: [T]]) -> Any {
        return value.map { $0.1.map { $0.encode() } }
    }
    
    public static func encode<T: Encodable>(_ value: [String: [T]]?, skipIfNil: Bool = false) -> Any? {
        return value.flatMap { $0.map { $0.1.map { $0.encode() } } } ?? (skipIfNil ? nil : NSNull())
    }
    
    //MARK: set
    public static func encode<T: Encodable & Hashable>(_ value: Set<T>) -> Any {
        return value.map { $0.encode() }
    }
    
    public static func encode<T: Encodable>(_ value: Set<T>?, skipIfNil: Bool = false) -> Any? {
        return value.flatMap { $0.map { $0.encode() } } ?? (skipIfNil ? nil : NSNull())
    }
    
    //inplace
    
    mutating public func merge(_ value: Any) {
        if let dict = value as? [String: Any] {
            _dictionary.merge(with: dict)
        }
    }
    
    mutating public func include(_ value: Any, key: String) {
        _dictionary["key"] = value
    }
}
