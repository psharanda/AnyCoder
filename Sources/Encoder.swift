//
//  Created by Pavel Sharanda on 29.09.16.
//  Copyright © 2016 Pavel Sharanda. All rights reserved.
//

import Foundation

public typealias Encoder = [String: Any]

public protocol AnyEncodable {
    func encode() -> Any
}

public protocol Encodable {
    func encode() -> Encoder
}

extension Dictionary where Key == String, Value == Any {
    
    public mutating func encode<T: Encodable>(_ value: T) {
        value.encode().forEach { updateValue($1, forKey: $0) }
    }
    
    //MARK: value
    public mutating func encode<T: Encodable>(_ value: T, key: String) {
        self[key] = value.encode()
    }
    
    public mutating func encode<T: Encodable>(_ value: T?, key: String, skipIfNil: Bool = false) {
        self[key] = value.map { $0.encode() } ?? (skipIfNil ? nil : NSNull())
    }
    
    public mutating func encode<T: AnyEncodable>(_ value: T, key: String) {
        self[key] = value.encode()
    }
    
    public mutating func encode<T: AnyEncodable>(_ value: T?, key: String, skipIfNil: Bool = false) {
        self[key] = value.map { $0.encode() } ?? (skipIfNil ? nil : NSNull())
    }
    
    //MARK: array
    public mutating func encode<T: Encodable>(_ value: [T], key: String) {
        self[key] = value.encode()
    }
    
    public mutating func encode<T: Encodable>(_ value: [T]?, key: String, skipIfNil: Bool = false) {
        self[key] = value.map { $0.encode() } ?? (skipIfNil ? nil : NSNull())
    }
    
    public mutating func encode<T: Encodable>(_ value: [T?], key: String) {
        self[key] = value.encode()
    }
    
    public mutating func encode<T: Encodable>(_ value: [T?]?, key: String, skipIfNil: Bool = false) {
        self[key] = value.map { $0.encode() } ?? (skipIfNil ? nil : NSNull())
    }
    
    public mutating func encode<T: AnyEncodable>(_ value: [T], key: String) {
        self[key] = value.encode()
    }
    
    public mutating func encode<T: AnyEncodable>(_ value: [T]?, key: String, skipIfNil: Bool = false) {
        self[key] = value.map { $0.encode() } ?? (skipIfNil ? nil : NSNull())
    }
    
    public mutating func encode<T: AnyEncodable>(_ value: [T?], key: String) {
        self[key] = value.encode()
    }
    
    public mutating func encode<T: AnyEncodable>(_ value: [T?]?, key: String, skipIfNil: Bool = false) {
        self[key] = value.map { $0.encode() } ?? (skipIfNil ? nil : NSNull())
    }
    
    //MARK: dict
    public mutating func encode<T: Encodable>(_ value: [String: T], key: String) {
        self[key] = value.encode()
    }
    
    public mutating func encode<T: Encodable>(_ value: [String: T]?, key: String, skipIfNil: Bool = false) {
        self[key] = value.map { $0.encode() } ?? (skipIfNil ? nil : NSNull())
    }
    
    public mutating func encode<T: Encodable>(_ value: [String: T?], key: String) {
        self[key] = value.encode()
    }
    
    public mutating func encode<T: Encodable>(_ value: [String: T?]?, key: String, skipIfNil: Bool = false) {
        self[key] = value.map { $0.encode() } ?? (skipIfNil ? nil : NSNull())
    }
    
    public mutating func encode<T: AnyEncodable>(_ value: [String: T], key: String) {
        self[key] = value.encode()
    }
    
    public mutating func encode<T: AnyEncodable>(_ value: [String: T]?, key: String, skipIfNil: Bool = false) {
        self[key] = value.map { $0.encode() } ?? (skipIfNil ? nil : NSNull())
    }
    
    public mutating func encode<T: AnyEncodable>(_ value: [String: T?], key: String) {
        self[key] = value.encode()
    }
    
    public mutating func encode<T: AnyEncodable>(_ value: [String: T?]?, key: String, skipIfNil: Bool = false) {
        self[key] = value.map { $0.encode() } ?? (skipIfNil ? nil : NSNull())
    }
}

public protocol Optionable {
    associatedtype Wrapped
    func map<U>(_ transform: (Wrapped) throws -> U) rethrows -> U?
}

extension Optional: Optionable  {
    
}

extension Array where Element: Encodable {
    public func encode() -> [Any] {
        return map { $0.encode() }
    }
}

extension Array where Element: AnyEncodable {
    public func encode() -> [Any] {
        return map { $0.encode() }
    }
}


extension Array where Element: Optionable, Element.Wrapped: Encodable {
    public func encode() -> [Any] {
        return map { $0.map { $0.encode() as Any } ?? NSNull() as Any }
    }
}

extension Array where Element: Optionable, Element.Wrapped: AnyEncodable {
    public func encode() -> [Any] {
        return map { $0.map { $0.encode() as Any } ?? NSNull() as Any }
    }
}

extension Dictionary where Key == String, Value: Encodable {
    public func encode() -> [String: Any] {
        return map { $0.1.encode() }
    }
}

extension Dictionary where Key == String, Value: AnyEncodable {
    public func encode() -> [String: Any] {
        return map { $0.1.encode() }
    }
}

extension Dictionary where Key == String, Value: Optionable, Value.Wrapped: Encodable {
    public func encode() -> [String: Any] {
        return map { $0.1.map { $0.encode() as Any } ?? NSNull() as Any }
    }
}

extension Dictionary where Key == String, Value: Optionable, Value.Wrapped: AnyEncodable {
    public func encode() -> [String: Any] {
        return map { $0.1.map { $0.encode() as Any } ?? NSNull() as Any }
    }
}
