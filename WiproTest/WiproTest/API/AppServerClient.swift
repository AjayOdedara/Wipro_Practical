//
//  AppServerClient.swift
//  WiproTest
//
//  Created by Ajay Odedra on 15/08/20.
//  Copyright © 2020 Ajay Odedra. All rights reserved.
//

import Foundation
// MARK: - AppServerClient

typealias JSON = Dictionary<String, Any>
    
typealias Codable = Decodable & Encodable


class AppServerClient {
    
    class var sharedInstance: AppServerClient {
        struct Static {
            static let instance: AppServerClient! = AppServerClient()
        }
        return Static.instance
    }
    
    func api(url:String, param:[String:Any]?, success: @escaping (JSON) -> Void, failure: ((NSError?) -> Void)?) -> Void {
        
        guard let loanUrl = URL(string: url) else {
            return
        }
     
        let request = URLRequest(url: loanUrl)
        let task = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) -> Void in
     
            if let error = error {
                print(error)
                return
            }
     
            // Parse JSON data
            if let dataJson = data {
                print(data)
                
                //let decoder = JSONDecoder()
                 
            }
        })
        task.resume()
        
    }


}
