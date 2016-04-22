//
// Created by Alexander Babaev on 09.02.16.
// Copyright (c) 2016 LonelyBytes. All rights reserved.
//

import Foundation
import UIKit

extension S2Styler {
    static func buildParagraphStyle(attributes:[String:AnyObject]) -> NSParagraphStyle {
        let paragraphAttributes:NSMutableParagraphStyle = NSParagraphStyle.defaultParagraphStyle().mutableCopy() as! NSMutableParagraphStyle

        for (key, value) in attributes {
            switch key {
                case "lineHeight":
                    paragraphAttributes.minimumLineHeight = value as! CGFloat
                    paragraphAttributes.maximumLineHeight = value as! CGFloat
                case "paragraphSpacing":
                    paragraphAttributes.paragraphSpacing = value as! CGFloat
                case "paragraphSpacingBefore":
                    paragraphAttributes.paragraphSpacingBefore = value as! CGFloat
                case "alignment":
                    paragraphAttributes.alignment = NSTextAlignment(rawValue:value as! Int)!
                case "lineBreakMode":
                    paragraphAttributes.lineBreakMode = NSLineBreakMode(rawValue:value as! Int)!
                default:
                    print("!!!!!!!!!!!!!!! Can't parse paragraph attribute: \(key)")
            }
        }

        return paragraphAttributes.copy() as! NSParagraphStyle
    }
}
