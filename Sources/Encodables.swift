//
//  Created by Pavel Sharanda on 04.10.16.
//  Copyright © 2016 Pavel Sharanda. All rights reserved.
//

import Foundation
import CoreGraphics

//MARK:- ScalarEncodable
public protocol ScalarEncodable: ValueEncodable {}

extension ScalarEncodable {
    public func encode() -> Any {
        return self //self must be bridged to Any directly
    }
}

extension Double : ScalarEncodable {}
extension Int : ScalarEncodable {}
extension Int8 : ScalarEncodable {}
extension Int16 : ScalarEncodable {}
extension Int32 : ScalarEncodable {}
extension Int64 : ScalarEncodable {}
extension UInt : ScalarEncodable {}
extension UInt8 : ScalarEncodable {}
extension UInt16 : ScalarEncodable {}
extension UInt32 : ScalarEncodable {}
extension UInt64 : ScalarEncodable {}
extension Float : ScalarEncodable {}
extension CGFloat : ScalarEncodable {}
extension String : ScalarEncodable {}
extension Bool : ScalarEncodable {}

//MARK:- NSURL
extension URL: ValueEncodable {
    public func encode() -> Any {        
        return absoluteString
    }
}

//MARK:- RawRepresentable

extension ValueEncodable where Self: RawRepresentable, Self.RawValue: ValueEncodable {
    public func encode() -> Any {
        return self.rawValue.encode()
    }
}

//MARK:- NSDate as decodable
extension Date: ValueEncodable {
    public func encode() -> Any {
        return timeIntervalSince1970
    }
}




