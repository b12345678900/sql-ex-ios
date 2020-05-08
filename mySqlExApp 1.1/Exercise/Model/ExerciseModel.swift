//
//  ExerciseModel.swift
//  mySqlExApp 1.1
//
//  Created by imac on 01/04/2019.
//  Copyright © 2019 imac. All rights reserved.
//

import UIKit
import SwiftSoup
class ExerciseModel: StandartModel {
    let number:String
    let level:Level
    var data:[String:String]?
    var help:[helpItem]!
    func getData()->[String:String]
    {
        do
        {
        if (data==nil && htmlContent != "")
        {
            data=[:]
            let doc:Document=try SwiftSoup.parse(htmlContent)
            let base_desc=try doc.select("td[colspan]").array().first
            var ArrayOfA=try base_desc!.select("a").array()
            var pathToDetailBaseDesc=level.address==LevelsAdress.dml ? try ArrayOfA[0].attr("href") : try ArrayOfA[1].attr("href")
            pathToDetailBaseDesc="https://www.sql-ex.ru"+matches(for: "/help/select13.php#db_[0-9]+", in: pathToDetailBaseDesc).first!
            let db=Int(matches(for:"(?<=#db_)\\d+", in: pathToDetailBaseDesc).first!)
            let temp=try String(contentsOf: URL(string:pathToDetailBaseDesc)!,encoding: String.Encoding.windowsCP1251)
            let img:Element=try SwiftSoup.parse(temp).select("img").array()[db!]
            let uri=try img.attr("src").replacingOccurrences(of: "..", with: "")
            data!["pathToSchemeImage"]="https://www.sql-ex.ru" + uri
           
           let forum=matches(for: "(?<=<[Aa] class='let' href=')/forum\\S+(?='>)", in: htmlContent)
            if forum.count>0{
                data!["forum_path"]="https://www.sql-ex.ru" + forum[0]}
            help=[]
            let s=try doc.select("a.let[target=_blank]")
            if s.count>0{
                
            for x:Element in s
            {
                 let html=try x.outerHtml()
                let label = matches(for: "(?<=>)[\\s\\S]+(?=<)", in: html).first!
                print (html)
                let url=matches(for: "(?<=href=\").+?(?=\")", in: html).first!
                help.append(helpItem(label: label,url: url))
            }
            }
            //****подсказки
            let b = try doc.select("div#hint").array().first
            if let b=b
            {
                 print(try b.text())
            }
           //****
            
             //****подсказки
            let user_solution=try doc.select("#txtsql").array().first?.text()
            data!["user_solution"]=user_solution!
            dataPassing.code=user_solution!
            //****
            
            try base_desc?.select("a").remove()
            
            let task = matches(for: "(?<=<!-- Задание: -->)[\\s\\S]+?(?=(<p>)|(<font color))", in: htmlContent)
            data!["task"]=task[0].replacingOccurrences(of: "\r\n", with: "\n").replacingOccurrences(of: "<br>", with: "\n").replacingOccurrences(of: "</br>", with: "").replacingOccurrences(of: "<br />", with: "")
            data!["base_desc"]=try base_desc!.html().replacingOccurrences(of: "\r\n", with: "\n").replacingOccurrences(of: "<br>", with: "\n").replacingOccurrences(of: "<b>", with: "").replacingOccurrences(of: "</b>", with: "").replacingOccurrences(of: "<div>", with: "").replacingOccurrences(of: "</div>", with: "").replacingOccurrences(of: "<div style=\"display: none;\">", with: "")
          
            var ex_info=try doc.select("form[name=frmN]").array().first
           ex_info=try ex_info!.nextElementSibling()
           data!["full_html_code"]=htmlContent
            data!["ex_info"]=try ex_info!.text()
            
            
        }
        }
        catch
        {
            
        }
        return data!
    }
    
    init (number:String,level:Level)
    {
        self.number=number
        self.level=level
        var url=""
        switch level.address {
        case .learn:
            url=level.address.rawValue+"?LN="+number
       
        case .rating:
            url=level.address.rawValue+"?N="+number
        case .dml:
            url=level.address.rawValue+"?N="+number
        }
        super.init(url: url)
    }
    
    
}
struct helpItem
{
    let label:String
    let url:URL
    init(label:String,url:String) {
        self.label=label
        self.url = URL(string: url)!
    }
}
