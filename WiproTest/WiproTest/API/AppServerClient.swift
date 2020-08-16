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
    
    static var sharedInstance:AppServerClient = AppServerClient()
    
    func api(url:String, param:[String:Any]?, success: @escaping ([Album]) -> Void, failure: ((NSError?) -> Void)?) -> Void {
        
        guard let loanUrl = URL(string: url) else {
            return
        }
     
        let request = URLRequest(url: loanUrl)
        let task = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) -> Void in
     
            if let error = error {
                failure?(error as NSError)
                return
            }
            // Parse JSON data
            if let dataJson = data {
                let decoder = JSONDecoder()
                let music = try? decoder.decode(MusicData.self, from: dataJson)
                success(music?.results.albummatches.album ?? [])
            }else{
                // clean code
                failure?(error as NSError? ?? NSError(domain: "n/a", code: 0, userInfo: [:]))
            }
        })
        task.resume()
        
    }
    
    
    
    //MARK: Imageview Downloader
    
    private var downloadTasks = [URL: DownloadTask]()
    private var session: URLSession? =  URLSession(configuration: .default)
    
    func download(fromURL url: URL, completion: @escaping RequestCompletionHandler) {
        
        if downloadTasks.keys.contains(url){
            let downloadTask = downloadTasks[url]
            downloadTask?.completionHandler = completion
            //downloadTask?.priority = URLSessionTask.highPriority
        }else{
            let downloadTask = session?.downloadTask(with: url, completionHandler: {[weak self] (tempLocalUrl, response, error) in
                let completionHandler = self?.downloadTasks[url]?.completionHandler
                if self?.isSuccessResponse(response, error) ?? false, let data = self?.dataFrom(tempLocalUrl){
                    completionHandler?(data, nil)
                }else{
                    completionHandler?(nil, error)
                }
                
                self?.downloadTasks.removeValue(forKey: url)
            })
            let task = DownloadTask(completionHandler: completion)
            downloadTasks[url] = task
            downloadTask?.resume()
        }
    }
    private func dataFrom(_ tempLocalUrl: URL?) -> Data!{
        guard let tempLocalUrl = tempLocalUrl else{
            return nil
        }
        
        do{
            let data = try Data(contentsOf: tempLocalUrl)
            return data
        }catch{
            return nil
        }
    }
    private func isSuccessResponse(_ response: URLResponse?,_ error: Error?)-> Bool{
        if let httpResponse: HTTPURLResponse = response as? HTTPURLResponse{
            switch httpResponse.statusCode{
            case 200...202:
                return true
            default:
                return false
            }
        }else{
            return false
        }
    }

    func reducePriorityOfTask(withURL url: URL){
        if downloadTasks.keys.contains(url){
            let downloadTask = downloadTasks[url]
            downloadTask?.priority = URLSessionTask.lowPriority
        }
    }

}
typealias RequestCompletionHandler = (Data?, Error?) -> Void
class DownloadTask:  URLSessionTask{
    var completionHandler: RequestCompletionHandler
    init(completionHandler: @escaping RequestCompletionHandler) {
        self.completionHandler = completionHandler
    }
}
