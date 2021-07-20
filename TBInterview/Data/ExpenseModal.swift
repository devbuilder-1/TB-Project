//
//  ExpenseModal.swift
//  TBInterview
//
//  Created by Prithiv Dev on 17/07/21.
//

import Foundation

struct expenseData :Decodable {
    var title = String()
    var category : String?
    var amount = Float()
}
