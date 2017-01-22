//
//  CoverRepository.swift
//  NAS-T
//
//  Created by Axel on 22/01/17.
//  Copyright © 2017 Axel. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

final class CoverRepository {
    
    func getAll(completionHandler: @escaping ([Cover]?) -> ()) {
        Alamofire.request("http://localhost:8080/api/covers").validate().responseJSON { response in
            if let value = response.result.value {
                let json = JSON(value)
                
                var covers = [Cover]()
                
                for cover in json.array! {
                    let data: NSData = NSData(base64Encoded: cover["thumbnail"].stringValue, options: .ignoreUnknownCharacters)!
                    let dataImage = UIImage(data: data as Data)
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "dd-MM-yyyy"
                    print(cover)
                    let date = dateFormatter.date(from: cover["date"].stringValue)!
                    let cover = Cover(id: cover["_id"].stringValue, date: date, type: cover["type"].stringValue, thumbnail: dataImage)!
                    covers.append(cover)
                }
                
                completionHandler(covers)
            }
        }
    }
    
    func add(cover: Cover, completionHandler: @escaping (Bool) -> ()) {
        let param: Parameters = [
            "type": cover.type,
            "date": cover.stringDate(),
            "thumbnail": UIImageJPEGRepresentation(cover.thumbnail!, 0.1)?.base64EncodedString() ?? ""
        ]
        
        Alamofire.request("http://localhost:8080/api/covers", method: .post, parameters: param).responseJSON { response in
            if (response.result.isSuccess) {
                completionHandler(true)
            }
            
            completionHandler(false)
        }
    }
    
    func archive(cover: Cover, completionHandler: @escaping (Bool) -> ()) {
        Alamofire.request("http://localhost:8080/api/covers/" + cover.id, method: .put).responseString { response in
            print(response)
            if (response.result.isSuccess) {
                completionHandler(true)
            }
            
            completionHandler(false)
        }
    }
    
    func getDetail(cover: Cover, completionHandler: @escaping ([UIImage]?) -> ()) {
        Alamofire.request("http://localhost:8080/api/covers/" + cover.id).validate().responseJSON { response in
            if let value = response.result.value {
                let json = JSON(value)
                
                var gallery = [UIImage]()
                
                for image in json["gallery"].array! {
                    let data: NSData = NSData(base64Encoded: image.stringValue, options: .ignoreUnknownCharacters)!
                    let dataImage = UIImage(data: data as Data)
                    gallery.append(dataImage!)
                }
                
                completionHandler(gallery)
            }
        }
    }
    
    func addImage(cover: Cover, image: UIImage, completionHandler: @escaping (Bool) -> ()) {
        let base64 = UIImageJPEGRepresentation(image, 0.1)?.base64EncodedString() ?? ""
        
        let imageParam: Parameters = [ "image": base64 ]
        
        Alamofire.request("http://localhost:8080/api/covers/" + cover.id, method: .post, parameters: imageParam).responseJSON { response in
            if (response.result.isSuccess) {
                completionHandler(true)
            }
            
            completionHandler(false)
        }
    }
}
