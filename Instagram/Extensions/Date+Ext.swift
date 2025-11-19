//
//  Date+Ext.swift
//  Instagram
//
//  Created by Alpay Calalli on 06.11.25.
//

import Foundation

extension Date {
   func format(_ format: String = "EEEE, MMMM dd, yyyy") -> String {
      let dateFormatter = DateFormatter()
      dateFormatter.dateFormat = format
      
      return dateFormatter.string(from: self)
   }
   
   func timePassed(from date: Date) -> String {
      let calendar = Calendar.current
      
      // Calculate the difference between the current date and the given date
      let components = calendar.dateComponents([.year, .month, .day], from: date, to: self)
      
      // Extract the year, month, and day components
      let years = components.year ?? 0
      let months = components.month ?? 0
      let days = components.day ?? 0
      let hours = components.hour ?? 0
      let minutes = components.minute ?? 0
      
      if years >= 1 {
         return "\(years)y"
      } else if months >= 1 {
         return "\(months)m"
      } else if days >= 1 {
         return "\(days)d"
      } else if hours >= 1 {
         return "\(hours)h"
      } else if minutes >= 1 {
         return "\(minutes)h"
      }
      
      return ""
   }
   
}

func parseDateFromISO8601(iso8601Date: String) -> Date? {
   let formatter = ISO8601DateFormatter()
   formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]

   return formatter.date(from: "2022-01-31T10:00:00.123Z")
}
