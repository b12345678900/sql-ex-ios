//
//  ViewController.swift
//  youtube
//
//  Created by Brian Voong on 6/1/16.
//  Copyright © 2016 letsbuildthatapp. All rights reserved.
//

import UIKit

class dataPassing
{
    static var code:String=""
}
protocol notifeChildControllers {
    func setData(data:[String:String],level:Level,number:String,help:[helpItem],index:Int, StrTitle:String)->()

}

class ExerciseTabBarController2:TabBarViewController
{
    var pageControllerAnchorWhenMenuIsVisible:NSLayoutConstraint!
    var pageControllerAnchorWhenMenuIsNotVisible:NSLayoutConstraint!
    var taskVC:BasicTabContentController!
    var codeVC:BasicTabContentController!
    var runVC:BasicTabContentController!
    var forumVC:BasicTabContentController!
    var number:String=""
    var level: Level!
    
    var model :ExerciseModel!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        taskVC=(self.storyboard!.instantiateViewController(withIdentifier: "TaskViewController"))as!BasicTabContentController
        codeVC=(self.storyboard!.instantiateViewController(withIdentifier: "CodeViewController"))as!BasicTabContentController
        runVC=(self.storyboard!.instantiateViewController(withIdentifier: "RunViewController"))as!BasicTabContentController
        
        forumVC=(self.storyboard!.instantiateViewController(withIdentifier: "ForumViewController"))as!BasicTabContentController
        ContentViewControllers=[taskVC,codeVC,runVC,forumVC]
        title="Задача " + number+", " + level.name
        model=ExerciseModel(number: number,level: level)
        model.loadData (completionHandler: completionHandler)
        for vc in ContentViewControllers
        {
            //let vk=viewController as! BasicTabContentController
            vc.tabBarVK=self
        }
        pageControllerAnchorWhenMenuIsVisible=collectionView.topAnchor.constraint(equalTo: menuBar.bottomAnchor)
        pageControllerAnchorWhenMenuIsVisible.isActive=true
        pageControllerAnchorWhenMenuIsNotVisible=collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
        pageControllerAnchorWhenMenuIsNotVisible.isActive=false
    }
    
    func completionHandler (res:standartModelResult)
    {
        switch res
        {
        case standartModelResult.success:
            DispatchQueue.main.async {
                self.reloadData()
                
            }
                break
                
            
        case standartModelResult.error:
            repeateRequestData(model: self.model!, controller: self, completionHandler: self.completionHandler)
            
        case standartModelResult.login:
            LoginModel.shared.Login(currentUrl: nil,completionHandler: completionHandlerforRelogin)
    }
    }
    
    func reloadData()
    {
        let data=model.getData()
        for vc in ContentViewControllers
        {
            if let vc=vc as? notifeChildControllers
            {
            vc.setData(data: data,level: level,number: number,help: model!.help,index: 1,StrTitle: "")
            }
        }
        collectionView.reloadData()
    }
    
   
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
       
        
        
        return super.collectionView(collectionView, cellForItemAt: indexPath)
    }
    func completionHandlerforRelogin(res:loginResult)
    {
        
            switch res{
            case .error:
                DispatchQueue.main.async {
                    let c=UIAlertController(title:"Ошибка", message: "Нет сети", preferredStyle: .alert)
                    let okAction=UIAlertAction(title: "Повторить", style: .default) {
                        (c)in
                        LoginModel.shared.Login(currentUrl: nil,completionHandler: self.completionHandlerforRelogin)
                    }
                    c.addAction(okAction)
                    self.present(c, animated: true, completion: nil)
                }
            case .complete(let result):
                
                if result {
                    
                    DispatchQueue.main.async {
                        changeLanguage(lang: .RU){
                            () in
                            
                        }
                        
                    }
                    self.model.loadData (completionHandler: self.completionHandler)
                }
                
            }
        }
}


extension ExerciseTabBarController2
{
    func  changeTabBarAndMenuVisibility(visibility:Bool)
    {
        UIView.animate(withDuration: 0.2,delay: 0, animations:{
            self.menuBar.isHidden = !visibility
            self.pageControllerAnchorWhenMenuIsVisible.isActive = visibility
            self.pageControllerAnchorWhenMenuIsNotVisible.isActive = !visibility
                   self.navigationController?.isNavigationBarHidden = !visibility
            self.collectionView.collectionViewLayout.invalidateLayout()
            
        })
       
       
       
        
    }
}

/*

import UIKit
protocol notifeChildControllers {
    func setData(data:[String:String],level:Level,number:String,help:[helpItem],index:Int, StrTitle:String)->()

}

class ExerciseTabBarController1: UIViewController {
    
    @IBOutlet weak var menuBarView: MenuTabsView!
    
    
    
    var currentIndex: Int = 0
    var tabs = ["Условие","Код","Выполнение","Форум"]
    var storyboarsIds:[String]=["TaskViewController", "CodeViewController","RunViewController","ForumViewController"]
    var ContentViewControllers:[BasicTabContentController] = []
    var pageController: UIPageViewController!
    var pageControllerAnchorWhenMenuIsVisible:NSLayoutConstraint!
    var pageControllerAnchorWhenMenuIsNotVisible:NSLayoutConstraint!
    var number:String=""
       var level: Level!
       var model :ExerciseModel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let guide = view.safeAreaLayoutGuide
        //view.translatesAutoresizingMaskIntoConstraints=false
        menuBarView.translatesAutoresizingMaskIntoConstraints=false
        menuBarView.dataArray = tabs
        menuBarView.isSizeToFitCellsNeeded = true
        menuBarView.collView.backgroundColor = UIColor.init(white: 0.97, alpha: 0.97)
        menuBarView.topAnchor.constraint(equalTo: guide.topAnchor,constant: 0).isActive=true
        menuBarView.widthAnchor.constraint(equalTo: guide.widthAnchor).isActive=true
        //menuBarView.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 0).isActive=true
        //menuBarView.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: 0).isActive=true
        menuBarView.heightAnchor.constraint(equalToConstant: 30).isActive=true
        //menuBarView.backgroundColor=UIColor(red: 255, green: 0, blue: 0, alpha: 1)
        presentPageVCOnView()
        
        menuBarView.menuDelegate = self
        pageController.delegate = self
        pageController.dataSource = self
        for view in self.pageController.view.subviews {
          if let scrollView = view as? UIScrollView {
            scrollView.delegate = self
          }
        }
        
        //For Intial Display
        menuBarView.collView.selectItem(at: IndexPath.init(item: 0, section: 0), animated: true, scrollPosition: .centeredVertically)
       
        model=ExerciseModel(number: number,level: level)
          model.loadData (completionHandler: completionHandler)
        title="Задача " + number+", " + level.name
        

    }
    
     
    
    
 
    func presentPageVCOnView() {
        
        self.pageController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)//storyboard?.instantiateViewController(withIdentifier: "PageControllerVC") as! PageControllerVC
        //self.pageController.view.frame = CGRect.init(x: 0, y: menuBarView.frame.maxY, width: self.view.frame.width, height: self.view.frame.height - menuBarView.frame.maxY)
        
        
        self.addChild(self.pageController)
        self.view.addSubview(self.pageController.view)
        self.pageController.didMove(toParent: self)
        let guide = view.safeAreaLayoutGuide
        pageController.view.translatesAutoresizingMaskIntoConstraints=false
        
        pageControllerAnchorWhenMenuIsVisible=pageController.view.topAnchor.constraint(equalTo: menuBarView.bottomAnchor)
        pageControllerAnchorWhenMenuIsVisible.isActive=true
        pageControllerAnchorWhenMenuIsNotVisible=pageController.view.topAnchor.constraint(equalTo: view.topAnchor)
        pageControllerAnchorWhenMenuIsNotVisible.isActive=false
        pageController.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive=true
        //pageController.view.widthAnchor.constraint(equalTo:guide.widthAnchor).isActive=true
        //pageController.view.backgroundColor=UIColor(red: 255, green: 0, blue: 0, alpha: 1)
        pageController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive=true
        pageController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive=true
    }
    
    func setContentViewControllers()
    {
        for i in 0...storyboarsIds.count-1
        {
            self.ContentViewControllers.append(viewController(At: i)!)
            //self.pageController.setContentViewControllers([self.ContentViewControllers[i]], direction: .forward, animated: true, completion: nil)
        }
        //self.pageController.setContentViewControllers(self.ContentViewControllers, direction: .forward, animated: true, completion: nil)
        self.pageController.setContentViewControllers([self.ContentViewControllers[0]], direction: .forward, animated: true, completion: nil)
        self.currentIndex=0
    }
    
    func viewController(At index: Int) -> BasicTabContentController? {
        
        if((self.menuBarView.dataArray.count == 0) || (index >= self.menuBarView.dataArray.count)) {
            return nil
        }
        var viewController : notifeChildControllers?
        
            viewController = self.storyboard?.instantiateViewController(withIdentifier: self.storyboarsIds[index]) as! notifeChildControllers
        print ("vc is create")
        
        let data=model.getData()
        viewController!.setData(data: data,level: level,number: number,help: model!.help,index: index,StrTitle: tabs[index])
        let vk=viewController as! BasicTabContentController
        vk.tabBarVK=self
        currentIndex = index
        return vk
        
    }
    
}


extension ExerciseTabBarController1
{
    func  changeTabBarAndMenuVisibility(visibility:Bool)
    {
        menuBarView.isHidden = !visibility
        pageControllerAnchorWhenMenuIsVisible.isActive = visibility
        pageControllerAnchorWhenMenuIsNotVisible.isActive = !visibility
        self.navigationController?.isNavigationBarHidden = !visibility
    }
}


extension ExerciseTabBarController1: MenuBarDelegate {

    func menuBarDidSelectItemAt(menu: MenuTabsView, index: Int) {

        // If selected Index is other than Selected one, by comparing with current index, page controller goes either forward or backward.
        
        if index != currentIndex {

            if index > currentIndex {
                self.pageController.setContentViewControllers([ContentViewControllers[index] as! UIViewController], direction: .forward, animated: true, completion: nil)
            }else {
                self.pageController.setContentViewControllers([ContentViewControllers[index] as! UIViewController], direction: .reverse, animated: true, completion: nil)
            }
            self.currentIndex=index
            menuBarView.collView.scrollToItem(at: IndexPath.init(item: index, section: 0), at: .centeredHorizontally, animated: true)

        }

    }

}

extension ExerciseTabBarController1:UIScrollViewDelegate
{
    func scrollViewDidScroll(_ scrollView: UIScrollView)
    {
        print("f")
    }
}
extension ExerciseTabBarController1: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        var index = (viewController as! BasicTabContentController).pageIndex!
        
        if (index == 0) || (index == NSNotFound) {
            return nil
        }
        
        index -= 1
        self.currentIndex=index
        return self.ContentViewControllers[index]
        
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        var index = (viewController as! BasicTabContentController).pageIndex!
        
        if (index == tabs.count-1) || (index == NSNotFound) {
            return nil
        }
        
        index += 1
         self.currentIndex=index
        return self.ContentViewControllers[index]
        
        
    }
   
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousContentViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
        if finished {
            if completed {
                let cvc = pageViewController.ContentViewControllers!.first as! BasicTabContentController
                let newIndex = cvc.pageIndex!
                menuBarView.collView.selectItem(at: IndexPath.init(item: newIndex, section: 0), animated: true, scrollPosition: .centeredVertically)
                menuBarView.collView.scrollToItem(at: IndexPath.init(item: newIndex, section: 0), at: .centeredHorizontally, animated: true)
                
            }
        }
        
    }
    
    
    func completionHandler (res:standartModelResult)
    {
        switch res
        {
        case standartModelResult.success:
            DispatchQueue.main.async {
                self.setContentViewControllers()
                
            }
                break
                
            
        case standartModelResult.error:
            repeateRequestData(model: self.model!, controller: self, completionHandler: self.completionHandler)
            
        case standartModelResult.login:
            LoginModel.shared.Login(currentUrl: nil,completionHandler: completionHandlerforRelogin)
    }
    }
    func completionHandlerforRelogin(res:loginResult)
    {
        
            switch res{
            case .error:
                DispatchQueue.main.async {
                    let c=UIAlertController(title:"Ошибка", message: "Нет сети", preferredStyle: .alert)
                    let okAction=UIAlertAction(title: "Повторить", style: .default) {
                        (c)in
                        LoginModel.shared.Login(currentUrl: nil,completionHandler: self.completionHandlerforRelogin)
                    }
                    c.addAction(okAction)
                    self.present(c, animated: true, completion: nil)
                }
            case .complete(let result):
                
                if result {
                    
                    DispatchQueue.main.async {
                        changeLanguage(lang: .RU){
                            () in
                            
                        }
                        
                    }
                    self.model.loadData (completionHandler: self.completionHandler)
                }
                
            }
        }
        
    
}
*/
