//
// Created by Alexander Babaev on 09.02.16.
// Copyright (c) 2016 LonelyBytes. All rights reserved.
//

import Foundation

enum S2GeneratorWarnings: ErrorType {
    case OldStyledReferenceOrParent // ASS-styled reference, include or something like it
}

enum S2GeneratorErrors: ErrorType {
    case WrongPropertyPrefix(String) // for example, properties can not start with "new" word
    case ArrayCanNotContainObjectsOrArrays

    case BadFontObject
    case BadColorObject

    case UnknownValueType
    case UnsupportedValueType
}
