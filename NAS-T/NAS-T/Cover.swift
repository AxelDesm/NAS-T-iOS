//
//  Cover.swift
//  NAS-T
//
//  Created by Axel on 30/11/16.
//  Copyright © 2016 Axel. All rights reserved.
//

import UIKit

class Cover {
    let id: String
    let date: Date
    let type: String
    let thumbnail: UIImage?
    var gallery = [UIImage]()
    
    init?(id: String, date: Date, type: String, thumbnail: UIImage?) {
        self.id = id
        self.type = type
        self.date = date
        self.thumbnail = thumbnail
        
        if type.isEmpty {
            return nil
        }
    }
    
    convenience init?(type: String, thumbnail: UIImage?) {
        let date = Date()
        self.init(id: "", date: date, type: type, thumbnail: thumbnail)
    }
    
    func stringDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        let date = dateFormatter.string(from: self.date)
        return date
    }
}
