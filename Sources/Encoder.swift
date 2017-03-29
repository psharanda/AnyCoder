//
//  Created by Pavel Sharanda on 29.09.16.
//  Copyright © 2016 Pavel Sharanda. All rights reserved.
//

import Foundation

public protocol Encodable {
    func encode() -> Any
}

public typealias Encoder = [String: Any]

extension Dictionary where Key == String, Value == Any {
    
    //MARK: value
    mutating public func encode<T: Encodable>(_ value: T, key: String) {
        self[key] = value.encode()
    }
    
    mutating public func encode<T: Encodable>(_ value: T?, key: String, skipIfNil: Bool = false) {
        self[key] = value.flatMap { $0.encode() } ?? (skipIfNil ? nil : NSNull())
    }
    
    //MARK: array
    mutating public func encode<T: Encodable>(_ value: [T], key: String) {
        self[key] = value.encode()
    }
    
    mutating public func encode<T: Encodable>(_ value: [T]?, key: String, skipIfNil: Bool = false) {
        self[key] = value.flatMap { $0.encode() } ?? (skipIfNil ? nil : NSNull())
    }
    
    mutating public func encode<T: Encodable>(_ value: [T?], key: String) {
        self[key] = value.encode()
    }
    
    mutating public func encode<T: Encodable>(_ value: [T?]?, key: String, skipIfNil: Bool = false) {
        self[key] = value.flatMap { $0.encode() } ?? (skipIfNil ? nil : NSNull())
    }
    
    //MARK: dict
    mutating public func encode<T: Encodable>(_ value: [String: T], key: String) {
        self[key] = value.encode()
    }
    
    mutating public func encode<T: Encodable>(_ value: [String: T]?, key: String, skipIfNil: Bool = false) {
        self[key] = value.flatMap { $0.encode() } ?? (skipIfNil ? nil : NSNull())
    }
    
    mutating public func encode<T: Encodable>(_ value: [String: T?], key: String) {
        self[key] = value.encode()
    }
    
    mutating public func encode<T: Encodable>(_ value: [String: T?]?, key: String, skipIfNil: Bool = false) {
        self[key] = value.flatMap { $0.encode() } ?? (skipIfNil ? nil : NSNull())
    }
    
    //MARK: set
    mutating public func encode<T: Encodable & Hashable>(_ value: Set<T>, key: String) {
        self[key] = value.encode()
    }
    
    mutating public func encode<T: Encodable & Hashable>(_ value: Set<T>?, key: String, skipIfNil: Bool = false) {
        self[key] = value.flatMap { $0.encode() } ?? (skipIfNil ? nil : NSNull())
    }
    
    public mutating func encode(_ encoder: Encoder) {
        encoder.forEach { updateValue($1, forKey: $0) }
    }
    
    public mutating func encode(_ encoder: Encoder, key: String) {
        self[key] = encoder
    }
}

public protocol Optionable {
    associatedtype Wrapped
    func map<U>(_ transform: (Wrapped) throws -> U) rethrows -> U?
}

extension Optional: Optionable  {
    
}

extension Array where Element: Encodable {
    public func encode() -> Any {
        return map { $0.encode() }
    }
}


extension Array where Element: Optionable, Element.Wrapped: Encodable {
    public func encode() -> Any {
        return map { $0.map { $0.encode() } ?? NSNull() }
    }
}

extension Dictionary where Key == String, Value: Encodable {
    public func encode() -> Any {
        return map { $0.1.encode() }
    }
}

extension Dictionary where Key == String, Value: Optionable, Value.Wrapped: Encodable {
    public func encode() -> Any {
        return map { $0.1.map { $0.encode() } ?? NSNull() }
    }
}

extension Set where Element: Encodable {
    public func encode() -> Any {
        return map { $0.encode() }
    }
}

