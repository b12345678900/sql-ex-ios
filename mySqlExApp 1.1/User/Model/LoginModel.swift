//
//  LoginModel.swift
//  mySqlExApp 1.1
//
//  Created by imac on 24/03/2019.
//  Copyright © 2019 imac. All rights reserved.
//

import UIKit
enum loginResult
{
    case error
    case complete(Bool)
}
class LoginModel{
    var login :String?
    var password:String?
    static let shared:LoginModel=LoginModel()
    func setUserData(login:String,password:String)
    {
        self.login=login
        self.password=password
    }
    func Login(currentUrl:String?,completionHandler: @escaping (loginResult) -> ())
    {
        var url:String=""
        if let currentUrl=currentUrl
        {
            url=currentUrl
        }
        else
        {
            url="https://www.sql-ex.ru/index.php"
        }
        let params:[String:String]=["login":self.login!,"psw":self.password!]
        NetworkService.shared.getData(url: url, params:params){
            (res) in
            switch res{
            case .error:completionHandler(loginResult.error)
            case .success(let htmlcontent):
                if(!htmlcontent.contains("frmlogin"))
                {
                    //UserInfo.saveUserData(login: login, password:password)
                }
                completionHandler(loginResult.complete(!htmlcontent.contains("frmlogin")))
            }
            
            
            
        }
        
    }
 
}
