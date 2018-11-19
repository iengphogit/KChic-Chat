//
//  UIImageExt.swift
//  KChic-Chat
//
//  Created by Iengpho on 11/14/18.
//  Copyright © 2018 Iengpho. All rights reserved.
//

import UIKit
let imageCache = NSCache<AnyObject, AnyObject>()

extension UIImageView {
    
    func downloadImageWithUrl(url:URL){
//        self.image = nil
        if let imageFromCache = imageCache.object(forKey: url as AnyObject) as? UIImage {
            self.image = imageFromCache
            return
        }
        downloadImage(from: url)
    }
    
    func downloadImage(from url: URL){
        getData(from: url) { data, response, error in
            guard let data = data, error == nil else { return }
            DispatchQueue.main.async() {
                if let downloadImg = UIImage(data: data) {
                    imageCache.setObject(downloadImg, forKey: url as AnyObject)
                    self.image = UIImage(data: data)
                }
                
            }
        }
    }
    
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
}
