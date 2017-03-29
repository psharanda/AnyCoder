//
//  Created by Pavel Sharanda on 30.09.16.
//  Copyright © 2016 Pavel Sharanda. All rights reserved.
//

import Foundation

//Utils
extension Dictionary {
    func map<T>(_ transform: ((Key, Value)) throws -> T) rethrows -> [Key: T] {
        var result: [Key: T] = [:]
        for (key, value) in self {
            result[key] = try transform(key, value)
        }
        return result
    }
}

extension Dictionary {
    
    mutating func merge(with dictionary: Dictionary) {
        dictionary.forEach { updateValue($1, forKey: $0) }
    }
    
    func merged(with dictionary: Dictionary) -> Dictionary {
        var dict = self
        dict.merge(with: dictionary)
        return dict
    }
}
