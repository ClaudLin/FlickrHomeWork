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
        collectionView?.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "collectionView")
        collectionView?.delegate = self
        collectionView?.dataSource = self
        collectionView?.backgroundColor = UIColor.white
        view.addSubview(collectionView!)
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (favoriteArray?.count)!
    }
    
    func createCell(cell:UICollectionViewCell,dic:Dictionary<String,Any>){
        let imageView = UIImageView(frame: CGRect(x: cell.bounds.minX, y: cell.bounds.minY, width: cell.bounds.width, height: 250))//itemSize高度少50
        let urlString = getUrlString(dic: dic)
        let imageData = try? Data(contentsOf: URL(string:urlString)!)
        let label = UILabel(frame: CGRect(x: imageView.frame.minX, y: imageView.frame.maxY, width: imageView.bounds.width, height: 50))
        label.textAlignment = .center
        label.text = dic["title"] as? String
        imageView.image = UIImage(data: imageData!)
        cell.addSubview(label)
        cell.addSubview(imageView)
    }
    
    func getUrlString(dic:Dictionary<String,Any>) -> String{
        let farm = dic["farm"]!
        let secret = dic["secret"]!
        let ID = dic["id"]!
        let server = dic["server"]!
        return "https://farm\(farm).staticflickr.com/\(server)/\(ID)_\(secret)_m.jpg"
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell = UICollectionViewCell()
        cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionView", for: indexPath)
        let dic = favoriteArray![indexPath.row] as! Dictionary<String,Any>
        createCell(cell: cell,dic: dic)
        return cell
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
