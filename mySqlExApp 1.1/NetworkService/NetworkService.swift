//
//  NetworkService.swift
//  mySqlExApp 1.1
//
//  Created by imac on 23/03/2019.
//  Copyright © 2019 imac. All rights reserved.
//

import UIKit
enum requestResult
{
    case error
    case success(String)
}

enum requestImageResult
{
    case error
    case success(UIImage)
}

class NetworkService{
    static let shared = NetworkService()
    
    private func getPostString(params:[String:Any]) -> String
    {
        var data = [String]()
        for(key, value) in params
        {
            data.append(key + "=\(value)")
        }
        return data.map { String($0) }.joined(separator: "&")
    }
    func getData(url:String, params:[String:Any]?,completionHandler: @escaping (requestResult) -> ()) {
        
        let session = URLSession.shared
        let url = URL(string:  url)
        var request=URLRequest(url: url!)
        request.httpMethod="GET"
        request.timeoutInterval=30
        if let params=params
        {
            var postString=self.getPostString(params: params);
            postString=postString.replacingOccurrences(of: "+", with: "%2B")
            request.httpMethod="POST"
          
            //request.httpBody=postString.data(using:.utf8)
            request.httpBody=postString.data(using:.windowsCP1251)
        }
        
        session.dataTask(with: request) { (data, response, error) in
            
            if (!(error==nil))
            {
                completionHandler(requestResult.error)
            }
            
            guard let data = data,let httpResponse = response as? HTTPURLResponse else { return}
           print(data)
           
            do {
                let decoder = JSONDecoder()
                
                let result = try decoder.decode(Answer.self, from: data)
               if var str=result.resplace
               {
                if let hint=result.hint
                {
                    str = "<div>"+hint["hint"]!+"</div>" + str
                }
      completionHandler(requestResult.success(str))
                }
                else if let str=result.result
               {
                completionHandler(requestResult.success(str))
                }
                
            }
            catch
            {
                
                let htmlContent=NSString(data:data,encoding:String.Encoding.windowsCP1251.rawValue)!
                
                completionHandler(requestResult.success(htmlContent as String))
            }
           
            
            
            
            }.resume()
        
        
       
    }
    
    func getImage (url:String,completionHandler: @escaping (requestImageResult) -> ())
    {
        let session = URLSession.shared
        let url = URL(string:  url)
        var request=URLRequest(url: url!)
        request.httpMethod="GET"
        request.timeoutInterval=30
        session.dataTask(with: request) { (data, response, error) in
            if let data = data, let image = UIImage(data: data) {
                completionHandler(.success(image))
            }
            else
            {
                completionHandler(.error)
            }
            }.resume()
    }
}
