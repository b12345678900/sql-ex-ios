//
//  ViewController.swift
//  youtube
//
//  Created by Brian Voong on 6/1/16.
//  Copyright © 2016 letsbuildthatapp. All rights reserved.
//

import UIKit

class TabBarViewController:UIViewController,UICollectionViewDelegateFlowLayout,UICollectionViewDataSource,UICollectionViewDelegate {
    
    var collectionView:UICollectionView!
    var ContentViewControllers:[BasicTabContentController]!
   
    let cellId = "cellId"
    var cell_width:CGFloat=0
    var cell_height:CGFloat=0
    var index:Int=0
     var screen_rotate:Bool=false
    private func setupMenuBar() {
        
        
        //let redView = UIView()
        //redView.backgroundColor = UIColor.rgb(red: 230, green: 32, blue: 31)
        //view.addSubview(redView)
        //view.addConstraintsWithFormat("H:|[v0]|", views: redView)
        //view.addConstraintsWithFormat("V:[v0(50)]", views: redView)
        
        view.insertSubview(menuBar, at: 0)
        view.addConstraintsWithFormat("H:|[v0]|", views: menuBar)
        view.addConstraintsWithFormat("V:[v0(30)]", views: menuBar)
        //view.addConstraintsWithFormat("V:[v0]", views: menuBar)
        menuBar.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor).isActive = true
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        screen_rotate=true
        self.cell_height=size.height
        self.cell_width=size.width
    /*DispatchQueue.main.async {
        self.cell_height=size.height
        self.cell_width=size.width
        
        
        self.collectionView.collectionViewLayout.invalidateLayout()
        
        self.collectionView.selectItem(at: IndexPath(item: self.index, section: 0), animated: true, scrollPosition: .centeredHorizontally)
        print(self.index)
        //self.collectionView.scrollToItem(at: IndexPath(item: self.index, section: 0), at: .centeredHorizontally, animated: false)
        self.menuBar.collectionView.collectionViewLayout.invalidateLayout()
        self.ContentViewControllers[self.index].viewInTheScreen()
       // menuBar.collectionView.selectItem(at: IndexPath(item: index, section: 0), animated: true, scrollPosition: .centeredHorizontally)
        // menuBar.collectionView.reloadData()
        //collectionView.reloadData()
        }*/
       }
     override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        cell_width = collectionView.bounds.width
        cell_height = collectionView.bounds.height
      
        self.menuBar.collectionView.collectionViewLayout.invalidateLayout()
        
        self.collectionView.collectionViewLayout.invalidateLayout()
        
        //self.collectionView.selectItem(at: IndexPath(item: self.index, section: 0), animated: true, scrollPosition: .centeredHorizontally)
        print(self.index)
        
    
        self.collectionView.scrollToItem(at: IndexPath(item: self.index, section: 0), at: .centeredHorizontally, animated: false)
        
        
    }
     func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (screen_rotate) {
            screen_rotate=false
            return
        }
          menuBar.horizontalBarLeftAnchorConstraint?.constant = scrollView.contentOffset.x / 4
        let new_index=Int(scrollView.contentOffset.x / view.frame.width)
        if (new_index != index && new_index<4)
        {
            ContentViewControllers[new_index].viewInTheScreen()
            index=new_index
        }
       
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupMenuBar()
        
        
        navigationItem.title = "Home"
        
        
        
        
        
        
       
       
        
        setupCollectionView()
        
    }
    /*override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        cell_width = collectionView.bounds.width
        cell_height = collectionView.bounds.height
    }*/
    
    func setupCollectionView() {
        let flowLayout=UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumLineSpacing = 0
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.delegate=self
        collectionView.dataSource=self
        
        
        
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: cellId)
        
        
        
        collectionView.isPagingEnabled = true
        view.insertSubview(collectionView, at: 1)
        collectionView.translatesAutoresizingMaskIntoConstraints=false
        //collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 200).isActive=true
        //collectionView.topAnchor.constraint(equalTo:menuBar.bottomAnchor,constant: 0).isActive=true
        collectionView.bottomAnchor.constraint(equalTo:view.safeAreaLayoutGuide.bottomAnchor).isActive=true
        collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive=true
        collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive=true
        
    }
    
    
    
    
    
    
    
    
    
    func scrollToMenuIndex(menuIndex: Int) {
        let indexPath = IndexPath(item: menuIndex, section: 0)
        print("gavno" + String(collectionView.numberOfItems(inSection: 0)))
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
    }
    
    lazy var menuBar: MenuBar = {
        let mb = MenuBar()
        mb.homeController = self
        return mb
    }()
    
     
    
     func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let index = Int(targetContentOffset.pointee.x / view.frame.width)
        let indexPath = IndexPath(item: index, section: 0)
        menuBar.collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .centeredHorizontally)
    }
    
     func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ContentViewControllers.count
    }
    
     func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath)
        let vc = ContentViewControllers[indexPath.item]
        cell.contentView.addSubview(vc.view)
        addChild(vc)
        vc.didMove(toParent: self)
        //cell.contentView.backgroundColor=UIColor.green
        
        
        vc.view.translatesAutoresizingMaskIntoConstraints=false
        vc.view.bottomAnchor.constraint(equalTo:cell.contentView.safeAreaLayoutGuide.bottomAnchor,constant:0).isActive=true
        vc.view.topAnchor.constraint(equalTo:cell.contentView.safeAreaLayoutGuide.topAnchor,constant: 0).isActive=true
        vc.view.leadingAnchor.constraint(equalTo:cell.contentView.safeAreaLayoutGuide.leadingAnchor).isActive=true
        vc.view.trailingAnchor.constraint(equalTo:cell.contentView.safeAreaLayoutGuide.trailingAnchor).isActive=true
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: cell_width, height: cell_height)
        //return CGSize(width: view.frame.width,height: collectionView.frame.height)
    }
    
    
    

    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
}






