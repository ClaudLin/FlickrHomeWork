//
//  ShowViewController.swift
//  FlickrHomeWork
//
//  Created by 1900347_Claud on 2020/5/29.
//  Copyright © 2020 1900347_Claud. All rights reserved.
//

import UIKit

class ShowViewController: UIViewController,UICollectionViewDelegateFlowLayout,UICollectionViewDelegate,UICollectionViewDataSource {
    var searchStr = ""
    var maxInt = ""
    var collectionViewFlowLayout:UICollectionViewFlowLayout?
    var collectionView: UICollectionView?
    var dataArray:Array<Any>?
    var httpUrl:String?
    var favoriteArray:Array<Any>?
    var userDefault = UserDefaults.standard
    var commonNetwork = CommonNetwork.sharedManager
    let searchObject = SearchObject.sharedManager
    //https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=370ea9786aaf3fd315f259f0506298e7&text=apple&per_page=20&format=json&nojsoncallback=1
    override func viewDidLoad() {
        super.viewDidLoad()
        searchStr = searchObject.searchType!
        maxInt = searchObject.pageCount!
        let apiKey = userDefault.value(forKey: "api_key") as! String
        view.backgroundColor = UIColor.white
        tabBarController?.navigationItem.title = "搜尋覺結果 \(searchStr)"
        let parameters:[String:String] =
            [
            "api_key":apiKey,
            "method":"flickr.photos.search",
            "text":searchStr,
            "per_page":maxInt,
            "format":"json",
            "nojsoncallback":"1"
            ]
            
        dataInit()
        getResult(urlStr: httpUrl!, parameters: parameters)
            // Do any additional setup after loading the view.
    }
        
    func dataInit(){
        favoriteArray = self.userDefault.value(forKey: "favoriteArray") as? Array<Any>
        if(favoriteArray == nil){
            favoriteArray = Array<Any>()
        }
        httpUrl = "https://api.flickr.com/services/rest"
        dataArray = Array<Any>()
    }
        
    func elementInit(){
        collectionViewFlowLayout = UICollectionViewFlowLayout()
//        collectionViewFlowLayout?.itemSize = CGSize(width: view.getFrame().width/2-20, height: 450)
        collectionViewFlowLayout?.minimumInteritemSpacing = 5
//        collectionViewFlowLayout?.minimumLineSpacing = 5
        collectionView = UICollectionView(frame: view.getFrame(),collectionViewLayout:collectionViewFlowLayout!)
        collectionView?.register(UINib(nibName: "CustomCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CustomCollectionViewCell")
        collectionView?.delegate = self
        collectionView?.dataSource = self
        collectionView?.backgroundColor = UIColor.white
        view.addSubview(collectionView!)
    }
        
    func getResult(urlStr:String,parameters:[String:Any]){
        var urlComponent = URLComponents(string: urlStr)
        urlComponent?.queryItems = []
        for(key,value) in parameters{
            guard let value = value as? String
                else{
                    return
            }
            urlComponent?.queryItems?.append(URLQueryItem(name: key, value: value))
        }
        let queryURL = urlComponent?.url
        var request = URLRequest(url: queryURL!)
        request.httpMethod = "POST"

        commonNetwork.fetchedDataByDataTask(from: request, completion: {(result) in
            let photosDic = self.commonNetwork.dataToDictionary(data: result)
            let dic = photosDic["photos"] as? Dictionary<String,Any>
            self.dataArray = dic!["photo"] as? Array<Any>
            DispatchQueue.main.async {
                self.elementInit()
            }
        })
    }
        
        
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (dataArray?.count)!
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let customCell = collectionView.dequeueReusableCell(withReuseIdentifier: "CustomCollectionViewCell", for: indexPath) as! CustomCollectionViewCell
        let dic = dataArray![indexPath.row] as! Dictionary<String,Any>
        createCell(cell: customCell,dic: dic)
        return customCell
    }

    func createCell(cell:CustomCollectionViewCell,dic:Dictionary<String,Any>){
//        let imageView = UIImageView(frame: CGRect(x: cell.frame.minX, y: cell.frame.minY, width: cell.frame.width, height: 250))//itemSize高度少50
        let urlString = getUrlString(dic: dic)
        let imageData = try? Data(contentsOf: URL(string:urlString)!)
//        let label = UILabel(frame: CGRect(x: imageView.frame.minX, y: imageView.frame.maxY, width: imageView.frame.width, height: 100))
        cell.label.text = dic["title"] as? String
        cell.imageView.image = UIImage(data: imageData!)
//        cell.addSubview(label)
//        cell.addSubview(imageView)
    }
        
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        editFavoriteArray(indexPath: indexPath)
    }
        
    func editFavoriteArray(indexPath:IndexPath){
        let dic = dataArray![indexPath.row] as! Dictionary<String,Any>
        var bool = false
        let ID = dic["id"]! as? String
        var index:Int = 0
        if((favoriteArray?.count)! > 0){
            for i in 0...favoriteArray!.count-1 {
                let favoriteDic = favoriteArray![i] as! Dictionary<String,Any>
                let favoriteID = favoriteDic["id"] as? String
                if (ID == favoriteID){
                    index = i
                    bool = true
                    break
                }
            }
        }

        if(bool){
            favoriteArray?.remove(at: index)
        }else{
            favoriteArray?.append(dic)
        }
        userDefault.set(favoriteArray, forKey: "favoriteArray")
    }
        
    func getUrlString(dic:Dictionary<String,Any>) -> String{
        let farm = dic["farm"]!
        let secret = dic["secret"]!
        let ID = dic["id"]!
        let server = dic["server"]!
        return "https://farm\(farm).staticflickr.com/\(server)/\(ID)_\(secret)_m.jpg"
    }
    
}

extension UIView{
    func getFrame()->CGRect{
        var v = self.bounds
        if #available(iOS 11.0, *) {
            v = self.safeAreaLayoutGuide.layoutFrame
        }
        return v
    }
}

