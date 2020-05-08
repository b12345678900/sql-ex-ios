//
//  StartViewController.swift
//  mySqlExApp 1.1
//
//  Created by imac on 24/03/2019.
//  Copyright © 2019 imac. All rights reserved.
//

import UIKit
import CoreData
struct  Level
    {
    let address:LevelsAdress
    let name:String
}
enum LevelsAdress: String
{
    case learn="https://www.sql-ex.ru/learn_exercises.php"
    
    
    case rating="https://www.sql-ex.ru/exercises.php"
    case dml="https://www.sql-ex.ru/dmlexercises.php"
}
class StartViewController: UIViewController {
    var context: NSManagedObjectContext!
    var password:String?
    var login:String?
    var level:Level!
    
    @IBOutlet weak var cleanBut: UIButton!
    @IBAction func clean(_ sender: Any) {
        let cookieStore = HTTPCookieStorage.shared
        for cookie in cookieStore.cookies ?? [] {
            cookieStore.deleteCookie(cookie)
        }
    }
    
    @IBAction func goToExList(_ sender: UIButton) {
        
        switch (sender.tag)
        {
        case 0:
            level = Level(address: .learn, name: sender.titleLabel!.text!)
        
            
        case 2:
           level = Level(address: .rating, name: sender.titleLabel!.text!)
            
        case 3:
            level = Level(address: .dml, name: sender.titleLabel!.text!)
          
        default:
            level = Level(address: .learn, name: sender.titleLabel!.text!)
        }
        performSegue(withIdentifier:"exSegue" , sender: nil)
    }
    
    @IBOutlet weak var levelStack: UIStackView!
    
    @IBOutlet weak var learnLevel: UIButton!
    
    @IBOutlet weak var learnLevelWithSelectSubd: UIButton!
    
    @IBOutlet weak var ratingLevel: UIButton!
    
    @IBOutlet weak var DML: UIButton!
    @IBAction func unwindSegue(segue:UIStoryboardSegue)
    {
        guard let svc = segue.source as? LoginViewController else { return }
        
        DispatchQueue.main.async {
            self.login = svc.login.text!
            self.password = svc.password.text!
            self.levelStack.isHidden=false
        }
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let dvc = segue.destination as? LoginViewController
        {
            dvc.context = self.context
        }
        else if let dvc = segue.destination as? ExerciceListController
        {
            dvc.level = level!
        }
            
            else { return }
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        levelStack.isHidden=true
         self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        cleanBut.isHidden=true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        
        if (login==nil)
        {
            
            if let user=UserInfo.LoadUserData(context: context)
            {
                login=user.login
                password=user.password
                
                LoginModel.shared.setUserData(login:login!, password:password!)
                LoginModel.shared.Login(currentUrl: nil, completionHandler: completionHandlerForLogin)
                
                
            }
            else
                {
                performSegue(withIdentifier: "loginSeg", sender: nil)
            }
        }
        else
        {
            
            levelStack.isHidden=false
        }
        
    }
    
      func completionHandlerForLogin  (res:loginResult)
    {
        switch res{
        case .error:
            DispatchQueue.main.async {
                let c=UIAlertController(title:"Ошибка", message: "Нет сети", preferredStyle: .alert)
                let okAction=UIAlertAction(title: "Повторить", style: .default) {
                    (c)in
                    LoginModel.shared.Login(currentUrl: nil, completionHandler: self.completionHandlerForLogin)
                }
                c.addAction(okAction)
                self.present(c, animated: true, completion: nil)
            }
        case .complete(let result):
            
            if result {
                
                DispatchQueue.main.async {
                    changeLanguage(lang: .RU){
                         () in
                        DispatchQueue.main.async {
                        self.levelStack.isHidden=false
                        }
                    }
                    
                }
            }
            else
            {
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: "loginSeg", sender: nil)
                }
            }
        }
    }
    
    
    
    
}
