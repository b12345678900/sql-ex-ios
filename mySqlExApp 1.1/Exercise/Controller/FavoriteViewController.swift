//
//  FavoriteViewController.swift
//  mySqlExApp2
//
//  Created by DenisMacOS on 26/06/2019.
//  Copyright © 2019 imac. All rights reserved.
//

import UIKit

class FavoriteViewController: UIViewController {
    var url:String=""
    override func viewDidLoad() {
        super.viewDidLoad()
        print(url)
        view.backgroundColor=UIColor.lightGray
    }
    
    @IBOutlet weak var commentOutlet: UITextView!
    @IBAction func saveAction(_ sender: Any) {
        let str=commentOutlet.text!
        
        
        NetworkService.shared.getData(url: "https://www.sql-ex.ru\(url)", params: ["comment":str])
        {
            res in
            switch (res)
            {
            case .success(_):
                DispatchQueue.main.async {
                self.performSegue(withIdentifier: "unwindSegueFav", sender: nil)
                }
            case .error: break
                
        }
    }
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    @IBAction func cancelAction(_ sender: Any) {
         self.performSegue(withIdentifier: "unwindSegueFav", sender: nil)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
