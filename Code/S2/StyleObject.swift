//
// Created by Alexander Babaev on 15/06/2016.
// Copyright (c) 2016 LonelyBytes. All rights reserved.
//

import Foundation
#if os(iOS)
    import KTVKit
#endif

public protocol StyleObject {
    var ktv: KTVObject { get }

    func int(key:String) -> Int
    func string(key:String) -> String
    func double(key:String) -> Double
    func bool(key:String) -> Bool
}

public extension StyleObject {
    func int(key:String) -> Int {
        do {
            if case .int(let value) = try ktv.findObjectByReference(key) {
                return value
            } else {
                return 0
            }
        } catch {
            return 0
        }
    }

    func double(key:String) -> Double {
        do {
            if case .double(let value) = try ktv.findObjectByReference(key) {
                return value
            } else {
                return 0.0
            }
        } catch {
            return 0.0
        }
    }

    func bool(key:String) -> Bool {
        do {
            if case .bool(let value) = try ktv.findObjectByReference(key) {
                return value
            } else {
                return false
            }
        } catch {
            return false
        }
    }

    func string(key:String) -> String {
        do {
            if case .string(let value) = try ktv.findObjectByReference(key) {
                return value
            } else {
                return ""
            }
        } catch {
            return ""
        }
    }
}
