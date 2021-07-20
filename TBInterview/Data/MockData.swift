//
//  MockData.swift
//  TBInterview
//
//  Created by Zachary Rhodes on 5/25/21.
//

import Foundation

enum MockData {
    
    
    static func randomExpenseData() -> [expenseData] {
        let fileName = ["expenses1", "expenses2", "expenses3"].randomElement()
        return parseData(data: readJSONData(fromFile: fileName!))
    }
    
    
    
    static private func parseData(data:Data) -> [expenseData] {
        let decodedResponse = try! JSONDecoder().decode([expenseData].self, from: data)
        return decodedResponse
    }
    
    
    static private func readJSONData(fromFile filename: String) -> Data {
        guard let filePath = Bundle.main.url(forResource: filename,
                                             withExtension: "json"),
              let data = NSData(contentsOf: filePath) else {
            return Data()
        }
        return data as Data
    }
    
    
}
