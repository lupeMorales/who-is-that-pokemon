//
//  ResultViewController.swift
//  who is that pokemon
//
//  Created by Guadalupe Morales carmona on 22/11/22.
//

import UIKit
import Kingfisher
class ResultViewController: UIViewController {
    
    @IBOutlet weak var pokeImage: UIImageView!
  
    @IBOutlet weak var resultPokemonLabel: UILabel!

    @IBOutlet weak var resultScoreLabel: UILabel!
    @IBOutlet weak var playAgainButton: UIButton!
    
    
    //MARK: - variables
    
    var pokemonName: String = ""
    var pokemonImageURL: String = ""
    var finalScore: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        resultScoreLabel.text = "Perdiste, tu puntuación fue de \(finalScore)"
        resultPokemonLabel.text = "No, es un \(pokemonName.capitalized)"
        pokeImage.kf.setImage(with: URL(string: pokemonImageURL))

    }
    

    @IBAction func playAgainButtonAction(_ sender: Any) {
        self.dismiss(animated: true)
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
