//
//  Created by Pavel Sharanda on 04.10.16.
//  Copyright © 2016 Pavel Sharanda. All rights reserved.
//

import Foundation
import CoreGraphics

//MARK:- scalar decodables
public protocol ScalarDecodable : Decodable {}

extension ScalarDecodable {
    public init(decoder: Decoder) throws {
        self = try decoder.extractValue() as Self
    }
}

extension Double : ScalarDecodable {}
extension Int : ScalarDecodable {}
extension Float : ScalarDecodable {}
extension CGFloat : ScalarDecodable {}
extension String : ScalarDecodable {}
extension Bool : ScalarDecodable {}

//MARK:- NSURL as decodable
extension URL: Decodable {
    public init?(decoder: Decoder) throws {
        let string: String = try decoder.decode()
        self.init(string: string)
    }
}

//MARK:- RawRepresentable as decodable, enum itself must be marked as conforming Decodable
extension Decodable where Self: RawRepresentable, Self.RawValue: Decodable {
    public init?(decoder: Decoder) throws {
        self.init(rawValue: try decoder.decode())
    }
}

//MARK:- NSDate as decodable
extension Date: Decodable {
    public init(decoder: Decoder) throws {
        self.init(timeIntervalSince1970: try decoder.decode())
    }
}




