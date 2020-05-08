//
//  ExerciseListModel.swift
//  mySqlExApp 1.1
//
//  Created by imac on 27/03/2019.
//  Copyright © 2019 imac. All rights reserved.
//

import UIKit
import SwiftSoup

class ExerciseListModel:StandartModel {
    private var data:[[String:String]]=[]
    var lastEx:String=""
    func getData() -> [[String:String]]
    {
        if (data.count==0 && htmlContent != "")
        {
            data=self.converter(res: htmlContent)
        }
        return data
    }
    func converter (res:String)->[[String:String]]
    {
        print(res)
        var data:[[String:String]]=[]
        do {
            
            let doc:Document=try SwiftSoup.parse(res)
            var options:Elements=try doc.select("form[name=frmN] option")
            if options.array().count==0
            {
                options=try doc.select("select#LN option")
            }
            
            for option: Element in options.array() {
                let text=try option.text()
                let value=try option.attr("value")
                data.append(["number":value,"content":text])
                
            }
            var sel_opt:Elements=try doc.select("form[name=frmN] option[selected]")
            if sel_opt.array().count==0
            {
                sel_opt=try doc.select("select#LN option[selected]")
            }
            self.lastEx=try sel_opt.first()!.attr("value")
            
        }
        catch
        {
            
        }
        return data
    }
  
    
    
}
