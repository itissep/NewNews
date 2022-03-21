//
//  extensions.swift
//  NewNews
//
//  Created by The GORDEEVS on 19.03.2022.
//

import UIKit


extension String {
    func getDateFromIsoString() -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        return dateFormatter.date(from:self)
    }
}

extension UITableView {
    func scrollToTop() {
        let indexPath = IndexPath(row: 0, section: 0)
        self.scrollToRow(at: indexPath, at: .top, animated: true)
    }
}


extension Date {
    
    func isYesterday() -> Bool {
        return Calendar.current.isDateInYesterday(self)
    }
    
    func isToday() -> Bool {
        return Calendar.current.isDateInToday(self)
    }
    
    func dateAndTimetoString(format: String = "yyyy-MM-dd HH:mm") -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
       
    func timeIn24HourFormat() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: self)
    }
    
    static func minutesBetweenDates(_ oldDate: Date, _ newDate: Date) -> Double {

        //get both times sinces refrenced date and divide by 60 to get minutes
        let newDateMinutes = newDate.timeIntervalSinceReferenceDate/60
        let oldDateMinutes = oldDate.timeIntervalSinceReferenceDate/60

        let result = Double(newDateMinutes - oldDateMinutes)
        //then return the difference
        return abs(result)
    }
}



extension UIImageView {
    func downloaded(from url: URL, contentMode mode: ContentMode = .scaleAspectFit) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                    
                else { return }
            //FIXIT: загрузка фоток после пропажи скелетона
            DispatchQueue.main.async() { [weak self] in
                self?.image = image
            }
        }.resume()
    }
    func downloaded(from link: String, contentMode mode: ContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        downloaded(from: url, contentMode: mode)
    }
}

extension UIImage {
  func resizeImage(targetSize: CGSize) -> UIImage {
    let size = self.size
    let widthRatio  = targetSize.width  / size.width
    let heightRatio = targetSize.height / size.height
    let newSize = widthRatio > heightRatio ?  CGSize(width: size.width * heightRatio, height: size.height * heightRatio) : CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
    let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)

    UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
    self.draw(in: rect)
    let newImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()

    return newImage!
  }
    
    
    func withInset(_ insets: UIEdgeInsets) -> UIImage? {
            let cgSize = CGSize(width: self.size.width + insets.left * self.scale + insets.right * self.scale,
                                height: self.size.height + insets.top * self.scale + insets.bottom * self.scale)

            UIGraphicsBeginImageContextWithOptions(cgSize, false, self.scale)
            defer { UIGraphicsEndImageContext() }

            let origin = CGPoint(x: insets.left * self.scale, y: insets.top * self.scale)
            self.draw(at: origin)

            return UIGraphicsGetImageFromCurrentImageContext()?.withRenderingMode(self.renderingMode)
        }
    
}
