//
//  ViewController.swift
//  ShopifyChallenge
//
//  Created by Fabian Vergara on 2016-12-17.
//  Copyright © 2016 Studio. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON


class ViewController: UIViewController {

    var dispatchGroup = DispatchGroup()
    var totalEarnings = 0.0


    override func viewDidLoad() {
        super.viewDidLoad()
        
        doRequestCall()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func buildStringGetRequest(counter: Int) -> String{
        return  "https://shopicruit.myshopify.com/admin/orders.json?page=" + String(counter) + "&access_token=c32313df0d0ef512ca64d5b336a0d7c6"

    }
    
    func doRequestCall(){
        var counter = 10
    
        for i in 1 ..< counter{
            
            dispatchGroup.enter()
            Alamofire.request("https://shopicruit.myshopify.com/admin/orders.json?page=" + String(i) + "&access_token=c32313df0d0ef512ca64d5b336a0d7c6").responseJSON { response in
                print(response.result)   // result of response serialization
                
                if let JSON = response.result.value as? [String: Any]{
                    
                    print(">>>>Doing request \(i)")

                    let ordersInResponse = JSON["orders"] as? [[String: Any]]

                    if ordersInResponse!.count == 0{
                        print("orders in response is 0")
                        counter = 0
                        self.dispatchGroup.leave()
                        return
                    }else{
                        counter += 1
                        for order in ordersInResponse!{
                            let price = (order["total_price"]! as AnyObject).doubleValue
                            self.totalEarnings += price!
                        }
                    }
                }
                self.dispatchGroup.leave()
            }
        }
        
        
        dispatchGroup.notify(queue: DispatchQueue.main) {
            print("Total earnings = " + String(self.totalEarnings))
            
        }
    }


}

