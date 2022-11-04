//
//  DateModels.swift
//  DateModels
//
//  Created by 陳韋綸 on 2022/5/14.
//

import Foundation

class DateModels {
    
    static func videoDate(_ videoPublishTime: String) -> Date {
        // 擷取前10字串
        let indexString = videoPublishTime.index(videoPublishTime.startIndex, offsetBy: 10)
        let stringDate = String(videoPublishTime.prefix(upTo: indexString))
        // 字串轉日期
        let formatter = DateFormatter()
        formatter.locale = Locale.init(identifier: "zh_TW")
        formatter.dateFormat = "yyyy-MM-dd"
        let date = formatter.date(from: stringDate) ?? Date()
        return date
    }
    
    static func dateInterval(videoPublishTime: Date) -> String {
        let timeInterval = videoPublishTime.timeIntervalSinceNow
        let time = Date.now.advanced(by: timeInterval)
        let formatter = RelativeDateTimeFormatter()
        formatter.locale = Locale(identifier: "zh-TW")
        return formatter.string(for: time) ?? "error"
    }
}
