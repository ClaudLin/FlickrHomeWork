//
//  FavoriteVC.swift
//  flickr
//
//  Created by 林書郁 on 2/27/19.
//  Copyright © 2019 林書郁. All rights reserved.
//

import UIKit

class FavoriteVC: UIViewController,UICollectionViewDelegateFlowLayout,UICollectionViewDelegate,UICollectionViewDataSource {
    var collectionViewFlowLayout:UICollectionViewFlowLayout?
    var collectionView: UICollectionView?
    var favoriteArray:Array<Any>?
    var userDefault = UserDefaults.standard
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBarController?.navigationItem.title = "我的最愛"
        dataInit()
        elementInit()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        dataInit()
        collectionView?.reloadData()
    }
    
    func getFrame()->CGRect{
        var v = view.bounds
        if #available(iOS 11.0, *) {
            v = view.safeAreaLayoutGuide.layoutFrame
        }
        return v
    }
    
    func dataInit(){
        favoriteArray = try! self.userDefault.value(forKey: "favoriteArray") as? Array<Any>
        if(favoriteArray == nil){
            favoriteArray = Array<Any>()
        }    }
    
    func elementInit(){
        collectionViewFlowLayout = UICollectionViewFlowLayout()
        collectionViewFlowLayout?.itemSize = CGSize(width: getFrame().width/2-10, height: 300)
        collectionViewFlowLayout?.minimumInteritemSpacing = 5
        collectionViewFlowLayout?.minimumLineSpacing = 5
        collectionView = UICollectionView(frame: getFrame(),collectionViewLayout:collectionViewFlowLayout!)
        collectionView?.register(UINib(nibName: "CustomCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CustomCollectionViewCell")
        collectionView?.delegate = self
        collectionView?.dataSource = self
        collectionView?.backgroundColor = UIColor.white
        view.addSubview(collectionView!)
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (favoriteArray?.count)!
    }
    
    func createCell(cell:CustomCollectionViewCell,dic:Dictionary<String,Any>){
        let urlString = getUrlString(dic: dic)
        let imageData = try? Data(contentsOf: URL(string:urlString)!)
        cell.label.text = dic["title"] as? String
        cell.imageView.image = UIImage(data: imageData!)
    }
    
    func getUrlString(dic:Dictionary<String,Any>) -> String{
        let farm = dic["farm"]!
        let secret = dic["secret"]!
        let ID = dic["id"]!
        let server = dic["server"]!
        return "https://farm\(farm).staticflickr.com/\(server)/\(ID)_\(secret)_m.jpg"
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let customCell = collectionView.dequeueReusableCell(withReuseIdentifier: "CustomCollectionViewCell", for: indexPath) as! CustomCollectionViewCell
        let dic = favoriteArray![indexPath.row] as! Dictionary<String,Any>
        createCell(cell: customCell,dic: dic)
        return customCell
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
