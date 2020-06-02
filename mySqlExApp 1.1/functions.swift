//
//  functions.swift
//  mySqlExApp 1.1
//
//  Created by imac on 29/03/2019.
//  Copyright © 2019 imac. All rights reserved.
//

import Foundation
import UIKit
enum Language : String
{
    
    
    case RU="0"
    case EN="1"
}
func changeLanguage (lang:Language,completionHandler: @escaping () -> ())
{
    let url="https://www.sql-ex.ru/index.php?Lang=" + lang.rawValue
    let url1="https://www.sql-ex.ru/exercises/index.php?act=learn&Lang=" + lang.rawValue
    
    NetworkService.shared.getData(url: url, params: nil, completionHandler:{_ in })
    NetworkService.shared.getData(url: url1, params: nil, completionHandler:{_ in completionHandler()})
    
}

func repeateRequestData (model: StandartModel,controller:UIViewController,completionHandler:@escaping (standartModelResult)->())
{
    DispatchQueue.main.async {
        let c=UIAlertController(title:"Ошибка", message: "Нет сети", preferredStyle: .alert)
        let okAction=UIAlertAction(title: "Повторить", style: .default) {
            (c)in
            model.loadData(completionHandler: completionHandler)
        }
        c.addAction(okAction)
        controller.present(c, animated: true, completion: nil)
    }
}

func matches(for regex: String, in text: String) -> [String] {
    
    do {
        let regex = try NSRegularExpression(pattern: regex)
        let results = regex.matches(in: text,
                                    range: NSRange(text.startIndex..., in: text))
        return results.map {
            String(text[Range($0.range, in: text)!])
        }
    } catch let error {
        print("invalid regex: \(error.localizedDescription)")
        return []
    }
}


