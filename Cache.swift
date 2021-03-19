//
//  Cache.swift
//  Alamofire
//
//  Created by Prakhar Srivastava on 19/03/21.
//

import Foundation

class Cache{
    
    let userDefault = UserDefaults.standard
    
    public func saveString(value : String, key : String){
      userDefault.set(value, forKey: key)
    }
    public func saveBool(value : Bool, key : String){
        userDefault.set(value, forKey: key)
      }
  
    
    public func getString(key : String){
        userDefault.string(forKey: key)
    }
    
    public func getBool(key : String){
        userDefault.bool(forKey: key)
      }
    
}
