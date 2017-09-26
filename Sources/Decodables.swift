//
//  Created by Pavel Sharanda on 04.10.16.
//  Copyright © 2016 Pavel Sharanda. All rights reserved.
//

import Foundation
import CoreGraphics

//MARK:- scalar decodables
public protocol ScalarDecodable : AnyValueDecodable {}

extension ScalarDecodable {
    public init(value: Self) {
        self = value
    }
}

extension Double : ScalarDecodable {}
extension Int : ScalarDecodable {}
extension Int8 : ScalarDecodable {}
extension Int16 : ScalarDecodable {}
extension Int32 : ScalarDecodable {}
extension Int64 : ScalarDecodable {}
extension UInt : ScalarDecodable {}
extension UInt8 : ScalarDecodable {}
extension UInt16 : ScalarDecodable {}
extension UInt32 : ScalarDecodable {}
extension UInt64 : ScalarDecodable {}
extension Float : ScalarDecodable {}
extension CGFloat : ScalarDecodable {}
extension String : ScalarDecodable {}
extension Bool : ScalarDecodable {}

//MARK:- URL as decodable
extension URL: AnyValueDecodable {
    public init?(value: String) {
        self.init(string: value)
    }
}

//MARK:- RawRepresentable as decodable, enum itself must be marked as conforming AnyValueDecodable
extension AnyValueDecodable where Self: RawRepresentable, Self.RawValue: AnyValueDecodable {
    public init?(value: RawValue) {
        self.init(rawValue: value)
    }
}

//MARK:- Date as decodable
extension Date: AnyValueDecodable {
    public init(value: Double) {
        self.init(timeIntervalSince1970: value)
    }
}
