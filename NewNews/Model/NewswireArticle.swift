//
//  NewswireArticle.swift
//  NewNews
//
//  Created by The GORDEEVS on 17.03.2022.
//

import Foundation

struct NewswireArticle: Codable {
    let url: String
    let abstract: String?
    let title: String
    let byline: String?
    let published_date: String
    let multimedia: [Metadata]?
    
    
    var timeToShow: String {
        get {
            return timeToShow(from: published_date)
        }
    }
    
    

    func timeToShow(from: String) -> String {
        if let date = from.getDateFromIsoString() {
            if date.isToday() {
                let minsBetween = Date.minutesBetweenDates(date, Date())
                if minsBetween < 60 {
                    let minsInt = Int(minsBetween)
                    return "\(minsInt) minutes ago"
                } else {
                    let time = date.dateAndTimetoString(format: "hh:mm a")
                    return "today at \(time)"
                }
            }
            if date.isYesterday(){
                let time = date.dateAndTimetoString(format: "hh:mm a")
                return "yesterday at \(time)"
            }
            return date.dateAndTimetoString(format: "dd MMM' at 'hh:mm a")
        }
        return "who knows when..."
    }
}

