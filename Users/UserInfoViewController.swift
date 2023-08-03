//
//  UserInfoViewController.swift
//  Users
//
//  Created by Edgar Sargsyan on 21.07.23.
//

import UIKit

class UserInfoViewController: UIViewController {

    @IBOutlet weak var labelUserinfo: UILabel!
    var testResult = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        

        
        labelUserinfo.text = testResult
       }
   }





