
import UIKit
import Alamofire
import SwiftyJSON

public class ReplaceMe{
    
    public  init(){
        
    }
    
   public func getData() {
        
        let params : [String : String] = ["name" : "prakhar", "company" : "trackier"]
      

    Alamofire.request("https://requestbin.offersoptimize.com/zwtdl6zw", method: .post, parameters: params,encoding: JSONEncoding.default).response {
            response in

            print("Success!")
            print(response)
//            if response.result.isSuccess {
//
//                print("Success! Got the data")
//
//            }
//            else {
//                print("Error \(String(describing: response.result.error))")
//            }
    
       }
     }
  }





