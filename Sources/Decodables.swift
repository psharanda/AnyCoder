//
//  Created by Pavel Sharanda on 04.10.16.
//  Copyright © 2016 Pavel Sharanda. All rights reserved.
//

import Foundation
import CoreGraphics

//MARK:- scalar decodables
public protocol ScalarDecodable : AnyDecodable {}

extension ScalarDecodable {
    public init?(anyValue: Any) {
        if let value = anyValue as? Self {
            self = value
        } else {
            return nil
        }
    }
}

extension Double : ScalarDecodable {}
extension Int : ScalarDecodable {}
extension Float : ScalarDecodable {}
extension CGFloat : ScalarDecodable {}
extension String : ScalarDecodable {}
extension Bool : ScalarDecodable {}

//MARK:- NSURL as decodable
extension URL: AnyDecodable {
    public init?(anyValue: Any) {
        if let value = anyValue as? String {
            self.init(string: value)
        } else {
            return nil
        }
    }
}

//MARK:- RawRepresentable as decodable, enum itself must be marked as conforming Decodable
extension AnyDecodable where Self: RawRepresentable, Self.RawValue: AnyDecodable {
    public init?(anyValue: Any) {
        if let value = anyValue as? RawValue {
            self.init(rawValue: value)
        } else {
            return nil
        }
    }
}

//MARK:- NSDate as decodable
extension Date: AnyDecodable {
    public init?(anyValue: Any) {
        if let value = anyValue as? Double {
            self.init(timeIntervalSince1970: value)
        } else {
            return nil
        }
    }
}




