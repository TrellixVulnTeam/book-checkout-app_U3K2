
//
//  CheckoutListEvent.swift
//  UniversityLibrary
//
//  Created by Huy Vo on 11/19/17.
//  Copyright © 2017 Huy Vo. All rights reserved.
//
import Foundation
import Firebase

class CheckoutListEvent: AbstractEvent{
    
    let checkoutList: CheckoutList
         var state: CheckoutState?
    
    weak var delegate: AbstractEventDelegate? {
        didSet{
            self.async_ProcessEvent()
        }
    }
    
    init(checkoutList: CheckoutList ) {
        self.checkoutList = checkoutList
         
    }
    
    func async_ProcessEvent() {
        guard let delegate = self.delegate else{
            return
        }
        
        let queue = DispatchQueue(label: "com.huyvo.cmpe277.checkoutlistevent")
        queue.async {
           
            if self.checkoutList.patron.canCheckoutBook{
                self.addToList(delegate: delegate, checkoutList: self.checkoutList)
            }else{
                // cannot checkout
                
                self.state = .error
                
                delegate.error(event: self)
            }
        }
        
    }
    
    // add user to list
    private func addToList(delegate: AbstractEventDelegate, checkoutList: CheckoutList){
        let db = FirebaseManager().reference.child(DatabaseInfo.checkedOutListTable)
        
        
        db.child(self.checkoutList.book.key).observeSingleEvent(of: .value, with: {(snapshot) in
            
            if var value = snapshot.value as? [String: Any]{
                if let numberOfCopies = value["numberOfCopies"] as? Int{
                    
                    if var users = value["users"] as? Dictionary<String, Any>{
                        
                        if users[self.checkoutList.patron.id!] != nil{
                            self.state = .contain
                            delegate.complete(event: self)
                            
                        }
                        else if users.count == numberOfCopies{
                            self.state = .full
                            delegate.complete(event: self)
                            
                        }else{
                            
                           
                            let checkoutInfo = CheckoutBookInfo(patron: self.checkoutList.patron)
                            
                            users[self.checkoutList.patron.id!] = checkoutInfo.dict
                            
                            value["users"] = users
                            db.child(self.checkoutList.book.key).updateChildValues(value)
                          
                            self.state = .success
                            delegate.complete(event: self)
                            
                            
                            /*
                            DataService.shared.confirmCheckout(email: checkoutInfo.patron.email!,
                                                               transactionTime: checkoutInfo.transactionDate,
                                                               dueDate: checkoutInfo.transactionDate, completion: {success in
                                        
                                                                if success {
                                                             
                                                                }
                                                                
                                                                
                            })*/
                            
                            
                        }
                    }else{
                        
                        let checkoutInfo = CheckoutBookInfo(patron: self.checkoutList.patron)
                        
                        let user = checkoutInfo.dict
                        
                        value["users"] = [self.checkoutList.patron.id! : user]
                        
                        db.child(checkoutList.book.key).updateChildValues(value)
                        
                        
                        self.state = .success
                        delegate.complete(event: self)
                        
                        /*
                        DataService.shared.confirmCheckout(email: checkoutInfo.patron.email!,
                                                           transactionTime: checkoutInfo.transactionDate,
                                                           dueDate: checkoutInfo.transactionDate, completion: {success in
                                                            
                                                            if success{
                                                                
                                                            }
                                                      
                                                            
                        })*/
                        
                        
                    }
                    
                }
            }
            
        })
        
        
        
    }
    
    
    
    // remove user from list
    private func deleteFromList(delegate: AbstractEventDelegate, checkoutList: CheckoutList){
        let db = FirebaseManager().reference.child(DatabaseInfo.checkedOutListTable)
        
        db.child(checkoutList.book.key).observe(.value, with: {(snapshot) in
            
            if var value = snapshot.value as? [String: Any]{
                // if list is empty, we know user isn't in the list
                if let isEmpty = value["isEmpty"] as? Bool{
                    
                    if isEmpty{
                        
                    }else{
                        
                        if var users = value["users"] as? [String]{
                            
                            if let index = users.index(of: checkoutList.patron.id!){
                                users.remove(at: index)
                                if users.isEmpty{
                                    db.child(checkoutList.book.key).updateChildValues(["isEmpty": true])
                                }
                                db.child(checkoutList.book.key).updateChildValues(["users": users])
                            }
                            
                        }
                    }
                }
            }
            
            db.child(checkoutList.book.key).removeAllObservers()
        })
        
    }
}

protocol CheckoutListDelegate: AbstractEventDelegate {}

enum CheckoutAction{
    case add
    case delete
}

enum CheckoutState{
    case full
    case error
    case success
    case contain
}
