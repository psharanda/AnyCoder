//
//  Created by Pavel Sharanda on 04.10.16.
//  Copyright © 2016 Pavel Sharanda. All rights reserved.
//

import Foundation

extension DecoderError: CustomDebugStringConvertible {
    public var debugDescription: String {
        return description
    }
}

public enum DecoderErrorType {
    case missing
    case invalidType(Any.Type, Any)
    case failed(Any.Type, Any)
    
    var error: DecoderError  {
        return DecoderError(errorType: self, path: [])
    }
}

public enum DecoderErrorPathComponent {
    case key(String)
    case index(Int)
}

public struct DecoderError: Error {
    public let errorType: DecoderErrorType
    public let path: [DecoderErrorPathComponent]
    
    func backtraceError(path: DecoderErrorPathComponent) -> DecoderError {
        return DecoderError(errorType: errorType, path: [path] + self.path)
    }
    
    public var jsonPath: String {
        var result = "$"
        
        for component in path {
            switch component {
            case .index(let index):
                result += "[\(index)]"
            case .key(let key):
                result += ".\(key)"
            }
        }
        
        return result
    }
    
    public var description: String {
        
        switch errorType {
        case .missing:
            return "Value is missing at path '\(jsonPath)'"
        case .invalidType(let type, let value):
            return "Invalid value '\(value)' of type '\(type(of: value))' was found at path '\(jsonPath)', while expected '\(type)'"
        case .failed(let type, let value):
            return "Failed to create object of type '\(type))' from '\(value)' at path '\(jsonPath)'"
        }
    }
    
    public var code: Int {
        switch errorType {
        case .missing:
            return -1
        case .invalidType:
            return -2
        case .failed:
            return -3
        }
    }

}
