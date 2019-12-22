//
//  BreedAPI.swift
//  BreedApi
//
//  Created by Denis Zhukov on 17/12/2019.
//  Copyright © 2019 Denis Zhukov. All rights reserved.
//

import Foundation
import ResourceNetworking
import UIKit

struct BreedAPI: Codable {
    let message: [String: [String]]
   //let id: [String]?
}

struct BreedImageAPI: Codable {
    let message: String
}

class ResourceFactory {
    func createResource() -> Resource<BreedAPI> {
        return Resource(url: URL(string: "https://dog.ceo/api/breeds/list/all")!, headers: nil)
    }

    func createImageURL(breed: String, subbreed: String = "") -> Resource<BreedImageAPI> {
        let path = subbreed.isEmpty ? breed : breed + "/" + subbreed
        return Resource(url: URL(string: "https://dog.ceo/api/breed/" + path + "/images/random")!, headers: nil)
    }
    
    func createIconResource(from urlString: String) -> Resource<UIImage>? {
           guard let url = URL(string: urlString) else {
            return nil
           }
        
           let parse: (Data) throws -> UIImage = {data in
               guard let image = UIImage(data: data) else {
                   throw NSError(domain: "data image error \(data)", code: 129, userInfo: [NSLocalizedDescriptionKey: NSLocalizedString("MyString", comment: "MyComment")])
               }
               return image
           }
           return Resource(url: url, method: .get, parse: parse)
       }
    
}
