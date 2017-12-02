//
//  User.swift
//  UniversityLibrary
//
//  Created by Huy Vo on 11/14/17.
//  Copyright © 2017 Huy Vo. All rights reserved.
//

import Foundation

class User: UniModel{
    var email: String!
    var password: String!
    var universityId: Int?
    
    // for sign in
    convenience init(email: String, password: String){
        self.init(email: email, password: password, universityId: nil)
    }
    
    init(dict: [String: Any]){
        super.init()
        
        if let email = dict["email"] as? String{
            self.email = email
        }
        if let id = dict["id"] as? String{
            
            self.id = id
        }
        
        if let password = dict["password"] as? String{
            self.password = password
        }
        if let universityId = dict["universityId"] as? Int{
            self.universityId = universityId
        }
        
    }
    
    // for sign out
    init(email: String, password: String, universityId: Int?) {
        self.email = email
        self.password = password
        self.universityId = universityId
        
    }
    
    var emailKey: String{
        get{
            return self.email.replacingOccurrences(of: ".", with: "+", options: .literal, range: nil)
        }
    }
    
    var dictEmail: [String: String]{
        get{
            return ["email": email]
        }
    }
    
    var dictUniId:[String: Int?]{
        get{
            return ["universityId": universityId]
        }
        
    }
    
    // used for firebase 
    override var dict:[String: Any] {
        get{
            var dict = super.dict
             
            dict["email"] = email
            dict["password"] = password
            dict["universityId"] = universityId
            
            return dict
        }
    }
    
}

class Librarian: User{
    
}

class Patron: User{
    let today = Date()
    var numberOfBooksCheckoutToday = 0
    var totalNumberOfBooksCheckout = 0
    // contains id to books
    var booksCheckedOut: [String]?
    // contains id to books
    var booksOnWaitingList: [String]?
     
    //The total number of books a patron can keep at any given time cannot exceed 9.
    static let MAX_BOOKS = 9
    //var booksChecked = [Book]()
    
    
    override init(email: String, password: String, universityId: Int?) {

        super.init(email: email, password: email, universityId: universityId)
    }
    
    
    convenience init(email: String, password: String) {
       
        self.init(email: email, password: password, universityId: nil)
    }
    
   
    override init(dict: [String: Any]){
        super.init(dict: dict)

        if let totalNumberOfBooksCheckout = dict["totalNumberOfBooksCheckout"] as? Int{
            self.totalNumberOfBooksCheckout = totalNumberOfBooksCheckout
        }
    }
    
    /*
    required init(from decoder: Decoder) throws {
      
    }*/
    
    var checkoutDict: [String: Any]{
        get{
            var user = [String: Any]()
            user["dueDate"] = Date().thirtyDaysfromNow.timeIntervalSince1970
            user["email"] = email
            user["id"] = id
            
            return user
        }
    }
    
  
    
    var canCheckoutBook: Bool{
        get{
            if numberOfBooksCheckoutToday < 3{
                numberOfBooksCheckoutToday += 1
                return true
            }else{
                return false
            }
        }
    }
 
    override var dict: [String : Any]{
        get{
            var pDict = super.dict
            
            pDict["totalNumberOfBooksCheckout"] = 0
            return pDict
        }
    }
    
    // A patron must be able to check out up to 3 books in any day.
    func numberOfBookCheckedOut(on date: Date) -> Int{
        
        return -1 
    }
}
