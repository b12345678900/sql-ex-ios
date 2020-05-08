//
//  BasicTabContentController.swift
//  mySqlExApp2
//
//  Created by DenisMacOS on 06/10/2019.
//  Copyright © 2019 imac. All rights reserved.
//

import UIKit

class BasicTabContentController: baseController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
     func viewInTheScreen (){
        tabBarVK.changeTabBarAndMenuVisibility(visibility: true)
    }
    var pageIndex:Int!
    public var tabBarVK:ExerciseTabBarController2!

}
