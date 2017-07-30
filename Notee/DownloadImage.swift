//
//  DownloadImage.swift
//  Notee
//
//  Created by Mathis Delaunay on 11/07/2017.
//  Copyright © 2017 Wathis. All rights reserved.
//

import Foundation

class DownloadFromUrl {
    init() {
        
    }
    
    func getDataFromUrl(url: URL, completion: @escaping (_ data: Data?, _  response: URLResponse?, _ error: Error?) -> Void) {
        URLSession.shared.dataTask(with: url) {
            (data, response, error) in
            completion(data, response, error)
            }.resume()
    }
    
    func downloadImage(url: URL,completion: @escaping (UIImage) -> Void) {
        getDataFromUrl(url: url) { (data, response, error)  in
            guard let data = data, error == nil else { return }
            DispatchQueue.main.async() { () -> Void in
                completion(UIImage(data: data)!)
            }
        }
    }
    
    func downloadCommentProfilImage(url: URL, index : Int,completion: @escaping (UIImage,Int) -> Void) {
        getDataFromUrl(url: url) { (data, response, error)  in
            guard let data = data, error == nil else { return }
            DispatchQueue.main.async() { () -> Void in
                completion(UIImage(data: data)!,index)
            }
        }
    }
    
}
