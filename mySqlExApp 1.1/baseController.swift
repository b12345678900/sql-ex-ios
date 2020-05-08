//
//  reLoginProtocol.swift
//  mySqlExApp1.1copy
//
//  Created by imac on 24/05/2019.
//  Copyright © 2019 imac. All rights reserved.
//

import UIKit

class baseController:UIViewController
{
    var standarModel:StandartModel?
    var reloginSuccessHandler:()->()={}
    var level:Level!
    var url:String!
    
    func relogin (completionHandler:@escaping ()->())
    {
        
        LoginModel.shared.Login(currentUrl: self.url){
            (res) in
            self.reloginSuccessHandler=completionHandler
            self.completionHandlerforRelogin(res: res)
        }
    }
  
    func completionHandlerforRelogin(res:loginResult)->()
    {
        switch res{
        case .error:
            DispatchQueue.main.async {
                let c=UIAlertController(title:"Ошибка", message: "Нет сети", preferredStyle: .alert)
                let okAction=UIAlertAction(title: "Повторить", style: .default) {
                    (c)in
                    LoginModel.shared.Login(currentUrl: self.url,completionHandler: self.completionHandlerforRelogin)
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
                reloginSuccessHandler()
            }
            
        }
    }

    }



