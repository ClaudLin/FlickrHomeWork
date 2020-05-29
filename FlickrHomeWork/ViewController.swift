//
//  ViewController.swift
//  FlickrHomeWork
//
//  Created by 1900347_Claud on 2020/5/29.
//  Copyright © 2020 1900347_Claud. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UITextFieldDelegate {

    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var pageCountTF: UITextField!
    @IBOutlet weak var searchTypeTF: UITextField!
    
    override func viewDidLoad() {
            super.viewDidLoad()
            navigationItem.title = "搜尋輸入頁"
            elementInit()
            // Do any additional setup after loading the view, typically from a nib.
        }
            
        func elementInit(){
            searchButton.addTarget(self, action: #selector(searchButtonAction), for: .touchDown)
            searchButton.isUserInteractionEnabled = false
            searchTypeTF.delegate = self
            pageCountTF.delegate = self
            searchTypeTF.tag = 0
            pageCountTF.tag = 1
            pageCountTF.keyboardType = .numberPad
            searchTypeTF.addTarget(self, action: #selector(textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
            pageCountTF.addTarget(self, action: #selector(textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
        }
        
        @objc func searchButtonAction() {
            let vc = ShowViewController()
            let str = searchTypeTF.text?.trimmingCharacters(in: .whitespaces)
            let maxInt = (pageCountTF.text?.trimmingCharacters(in: .whitespaces))!
            vc.maxInt = maxInt
            vc.searchStr = str ?? ""
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        @objc func textFieldDidChange(_ textfield:UITextField){
            let userDefaults = UserDefaults.standard
            let searchTypeStr = searchTypeTF.text
            let pageCountTFStr = pageCountTF.text
            let str = searchTypeStr?.trimmingCharacters(in: .whitespaces)
            let str2 = pageCountTFStr?.trimmingCharacters(in: .whitespaces)
            if(str != "" && str2 != ""){
                buttonCanAction()
                userDefaults.set(str, forKey: "searchText")
                userDefaults.set(str2, forKey: "searchCount")
            }else{
                buttonNotAction()
            }
        }
        
        func buttonCanAction(){
            searchButton.isUserInteractionEnabled = true
            searchButton.setTitleColor(UIColor.white, for: .normal)
            searchButton.backgroundColor = UIColor.blue
        }
        
        func buttonNotAction() {
            searchButton.isUserInteractionEnabled = false
            searchButton.setTitleColor(UIColor.white, for: .normal)
            searchButton.backgroundColor = UIColor.gray
        }
        
        func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            if(textField.tag == 1){
                let length = string.lengthOfBytes(using: .utf8)
                for i in 0..<length{
                    let char = (string as NSString).character(at: 0)
                    if char < 48{
                        return false
                    }
                    if char > 57{
                        return false
                    }
                }
            }
            return true
        }


}

