//
//  LoginViewController.swift
//  mySqlExApp 1.1
//
//  Created by imac on 24/03/2019.
//  Copyright © 2019 imac. All rights reserved.
//

import UIKit
import CoreData
class LoginViewController: UIViewController {

    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var login: UITextField!
    var context: NSManagedObjectContext!
    
    @IBAction func loginAction() {
        
        guard let login=login.text else {return}
         guard let password=password.text else {return}
        LoginModel.shared.setUserData(login: login, password: password)
        LoginModel.shared.Login(currentUrl: nil) {
            (res) in
            switch res{
            case .error:
                DispatchQueue.main.async {
                let c=UIAlertController(title:"Ошибка", message: "Нет сети", preferredStyle: .alert)
                let okAction=UIAlertAction(title: "Ok", style: .default, handler: nil)
                c.addAction(okAction)
                self.present(c, animated: true, completion: nil)
                }
            case .complete(let result):
                
                if result {
                    UserInfo.saveUserData(login: login, password:password,context: self.context)
                    DispatchQueue.main.async {
                    self.performSegue(withIdentifier: "unwindFromLoginScreen", sender: nil)
                    }
                    }
            }
            
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

    
}
