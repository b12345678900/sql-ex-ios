//

//  ForumViewController.swift

//  mySqlExApp1.1copy

//

//  Created by imac on 28/04/2019.

//  Copyright © 2019 imac. All rights reserved.

//



import UIKit

import WebKit

import SwiftSoup



class ForumViewController: BasicTabContentController,notifeChildControllers,cellDelegator {

    func callSegueFromCell(url: Any) {

        performSegue(withIdentifier: "add_in_fav_segue", sender:url )

    }
    func tapOnWebViewInCellHandler()
    {
        onTapAction()
    }

    @IBAction func unwindSegue(segue:UIStoryboardSegue){

        

    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        

        if let dvc = segue.destination as? FavoriteViewController

        {

            dvc.url = sender as! String

        }

        

            

        else { return }

        

    }

    private var indexPathForVisibleRow:IndexPath=IndexPath(row: 0, section: 0)

    var currentOffset:Int!

    var strTitle:String=""

    var count:Int=0

   

    var model:ForumModel!

    var cellHeights: [String:CGFloat]=[:]

    var isLoad:Bool=false

    var heightConstraint30:NSLayoutConstraint!

    var heightConstraint0:NSLayoutConstraint!

    var okButton:UIButton!
    var pageChangeButtonIsHidden : Bool=false
    

    var cancelButton:UIButton!

    var pageChangeView:UIView!

    var paginationView:UIView!

    var showSelectPageViewer:UIButton!

    @IBAction func selectPageShowAction(_ sender: Any) {

        picker.selectRow(Int(model.currentPage!)!-1, inComponent: 0, animated: false)

        view.addSubview(pageChangeView)

        

    }
    override func viewInTheScreen()
    {
        updateInterface()
        UIApplication.shared.windows.first?.endEditing(true)
    }

    var picker: UIPickerView!

    @IBOutlet weak var pageOutlet: UIButton!

    @IBOutlet weak var forumTVOutlet: MyTableView!

    
    @IBOutlet weak var constraintTVtoSA: NSLayoutConstraint!
    
    @IBOutlet weak var contraintPageToTV: NSLayoutConstraint!
    
    func setData(data: [String : String],level:Level,number:String,help:[helpItem],index:Int, StrTitle:String) {

         print("setData was launched")

        

        if let _ = data.index(forKey: "forum_path")

        {

        model = ForumModel(url: data["forum_path"]!)

        //model.loadData(completionHandler: completionHandler)

        }

        self.pageIndex=index

        self.strTitle=StrTitle

        

    }

    @objc func cancelButtonAction()

    {

       pageChangeView.removeFromSuperview()

    }
    
func prepareContent()

{

    DispatchQueue.main.async {

    
        
        self.updateInterface()
        if(self.forumTVOutlet != nil)

        {

       

        }

        

        for (index,value) in self.model.comments!.enumerated()

    {

        let wv:WKWebView=WKWebView()

        wv.navigationDelegate=self

        wv.frame.size.width=self.forumTVOutlet.frame.size.width

        wv.frame.size.height=0.0

        

       self.view.addSubview(wv)

        wv.tag=index

        do

        {

            try wv.loadHTML(fromString: "<div>" + self.model.comments![index].html()+"</div>",filename: "comment.css")

        }

        catch

        {

            

        }

    }

        self.pageChangeView=UIView(frame: CGRect(x: 0, y: self.view.frame.size.height-250, width: self.view.frame.size.width,height: 250))

        self.pageChangeView.backgroundColor=UIColor.black

        self.pageOutlet.setTitle("\(self.model.currentPage!) из \(self.model.kolvoStranic!)", for:UIControl.State.normal)

        self.picker=UIPickerView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width-70,height: 250))

        self.picker.backgroundColor = .black

       self.okButton=UIButton(frame: CGRect(x: self.view.frame.size.width-70, y: 0, width: 70,height: 124))

        self.okButton.setTitle("Ok", for: .normal)

        self.cancelButton=UIButton(frame: CGRect(x: self.view.frame.size.width-70, y: 126, width: 70,height: 125))

        self.cancelButton.setTitle("Cancel", for: .normal)

        self.cancelButton.backgroundColor=UIColor.lightGray

         self.okButton.backgroundColor=UIColor.lightGray

        self.cancelButton.addTarget(self, action: #selector(self.cancelButtonAction), for: .touchUpInside)

        self.okButton.addTarget(self, action: #selector(self.okButtonAction), for: .touchUpInside)

        self.picker.delegate=self

        self.picker.dataSource=self

        self.pageChangeView.addSubview(self.picker)

        self.pageChangeView.addSubview(self.okButton)

        self.pageChangeView.addSubview(self.cancelButton)

    }

    

}

    @objc func okButtonAction()

    {

        

      let page=String(Int(picker.selectedRow(inComponent: 0))+1)

        model.postParams["textbox"]=page

        self.cellHeights=[:]

        self.isLoad=false

       model.loadData(url: nil, params: model.postParams, completionHandler: completionHandler)

        pageChangeView.removeFromSuperview()

        

    }

    override func viewDidLoad() {

        super.viewDidLoad()

        print("launch ViewDidLoad\n")

        forumTVOutlet.dataSource=self

        forumTVOutlet.delegate=self
        forumTVOutlet.Tapdelegate=self
        pageOutlet.frame.size.height=0
        forumTVOutlet.backgroundColor=UIColor(red: 255, green: 0, blue: 0, alpha: 0)
        
        //forumTVOutlet.contentInset=UIEdgeInsets(top: 30,left: 0,bottom: 0,right: 0)

        forumTVOutlet.isHidden=true

        

               

               

           

            

        /*paginationView=UIView()

        view.addSubview(paginationView)

        paginationView.backgroundColor=UIColor(red: 0, green: 0, blue: 0, alpha: 1)

        //paginationView.frame=CGRect(x: 0, y: 8, width: view.bounds.size.width, height: 30)

        

       paginationView.translatesAutoresizingMaskIntoConstraints=false

        let guide = view.safeAreaLayoutGuide

        paginationView.leadingAnchor.constraint(equalTo: guide.leadingAnchor, constant: 0).isActive=true

        paginationView.trailingAnchor.constraint(equalTo: guide.trailingAnchor,constant:  0).isActive=true

        paginationView.topAnchor.constraint(equalTo: guide.topAnchor,constant: 0 ).isActive=true

        

       heightConstraint30=paginationView.heightAnchor.constraint(equalToConstant: 30)

        heightConstraint30.isActive=true

        showSelectPageViewer=UIButton()

        paginationView.addSubview(showSelectPageViewer)

        showSelectPageViewer.centerXAnchor.constraint(equalTo: paginationView.centerXAnchor).isActive=true

        showSelectPageViewer.topAnchor.constraint(equalTo: paginationView.topAnchor).isActive=true

        showSelectPageViewer.bottomAnchor.constraint(equalTo: paginationView.bottomAnchor).isActive=true

        showSelectPageViewer.widthAnchor.constraint(equalToConstant: 50)

        showSelectPageViewer.backgroundColor=UIColor(red: 255, green: 0, blue: 0, alpha: 1)*/

       if let model=model/*, let _=model.comments*/

       {

       print("model load in VDL")

        model.loadData(completionHandler: completionHandler)

        //prepareContent()

        }

    }





    /*func scrollViewDidScroll(_ scrollView: UIScrollView) {

       

        if paginationView != nil

        {

           

            let y = 30-(scrollView.contentOffset.y + 30)

        let height = min(max(y, 0), 30)

        //paginationView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: height)

            

            

            heightConstraint30.constant=height

        }

    }*/

    func completionHandler (res:standartModelResult)

    {

        switch res

        {

        case standartModelResult.success:

            print("load content")

            model.getContent()

            

            if let tv = forumTVOutlet

            {

                

                 DispatchQueue.main.async {

                    self.prepareContent()

            tv.reloadData()

                }

            }

            

        case standartModelResult.error:

            repeateRequestData(model: self.model!, controller: self, completionHandler: self.completionHandler)

            

        case standartModelResult.login:print(4)

        }

        

        

    }

    

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {

        print(UIDevice.current.orientation.isLandscape)

        self.indexPathForVisibleRow=self.forumTVOutlet.indexPathsForVisibleRows!.last!

        self.forumTVOutlet.isHidden=true

        DispatchQueue.main.async {

        if UIDevice.current.orientation.isLandscape {

            

            self.isLoad=false

            

            

           

            print (self.indexPathForVisibleRow.row)

            self.prepareContent()

            print("Landscape")

            

        }

            if UIDevice.current.orientation.isFlat {

                

            

            self.isLoad=false

                self.prepareContent()

            print("Flat")

        } else {

               

                

            self.isLoad=false

                self.prepareContent()

            print("Portrait")

        }

        }

    }



}



extension ForumViewController:UITableViewDataSource,UITableViewDelegate

{
   

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        if let model=model,let _=model.comments

        {

        return model.comments!.count

        }

        return 0

    }

    

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

           let cell=tableView.dequeueReusableCell(withIdentifier: "cellForum",for: indexPath)as!ForumCell

        

        

       

      

        if isLoad {

        do {

            try  cell.forumContentOutlet.loadHTML(fromString: "<div>" + model.comments![indexPath.row].html() + "</div>" ,filename: "comment.css")

           

            cell.WebHeightConstraint.constant=cellHeights[String(indexPath.row)]!
            

            cell.forumContentOutlet.sizeToFit()

            try cell.authorLabelOutlet.text=model.authors![indexPath.row].text()

             try cell.dateLabelOutlet.text=model.dates![indexPath.row].text()

            cell.link_to_favorite=model.favorites_links[indexPath.row]

            cell.delegate=self

        } catch  {

            

        }

       }

       

       

       

        

        return cell

    }

    

    
     
   

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        

       

        

        if   cellHeights.count==model.comments!.count

        {

            

            return cellHeights[String(indexPath.row)]!

        }

        

            return 100.0

        

        

    }

    



}



extension ForumViewController:WKNavigationDelegate

{

    func webView(_ webView: WKWebView,

                 didFinish navigation: WKNavigation!) {

        webView.evaluateJavaScript("document.body.scrollHeight", completionHandler: { (result, error) in

            DispatchQueue.main.async {

                

                //let frame=CGRect(x: 0, y: 0, width: webView.frame.width, height: (result as! CGFloat))  //(result as! CGFloat)

                

                //webView.frame=frame

                //webView.sizeToFit()

                self.cellHeights[String(webView.tag)]=result as! CGFloat + 100.0 as!CGFloat

                webView.removeFromSuperview()

                if (self.cellHeights.count==self.model.comments!.count && !self.isLoad )

                {

                    

                    self.forumTVOutlet.isHidden=false

                    

                    self.forumTVOutlet.reloadData()

                    print(self.indexPathForVisibleRow.row)

                    

                     self.forumTVOutlet.scrollToRow(at: self.indexPathForVisibleRow, at: .middle, animated: true)

                    self.isLoad=true

                }

               // self.forumTVOutlet.reloadData()

               

             // self.forumTVOutlet.reloadRows(at:[IndexPath(row: webView.tag, section: 0)], with: .none)

              

                

            }

            

            

            

        })

        

    }

}





extension ForumViewController:UIPickerViewDelegate,UIPickerViewDataSource

{

    func numberOfComponents(in pickerView: UIPickerView) -> Int {

        return 1

    }

    

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {

        return Int(model.kolvoStranic!)!

    }

    

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {

        return String(row)

    }

    

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {

       

        

    }

    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {

        let titleData = String(row+1)

        let myTitle = NSAttributedString(string: titleData, attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])

        

        return myTitle

    }

    

}

extension ForumViewController:TapTableViewDelegate
{
    
    func onTapAction() {
        self.pageChangeButtonIsHidden = !self.pageChangeButtonIsHidden
        self.updateInterface()
    
}
    func updateInterface()
    {
        guard (self.constraintTVtoSA != nil) else {return}
        self.constraintTVtoSA.isActive = self.pageChangeButtonIsHidden
        self.contraintPageToTV.isActive = !self.pageChangeButtonIsHidden
        
        self.tabBarVK.changeTabBarAndMenuVisibility(visibility: !self.pageChangeButtonIsHidden)
        UIView.animate(withDuration: 0.2,delay: 0, animations:{
            self.pageOutlet.isHidden = self.pageChangeButtonIsHidden
            self.pageOutlet.layoutIfNeeded()
            self.forumTVOutlet.layoutIfNeeded()
            
        })
    }

}
