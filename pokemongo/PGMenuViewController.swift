//
//  PGMenuViewController.swift
//  pokemongo
//
//  Created by Lawrence Tan on 19/7/16.
//  Copyright © 2016 2359 Media Pte Ltd. All rights reserved.
//

import UIKit
import Nuke

class PGMenuViewController: UIViewController {

    @IBOutlet weak var btnCatch: UIButton!
    @IBOutlet weak var btnView: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    @IBAction func onCatch(sender: AnyObject) {
        LoadingOverlay.shared.showOverlay(view)
        PGClient.getPokemonsFromServer { (hasResult, error) in
            if hasResult == true {
                self.loadImages()
            }
        }
    }
    
    func loadImages() {
        var count = 1
        for pokemon in PGClient.sharedInstance().pokemons {
            PGClient.nukeTaskForImage(pokemon.imagePath, completionHandler: { (image, error) in
                let image = image
                pgClient.pokemonPictures.updateValue(image!, forKey: pokemon.name)
                count+=1
                if count == PGClient.sharedInstance().pokemons.count {
                    let destioationVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("PGCatchSceneViewController") as! PGCatchSceneViewController
                    self.presentViewController(destioationVC, animated: true, completion: nil)
                    LoadingOverlay.shared.hideOverlayView()
                }
            })
        }
        
    }
    
    @IBAction func onView(sender: AnyObject) {
        let destinationVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("PGHighscoresTableViewControllerNav") as! UINavigationController
        self.presentViewController(destinationVC, animated: true, completion: nil)
    }
    

}
