//
//  TaskViewController.swift
//  mySqlExApp 1.1
//
//  Created by imac on 01/04/2019.
//  Copyright © 2019 imac. All rights reserved.
//

import UIKit
import WebKit
class TaskViewController: BasicTabContentController,notifeChildControllers,UITableViewDelegate,UITableViewDataSource {
    var taskWebView:WKWebView=WKWebView()
    var help:[helpItem]!
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let help=help
        {return 3+help.count}
        else{
            return 2}
    }
    override func viewInTheScreen() {
        
        UIApplication.shared.windows.first?.endEditing(true)
        super.viewInTheScreen()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier:  "taskCell")as!taskCell
            if let data=self.data{
            cell.taskTextOutlet.text=data["ex_info"]!+"\n"+data["base_desc"]!+data["task"]!
            }
                  return cell
              }
            
              else  if indexPath.row == 1{
            let cell = tableView.dequeueReusableCell( withIdentifier: "schemeCell")as! schemeCell
            if let image=self.schemeImage
            {
            cell.schemeImageOutlet.image=image
            }
                  return cell
              }
        else
        {
            let cell = tableView.dequeueReusableCell( withIdentifier: "HelpItemCell")as! HelpItemCell
            if indexPath.row==2
            {
                cell.itemLabel.text="FAQ"
                cell.itemLabel.textAlignment = .center
                cell.selectionStyle = .none
            }
            else {
                cell.itemLabel.text=help[indexPath.row-3].label
                cell.itemLabel.textAlignment = .natural
                cell.selectionStyle = .default
            }
                  return cell
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        if indexPath.row>2
        {
            
            UIApplication.shared.open(help[indexPath.row-3].url, options: [:], completionHandler: nil)
            
        }
         tableView.deselectRow(at: indexPath, animated: false)
    }
    
    
    
    
    @IBOutlet weak var tvOutlet: UITableView!
    var data:[String:String]!
    var schemeImage:UIImage!
    var strTitle:String=""
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tvOutlet.delegate=self as! UITableViewDelegate
        tvOutlet.dataSource=self as! UITableViewDataSource
        tvOutlet.separatorStyle =  .none
        view.backgroundColor = .none
        
    }
   
    func setData(data: [String : String],level:Level,number:String,help:[helpItem],index:Int, StrTitle:String){
        DispatchQueue.main.async {
            self.pageIndex=index
            self.strTitle=StrTitle
            self.data=data
            self.help=help
            self.taskWebView.loadHTMLString(data["full_html_code"]!, baseURL: URL(string: "https://www.sql-ex.ru"))
            
          
            
            
           
            
       NetworkService.shared.getImage(url: data["pathToSchemeImage"]!){
            (res) in
            switch res
            {
            case .success(let image):
                
                DispatchQueue.main.async {
                   // self.SchemeImage.image=image
                    //self.scrollViewOutlet.contentSize.height = self.TextViewHeightConstr.constant + image.size.height
                    self.schemeImage=image
                    self.tvOutlet.reloadData()
                }
                
            case .error: print("error download scheme  image")
            }
        
        }
            
            
    }
    }
   
   
    
    
     
    
    
    
    
    

}


