//
// Created by Alexander Babaev on 07.02.16.
// Copyright (c) 2016 LonelyBytes. All rights reserved.
//

import Foundation

#if os(iOS)
    import KTVKit
#endif

protocol S2Generator {
    func generateToFile(path:String, fromObject:KTVObject, rootClassName:String, needS2Import:Bool) throws
}
