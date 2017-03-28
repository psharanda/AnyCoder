//
//  Created by Pavel Sharanda on 04.10.16.
//  Copyright © 2016 Pavel Sharanda. All rights reserved.
//

import Foundation
import CoreGraphics

//MARK:- ScalarEncodable
public protocol ScalarEncodable: Encodable {}

extension ScalarEncodable {
    public func encode() -> Any {
        return self //self must be bridged to Any directly
    }
}

extension Double : ScalarEncodable {}
extension Int : ScalarEncodable {}
extension String : ScalarEncodable {}
extension Float : ScalarEncodable {}
extension CGFloat : ScalarEncodable {}
extension Bool : ScalarEncodable {}

//MARK:- NSURL
extension URL: Encodable {
    public func encode() -> Any {        
        return absoluteString
    }
}

//MARK:- RawRepresentable

extension Encodable where Self: RawRepresentable, Self.RawValue: Encodable {
    public func encode() -> Any {
        return self.rawValue.encode()
    }
}

//MARK:- NSDate as decodable
extension Date: Encodable {
    public func encode() -> Any {
        return timeIntervalSince1970
    }
}



