//
//  PGHighscoreCell.swift
//  pokemongo
//
//  Created by Lawrence Tan on 21/7/16.
//  Copyright © 2016 2359 Media Pte Ltd. All rights reserved.
//

import UIKit

class PGHighscoreCell: UITableViewCell {

    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblScore: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .None
    }

    func setDetails(trainer: Trainer) {
        lblName.text = trainer.name.uppercaseString
        lblScore.text = "\(trainer.score)"
    }
}
