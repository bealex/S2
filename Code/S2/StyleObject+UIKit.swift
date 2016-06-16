//
// Created by Alexander Babaev on 15/06/2016.
// Copyright (c) 2016 LonelyBytes. All rights reserved.
//

import Foundation
import UIKit
#if os(iOS)
    import KTVKit
#endif

public extension StyleObject {
    func color(key:String) -> UIColor! {
        if case .color(let colorString) = try! ktv.findObjectByReference(key) {
            let (r, g, b, a) = ColorUtils.colorFromHex(colorString)
            return UIColor(red: CGFloat(r), green: CGFloat(g), blue: CGFloat(b), alpha: CGFloat(a))
        }

        return nil
    }

    func font(key:String) -> UIFont! {
        if case .object(_, let object) = try! ktv.findObjectByReference(key) {
            if let name = try! object.string(key:"name", defaultValue:nil),
                   size = try! object.double(key:"size", defaultValue:nil) {
                if name == "system" {
                    let fontDescriptor = UIFont.systemFontOfSize(CGFloat(size)).fontDescriptor()
                    return UIFont(descriptor:fontDescriptor, size:CGFloat(size))
                } else {
                    let fontDescriptor = UIFontDescriptor(name:name, size:CGFloat(size))
                    return UIFont(descriptor:fontDescriptor, size:CGFloat(size))
                }
            }
        }

        return nil
    }

    func point(key:String) -> CGPoint! {
        if case .array(_, let array) = try! ktv.findObjectByReference(key) {
            if let x = cgFloat(array[0]),
                   y = cgFloat(array[1]) {
                return CGPoint(x: x, y: y)
            }
        }

        return nil
    }

    func rect(key:String) -> CGRect! {
        if case .array(_, let array) = try! ktv.findObjectByReference(key) {
            if let x = cgFloat(array[0]),
                   y = cgFloat(array[1]),
                   width = cgFloat(array[2]),
                   height = cgFloat(array[3]) {
                return CGRect(x: x, y: y, width: width, height: height)
            }
        }

        return nil
    }
}

private extension StyleObject {
    func cgFloat(value:KTVValue) -> CGFloat? {
        if case .int(let result) = value {
            return CGFloat(result)
        } else if case .double(let result) = value {
            return CGFloat(result)
        }

        return nil
    }

//    func textAttributes(object:KTVObject) throws -> String {
//        var results:[String] = []
//        var paragraphAttributes:[String] = []
//
//        for name in object.propertyNamesInAddedOrder {
//            if let value = object.properties[name] {
//                switch name {
//                    case "font":
//                        if case .object(_, let object) = value {
//                            try results.append("    NSFontAttributeName: " + fontValue(object))
//                        } else if case .reference(_) = value {
//                            results.append("    NSFontAttributeName: " + referenceProperty(value))
//                        } else {
//                            throw S2GeneratorErrors.BadFontObject
//                        }
//                    case "color", "foregroundColor":
//                        if case .color(let hexColor) = value {
//                            results.append("    NSForegroundColorAttributeName: " + colorValue(hexColor))
//                        } else if case .reference(_) = value {
//                            results.append("    NSFontAttributeName: " + referenceProperty(value))
//                        } else {
//                            throw S2GeneratorErrors.BadColorObject
//                        }
//                    case "lineHeight":
//                        paragraphAttributes.append("        \"\(name)\": CGFloat(\(value.doubleValue))")
//                    case "paragraphSpacing":
//                        paragraphAttributes.append("        \"\(name)\": CGFloat(\(value.doubleValue))")
//                    case "paragraphSpacingBefore":
//                        paragraphAttributes.append("        \"\(name)\": CGFloat(\(value.doubleValue))")
//                    case "alignment":
//                        if case .string(let alignment) = value {
//                            switch alignment {
//                                case "center", "Center", "NSTextAlignmentCenter":
//                                    paragraphAttributes.append("        \"\(name)\": NSTextAlignment.Center.rawValue")
//                                case "left", "Left", "NSTextAlignmentLeft":
//                                    paragraphAttributes.append("        \"\(name)\": NSTextAlignment.Left.rawValue")
//                                case "right", "Right", "NSTextAlignmentRight":
//                                    paragraphAttributes.append("        \"\(name)\": NSTextAlignment.Right.rawValue")
//                                case "justify", "justified", "Justify", "Justified", "NSTextAlignmentJustified":
//                                    paragraphAttributes.append("        \"\(name)\": NSTextAlignment.Justified.rawValue")
//                                default:
//                                    paragraphAttributes.append("        \"\(name)\": NSTextAlignment.Natural.rawValue")
//                            }
//                        }
//                    case "lineBreakMode":
//                        if case .string(let wrapping) = value {
//                            switch wrapping {
//                                case "wordWrapping", "NSLineBreakModeByWordWrapping":
//                                    paragraphAttributes.append("        \"\(name)\": NSLineBreakMode.ByWordWrapping.rawValue")
//                                case "charWrapping", "NSLineBreakModeByCharWrapping":
//                                    paragraphAttributes.append("        \"\(name)\": NSLineBreakMode.ByCharWrapping.rawValue")
//                                case "clipping", "NSLineBreakModeByClipping":
//                                    paragraphAttributes.append("        \"\(name)\": NSLineBreakMode.ByClipping.rawValue")
//                                case "truncatingHead", "NSLineBreakModeByTruncatingHead":
//                                    paragraphAttributes.append("        \"\(name)\": NSLineBreakMode.ByTruncatingHead.rawValue")
//                                case "truncatingMiddle", "NSLineBreakModeByTruncatingMiddle":
//                                    paragraphAttributes.append("        \"\(name)\": NSLineBreakMode.ByTruncatingMiddle.rawValue")
//                                case "truncatingTail", "NSLineBreakModeByTruncatingTail":
//                                    paragraphAttributes.append("        \"\(name)\": NSLineBreakMode.ByTruncatingTail.rawValue")
//                                default:
//                                    paragraphAttributes.append("        \"\(name)\": NSLineBreakMode.ByTruncatingTail.rawValue")
//                            }
//                        }
//                    default:
//                        print("!!!!!!!!!!!!!!! Can't parse text attribute: \(name)")
//                }
//            }
//        }
//
//        if !paragraphAttributes.isEmpty {
//            results.append("    NSParagraphStyleAttributeName: S2Styler.buildParagraphStyle([\n" + paragraphAttributes.joinWithSeparator(",\n") + "\n    ])")
//        }
//
//        return "[\n" + results.joinWithSeparator(",\n") + "\n]\n"
//    }
}