//
//  SearchObject.swift
//  FlickrHomeWork
//
//  Created by 林書郁 on 2020/5/31.
//  Copyright © 2020 1900347_Claud. All rights reserved.
//

import UIKit
private let sharedInstance = SearchObject()
class SearchObject: NSObject {
    class var sharedManager : SearchObject {
        return sharedInstance
    }
    var searchType:String?
    var pageCount:String?
    
    deinit {
        print("SearchObject is being deinitialized" )
    }
    
}
