//
// Created by Alexander Babaev on 07.02.16.
// Copyright (c) 2016 LonelyBytes. All rights reserved.
//

import Foundation
import KTVKit

protocol S2Generator {
    func generateToFile(path:String, fromObject:KTVObject, rootClassName:String) throws
}
