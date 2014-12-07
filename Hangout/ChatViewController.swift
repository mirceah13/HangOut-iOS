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
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let url = NSURL(string: "http://rshankar.com/swift-webview-demo/")
        let request = NSURLRequest(URL: url!)
        webView?.loadRequest(request)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
