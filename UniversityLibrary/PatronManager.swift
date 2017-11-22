//
//  PatronManager.swift
//  UniversityLibrary
//
//  Created by Huy Vo on 11/19/17.
//  Copyright © 2017 Huy Vo. All rights reserved.
//

import Foundation

// MARK - Kevin
class PatronManager: BookKeeper, WaitingListDelegate{
    
    let patorn: Patron
    init(patorn: Patron ){
        self.patorn = patorn
    }
    
    func doReturn(book: Book){
        
    }
    func checkout(book: Book) {
        
        let checkout = CheckoutList(patron: self.patorn, book: book)
        let event = CheckoutListEvent(checkoutList: checkout, action: .add)
        event.delegate = self 
    }
    
    func waiting(book: Book) {
        let waitingList = WaitingList(book: book, patron: self.patorn)
        
        let event = WaitingListEvent(waitingList: waitingList, action: .add)
        event.delegate = self
 
    }
    
    
    
    func complete(event: AbstractEvent) {
        switch event {
        case let event as CheckoutListEvent:
            if event.state == .full{
                
                let book = event.checkoutList.book
                self.waiting(book: book)
            }
            
        default:
            print("No action")
        }
    }
    
    
    func error(event: AbstractEvent) {
        
    }
}

