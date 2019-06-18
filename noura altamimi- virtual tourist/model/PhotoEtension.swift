//
//  PhotoEtension.swift
//  noura altamimi- virtual tourist
//
//  Created by noura tamimi on 15/06/2019.
//  Copyright © 2019 noura tamimi. All rights reserved.
//


import UIKit

extension Photo {
    func set(image: UIImage){
        self.image = image.pngData()
    }
    
    func getImage()-> UIImage? {
        return (image==nil) ? nil : UIImage(data:image!)
    }
    public override func awakeFromInsert() {
        super.awakeFromInsert()
        creationDate = Date()
    }
}
