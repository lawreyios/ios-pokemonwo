//
//  PGCatchSceneViewController.swift
//  pokemongo
//
//  Created by Lawrence Tan on 19/7/16.
//  Copyright © 2016 2359 Media Pte Ltd. All rights reserved.
//

import UIKit

class PGCatchSceneViewController: UIViewController {

    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var pokemonImageView: UIImageView!
    
    var pokemon: Pokemon?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        generateRandomPokemon()
    }
    
    func generateRandomPokemon() {
        let randomNumber = Int(arc4random_uniform(UInt32(60)))
        var randomPokemonImage: UIImage?
        
        if randomNumber < pgClient.pokemons.count {
            if let randomPokemon: Pokemon? = pgClient.pokemons[randomNumber] {
                randomPokemonImage = pgClient.pokemonPictures[randomPokemon!.name]
                pokemon = randomPokemon
            }
        }else{
            randomPokemonImage = pgClient.pokemonPictures[pgClient.pokemons[5].name]
            pokemon = pgClient.pokemons[5]
        }

        
        pokemonImageView.image = randomPokemonImage
        lblName.text = "\(pokemon!.name.uppercaseString)!"
        NSTimer.scheduledTimerWithTimeInterval(2, target: self, selector: #selector(self.onClose), userInfo: nil, repeats: false)
        updateScore(pokemon!)
    }
    
    func updateScore(pokemon: Pokemon) {
        var trainerScore: Int = appDelegate.trainerScore
        trainerScore+=pokemon.score
        let score: Dictionary<String, AnyObject> = [
            "score": trainerScore
        ]
        PGClient.updatePokemonTrainerScore(appDelegate.trainerId, score: score) { (finished, error) in
            
        }
    }
    
    func onClose() {
        
        if pokemon?.name == "mew" {
        
            let alertController = UIAlertController(title: "You caught MEW!", message: "Submit your name", preferredStyle: UIAlertControllerStyle.Alert)
            let saveAction = UIAlertAction(title: "Submit", style: UIAlertActionStyle.Default, handler: {
                alert -> Void in
                
                let firstTextField = alertController.textFields![0] as UITextField
                PGClient.updatePokemonSpecialTrainerName(firstTextField.text!, completionHandler: { (finished, error) in
                    
                })
                self.dismissViewControllerAnimated(true, completion: nil)
                
            })
            
            let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler: {
                (action : UIAlertAction!) -> Void in
                self.dismissViewControllerAnimated(true, completion: nil)
            })
            alertController.addTextFieldWithConfigurationHandler { (textField : UITextField!) -> Void in
                textField.placeholder = "Enter your name"
            }
            
            alertController.addAction(saveAction)
            alertController.addAction(cancelAction)
            
            self.presentViewController(alertController, animated: true, completion: nil)
        }else{
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    

}
