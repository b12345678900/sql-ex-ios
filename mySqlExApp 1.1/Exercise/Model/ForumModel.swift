//
//  ForumModel.swift
//  mySqlExApp1.1copy
//
//  Created by imac on 03/05/2019.
//  Copyright © 2019 imac. All rights reserved.
//

import UIKit
import WebKit
import SwiftSoup
class ForumModel: StandartModel {
   
    var comments:[Element]?
    var authors:[Element]?
    var dates:[Element]?
    var kolvoStranic:String?
    var currentPage:String?
    var postParams:[String:String]!
    var favorites_links:[String]=[]
    override init(url: String) {
        super.init(url: url)
    }
    
    func getContent()
    {
        do
        {
            let doc:Document=try SwiftSoup.parse(htmlContent)
            
           favorites_links.removeAll()
            
            authors=try doc.select("table[id] td[width]>b").array()
            comments=try doc.select("td[id]").array()
            dates=try doc.select("table[id] td[style]").array()
            kolvoStranic=try doc.select("input[name=\"kolvostranic\"]").array()[0].attr("value")
            currentPage=try doc.select("input[name=\"textbox\"]").array()[0].attr("value")
            let form1=try doc.select("form[name=\"form1\"]+td")
            let input=try form1.select("input")
            postParams=[:]
            let links_favorites=try doc.select("a:contains(Добавить в избранное)").array()
            for item in links_favorites
            {
                let str:String=try item.attr("href")
                 favorites_links.append(str)
            }
            for item in input
            {
               
                try postParams[item.attr("name")]=item.attr("value")
            }
            
        }
        catch
        {
            
        }
        
    }
    

}
