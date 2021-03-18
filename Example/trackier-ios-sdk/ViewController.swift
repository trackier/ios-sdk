//
//  ViewController.swift
//  trackier-ios-sdk
//
//  Created by prak24oct on 03/18/2021.
//  Copyright (c) 2021 prak24oct. All rights reserved.
//

import UIKit
import trackier_ios_sdk

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
      let replaceMe = ReplaceMe()
        replaceMe.getData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

