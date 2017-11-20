//
//  PatronManager.swift
//  UniversityLibrary
//
//  Created by Huy Vo on 11/19/17.
//  Copyright © 2017 Huy Vo. All rights reserved.
//

import Foundation

class PatronManager: BookKeeper, WaitingListDelegate{
    
    let patorn: Patron
    init(patorn: Patron ){
        self.patorn = patorn
    }
    
    func checkout(book: Book) {
        
    }
    
    func waiting(book: Book) {
        let waitingList = WaitingList(book: book, patron: self.patorn)
        
        let event = WaitingListEvent(waitingList: waitingList, action: .add)
        event.delegate = self
 
    }
    
    func complete(event: AbstractEvent) {
        
    }
    
    
    func error(event: AbstractEvent) {
        
    }
}

