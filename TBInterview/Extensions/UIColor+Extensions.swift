//
//  UIColor+Extensions.swift
//  TBInterview
//
//  Created by Zachary Rhodes on 5/25/21.
//

import Foundation
import UIKit

extension UIColor {
    static let bajaBlast = UIColor(named: "bajaBlast")!
    static let radical = UIColor(named: "radical")!
    static let zircon = UIColor(named: "Zircon")!
    static let storm = UIColor(named: "Storm")!
}


///current month date extension
extension Date {
    func month() -> String {
        let dateFormat = DateFormatter()
        dateFormat.setLocalizedDateFormatFromTemplate("MMMM")
        return dateFormat.string(from: self)
    }
}
