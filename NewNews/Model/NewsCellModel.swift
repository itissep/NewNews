//
//  NewsCellModel.swift
//  NewNews
//
//  Created by The GORDEEVS on 19.03.2022.
//

import Foundation
import UIKit


struct NewsCellModel {
    let title: String
    let imageUrl: String
    let time: String

    
    var timeToShow: String {
        get {
            return timeToShow(from: time)
        }
    }
    

    func timeToShow(from: String) -> String {
        if let date = from.getDateFromIsoString() {
            if date.isToday() {
                let minsBetween = Date.minutesBetweenDates(date, Date())
                if minsBetween < 60 {
                    let minsInt = Int(minsBetween)
                    //FIXIT: локализация не работает!!!
                    let string = "minutes ago".localized()
                    return "\(minsInt)" + string
                } else {
                    let time = date.dateAndTimetoString(format: "hh:mm a")
                    return "today at".localized() + time
                }
            }
            if date.isYesterday(){
                let time = date.dateAndTimetoString(format: "hh:mm a")
                return "yesterday at".localized() + time
            }
            return date.dateAndTimetoString(format: "dd MMM' at 'hh:mm a")
        }
        return "who knows when..."
    }
    
    init(title: String, imageUrl: String, time: String) {
        self.imageUrl = imageUrl
        self.title = title
        self.time = time
    }
}


extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}
