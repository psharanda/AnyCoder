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
    
    //MARK: dict
    mutating public func encode<T: Encodable>(_ value: [String: T], key: String) {
        self[key] = value.encode()
    }
    
    mutating public func encode<T: Encodable>(_ value: [String: T]?, key: String, skipIfNil: Bool = false) {
        self[key] = value.flatMap { $0.encode() } ?? (skipIfNil ? nil : NSNull())
    }
    
    //MARK: set
    mutating public func encode<T: Encodable & Hashable>(_ value: Set<T>, key: String) {
        self[key] = value.encode()
    }
    
    mutating public func encode<T: Encodable & Hashable>(_ value: Set<T>?, key: String, skipIfNil: Bool = false) {
        self[key] = value.flatMap { $0.encode() } ?? (skipIfNil ? nil : NSNull())
    }
}

extension Array where Element: Encodable {
    public func encode() -> Any {
        return map { $0.encode() }
    }
}

extension Dictionary where Key == String, Value: Encodable {
    public func encode() -> Any {
        return map { $0.1.encode() }
    }
}

extension Set where Element: Encodable {
    public func encode() -> Any {
        return map { $0.encode() }
    }
}

//extension Dictionary {
//    
//    public mutating func merge(with dictionary: Dictionary) {
//        dictionary.forEach { updateValue($1, forKey: $0) }
//    }
//    
//    public func merged(with dictionary: Dictionary) -> Dictionary {
//        var dict = self
//        dict.merge(with: dictionary)
//        return dict
//    }
//}
