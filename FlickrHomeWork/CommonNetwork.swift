//
//  CommonNetwork.swift
//  flickr
//
//  Created by 1900347_Claud on 2020/5/28.
//  Copyright © 2020 林書郁. All rights reserved.
//

import UIKit
private let sharedInstance = CommonNetwork()
class CommonNetwork: NSObject,URLSessionDelegate,URLSessionTaskDelegate {
    class var sharedManager : CommonNetwork {
        return sharedInstance
    }
    
    func fetchedDataByDataTask(from request: URLRequest, completion: @escaping (Data) -> Void){
        let task = URLSession.shared.dataTask(with: request){(data,response,error) in
            if error != nil{
                print("url發生問題\(error.debugDescription)")
            }else{
                if data != nil {
                    completion(data!)
                }else {
                    print("Data is nil.")
                }
                //                guard let resultData = data else {return}
            }
        }
        task.resume()
    }
    
    func dataToDictionary(data:Data) -> Dictionary<String,Any>{
        var dic = Dictionary<String,Any>()
        do {
            let json = try JSONSerialization.jsonObject(with:data, options: .mutableContainers)
            dic = json as! Dictionary<String,Any>
        } catch  {
            print("\(error)")
        }
        return dic
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
         if let data = try? Data(contentsOf: location) {
            let dic = dataToDictionary(data: data)
            print(dic)
        }
    }

    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
         if error != nil {
            print("發生問題： \(error!)")
        }
    }
}
