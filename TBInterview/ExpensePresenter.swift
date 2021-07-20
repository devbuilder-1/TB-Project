//
//  ExpensePresenter.swift
//  TBInterview
//
//  Created by Prithiv Dev on 17/07/21.
//

import Foundation
import Combine
import UIKit



class ExpensePresenter {
    //MARK: - Interactor, timer etc. - Initialization
    let interactor = ExpenseInteractor(api: API())
    var timerCancellable: AnyCancellable?
    var expenseData: AnyPublisher<[expenseData], Error> {
        return expenseDataSubject.eraseToAnyPublisher()
    }
    private var expenseDataSubject = PassthroughSubject<[expenseData], Error>()
        
    
    //MARK: - Init funcs
    ///init the receiver
    init() {
        scheduleExpenseDataPublisherValues()
    }
    ///get the data from the API for the view to reieve
    private func scheduleExpenseDataPublisherValues() {
        timerCancellable =  self.interactor.api.expenseData.sink(receiveCompletion: {_ in}, receiveValue: {
            value in
            self.expenseDataSubject.send(value)
        })
    }
    
    
    
    //MARK: - UI Logic functions
    ///get the monthly budget
    ///returns in this order : Total Amount, Color of total amount text, animation bool depending on total spent and category with emoji
    func getBudgetColorAndAmount(data: [expenseData], completionHandler : @escaping (String, UIColor, Bool, String) -> Void)  {
    
        let totalAmount = data.compactMap({$0.amount}).reduce(0, +)
        var monthlyBudget = Float()
        var color = UIColor()
        var animation = Bool()
        let category = mostSpentCategory(data: data)
        self.interactor.api.fetchMonthlyBudget(completion: { value in
            ///set the monthly budget, find out the color
            monthlyBudget = value
            color = totalAmount >= monthlyBudget ? UIColor.radical : UIColor.bajaBlast
            animation = totalAmount >= monthlyBudget ? false : true
            
            print("Monthly Budget:\(monthlyBudget)")
            print("Total Amount:\(totalAmount)")

            completionHandler ("$" + String(totalAmount), color, animation, category)
        })
    }
    
    
    
    ///this function returns the current month
    func month() -> String {
        return Date().month()
    }
    
    
    
    ///get the most spent category
    func mostSpentCategory(data:[expenseData]) -> String {
        let emoji = (giveEmojiForCategory(category: data.sorted(by: {$0.amount > $1.amount}).first?.category ?? ""))
        let categoryString = (getCategoryString(category: data.sorted(by: {$0.amount > $1.amount}).first?.category ?? ""))
        return categoryString + " " + emoji
    }
    
    
    
    ///get thr string for category
     func getCategoryString(category:String) -> String {
        switch category {
        case "travel":
            return "Travel"
        case "software":
            return "Software"
        case "food":
            return "Food"
        default:
           return ""
        }
    }
    
    ///get emoji for given category
    private func giveEmojiForCategory(category:String) -> String {
        switch category {
        case "travel":
            return "✈️"
        case "software":
            return "💻"
        case "food":
            return "🍕"
        default:
           return ""
        }
    }
    
    
    
    
    
}
