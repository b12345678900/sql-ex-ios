//
//  RunViewController.swift
//  mySqlExApp 1.1
//
//  Created by imac on 01/04/2019.
//  Copyright © 2019 imac. All rights reserved.
//

import UIKit
import WebKit
class RunViewController: BasicTabContentController,notifeChildControllers {
   
   var strTitle:String=""
    var number:String!
    var model:RunModel?
    var currentRun: ((@escaping(standartModelResult)->())->())!
    @IBOutlet weak var switchDatabaseOutlet: UIPickerView!
    let databases:[String]=["mssql","mysql","pgsql","oracle"]
    @IBOutlet weak var webViewOutlet: WKWebView!
    @IBAction func ShowOkResButtonAction(_ sender: Any) {
        model!.OkRes(completionHandler: self.dataHandler)
        currentRun=model!.OkRes
    }
    @IBOutlet weak var withoutCheckSwitcher: UISwitch!
    func setData(data: [String : String],level:Level,number:String,help:[helpItem],index:Int, StrTitle:String) {
        self.level=level
        self.number=number
        
            switch level.address {
            case .learn:
                url=level.address.rawValue+"?LN="+number
                
            case .rating:
                url=level.address.rawValue+"?N="+number
            case .dml:
                url=level.address.rawValue+"?N="+number
            }
        self.pageIndex=index
        self.strTitle=StrTitle
        model=RunModel(level: level, number: number)
       if let switchDatabaseOutlet=switchDatabaseOutlet
       {
        if let model=model, level.address != LevelsAdress.learn
        {
            DispatchQueue.main.async {
            self.switchDatabaseOutlet.isUserInteractionEnabled=false
            }
        }
        for (index,value) in databases.enumerated()
        {
            if value==RunModel.currentSubd
            {
                DispatchQueue.main.async {
                self.switchDatabaseOutlet.selectRow(index, inComponent: 0, animated: false)
                }
            }
        }
        }
    }
    
    
    @IBAction func runButtonAction(_ sender: Any) {
         DispatchQueue.main.async {
            self.webViewOutlet.loadHTMLString("", baseURL: nil)
        }
        if (withoutCheckSwitcher.isOn)
        {
            model!.RunWithoutCheck (completionHandler: self.dataHandler)
            currentRun=model!.RunWithoutCheck
        }
        else
        {
            model!.Run (completionHandler: self.dataHandler)
            currentRun=model!.Run
        }
       
    }
    
    override func viewInTheScreen() {
         UIApplication.shared.windows.first?.endEditing(true)
          super.viewInTheScreen()
      }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        withoutCheckSwitcher.setOn(false, animated: false)
        switchDatabaseOutlet.dataSource=self
        switchDatabaseOutlet.delegate=self
        
        if let model=model, level.address != LevelsAdress.learn
        {
            switchDatabaseOutlet.isUserInteractionEnabled=false
            for (index,value) in databases.enumerated()
            {
                if value==RunModel.currentSubd
                {
                    switchDatabaseOutlet.selectRow(index, inComponent: 0, animated: false)
                }
            }
        }
        
    }
    
    
    
    func dataHandler(result:standartModelResult)
    {
        
        
        
        
        switch result
        {
        case standartModelResult.success:
            if (RunModel.currentSubd == "mssql")
            {
                self.model!.parseAnswer()
            }
            DispatchQueue.main.async{
                self.webViewOutlet.loadHTML(fromString: self.model!.htmlContent,filename: "table.css")
            }
        case standartModelResult.error:
            break
        case standartModelResult.login:relogin{ () in
            self.model!.loadData{
                res in
                self.currentRun(self.dataHandler)
            }
            }
        }
    }
    

   

}

extension RunViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return databases.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return databases[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if (RunModel.currentSubd != databases[row])
        {
        model?.changeSubd(subdName: databases[row])
        {
            (res) in
            switch res
            {
            case .success:break
            case .error:
                DispatchQueue.main.async {
            let ac=UIAlertController(title: "Ошибка", message:"Соединение не удалось", preferredStyle: UIAlertController.Style.alert)
               
             ac.show(self, sender: nil)
                }
            case .login: break
               
                
            }
        }
        }
       
    }
    
  
    
    
}

extension WKWebView {
    //<meta name="viewport" content="width=device-width, initial-scale=1">
    // <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, minimum-scale=1">
    func loadHTML(fromString: String,filename:String) {
        let htmlString = """
        <head>
        <meta name="viewport" content="initial-scale=1">
        
        <link rel="stylesheet" type="text/css" href="\(filename)">
        <script src="highlight.js"></script>
        <script>
        hljs.initHighlightingOnLoad('sql');
        </script>
        <script  src="sql.js"></script>
        </head>
        <body> \(fromString)</body>
        <script>
        var e = new MouseEvent("click", {
        view: window,
        bubbles: true,
        cancelable: true
        });
        var a =document.querySelectorAll('a[href="###"]')
        for (i = 0; i < a.length; ++i) {
        a[i].dispatchEvent(e)
        }
        
        
        var b =document.querySelectorAll('pre code')
        for (i = 0; i < b.length; ++i) {
         hljs.highlightBlock(b[i])
        }
        </script>
        """
        print("htmlstring\n"+htmlString)
        self.loadHTMLString(htmlString, baseURL: Bundle.main.bundleURL)
}
    
}
