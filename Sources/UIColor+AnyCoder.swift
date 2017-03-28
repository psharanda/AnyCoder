//
//  Created by Pavel Sharanda on 04.10.16.
//  Copyright © 2016 Pavel Sharanda. All rights reserved.
//

#if os(macOS)
    import AppKit
    
    //MARK:- UIColor as decodable
    extension Decodable where Self: NSColor {
        public init?(decoder: Decoder) throws {
            self.init(hexString: try decoder.decode())
        }
    }
    
    extension NSColor: Decodable {}
    
    //MARK:- UIColor
    
    extension NSColor: Encodable {
        public func encode() -> Any {
            return asHexString
        }
    }
    
    
    extension NSColor {
        convenience init?(hexString: String) {
            if let argb = argbFromString(hexString) {
                self.init(red: CGFloat(argb.r) / 255, green: CGFloat(argb.g) / 255, blue: CGFloat(argb.b) / 255, alpha: CGFloat(argb.a) / 255)
            } else {
                return nil
            }
        }
        
        var asHexString: String {
            var r: CGFloat = 0
            var g: CGFloat = 0
            var b: CGFloat = 0
            var a: CGFloat = 0
            self.getRed(&r, green: &g, blue: &b, alpha: &a)
            
            return argbToString(a: a, r: r, g: g, b: b)
        }
    }
    
#else
    import UIKit
    
    //MARK:- UIColor as decodable
    extension Decodable where Self: UIColor {
        public init?(decoder: Decoder) throws {
            self.init(hexString: try decoder.decode())
        }
    }
    
    extension UIColor: Decodable {}
    
    //MARK:- UIColor
    
    extension UIColor: Encodable {
        public func encode() -> Any {
            return asHexString
        }
    }
    
    
    extension UIColor {
        convenience init?(hexString: String) {
            if let argb = argbFromString(hexString) {
                self.init(red: CGFloat(argb.r) / 255, green: CGFloat(argb.g) / 255, blue: CGFloat(argb.b) / 255, alpha: CGFloat(argb.a) / 255)
            } else {
                return nil
            }
        }
        
        var asHexString: String {
            var r: CGFloat = 0
            var g: CGFloat = 0
            var b: CGFloat = 0
            var a: CGFloat = 0
            self.getRed(&r, green: &g, blue: &b, alpha: &a)
            
            return argbToString(a: a, r: r, g: g, b: b)
        }
    }
#endif

func argbFromString(_ hexString: String) -> (a: UInt32, r: UInt32, g: UInt32, b: UInt32)? {
    let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
    var int = UInt32()
    Scanner(string: hex).scanHexInt32(&int)
    let a, r, g, b: UInt32
    switch hex.characters.count {
    case 3: // RGB (12-bit)
        (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
    case 6: // RGB (24-bit)
        (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
    case 8: // ARGB (32-bit)
        (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
    default:
        return nil
    }
    
    return (a: a, r: r, g: g, b: b)
}

func argbToString(a: CGFloat, r: CGFloat, g: CGFloat, b: CGFloat) -> String {
    if (a < 1.0) {
        return String(format: "#%02X%02X%02X%02X", Int(r * 255), Int(g * 255), Int(b * 255), Int(a * 255))
    } else {
        return String(format: "#%02X%02X%02X", Int(r * 255), Int(g * 255), Int(b * 255))
    }
}
