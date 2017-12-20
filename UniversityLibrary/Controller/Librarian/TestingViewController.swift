//
//  TestingViewController.swift
//  UniversityLibrary
//
//  Created by student on 12/9/17.
//  Copyright © 2017 Huy Vo. All rights reserved.
//

import UIKit

class TestingViewController: BaseViewController {
    
    @IBOutlet weak var switchLabel: GeneralUILabel!
    @IBOutlet weak var testingSwitch: UISwitch!
    @IBOutlet weak var datePicker: UIDatePicker!
   

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.setToolbarHidden(true, animated: false)
        
 datePicker.addTarget(self, action: #selector(dateChanged(_:)), for: .valueChanged)
        
        if !Mock.isMockMode{
            self.testingSwitch.isOn = false
            self.switchLabel.text = "Testing Mode: Off"
        }else{
            self.testingSwitch.isOn = true
            
            self.switchLabel.text = "Testing Mode: On"
        }
        
  //      self.sender.isOn = false
        // Do any additional setup after loading the view.
    
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
        
     
    }
    


    func dateChanged(_ sender: UIDatePicker){
        
        if self.testingSwitch.isOn{
        
            Mock.mockDate = sender.date
        
            let date = DateHelper.getLocalDate(dt: Mock.mockDate.timeIntervalSince1970)
        
            print(date)
        
            print(DateHelper.getLocalTime(dt: Mock.mockDate.timeIntervalSince1970))
        }
        
        
    }
    
    @IBAction func toggleMode(_ sender: UISwitch) {
        if sender.isOn{
            switchLabel.text = "Testing Mode: On"
            
        }else{
            switchLabel.text = "Testing Mode: Off"
        }
    }
 
    @IBAction func notifyUsers(_ sender: Any) {
        self.notifyUsersOfDueDate()
    }
    
    func notifyUsersOfDueDate(){
        DispatchQueue.global().async {
            
            DataService.shared.sendAlertReminder(completion: {success in
                if success {
                    
                    DispatchQueue.main.async { 
                        self.alertMessage(title: "Success", message: "Notified all users success")
                    }
                }else{
                    
                }
            })
        }
    }
 

}
