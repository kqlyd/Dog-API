//
//  BreedCellTableViewCell.swift
//  BreedApi
//
//  Created by Denis Zhukov on 22/12/2019.
//  Copyright © 2019 Denis Zhukov. All rights reserved.
//

import UIKit

class BreedTableViewCell: UITableViewCell {

    @IBOutlet weak var imageBreed: UIImageView!
    
    @IBOutlet weak var breedName: UILabel!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func configuration(breed: Breed, index: IndexPath) {
        let path:String
        if(breed.subBreedName != nil){
            path = breed.breedName + " - " + breed.subBreedName!
        }
        else { path = breed.breedName }
        breedName.text = path
        imageBreed?.image = breed.icon
        if (breed.icon == nil) {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
    }
    
}
