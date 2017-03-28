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
    
    public func encode<T: Encodable>(_ value: T, key: String) {
        _dictionary[key] = Encoder.encode(value)
    }
    
    public func encode<T: Encodable>(_ value: T?, key: String, skipIfNil: Bool = false) {
        _dictionary[key] = Encoder.encode(value, skipIfNil: skipIfNil)
    }
    
    public func encode<T: Encodable>(_ value: [T], key: String) {
        _dictionary[key] = Encoder.encode(value)
    }
    
    public func encode<T: Encodable>(_ value: [T]?, key: String, skipIfNil: Bool = false) {
        _dictionary[key] = Encoder.encode(value, skipIfNil: skipIfNil)
    }
    
    public func encode<T: Encodable>(_ value: [String: T], key: String) {
        _dictionary[key] = Encoder.encode(value)
    }
    
    public func encode<T: Encodable>(_ value: [String: T]?, key: String, skipIfNil: Bool = false) {
        _dictionary[key] = Encoder.encode(value, skipIfNil: skipIfNil)
    }
    
    public func encode<T: Encodable>(_ value: [String: [T]], key: String) {
        _dictionary[key] = Encoder.encode(value)
    }
    
    public func encode<T: Encodable>(_ value: [String: [T]]?, key: String, skipIfNil: Bool = false) {
        _dictionary[key] = Encoder.encode(value, skipIfNil: skipIfNil)
    }
    
    public static func encode<T: Encodable>(_ value: T) -> Any {
        return value.encode()
    }
    
    public static func encode<T: Encodable>(_ value: T?, skipIfNil: Bool = false) -> Any? {
        return value.flatMap { $0.encode() } ?? (skipIfNil ? nil : NSNull())
    }
    
    public static func encode<T: Encodable>(_ value: [T]) -> Any {
        return value.map { $0.encode() }
    }
    
    public static func encode<T: Encodable>(_ value: [T]?, skipIfNil: Bool = false) -> Any? {
        return value.flatMap { $0.map { $0.encode() } } ?? (skipIfNil ? nil : NSNull())
    }
    
    public static func encode<T: Encodable>(_ value: [String: T]) -> Any {
        return value.map { $0.encode() }
    }
    
    public static func encode<T: Encodable>(_ value: [String: T]?, skipIfNil: Bool = false) -> Any? {
        return value.flatMap { $0.map { $0.encode() } } ?? (skipIfNil ? nil : NSNull())
    }
    
    public static func encode<T: Encodable>(_ value: [String: [T]]) -> Any {
        return value.map { $0.map { $0.encode() } }
    }
    
    public static func encode<T: Encodable>(_ value: [String: [T]]?, skipIfNil: Bool = false) -> Any? {
        return value.flatMap { $0.map { $0.map { $0.encode() } } } ?? (skipIfNil ? nil : NSNull())
    }
}
