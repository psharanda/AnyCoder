//
//  Created by Pavel Sharanda on 04.10.16.
//  Copyright © 2016 Pavel Sharanda. All rights reserved.
//

import Foundation

//public enum DecoderError: Error {
//    
//    case missing(keyPath: [String])
//    case invalidType(keyPath: [String], type: Any.Type, value: Any)
//    case failed(keyPath: [String], type: Any.Type, value: Any)
//    case nonnullable(keyPath: [String])
//    
//    public var description: String {
//        func keyPathString(_ keyPath: [String]) -> String {
//            if keyPath.count == 0 {
//                return "self"
//            }
//            return keyPath.joined(separator: ".")
//        }
//        switch self {
//        case .missing(let keyPath):
//            return "Value is missing at keyPath '\(keyPathString(keyPath))'"
//        case .invalidType(let keyPath, let type, let value):
//            return "Invalid value '\(value)' of type '\(type(of: value))' was found at keyPath '\(keyPathString(keyPath))', while expected '\(type)'"
//        case .failed(let keyPath, let type, let value):
//            return "Failed to create object of type '\(type))' from '\(value)' at keyPath '\(keyPathString(keyPath))'"
//        case .nonnullable(let keyPath):
//            return "Value can't be null at keyPath '\(keyPathString(keyPath))'"
//        }
//    }
//    
//    public var code: Int {
//        switch self {
//        case .missing:
//            return -1
//        case .invalidType:
//            return -2
//        case .failed:
//            return -3
//        case .nonnullable:
//            return -4
//        }
//    }
//}
//
//extension DecoderError: CustomDebugStringConvertible {
//    public var debugDescription: String {
//        return description
//    }
//}


public enum DecoderErrorType: Error {
    case missing
    case invalidType(Any)
    case invalidValue(Any)
}

public struct DecoderError: Error {
    let errorType: DecoderErrorType
    let keyPath: [String]
}
