//
//  Json.swift
//  UniversityLibrary
//
//  Created by Huy Vo on 11/28/17.
//  Copyright © 2017 Huy Vo. All rights reserved.
//

import Foundation


struct CheckoutBookInfo{
    
    let patron: Patron
    
    init(patron: Patron){
        self.patron = patron
    }
    
    
    var transactionDate: String{
        
        get{
            let now = Date()
            return DateHelper.getLocalDate(dt: now.timeIntervalSince1970)
        }
        
    }
    
    var dueDate: String{
        get{
            let dueDate = Date().thirtyDaysfromNow
            return DateHelper.getLocalDate(dt: dueDate.timeIntervalSince1970)
        }
    }
    
    var dict: [String: Any]{
        get{
            var user = [String: Any]()
            user["dueDate"] = Date().thirtyDaysfromNow.timeIntervalSince1970
            user["transactionDate"] = Date().thirtyDaysfromNow.timeIntervalSince1970
            user["email"] = self.patron.email!
            user["id"] = self.patron.id!
            
            let transaction = Date().timeIntervalSince1970
            
            
            user["dueDateInfo"] = dueDate
            
            user["transactionDateInfo"] = transactionDate
        
            return user
        }
    }
    
}

struct ReturnBookInfo{
    var nameOfBook: String
    var fineAmount: Int
    
    init(nameOfBook: String, fineAmount: Int){
        self.nameOfBook = nameOfBook
        self.fineAmount = fineAmount
        
    }
    
    func convertToJsonString()->String{
        return "{\"nameOfBook\":\"\(self.nameOfBook)\",\"fineAmount\":\"\(self.fineAmount)\"}"
    }
    
    static func convertToArrayString(books: [ReturnBookInfo]) -> String{
        
        if books.count == 1{
            return "[" + books[0].convertToJsonString() + "]"
        }
        
        var msg = "["
        
        for i in 0..<books.count-1{
            msg += books[i].convertToJsonString() + ","

        }
        
        msg += books[books.count-1].convertToJsonString()+"]"
        
        return msg
    }
}




