//
//  WLClient.swift
//  Wesley
//
//  Created by 2359 Lawrence on 28/6/16.
//  Copyright © 2016 2359 Media Pte Ltd. All rights reserved.
//

import Foundation
import FirebaseDatabase
import Firebase
import Nuke

class PGClient : NSObject {
    
    // MARK: Properties
    var rootRef = FIRDatabase.database().reference()
    var pokemons = [Pokemon]()
    var pokemonPictures = [String : UIImage]()
    var trainers = [Trainer]()
    var specialTrainers = [SpecialTrainer]()
    
    /* Shared session */
    var session: NSURLSession
    
    var count:Int = 0
    
    // MARK: Initializers
    
    override init() {
        session = NSURLSession.sharedSession()
        super.init()
    }
    
    // MARK: Shared Instance
    
    class func sharedInstance() -> PGClient {
        
        struct Singleton {
            static let sharedInstance = PGClient()
        }
        
        return Singleton.sharedInstance
    }
    
    class func getTrainer(trainerId: String, completionHandler: (score: Int?, error: NSError?) -> Void) {
        PGClient.sharedInstance().rootRef.child("trainers").observeSingleEventOfType(.Value, withBlock: { snapshot in
            
            if let trainerData = snapshot.value as? NSArray {
                var count = -1
                for data in trainerData {
                    count += 1
                    if let trainerName = data["name"] as? String, trainerTeam = data["team"] as? String, score = data["score"] as? Int {
                        if (trainerId == trainerTeam) {
                            appDelegate.trainerScore = score
                            appDelegate.trainerId = count
                        }
                    }
                }
            }
        
        })
    }
    
    class func getTrainersFromServer(completionHandler: (hasResult: Bool, error: NSError?) -> Void) {
        // observeEventType is called whenever anything changes in the Firebase - new scores.
        // It's also called here in viewDidLoad().
        // It's always listening.
        
        PGClient.sharedInstance().rootRef.child("trainers").observeEventType(.Value, withBlock: { snapshot in
            
            // The snapshot is a current look at our jokes data.
            
            pgClient.trainers.removeAll()
            
            if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot] {
                
                for snap in snapshots {
                    
                    // Make our trainers array for the tableView.
                    
                    if let postDictionary = snap.value as? Dictionary<String, AnyObject> {
                        if let score = (postDictionary["score"] as? Int), name = postDictionary["name"] {
                            let trainer = Trainer(name: name as! String, score: score)
                            pgClient.trainers.append(trainer)
                        }
                    }
                }
                
                pgClient.trainers.sortInPlace({$0.score > $1.score})
                NSNotificationCenter.defaultCenter().postNotificationName(kHighscoreUpdatedNotification, object: nil)
                
            }

        })
    }
    
    class func getSpecialTrainersFromServer(completionHandler: (hasResult: Bool, error: NSError?) -> Void) {
        // observeEventType is called whenever anything changes in the Firebase - new scores.
        // It's also called here in viewDidLoad().
        // It's always listening.
        PGClient.sharedInstance().count = 0
        
        PGClient.sharedInstance().rootRef.child("specialTrainers").observeEventType(.Value, withBlock: { snapshot in
            
            // The snapshot is a current look at our jokes data.
            
            pgClient.specialTrainers.removeAll()
            
            if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot] {
                
                for snap in snapshots {
                    
                    // Make our trainers array for the tableView.
                    
                    if let postDictionary = snap.value as? Dictionary<String, AnyObject> {
                        if let name = postDictionary["name"] {
                            let trainer = SpecialTrainer(name: name as! String)
                            pgClient.specialTrainers.append(trainer)
                        }
                    }
                }
                
                PGClient.sharedInstance().count+=1
                if PGClient.sharedInstance().count == 2 {
                    NSNotificationCenter.defaultCenter().postNotificationName(kHighscoreUpdatedNotification, object: nil)
                    NSNotificationCenter.defaultCenter().postNotificationName(kShowAlertNotification, object: nil)
                }
                
            }
            
        })
    }
    
    class func getPokemonsFromServer(completionHandler: (hasResult: Bool, error: NSError?) -> Void) {
        PGClient.sharedInstance().pokemons.removeAll()
        PGClient.sharedInstance().rootRef.child("pokemons").observeSingleEventOfType(.Value, withBlock: { snapshot in
            
            if let json = snapshot.value as? NSArray {
                for jsonDictionary in json {
                    let newPokemon = Pokemon(dictionary: jsonDictionary as! [String : AnyObject])
                    PGClient.sharedInstance().pokemons.append(newPokemon!)
                }
                completionHandler(hasResult: true, error: nil)
            }else{
                completionHandler(hasResult: false, error: nil)
            }
        })
    }
    
    class func updatePokemonTrainerScore(uid: Int, score: Dictionary<String, AnyObject>, completionHandler: (finished: Bool, error: NSError?) -> Void) {
        
        PGClient.sharedInstance().rootRef.child("trainers").child("\(uid)").updateChildValues(score)
        appDelegate.trainerScore = score["score"] as! Int
        
    }
    
    class func updatePokemonSpecialTrainerName(name: String, completionHandler: (finished: Bool, error: NSError?) -> Void) {
        
        PGClient.sharedInstance().rootRef.child("specialTrainers").child("0").updateChildValues(["name":name])
        
    }
    
    class func nukeTaskForImage(filePath: String, completionHandler: (image: UIImage?, error: NSError?) ->  Void) {
        
        var request = ImageRequest(URLRequest: NSURLRequest(URL: NSURL(string: filePath)!))
        
        // Set target size (in pixels) and content mode that describe how to resize loaded image
        request.contentMode = .AspectFill
        
        // Control memory caching
        request.memoryCacheStorageAllowed = true // true is default
        request.memoryCachePolicy = .ReturnCachedImageElseLoad // Force reload
        
        // Change the priority of the underlying NSURLSessionTask
        request.priority = NSURLSessionTaskPriorityHigh
        
        Nuke.taskWith(request) {
            // - Image is resized to fill target size
            // - Blur filter is applied
            let image = $0.image
            if image != nil {
                completionHandler(image: image, error: nil)
            }else{
                completionHandler(image: nil, error: nil)
            }
            }.resume()
        
    }
    
    
}
