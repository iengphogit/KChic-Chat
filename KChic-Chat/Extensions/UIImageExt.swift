//
//  UIImageExt.swift
//  KChic-Chat
//
//  Created by Iengpho on 11/14/18.
//  Copyright © 2018 Iengpho. All rights reserved.
//

import UIKit
extension UIImageView {
    
    func downloadImageWithUrl(url:URL){
        downloadImage(from: url)
    }
    
    func downloadImage(from url: URL){
        print("Download Started")
        getData(from: url) { data, response, error in
            guard let data = data, error == nil else { return }
            print(response?.suggestedFilename ?? url.lastPathComponent)
            print("Download Finished")
            DispatchQueue.main.async() {
                self.image = UIImage(data: data)!
                
            }
        }
    }
    
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
}
