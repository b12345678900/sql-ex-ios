//
//  MyTableView.swift
//  mySqlExApp2
//
//  Created by DenisMacOS on 29/12/2019.
//  Copyright © 2019 imac. All rights reserved.
//

import UIKit

class MyTableView: UITableView {
    var Tapdelegate:TapTableViewDelegate?
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
          
        if let delegate=Tapdelegate
        {
            
            delegate.onTapAction()
        }
       }


}


protocol TapTableViewDelegate {
    func onTapAction()
}
