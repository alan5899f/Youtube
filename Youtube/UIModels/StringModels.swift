//
//  StringModels.swift
//  StringModels
//
//  Created by 陳韋綸 on 2022/5/19.
//

import UIKit

enum type {
    case normalCount
    case channelCount
}

class StringModels {
    
    static func mathToString(int: CGFloat, _ type: type) -> String {
        switch type {
        case .normalCount:
            if int >= 10000, int < 999999 {
                return String(format: "%.1f", int/10000) + "萬"
            }
        case .channelCount:
            if int >= 10000, int < 999999 {
                return String(format: "%.2f", int/10000) + "萬"
            }
        }
        if int >= 1000000, int < 9999999 {
            return String(Int(int/10000)) + "萬"
        }
        if int >= 10000000, int < 99999999 {
            return String(Int(int/10000)) + "萬"
        }
        if int >= 100000000 {
            return String(Int(int/100000000)) + "億"
        }
        return String(Int(int))
    }
}
