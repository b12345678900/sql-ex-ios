//
//  ExericeListController.swift
//  mySqlExApp 1.1
//
//  Created by imac on 27/03/2019.
//  Copyright © 2019 imac. All rights reserved.
//

import UIKit





class ExerciceListController: baseController, UITableViewDelegate,UITableViewDataSource {
    
    var model:ExerciseListModel?
    
    
    @IBOutlet var ExTable: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
       
        title=level!.name
        model=ExerciseListModel.init(url: level!.address.rawValue as! String)
       
        self.model!.loadData(completionHandler: self.completionHandler)
       
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style:.plain, target: nil, action: nil)
        ExTable.dataSource=self
        ExTable.delegate=self
       
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let dvc = segue.destination as? ExerciseTabBarController2
        {
            if let indexPath = ExTable.indexPathForSelectedRow {
                dvc.level = self.level!
                dvc.number=model!.getData()[indexPath.row]["number"]!
                model!.lastEx=model!.getData()[indexPath.row]["number"]!
                ExTable.reloadData()
                let row=self.level!.address == LevelsAdress.rating ? (Int(self.model!.lastEx)!+18 + (Int(self.model!.lastEx)! < 0 ? 0: -1)):Int(self.model!.lastEx)!-1
                
                self.ExTable.scrollToRow(at: IndexPath(row: row, section: 0), at:.middle, animated: false)
            }
            
        }
        
        else { return }
        
    }
    
    func completionHandler (res:standartModelResult)
    {
        switch res
        {
        case standartModelResult.success:
            DispatchQueue.main.async {
                self.ExTable.reloadData()
                
                let row=self.level!.address == LevelsAdress.rating ? (Int(self.model!.lastEx)!+18 + (Int(self.model!.lastEx)! < 0 ? 0: -1)):Int(self.model!.lastEx)!-1
                
                self.ExTable.scrollToRow(at: IndexPath(row: row, section: 0), at:.middle, animated: false)
            }
        case standartModelResult.error:
            repeateRequestData(model: self.model!,controller: self,completionHandler: self.completionHandler)
        case standartModelResult.login:relogin{ () in
            self.model!.loadData(completionHandler: self.completionHandler)
            }
            }
        
    }
    // MARK: - Table view data source
    
     func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return model!.getData().count
    }
    
    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        // Configure the cell...
        cell.textLabel?.text=model!.getData()[indexPath.row]["content"]
        cell.accessoryType = (model!.lastEx==model!.getData()[indexPath.row]["number"]) ?.checkmark :.none
        return cell
    }
    
    
    
}
