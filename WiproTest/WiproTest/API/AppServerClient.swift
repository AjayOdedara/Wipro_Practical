//
//  AppServerClient.swift
//  WiproTest
//
//  Created by Ajay Odedra on 15/08/20.
//  Copyright © 2020 Ajay Odedra. All rights reserved.
//

import Foundation

typealias JSON = Dictionary<String, Any>
typealias Codable = Decodable & Encodable

class AppServerClient {
    
    static var sharedInstance:AppServerClient = AppServerClient()
    
    /**
    Use to call Api with current search query from Last.fm.
    If any objects exist in database, they will be updated.
    
    - Parameter url: Url with currentPage and Query search
    */
    func api(url:String, success: @escaping ([Album]) -> Void, failure: ((NSError?) -> Void)?) -> Void {
        
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
            guard let jsonData = data else {
                failure?(error as NSError? ?? NSError(domain: "n/a", code: 0, userInfo: [:]))
                return
            }
            let json = JSONDecoder()
            let music = try? json.decode(MusicData.self, from: jsonData)
            success(music?.results.albummatches.album ?? [])

        })
        
        task.resume()
        
    }
    
    private var downloadTasks = [URL: DownloadTask]()
    private var session: URLSession? =  URLSession(configuration: .default)
    
    /**
       Use to download the Image from Url.
       
       - Parameter fromUrl: Takes the url of image
       */
    
    //MARK: Image Downloader
    
    func download(fromURL url: URL, completion: @escaping RequestCompletionHandler) {
        
        if downloadTasks.keys.contains(url){
            let downloadTask = downloadTasks[url]
            downloadTask?.completionHandler = completion
            //AMRK: Todo - Future Enhancement
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
    
    /**
       Use to convert data from url which we using for download image
       
       - Parameter tempLocalUrl: convert to data
       */
    
    private func dataFrom(_ tempLocalUrl: URL?) -> Data! {
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
    /**
     Checks the response status of the donwload image
       
       - Parameter response: response  of image download block
       */
    
    private func isSuccessResponse(_ response: URLResponse?,_ error: Error?) -> Bool {
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

    /**
    Reduce the priority of the cell image which is not visible
      
     - Parameter withURL: It will check if contains the task of not
    */
    func reducePriorityOfTask(withURL url: URL) {
        if downloadTasks.keys.contains(url){
            let downloadTask = downloadTasks[url]
            downloadTask?.priority = URLSessionTask.lowPriority
        }
    }

}
typealias RequestCompletionHandler = (Data?, Error?) -> Void
class DownloadTask:  URLSessionTask {
    var completionHandler: RequestCompletionHandler
    init(completionHandler: @escaping RequestCompletionHandler) {
        self.completionHandler = completionHandler
    }
}
