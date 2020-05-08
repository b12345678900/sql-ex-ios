//
//  ResultModel.swift
//  mySqlExApp1.1copy
//
//  Created by imac on 10/04/2019.
//  Copyright © 2019 imac. All rights reserved.
//

import Foundation
import SwiftSoup
class RunModel:StandartModel
{
    let level:Level
    let number:String
    
     static var currentSubd:String = "mssql"
    
    init(level:Level,number:String)
    {
        self.level=level
        self.number=number
       print(RunModel.currentSubd)
        super.init(url: level.address.rawValue)
        
    }
     func Run(completionHandler: @escaping (standartModelResult) -> ()) {
        if (RunModel.currentSubd=="mssql")
       {
       
        super.loadData(params: ["txtsql":dataPassing.code,"checkMe":number,"CHB":1], completionHandler: completionHandler)
        }
        else
       {
        //
        super.loadData(url: "https://www.sql-ex.ru/exercises/index.php?act=check", params: ["query":dataPassing.code,"num":number,"check":false], completionHandler: completionHandler)
        }
    }
    func parseAnswer ()
    {
       print (htmlContent)
        let hint:String = (matches(for: "(?<=var text = ')[\\s\\S]+?(?=')", in: htmlContent))[0]
        
        var result = matches(for: "<a name=('|\")answer_ref('|\")></a>[\\s\\S]*?<div style=\"float:left\">|Execution time[\\s\\S]*?<div style=\"float:left\"", in: htmlContent)
        if result.count==0
        {
          result = matches(for: "<TABLE border=\"0\" cellpadding=\"5\" align=\"center\">[\\s\\S]+style=\"float:left\">", in: htmlContent)
        }
        if result.count==0
        {
            result = matches(for: "<div style=\"height:350px;overflow: auto;\"><a name=\"answer_ref\">[\\s\\S]+?</div>", in: htmlContent)
        }
        htmlContent=hint+result[0]
        
        
        
        print (htmlContent)
    }
    func RunWithoutCheck(completionHandler: @escaping (standartModelResult) -> ())
    {
        if (RunModel.currentSubd=="mssql"){
        super.loadData(params: ["txtsql":dataPassing.code,"checkMe":number,"CHB":1,"wo":1], completionHandler: completionHandler)
        }
        else
        {
            super.loadData(url: "https://www.sql-ex.ru/exercises/index.php?act=check", params: ["query":dataPassing.code,"num":number,"check":true], completionHandler: completionHandler)
        }
    }
    func OkRes(completionHandler: @escaping (standartModelResult) -> ())
    {
        
        super.loadData(params: ["txtsql":dataPassing.code,"showOKres":number,"CHB":1,"wo":true], completionHandler: completionHandler)
        
    }
    func changeSubd(subdName:String,completionHandler: @escaping (standartModelResult) -> ())
    {
        super.loadData(url: "https://www.sql-ex.ru/exercises/index.php?act=choisedb",params:["dbname":subdName]){
            (res) in
            switch res
            {
            case .success:
                if (self.htmlContent=="ok")
                {
                    RunModel.currentSubd = subdName
                }
            case .error: break
            case.login: break
            }
            completionHandler(res)
        }
    }
}




