//
//  ViewController.swift
//  mySqlExApp 1.1
//
//  Created by imac on 23/03/2019.
//  Copyright © 2019 imac. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let userData=["login":"b12345","psw":"79161418656"]
        NetworkService.shared.getData(url: "http://www.sql-ex.ru",params:userData){(htmlContent)in
            print (htmlContent)
    }


}

}
