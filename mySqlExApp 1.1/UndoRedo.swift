//
//  UndoRedo.swift
//  mySqlExApp1.1copy
//
//  Created by imac on 15/05/2019.
//  Copyright © 2019 imac. All rights reserved.
//

import UIKit

class EditItem
{
    let position:Int
    let textBefore:String
    let textAfter:String
    init(position:Int,textBefore:String, textAfter:String) {
        self.position=position
        self.textBefore=textBefore
        self.textAfter=textAfter
    }
}
class EditHistory
{
    var history:[EditItem]=[]
    var position:Int=0
    func isCanUndo()->Bool
    {
        return position>0
    }
    func isCanRedo() -> Bool {
        return history.count>position
    }
    func getPrevious()->EditItem?
    {
        if(position==0)
        {
            return nil
        }
        position=position-1
        return history[position]
    }
    func getNext()->EditItem?
    {
        if(position>=history.count)
        {
            return nil
        }
        let a=position
        position=position+1
        return history[a]
    }
    func add(item:EditItem)
    {
        while (history.count>position)
        {
            history.removeLast()
        }
        history.append(item)
        position+=1
    }
}

