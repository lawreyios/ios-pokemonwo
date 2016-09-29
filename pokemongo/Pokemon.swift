//
//  Pokemon.swift
//  pokemongo
//
//  Created by Lawrence Tan on 19/7/16.
//  Copyright © 2016 2359 Media Pte Ltd. All rights reserved.
//

import Foundation

struct Pokemon {
    
    
    let kPokemonNameKey = "name"
    let kPokemonScoreKey = "score"
    
    var name: String
    var score: Int
    var imagePath: String
    
    init?(dictionary: [String: AnyObject]){
        if let name = dictionary[kPokemonNameKey], score = dictionary[kPokemonScoreKey] {
            self.name = name as! String
            self.score = score as! Int
            self.imagePath = "https://firebasestorage.googleapis.com/v0/b/sharingsession01.appspot.com/o/\(name).png?alt=media"
        }else{
            return nil
        }
    }
    
}