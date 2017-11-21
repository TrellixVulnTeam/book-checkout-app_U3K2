//
//  DataService.swift
//  UniversityLibrary
//
//  Created by Huy Vo on 11/17/17.
//  Copyright © 2017 Huy Vo. All rights reserved.
//

import Foundation
import Firebase

class DataService{
    let BASE_URL = "https://us-central1-universitylibrary-8e17c.cloudfunctions.net/"
    
    private init(){}
    
    static let shared = DataService()
    
    func sendEmail(email: String, message: String, subject: String ){
        
        let url = "https://us-central1-universitylibrary-8e17c.cloudfunctions.net/sendGeneralEmail?email=\(email)&text=\(message)&subject=\(subject)"
        
        Logger.log(clzz: "DataService", message:"url: \(url)")
        
        let requestURL = URL(string: url)
        
        if let theRequestURL = requestURL{
            let urlRequest = URLRequest(url: theRequestURL)
            
            let session = URLSession.shared
            
            let task = session.dataTask(with: urlRequest){
                (data, response, error) -> Void in
                
                if let httpResponse = response as? HTTPURLResponse{
                    // request has been successful
                    
                    if httpResponse.statusCode == 200 {
                        
                        if let data = data{
                            
                            print(String(data: data, encoding: .utf8))
                        }
                    }
                }
            }
            
            task.resume()
            
        }
    }
    
   
  
}
