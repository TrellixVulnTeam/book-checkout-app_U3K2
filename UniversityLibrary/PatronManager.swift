//
//  PatronManager.swift
//  UniversityLibrary
//
//  Created by Huy Vo on 11/19/17.
//  Copyright © 2017 Huy Vo. All rights reserved.
//

import Foundation

// MARK - Kevin
class PatronManager: BookKeeper, AbstractEventDelegate{
    
    let patorn: Patron
    init(patorn: Patron ){
        self.patorn = patorn
    }
    
    func doReturn(book: Book){
        let event = ReturnBookEvent(patron: self.patorn, book: book)
        event.delegate = self 
        
    }
    
    func doReturn(books: [Book]){
        if books.count > 9{
            return
        }
        
        let queue = DispatchQueue(label: "com.huyvo.cmpe277.returnbooks")
        queue.async {
            for book in books{
                self.doReturn(book: book)
            }
        }
        
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

