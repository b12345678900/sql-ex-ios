//
//  ExerciseTabBarController.swift
//  mySqlExApp 1.1
//
//  Created by imac on 01/04/2019.
//  Copyright © 2019 imac. All rights reserved.
//

import UIKit
/*protocol notifeChildControllers {
    func setData(data:[String:String],level:Level,number:String,help:[String])->()

}*/


class ExerciseTabBarController: UITabBarController {
    var number:String=""
    var level: Level!
    var model :ExerciseModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        model=ExerciseModel(number: number,level: level)
        model.loadData (completionHandler: completionHandler)
      title="Задача " + number+", " + level.name
        
    }
    
    override func viewDidLayoutSubviews()
    {
        tabBar.frame = CGRect(x: 0, y: 80, width:UIScreen.main.bounds.width, height:40)
        
    }
    
    func completionHandler (res:standartModelResult)
    {
        switch res
        {
        case standartModelResult.success:
            
            for vc in self.viewControllers!
            {
                
                let vc = vc as! notifeChildControllers
                let data=model.getData()
                dataPassing.code=data["user_solution"]!
                
                //vc.setData(data: data,level: level,number: number,help: model!.help, index: <#Int#>)
                
            }
            
        case standartModelResult.error:
            repeateRequestData(model: self.model!, controller: self, completionHandler: self.completionHandler)
            
        case standartModelResult.login:
            LoginModel.shared.Login(currentUrl: nil,completionHandler: completionHandlerforRelogin)
    }
    }
    func completionHandlerforRelogin(res:loginResult)
    {
        
            switch res{
            case .error:
                DispatchQueue.main.async {
                    let c=UIAlertController(title:"Ошибка", message: "Нет сети", preferredStyle: .alert)
                    let okAction=UIAlertAction(title: "Повторить", style: .default) {
                        (c)in
                        LoginModel.shared.Login(currentUrl: nil,completionHandler: self.completionHandlerforRelogin)
                    }
                    c.addAction(okAction)
                    self.present(c, animated: true, completion: nil)
                }
            case .complete(let result):
                
                if result {
                    
                    DispatchQueue.main.async {
                        changeLanguage(lang: .RU){
                            () in
                            
                        }
                        
                    }
                    self.model.loadData (completionHandler: self.completionHandler)
                }
                
            }
        }
        
        
    
   

}
