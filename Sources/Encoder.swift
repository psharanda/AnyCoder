//
//  Created by Pavel Sharanda on 29.09.16.
//  Copyright © 2016 Pavel Sharanda. All rights reserved.
//

import Foundation

public typealias AnyEncoder = [String: Any]

public protocol AnyValueEncodable {
    func encode() -> Any
}

public protocol AnyEncodable {
    func encode() -> AnyEncoder
}

extension Dictionary where Key == String, Value == Any {
    
    public mutating func encode<T: AnyEncodable>(_ value: T) {
        encode(value) { $0.encode() }
    }
    
    public mutating func encode<T>(_ value: T, transform: (T)->AnyEncoder) {
        transform(value).forEach { updateValue($1, forKey: $0) }
    }
    
    //MARK: object
    public mutating func encode<T: AnyEncodable>(_ value: T, key: String) {
        encode(value, key: key) { $0.encode() }
    }
    
    public mutating func encode<T>(_ value: T, key: String, transform: (T)->AnyEncoder) {
        self[key] = transform(value)
    }
    
    public mutating func encode<T: AnyEncodable>(_ value: T?, key: String, nullIfNil: Bool = false) {
        encode(value, key: key, nullIfNil: nullIfNil) { $0.encode() }
    }
    
    public mutating func encode<T>(_ value: T?, key: String, nullIfNil: Bool = false, transform: (T)->AnyEncoder) {
        self[key] = value.map { transform($0) } ?? (nullIfNil ? NSNull() : nil)
    }
    
    public mutating func encode<T: AnyValueEncodable>(_ value: T, key: String) {
        encode(value, key: key) { $0.encode() }
    }
    
    public mutating func encode<T>(_ value: T, key: String, transform: (T)->Any) {
        self[key] = transform(value)
    }
    
    public mutating func encode<T: AnyValueEncodable>(_ value: T?, key: String, nullIfNil: Bool = false) {
        encode(value, key: key, nullIfNil: nullIfNil) { $0.encode() }
    }
    
    public mutating func encode<T>(_ value: T?, key: String, nullIfNil: Bool = false, transform: (T)->Any) {
        self[key] = value.map { transform($0) } ?? (nullIfNil ? NSNull() : nil)
    }
    
    //MARK: array
    public mutating func encode<T: AnyEncodable>(_ value: [T], key: String) {
        encode(value, key: key) { $0.encode() }
    }
    
    public mutating func encode<T>(_ value: [T], key: String, transform: (T)->AnyEncoder) {
        self[key] = value.encode(transform: transform)
    }
    
    public mutating func encode<T: AnyEncodable>(_ value: [T]?, key: String, nullIfNil: Bool = false) {
        encode(value, key: key, nullIfNil: nullIfNil) { $0.encode() }
    }
    
    public mutating func encode<T>(_ value: [T]?, key: String, nullIfNil: Bool = false, transform: (T)->AnyEncoder) {
        self[key] = value.map { $0.encode(transform: transform) } ?? (nullIfNil ? NSNull() : nil)
    }
    
    public mutating func encode<T: AnyEncodable>(_ value: [T?], key: String) {
        encode(value, key: key) { $0.encode() }
    }
    
    public mutating func encode<T>(_ value: [T?], key: String, transform: (T)->AnyEncoder) {
        self[key] = value.encode(transform: transform)
    }
    
    public mutating func encode<T: AnyEncodable>(_ value: [T?]?, key: String, nullIfNil: Bool = false) {
        encode(value, key: key, nullIfNil: nullIfNil) { $0.encode() }
    }
    
    public mutating func encode<T>(_ value: [T?]?, key: String, nullIfNil: Bool = false, transform: (T)->AnyEncoder) {
        self[key] = value.map { $0.encode(transform: transform) } ?? (nullIfNil ? NSNull() : nil)
    }
    
    public mutating func encode<T: AnyValueEncodable>(_ value: [T], key: String) {
        encode(value, key: key) { $0.encode() }
    }
    
    public mutating func encode<T>(_ value: [T], key: String, transform: (T)->Any) {
        self[key] = value.encode(transform: transform)
    }
    
    public mutating func encode<T: AnyValueEncodable>(_ value: [T]?, key: String, nullIfNil: Bool = false) {
        encode(value, key: key, nullIfNil: nullIfNil) { $0.encode() }
    }
    
    public mutating func encode<T>(_ value: [T]?, key: String, nullIfNil: Bool = false, transform: (T)->Any) {
        self[key] = value.map { $0.encode(transform: transform) } ?? (nullIfNil ? NSNull() : nil)
    }
    
    public mutating func encode<T: AnyValueEncodable>(_ value: [T?], key: String) {
        encode(value, key: key) { $0.encode() }
    }
    
    public mutating func encode<T>(_ value: [T?], key: String, transform: (T)->Any) {
        self[key] = value.encode(transform: transform)
    }
    
    public mutating func encode<T: AnyValueEncodable>(_ value: [T?]?, key: String, nullIfNil: Bool = false) {
        encode(value, key: key, nullIfNil: nullIfNil) { $0.encode() }
    }
    
    public mutating func encode<T>(_ value: [T?]?, key: String, nullIfNil: Bool = false, transform: (T)->Any) {
        self[key] = value.map { $0.encode(transform: transform) } ?? (nullIfNil ? NSNull() : nil)
    }
    
    //MARK: dict
    public mutating func encode<T: AnyEncodable>(_ value: [String: T], key: String) {
        self[key] = value.encode()
    }
    
    public mutating func encode<T>(_ value: [String: T], key: String, transform: (T)->AnyEncoder) {
        self[key] = value.encode(transform: transform)
    }

    public mutating func encode<T: AnyEncodable>(_ value: [String: T]?, key: String, nullIfNil: Bool = false) {
        self[key] = value.map { $0.encode() } ?? (nullIfNil ? NSNull() : nil)
    }
    
    public mutating func encode<T>(_ value: [String: T]?, key: String, nullIfNil: Bool = false, transform: (T)->AnyEncoder) {
        self[key] = value.map { $0.encode(transform: transform) } ?? (nullIfNil ? NSNull() : nil)
    }
    
    public mutating func encode<T: AnyEncodable>(_ value: [String: T?], key: String) {
        self[key] = value.encode()
    }
    
    public mutating func encode<T>(_ value: [String: T?], key: String, transform: (T)->AnyEncoder) {
        self[key] = value.encode(transform: transform)
    }
    
    public mutating func encode<T: AnyEncodable>(_ value: [String: T?]?, key: String, nullIfNil: Bool = false) {
        self[key] = value.map { $0.encode() } ?? (nullIfNil ? NSNull() : nil)
    }
    
    public mutating func encode<T>(_ value: [String: T?]?, key: String, nullIfNil: Bool = false, transform: (T)->AnyEncoder) {
        self[key] = value.map { $0.encode(transform: transform) } ?? (nullIfNil ? NSNull() : nil)
    }
    
    public mutating func encode<T: AnyValueEncodable>(_ value: [String: T], key: String) {
        self[key] = value.encode()
    }
    
    public mutating func encode<T>(_ value: [String: T], key: String, transform: (T)->Any) {
        self[key] = value.encode(transform: transform)
    }
    
    public mutating func encode<T: AnyValueEncodable>(_ value: [String: T]?, key: String, nullIfNil: Bool = false) {
        self[key] = value.map { $0.encode() } ?? (nullIfNil ? NSNull() : nil)
    }
    
    public mutating func encode<T>(_ value: [String: T]?, key: String, nullIfNil: Bool = false, transform: (T)->Any) {
        self[key] = value.map { $0.encode(transform: transform) } ?? (nullIfNil ? NSNull() : nil)
    }
    
    public mutating func encode<T: AnyValueEncodable>(_ value: [String: T?], key: String) {
        self[key] = value.encode()
    }
    
    public mutating func encode<T>(_ value: [String: T?], key: String, transform: (T)->Any) {
        self[key] = value.encode(transform: transform)
    }
    
    public mutating func encode<T: AnyValueEncodable>(_ value: [String: T?]?, key: String, nullIfNil: Bool = false) {
        self[key] = value.map { $0.encode() } ?? (nullIfNil ? NSNull() : nil)
    }
    
    public mutating func encode<T>(_ value: [String: T?]?, key: String, nullIfNil: Bool = false, transform: (T)->Any) {
        self[key] = value.map { $0.encode(transform: transform) } ?? (nullIfNil ? NSNull() : nil)
    }
}

//MARK: - Optional

public protocol Optionable {
    associatedtype Wrapped
    func map<U>(_ transform: (Wrapped) throws -> U) rethrows -> U?
}

extension Optional: Optionable  {
    
}

//MARK: - Array

extension Array where Element: AnyEncodable {
    public func encode() -> [Any] {
        return encode() { $0.encode() }
    }
}

extension Array {
    public func encode(transform: (Element)->AnyEncoder) -> [Any] {
        return map { transform($0) }
    }
}

extension Array where Element: AnyValueEncodable {
    public func encode() -> [Any] {
        return encode() { $0.encode() }
    }
}

extension Array {
    public func encode(transform: (Element)->Any) -> [Any] {
        return map { transform($0) }
    }
}

extension Array where Element: Optionable, Element.Wrapped: AnyEncodable {
    public func encode() -> [Any] {
        return encode() { $0.encode() }
    }
}

extension Array where Element: Optionable {
    public func encode(transform: (Element.Wrapped)->AnyEncoder) -> [Any] {
        return map { $0.map { transform($0) as Any } ?? NSNull() as Any }
    }
}

extension Array where Element: Optionable, Element.Wrapped: AnyValueEncodable {
    public func encode() -> [Any] {
        return encode() { $0.encode() }
    }
}

extension Array where Element: Optionable {
    public func encode(transform: (Element.Wrapped)->Any) -> [Any] {
        return map { $0.map { transform($0) as Any } ?? NSNull() as Any }
    }
}

//MARK: - Dictionary

extension Dictionary where Key == String {
    public func encode(transform: (Value)->AnyEncoder) -> [String: Any] {
        return map { transform($1) }
    }
}

extension Dictionary where Key == String, Value: AnyEncodable {
    public func encode() -> [String: Any] {
        return encode() { $0.encode() }
    }
}

extension Dictionary where Key == String, Value: AnyValueEncodable {
    public func encode() -> [String: Any] {
        return encode() { $0.encode() }
    }
}

extension Dictionary where Key == String {
    public func encode(transform: (Value)->Any) -> [String: Any] {
        return map { transform($1) }
    }
}

extension Dictionary where Key == String, Value: Optionable, Value.Wrapped: AnyEncodable {
    public func encode() -> [String: Any] {
        return encode() { $0.encode() as Any }
    }
}

extension Dictionary where Key == String, Value: Optionable {
    public func encode(transform: (Value.Wrapped)->AnyEncoder) -> [String: Any] {
        return map { $1.map { transform($0) as Any } ?? NSNull() as Any }
    }
}

extension Dictionary where Key == String, Value: Optionable, Value.Wrapped: AnyValueEncodable {
    public func encode() -> [String: Any] {
        return encode() { $0.encode() }
    }
}

extension Dictionary where Key == String, Value: Optionable {
    public func encode(transform: (Value.Wrapped)->Any) -> [String: Any] {
        return map { $1.map { transform($0) as Any } ?? NSNull() as Any }
    }
}

extension Dictionary {
    func map<T>(_ transform: (Key, Value) throws -> T) rethrows -> [Key: T] {
        var result: [Key: T] = [:]
        for (key, value) in self {
            result[key] = try transform(key, value)
        }
        return result
    }
}
