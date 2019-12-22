//
//  Breed.swift
//  BreedApi
//
//  Created by Denis Zhukov on 17/12/2019.
//  Copyright © 2019 Denis Zhukov. All rights reserved.
//

import Foundation
import UIKit
import ResourceNetworking

protocol BreedDelegate: AnyObject {
    func iconDidLoaded(breed: Breed)
}


class Breed{
    let uuid = UUID().uuidString
    var breedName: String
    var subBreedName: String?
    var imageURL: String?
    weak var delegate: BreedDelegate?
    private(set) var icon: UIImage? {
        didSet {
            delegate?.iconDidLoaded(breed: self)
        }
    }
    
    private var cancel: Cancellation?
    
    
    
    init(breed: String, subBreed: String? = nil,imageURL: String? = nil){
        self.breedName = breed
        self.subBreedName = subBreed
        self.imageURL = imageURL
        self.icon = nil
    }
}

extension Breed {
    func cancelDownloadIcon() {
       // print("CANCEL")
           cancel?.cancel()
           cancel = nil
       }
    
    func downloadIcon(with helper: NetworkHelper, subName: String?, index: Int) {
        if (icon != nil) || (cancel != nil) {
            return
        }
        let iconUrl = ResourceFactory().createImageURL(breed: breedName, subbreed: (subName) ?? "")
        print(iconUrl)
        _ = helper.load(resource: iconUrl) { [weak self] result in
            switch result {
            case .success(let iconUrlResource):
                guard let breedIconResource = ResourceFactory().createIconResource(from: iconUrlResource.message)else {
                    print("BreedIconResource error")
                    return
                }
                self?.cancel = helper.load(resource: breedIconResource, completion: {[weak self] (result) in
                    switch result {
                    case .success(let image):
                        self?.icon = image
                    case .failure(let error):
                        print(error)
                    }
                    self?.cancel = nil
                })
                
            case .failure(let error):
                print(error)
                break
            }
        }
    }
}

extension Breed: Equatable {
    static func == (lhs: Breed, rhs: Breed) -> Bool {
        lhs.uuid == rhs.uuid
    }
}

extension Breed: Comparable {
    static func < (lhs: Breed, rhs: Breed) -> Bool {
        lhs.breedName < rhs.breedName
    }
}
