//
//  CodeViewController.swift
//  mySqlExApp 1.1
//
//  Created by imac on 01/04/2019.
//  Copyright © 2019 imac. All rights reserved.
//

import UIKit

class CodeViewController: BasicTabContentController,notifeChildControllers {
    @IBOutlet weak var userCodeTextView: UITextView!
    let editHistory=EditHistory()
    var isUndo=false
    var code:String!
    
    var strTitle:String=""
    @IBOutlet weak var cleanBut: UIButton!
    var redoButton:UIBarButtonItem!
     var undoButton:UIBarButtonItem!
    
    @IBAction func clean(_ sender: Any) {
        
            let cookieStore = HTTPCookieStorage.shared
            for cookie in cookieStore.cookies ?? [] {
                cookieStore.deleteCookie(cookie)
            
        }

    }
    func setData(data: [String : String],level:Level,number:String,help:[helpItem],index:Int, StrTitle:String) {
        
        DispatchQueue.main.async {
            self.code=data["user_solution"]!
            self.pageIndex=index
            self.strTitle=StrTitle
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        self.view.endEditing(true) // Скрывает клавиатуру, вызванную для любого объекта
        
        
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        userCodeTextView.layoutIfNeeded()
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userCodeTextView.delegate = self
        userCodeTextView.text=code
        cleanBut.isHidden=true
        let toolbar=UIToolbar()
        toolbar.sizeToFit()
        let flexibleSpace=UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let doneButton=UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.done, target: self, action: #selector(doneClicked))
          undoButton=UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.undo, target: self, action: #selector(undoClicked))
         redoButton=UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.redo, target: self, action: #selector(redoClicked))
        toolbar.setItems([flexibleSpace,undoButton,redoButton,flexibleSpace,doneButton], animated: false)
        
        userCodeTextView.inputAccessoryView=toolbar
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(updateTextView(notification:)),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        
        // Отслеживаем скрытие клавиатуры
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(updateTextView(notification:)),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
        
    }
    @objc func updateTextView(notification: Notification) {
        
        guard let userInfo = notification.userInfo as? [String: AnyObject],
            let keyboardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
            else { return }
        
        if notification.name == UIResponder.keyboardWillHideNotification {
            userCodeTextView.contentInset = UIEdgeInsets.zero
        } else {
            userCodeTextView.contentInset = UIEdgeInsets(top: 0,
                                                 left: 0,
                                                 bottom: keyboardFrame.height+userCodeTextView.inputAccessoryView!.bounds.height ,
                                                 right: 0)
            
            userCodeTextView.scrollIndicatorInsets = userCodeTextView.contentInset
        }
        
        userCodeTextView.scrollRangeToVisible(userCodeTextView.selectedRange)
    }
    @objc func undoClicked()
    {
        isUndo=true
        var txt=userCodeTextView.text!
        if let editItem=editHistory.getPrevious()
        {
            let range=NSRange(location: editItem.position, length: editItem.textAfter.count)
            txt=txt.replacingCharacters(in: Range(range, in: txt)!, with: editItem.textBefore)
            DispatchQueue.main.async {
                self.userCodeTextView.text=txt
                
                self.userCodeTextView.selectedRange=NSMakeRange(editItem.position+editItem.textBefore.count,0)
                self.userCodeTextView.scrollRangeToVisible(NSMakeRange(editItem.position+editItem.textBefore.count,0))
            }
        }
        isUndo=false
         updateUndoRedoButtons()
    }
    @objc func redoClicked()
    {
        isUndo=true
        var txt=userCodeTextView.text!
        if let editItem=editHistory.getNext()
        {
            let range=NSRange(location: editItem.position, length: editItem.textBefore.count)
            txt=txt.replacingCharacters(in: Range(range, in: txt)!, with: editItem.textAfter)
            DispatchQueue.main.async {
                self.userCodeTextView.text=txt
                self.userCodeTextView.selectedRange=NSMakeRange(editItem.position+editItem.textAfter.count,0)
                self.userCodeTextView.scrollRangeToVisible(NSMakeRange(editItem.position+editItem.textAfter.count,0))
            }
        }
        isUndo=false
         updateUndoRedoButtons()
    }
    @objc func doneClicked()
    {
        view.endEditing(true)
    }

    func updateUndoRedoButtons()
    {
        undoButton.isEnabled=editHistory.isCanUndo()
        redoButton.isEnabled=editHistory.isCanRedo()
    }

}


extension CodeViewController:UITextViewDelegate
{
     func textViewDidEndEditing(_ textView: UITextView){
       
        dataPassing.code=userCodeTextView.text
        
    }
    
    func textView(_ textView: UITextView,
                  shouldChangeTextIn range: NSRange,
                  replacementText text: String)->Bool
    {
        if (!isUndo)
        {
            let txt=textView.text!
            
            
            
            print(txt[Range(range, in: txt)!])
            let editItem=EditItem(position: range.location, textBefore: String(txt[Range(range, in: txt)!]),textAfter: text)
            editHistory.add(item: editItem)
            
        }
        updateUndoRedoButtons()
        return true
        
    }
    
}
