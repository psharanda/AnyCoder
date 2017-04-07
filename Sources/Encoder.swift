//
//  Created by Pavel Sharanda on 29.09.16.
//  Copyright © 2016 Pavel Sharanda. All rights reserved.
//

import Foundation

public typealias Encoder = [String: Any]

public protocol ValueEncodable {
    func encode() -> Any
}

public protocol Encodable {
    func encode() -> Encoder
}

extension Dictionary where Key == String, Value == Any {
    
    public mutating func encode<T: Encodable>(_ value: T) {
        encode(value) { $0.encode() }
    }
    
    public mutating func encode<T>(_ value: T, transform: (T)->Encoder) {
        transform(value).forEach { updateValue($1, forKey: $0) }
    }
    
    //MARK: object
    public mutating func encode<T: Encodable>(_ value: T, key: String) {
        encode(value, key: key) { $0.encode() }
    }
    
    public mutating func encode<T>(_ value: T, key: String, transform: (T)->Encoder) {
        self[key] = transform(value)
    }
    
    public mutating func encode<T: Encodable>(_ value: T?, key: String, nullIfNil: Bool = false) {
        encode(value, key: key, nullIfNil: nullIfNil) { $0.encode() }
    }
    
    public mutating func encode<T>(_ value: T?, key: String, nullIfNil: Bool = false, transform: (T)->Encoder) {
        self[key] = value.map { transform($0) } ?? (nullIfNil ? NSNull() : nil)
    }
    
    public mutating func encode<T: ValueEncodable>(_ value: T, key: String) {
        encode(value, key: key) { $0.encode() }
    }
    
    public mutating func encode<T>(_ value: T, key: String, transform: (T)->Any) {
        self[key] = transform(value)
    }
    
    public mutating func encode<T: ValueEncodable>(_ value: T?, key: String, nullIfNil: Bool = false) {
        encode(value, key: key, nullIfNil: nullIfNil) { $0.encode() }
    }
    
    public mutating func encode<T>(_ value: T?, key: String, nullIfNil: Bool = false, transform: (T)->Any) {
        self[key] = value.map { transform($0) } ?? (nullIfNil ? NSNull() : nil)
    }
    
    //MARK: array
    public mutating func encode<T: Encodable>(_ value: [T], key: String) {
        encode(value, key: key) { $0.encode() }
    }
    
    public mutating func encode<T>(_ value: [T], key: String, transform: (T)->Encoder) {
        self[key] = value.encode(transform: transform)
    }
    
    public mutating func encode<T: Encodable>(_ value: [T]?, key: String, nullIfNil: Bool = false) {
        encode(value, key: key, nullIfNil: nullIfNil) { $0.encode() }
    }
    
    public mutating func encode<T>(_ value: [T]?, key: String, nullIfNil: Bool = false, transform: (T)->Encoder) {
        self[key] = value.map { $0.encode(transform: transform) } ?? (nullIfNil ? NSNull() : nil)
    }
    
    public mutating func encode<T: Encodable>(_ value: [T?], key: String) {
        encode(value, key: key) { $0.encode() }
    }
    
    public mutating func encode<T>(_ value: [T?], key: String, transform: (T)->Encoder) {
        self[key] = value.encode(transform: transform)
    }
    
    public mutating func encode<T: Encodable>(_ value: [T?]?, key: String, nullIfNil: Bool = false) {
        encode(value, key: key, nullIfNil: nullIfNil) { $0.encode() }
    }
    
    public mutating func encode<T>(_ value: [T?]?, key: String, nullIfNil: Bool = false, transform: (T)->Encoder) {
        self[key] = value.map { $0.encode(transform: transform) } ?? (nullIfNil ? NSNull() : nil)
    }
    
    public mutating func encode<T: ValueEncodable>(_ value: [T], key: String) {
        encode(value, key: key) { $0.encode() }
    }
    
    public mutating func encode<T>(_ value: [T], key: String, transform: (T)->Any) {
        self[key] = value.encode(transform: transform)
    }
    
    public mutating func encode<T: ValueEncodable>(_ value: [T]?, key: String, nullIfNil: Bool = false) {
        encode(value, key: key, nullIfNil: nullIfNil) { $0.encode() }
    }
    
    public mutating func encode<T>(_ value: [T]?, key: String, nullIfNil: Bool = false, transform: (T)->Any) {
        self[key] = value.map { $0.encode(transform: transform) } ?? (nullIfNil ? NSNull() : nil)
    }
    
    public mutating func encode<T: ValueEncodable>(_ value: [T?], key: String) {
        encode(value, key: key) { $0.encode() }
    }
    
    public mutating func encode<T>(_ value: [T?], key: String, transform: (T)->Any) {
        self[key] = value.encode(transform: transform)
    }
    
    public mutating func encode<T: ValueEncodable>(_ value: [T?]?, key: String, nullIfNil: Bool = false) {
        encode(value, key: key, nullIfNil: nullIfNil) { $0.encode() }
    }
    
    public mutating func encode<T>(_ value: [T?]?, key: String, nullIfNil: Bool = false, transform: (T)->Any) {
        self[key] = value.map { $0.encode(transform: transform) } ?? (nullIfNil ? NSNull() : nil)
    }
    
    //MARK: dict
    public mutating func encode<T: Encodable>(_ value: [String: T], key: String) {
        self[key] = value.encode()
    }
    
    public mutating func encode<T>(_ value: [String: T], key: String, transform: (T)->Encoder) {
        self[key] = value.encode(transform: transform)
    }

    public mutating func encode<T: Encodable>(_ value: [String: T]?, key: String, nullIfNil: Bool = false) {
        self[key] = value.map { $0.encode() } ?? (nullIfNil ? NSNull() : nil)
    }
    
    public mutating func encode<T>(_ value: [String: T]?, key: String, nullIfNil: Bool = false, transform: (T)->Encoder) {
        self[key] = value.map { $0.encode(transform: transform) } ?? (nullIfNil ? NSNull() : nil)
    }
    
    public mutating func encode<T: Encodable>(_ value: [String: T?], key: String) {
        self[key] = value.encode()
    }
    
    public mutating func encode<T>(_ value: [String: T?], key: String, transform: (T)->Encoder) {
        self[key] = value.encode(transform: transform)
    }
    
    public mutating func encode<T: Encodable>(_ value: [String: T?]?, key: String, nullIfNil: Bool = false) {
        self[key] = value.map { $0.encode() } ?? (nullIfNil ? NSNull() : nil)
    }
    
    public mutating func encode<T>(_ value: [String: T?]?, key: String, nullIfNil: Bool = false, transform: (T)->Encoder) {
        self[key] = value.map { $0.encode(transform: transform) } ?? (nullIfNil ? NSNull() : nil)
    }
    
    public mutating func encode<T: ValueEncodable>(_ value: [String: T], key: String) {
        self[key] = value.encode()
    }
    
    public mutating func encode<T>(_ value: [String: T], key: String, transform: (T)->Any) {
        self[key] = value.encode(transform: transform)
    }
    
    public mutating func encode<T: ValueEncodable>(_ value: [String: T]?, key: String, nullIfNil: Bool = false) {
        self[key] = value.map { $0.encode() } ?? (nullIfNil ? NSNull() : nil)
    }
    
    public mutating func encode<T>(_ value: [String: T]?, key: String, nullIfNil: Bool = false, transform: (T)->Any) {
        self[key] = value.map { $0.encode(transform: transform) } ?? (nullIfNil ? NSNull() : nil)
    }
    
    public mutating func encode<T: ValueEncodable>(_ value: [String: T?], key: String) {
        self[key] = value.encode()
    }
    
    public mutating func encode<T>(_ value: [String: T?], key: String, transform: (T)->Any) {
        self[key] = value.encode(transform: transform)
    }
    
    public mutating func encode<T: ValueEncodable>(_ value: [String: T?]?, key: String, nullIfNil: Bool = false) {
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

extension Array where Element: Encodable {
    public func encode() -> [Any] {
        return encode() { $0.encode() }
    }
}

extension Array {
    public func encode(transform: (Element)->Encoder) -> [Any] {
        return map { transform($0) }
    }
}

extension Array where Element: ValueEncodable {
    public func encode() -> [Any] {
        return encode() { $0.encode() }
    }
}

extension Array {
    public func encode(transform: (Element)->Any) -> [Any] {
        return map { transform($0) }
    }
}

extension Array where Element: Optionable, Element.Wrapped: Encodable {
    public func encode() -> [Any] {
        return encode() { $0.encode() }
    }
}

extension Array where Element: Optionable {
    public func encode(transform: (Element.Wrapped)->Encoder) -> [Any] {
        return map { $0.map { transform($0) as Any } ?? NSNull() as Any }
    }
}

extension Array where Element: Optionable, Element.Wrapped: ValueEncodable {
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
    public func encode(transform: (Value)->Encoder) -> [String: Any] {
        return map { transform($0.1) }
    }
}

extension Dictionary where Key == String, Value: Encodable {
    public func encode() -> [String: Any] {
        return encode() { $0.encode() }
    }
}

extension Dictionary where Key == String, Value: ValueEncodable {
    public func encode() -> [String: Any] {
        return encode() { $0.encode() }
    }
}

extension Dictionary where Key == String {
    public func encode(transform: (Value)->Any) -> [String: Any] {
        return map { transform($0.1) }
    }
}

extension Dictionary where Key == String, Value: Optionable, Value.Wrapped: Encodable {
    public func encode() -> [String: Any] {
        return encode() { $0.encode() as Any }
    }
}

extension Dictionary where Key == String, Value: Optionable {
    public func encode(transform: (Value.Wrapped)->Encoder) -> [String: Any] {
        return map { $0.1.map { transform($0) as Any } ?? NSNull() as Any }
    }
}

extension Dictionary where Key == String, Value: Optionable, Value.Wrapped: ValueEncodable {
    public func encode() -> [String: Any] {
        return encode() { $0.encode() }
    }
}

extension Dictionary where Key == String, Value: Optionable {
    public func encode(transform: (Value.Wrapped)->Any) -> [String: Any] {
        return map { $0.1.map { transform($0) as Any } ?? NSNull() as Any }
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
