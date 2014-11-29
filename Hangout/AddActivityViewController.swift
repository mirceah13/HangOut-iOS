//
//  AddActivityViewController.swift
//  Hangout
//
//  Created by Recognos on 09/11/14.
//  Copyright (c) 2014 RECOGNOS ROMANIA. All rights reserved.
//

import UIKit

class AddActivityViewController: UIViewController {

    var categArr:[String] = []
    
    var name: AnyObject? {
        get {
            return NSUserDefaults.standardUserDefaults().objectForKey("name")
        }
        set {
            NSUserDefaults.standardUserDefaults().setObject(newValue, forKey: "name")
            NSUserDefaults.standardUserDefaults().synchronize()
        }
    }

    @IBOutlet var txtName: UITextField!
    @IBOutlet var txtDescription: UITextField!
    
    @IBAction func btnAddTask(sender: UIButton){
        var name: String = txtName.text
        var description: String = txtDescription.text
        //actManager.addActivity(name, desc: description)
        txtName.text = ""
        txtDescription.text = ""
        
        self.view.endEditing(true)
        
        navigationController?.presentingViewController?.dismissViewControllerAnimated(true, completion: {})
    }
    
    @IBAction func btnCancel(){
        navigationController?.presentingViewController?.dismissViewControllerAnimated(true, completion: {})
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        categArr = ["ballGames.jpg", "indoor.jpg", "social.jpg", "outdoor.jpg", "water.jpg", "mountain.jpg"]

        navigationItem.title = "Add new"
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(textField: UITextField!) -> Bool {
        
        textField.resignFirstResponder()
        return true
    }
    
}
