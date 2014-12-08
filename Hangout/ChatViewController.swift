//
//  ChatViewController.swift
//  Hangout
//
//  Created by Recognos on 07/12/14.
//  Copyright (c) 2014 RECOGNOS ROMANIA. All rights reserved.
//

import UIKit

class ChatViewController: UIViewController {

    @IBOutlet var webView: UIWebView?
    
    var activityId:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let url = NSURL(string: "http://h-hang-out.azurewebsites.net/#!/activity/comments/\(self.activityId)")
        let request = NSURLRequest(URL: url!)
        webView?.loadRequest(request)

        // Do any additional setup after loading the view.
    }
    
    override func shouldAutorotate() -> Bool {
        return false
    }
    
    override func supportedInterfaceOrientations() -> Int {
        return UIInterfaceOrientation.Portrait.rawValue
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
