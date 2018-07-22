//
//  DataManager.swift
//  YouMeetsGuide
//
//  Created by Ryou on 2018/07/22.
//  Copyright © 2018年 Ryou. All rights reserved.
//

import UIKit

class DataManager: NSObject {
    static var shared:DataManager = {
        return DataManager();
    }();
    
    class func csvToArray (name:String) -> Array<String>? {
        if let csvPath = Bundle.main.path(forResource: name, ofType: "csv") {
            do {
                let csvStr = try String(contentsOfFile:csvPath, encoding:String.Encoding.utf8)
                let csvArr = csvStr.components(separatedBy: .newlines)
                return csvArr
            } catch let error as NSError {
                print(error.localizedDescription)
            }
            
        }
        return nil
    }
    class func csvToArray (str:String) -> Array<String>? {
        do {
            let csvArr = str.components(separatedBy: ",")
            return csvArr
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        return nil
    }
}
