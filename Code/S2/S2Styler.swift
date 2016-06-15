//
// Created by Alexander Babaev on 11.01.16.
// Copyright (c) 2016 LonelyBytes. All rights reserved.
//

import Foundation

#if os(iOS)
    import KTVKit
#endif

public class S2Styler: CustomStringConvertible {
    private var _sourceStyleFiles:[String:KTVObject] = [:]
    private var _wholeNotExpandedStyle = KTVObject()
    private var _expandedStyle = KTVObject()

    static func functionResolver(functionName:String, parameters:[String], rootObject:KTVObject) throws -> KTVValue {
        func getColor(colorString:String) throws -> (red:Double, green:Double, blue:Double, alpha:Double) {
            var r:Double = 0
            var g:Double = 0
            var b:Double = 0
            var a:Double = 1

            if colorString.hasPrefix("@") {
                let colorValue = try rootObject.findObjectByReference(colorString)
                if case .color(let colorHex) = colorValue {
                    (r, g, b, a) = ColorUtils.colorFromHex(colorHex)
                }
            } else if colorString.hasPrefix("#") {
                (r, g, b, a) = ColorUtils.colorFromHex(colorString)
            }

            return (r, g, b, a)
        }

        var result = KTVValue.nilValue

        switch functionName {
            case "color.alpha":
                var (r, g, b, a) = try getColor(parameters[0])
                let alpha = Double(parameters[1])!
                r *= alpha
                g *= alpha
                b *= alpha
                a *= alpha

                result = KTVValue.color(ColorUtils.colorToHex(r, g, b, a))
            case "color.mix":
                let (r1, g1, b1, a1) = try getColor(parameters[0])
                let (r2, g2, b2, a2) = try getColor(parameters[1])
                let mixPart2 = parameters.count > 2 ? Double(parameters[2])! : 0.5
                let mixPart1 = 1 - mixPart2
                let r = r1*mixPart1 + r2*mixPart2
                let g = g1*mixPart1 + g2*mixPart2
                let b = b1*mixPart1 + b2*mixPart2
                let a = a1*mixPart1 + a2*mixPart2

                result = KTVValue.color(ColorUtils.colorToHex(r, g, b, a))
            default:
                throw KTVParserError.BadFunctionDoesNotExist
        }

        return result
    }

    private func filePathFrom(fileName:String, parentFile:String) -> String {
        var result = fileName

        if !fileName.hasPrefix("/") {
            if parentFile.isEmpty {
                result = "\(NSBundle.mainBundle().bundlePath)/\(fileName)"
            } else {
                var parentDirectory = (parentFile as NSString).stringByDeletingLastPathComponent
                result = "\(parentDirectory)/\(fileName)"

                let fileManager = NSFileManager.defaultManager()
                if !fileManager.fileExistsAtPath(result) {
                    parentDirectory = (parentDirectory as NSString).stringByDeletingLastPathComponent

                    if let enumerator = fileManager.enumeratorAtPath(parentDirectory) {
                        while let element = enumerator.nextObject() as? String {
                            if element.hasSuffix("/\(fileName)") || element == fileName {
                                result = "\(parentDirectory)/\(element)"
                                break
                            }
                        }
                    }
                }
            }
        }

        return result
    }

    func loadStyleFromFile(fileName:String, needUpdateExpandedStyle:Bool = true) {
        let filePath = filePathFrom(fileName, parentFile:"")

        let parser = KTVParser(fileName:filePath)
        let ktvObject:KTVObject
        do {
            ktvObject = try parser.parse()

            _sourceStyleFiles[fileName] = ktvObject

            for (name, value) in ktvObject.properties {
                if name.hasPrefix("@include") {
                    if case .string(let path) = value {
                        loadStyleFromFile(filePathFrom(path, parentFile:fileName), needUpdateExpandedStyle: false)
                    } else if case .object(_, let pathObject) = value {
                        if let inAppPathValue = pathObject.properties["inApp"] {
                            if case .string(let path) = inAppPathValue {
                                loadStyleFromFile(filePathFrom(path, parentFile:fileName), needUpdateExpandedStyle:false)
                            }
                        } else {
                            //ToDo: try to load remote
                        }
                    }
                }
            }

            if needUpdateExpandedStyle {
                do {
                    try updateExpandedStyle()
                } catch {
                    print("Style parsing error \(error) file: \(filePath)")
                }
            }
        } catch {
            print("Style parsing error \(error) \(parser.currentPosition) file: \(filePath)")
        }
    }

    private func updateExpandedStyle() throws {
        _wholeNotExpandedStyle = KTVObject()
        for (name, ktv) in _sourceStyleFiles {
            do {
                try _wholeNotExpandedStyle.setPropertiesFromObject(ktv, replaceExisting:true)
            } catch {
                print("KTV Styles \(name) Merging error: \(error)")
            }
        }

        try updateOldStyleParentsAndMixIns(_wholeNotExpandedStyle)
        _expandedStyle = _wholeNotExpandedStyle.resolvedObject(mixinsOnly:false)

//        if let styleObject = _styleObject {
//            styleObject.updateFromKTV(_expandedStyle)
//        }
    }

    func updateOldStyleParentsAndMixIns(object:KTVObject) throws {
        let propertyNames = object.propertyNamesInAddedOrder
        for name in propertyNames {
            if let value = object.properties[name] {
                if case .string(let parent) = value where name == "@parent" {
                    if case .object(_, let parentObject) = try object.findObjectByReference(parent) {
                        try object.setPropertiesFromObject(parentObject, replaceExisting:false)
                    }
                } else if case .object(_, let childObject) = value {
                    try updateOldStyleParentsAndMixIns(childObject)
                } else if case .array(_, let values) = value {
                    for valueValue in values {
                        if case .object(_, let childObject) = valueValue {
                            try updateOldStyleParentsAndMixIns(childObject)
                        }
                    }
                }
            }
        }
    }

    func generateClassToFile(path:String, rootClassName:String, withGenerator generator: S2Generator, needS2Import: Bool, needSingleton:Bool) throws {
        try generator.generateToFile(path, fromObject:_wholeNotExpandedStyle, rootClassName:rootClassName, needS2Import:needS2Import, needSingleton:needSingleton)
//        try generator.generateClassesToFile(path, fromObject:_expandedStyle, rootClassName:rootClassName)
    }

    //MARK - Debug

    public var description: String {
        return _expandedStyle.description
//        return _sourceStyleFiles.description
    }
}
