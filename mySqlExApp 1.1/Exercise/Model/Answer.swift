//
//  Answer.swift
//  mySqlExApp1.1copy
//
//  Created by imac on 13/04/2019.
//  Copyright © 2019 imac. All rights reserved.
//

import Foundation
struct Answer:Decodable
{
    let answcorr:String?
    let resplace:String?
    let result:String?
    let hint:[String:String]?
    
}
