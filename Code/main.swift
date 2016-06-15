//
//  main.swift
//  s2generator
//
//  Created by Alexander Babaev on 12.02.16.
//  Copyright © 2016 LonelyBytes. All rights reserved.
//

import Foundation
import Darwin

var styleFilePath = ""
var outputClassPath = ""
var outputClassName = "S2Style"
var needS2Import = true
var needSingleton = false
var needObjCCompatibility = true
var reallyNeedObjCCompatibility = false // when specified as an argument

var skipArgument = false
var index = 0
for argument in Process.arguments {
    if skipArgument {
        skipArgument = false
        index += 1
        continue
    }

    switch argument.lowercaseString {
        case "-s":
            styleFilePath = Process.arguments[index + 1]
            skipArgument = true
        case "-o":
            outputClassPath = Process.arguments[index + 1]
            skipArgument = true
        case "-c":
            outputClassName = Process.arguments[index + 1]
            skipArgument = true
        case "-objc":
            needObjCCompatibility = true
            reallyNeedObjCCompatibility = true
        case "-swift":
            needObjCCompatibility = reallyNeedObjCCompatibility
        case "-noFramework":
            needS2Import = false
        case "-withS2Singleton":
            needSingleton = true

        default:
            if index != 0 {
                print("Unknown argument: \(argument)");
            }
    }

    index += 1
}

if styleFilePath.isEmpty || outputClassName.isEmpty || outputClassPath.isEmpty {
    print("Usage: s2generator -s StyleFilePath -o OutputClassPath [-с ClassName] [-objc|-swift] [-noFramework] [-withS2Singleton]\n" +
          "Will return 1 if generation is OK or 0 otherwise")

    exit(1)
} else {
    styleFilePath = (styleFilePath as NSString).stringByExpandingTildeInPath
    outputClassPath = (outputClassPath as NSString).stringByExpandingTildeInPath

    let styler = S2Styler()
    styler.loadStyleFromFile(styleFilePath)

    do {
        try styler.generateClassToFile("\(outputClassPath)/\(outputClassName).swift",
                         rootClassName:outputClassName,
                         withGenerator:S2GeneratorSwift(withObjCCompatibility:needObjCCompatibility),
                         needS2Import:needS2Import,
                         needSingleton:needSingleton)
    } catch {
        print("Error during generating of the S2 class file: \(error)")
    }

    exit(0)
}
