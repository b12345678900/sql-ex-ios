//
//  StandartModel.swift
//  mySqlExApp 1.1
//
//  Created by imac on 30/03/2019.
//  Copyright © 2019 imac. All rights reserved.
//

import UIKit
import SwiftSoup

enum standartModelResult
{
    case error
    case login
    case success
  
}
class StandartModel {
private let url:String
    var htmlContent:String
    
    init (url:String)
    {
        self.url=url
        htmlContent=""
    }
    func loadData(url:String?=nil,params:[String:Any]?=nil,completionHandler: @escaping (standartModelResult) -> ())
    {
        NetworkService.shared.getData(url: url ?? self.url, params: params)
        { (res) in
            
                
                switch res
                {
                case .error:
                    completionHandler(standartModelResult.error)
                    
                case .success(let res):
                    self.htmlContent=res
                    if (!self.htmlContent.contains("frmlogin") && !self.htmlContent.contains("form login"))
                    {
                    completionHandler(standartModelResult.success)
                    }
                    else
                    {
                        completionHandler(standartModelResult.login)
                    }
                    
                }
            
            
            
        }
    }

    
}
