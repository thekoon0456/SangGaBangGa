//
//  DateFormatterManager.swift
//  SangbooSangzo
//
//  Created by Deokhun KIM on 4/30/24.
//

import Foundation

final class DateFormatterManager {
    
    enum DateStyle: String {
        case dateAndHour = "yyyy년 M월 d일 a h시"
        case date = "yyyy년 M월 d일"
    }
    
    static let shared = DateFormatterManager()
    private let formatter = DateFormatter()
    private let iso8601formatter = ISO8601DateFormatter()
    private let krLocale = Locale(identifier: "ko_kr")
    
    private init() {
        iso8601formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
    }
    
    // MARK: - 최종적인 format결과
    
    func iso8601DateToString(_ input: String, format: DateStyle) -> String? {
        let inputDate = iso8601formatter.date(from: input)
        guard let inputDate else { return nil }
        formatter.locale = krLocale
        formatter.dateFormat = format.rawValue
        let result = formatter.string(from: inputDate)
        return result
    }
    
    func formattedISO8601ToDate(_ input: String) -> Date? {
        return formatter.date(from: input)
    }
}
