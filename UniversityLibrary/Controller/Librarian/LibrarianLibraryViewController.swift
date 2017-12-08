//
//  LibrarianLibraryViewController.swift
//  UniversityLibrary
//
//  Created by Huy Vo on 11/27/17.
//  Copyright © 2017 Huy Vo. All rights reserved.
//

import UIKit

class LibrarianLibraryViewController: BaseViewController, BookManager, BookCRUDDelegate {
    
    var librarian: Librarian?
 
    @IBAction func logout(_ sender: UIBarButtonItem) {
       // super.logout()
        
        let event = SignoutUserEvent()
        event.delegate = self
        
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let root = mainStoryboard.instantiateViewController(withIdentifier: "NavRootViewController") as! NavRootViewController
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = root
        
        
    }
    
    @IBAction func goToAddBooksVC(_ sender: MenuUIButton) {
        
        self.goToAddBooksView()
    }
    
    
    func goToAddBooksView(){
        if let vc  = self.storyboard?.instantiateViewController(withIdentifier: "AddBookViewController") as? AddBookViewController{
            
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction func goToSearchBooks(_ sender: MenuUIButton) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
         
        self.title = "Library"
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
        
    }
    func search(exact book: Book) {
       
        
    }
    
    func search(by book: Book) {
        
        
    }
    
    func add(with book: Book) {
       
    }
    
    
    func update( book: Book) {
 
    }
    
    func delete(book: Book) {
  
    }
    
    func complete(event: AbstractEvent) {
        
        
        
    }
    
    func error(event: AbstractEvent) {
        
    }
    
    func result(exact book: Book){
       
    }

}
