//
//  ViewController.swift
//  who is that pokemon
//
//  Created by Alex Camacho on 01/08/22.
//

import UIKit
import Kingfisher

class PokemonViewController: UIViewController {
    
    
    //MARK: - outlets
    @IBOutlet weak var pokemonImage: UIImageView!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet var answerButtons: [UIButton]!
    
    //decimos a view controller q vamos a trabahjar con las structura de PokemonManager
    //lazy para q sólo s eejecute en el momento q se necesita, ni antes ni despues
    
    // MARK: - variables
    lazy var pokemonManager = PokemonManager()
    lazy var imageManager = ImageManager()
    lazy var game = GameModel()
    
    var random4Pokemons: [PokemonModel] = [] {
        didSet {
            updateButtonTitle()
        }
    }
    var correctAnswer: String = ""
    var correctAnswerImage: String = ""
    
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pokemonManager.delegate = self
        imageManager.delegate = self
        
        scoreLabel.text = "Puntuación: \(game.score)"
        messageLabel.text = ""
        createButtons()
        
        
        //carga datos de la api
        pokemonManager.fetchPokemonAPI()
        
    }
    
    //MARK: - Actions
    
    
    @IBAction func answerButtonAction(_ sender: UIButton) {
        let userAnswer = sender.title(for: .normal)!
        
        if game.checkAnswer(userAnswer, correctAnswer) {
            messageLabel.text = " Sí, es un \(userAnswer.capitalized)"
            scoreLabel.text = "Puntuación: \(game.score)"
            
            //sender te dice q botton se ha pulsado
            sender.layer.borderColor = UIColor.systemGreen.cgColor
            sender.layer.borderWidth = 2
            
            showCorrectAnswerImage()
            getNewPokemon()
           
            
        } else {
            
            self.performSegue(withIdentifier: "goToResults", sender: self)
            
            
        }
        
    }
    
    // MARK: -functions
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       
        if segue.identifier == "goToResults" {
            let destination = segue.destination as! ResultViewController
            destination.pokemonName = correctAnswer
            destination.pokemonImageURL = correctAnswerImage
            destination.finalScore = game.score
            resetGame()
        }
    }
    
    func createButtons () {
        for button in answerButtons {
            button.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5).cgColor
            button.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
            button.layer.shadowOpacity = 1
            button.layer.shadowRadius = 0
            button.layer.masksToBounds = false
            button.layer.cornerRadius = 10.0
            
        }
        
    }
    
    func updateButtonTitle(){
        for (index, button) in answerButtons.enumerated() {
            DispatchQueue.main.async {
                button.setTitle(self.random4Pokemons[safe: index]?.name.capitalized, for: .normal)
            }
        }
    }
    
    func showCorrectAnswerImage(){
        let url = URL(string:correctAnswerImage)
        pokemonImage.kf.setImage(with: url)
        
    }
    func getNewPokemon() {
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false) { timer in
     
            self.pokemonManager.fetchPokemonAPI()
            self.messageLabel.text = ""
            for button in self.answerButtons {
                     button.layer.borderWidth = 0.0
                 }
        }
        
     
    }
    
    
    func resetGame() {
        
        pokemonManager.fetchPokemonAPI()
        messageLabel.text = ""
        for button in answerButtons {
            button.layer.borderWidth = 0.0
        }
        game.resetScore(score: 0)
        scoreLabel.text = "Puntuación: \(game.score)"
        
    }
    
}


// MARK: - extensions
extension PokemonViewController: PokemonManagerDelegate {
    func didUpdatePokemon(pokemons: [PokemonModel]) {
        random4Pokemons = (pokemons.choose(4))
        
        let index = Int.random(in: 0...3)
        let imageData = random4Pokemons[index].imageURL
        correctAnswer = random4Pokemons[index].name
        
        imageManager.fetchPokeImage(url: imageData)
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
    
    
}


extension PokemonViewController: ImageManagerDelegate {
    
    func didUpdatePokeImage(image: ImageModel) {
        correctAnswerImage = image.imageURL
        
        DispatchQueue.main.async { [self] in
            let url = URL(string: image.imageURL)
            let effect = ColorControlsProcessor(brightness: -1, contrast: 1, saturation: 1, inputEV: 0)
            pokemonImage.kf.setImage(with: url, options: [.processor(effect)])
            
        }
    }
    
    func didFailWithErrorPokeImage(error: Error) {
        print(error)
    }
    
    
}

//limita los indices
extension Collection where Indices.Iterator.Element == Index {
    public subscript(safe index: Index) -> Iterator.Element? {
        return (startIndex <= index && index < endIndex) ? self[index] : nil
    }
}
//elige los 4 pokemons de manera random
extension Collection {
    func choose(_ n: Int) -> Array<Element> {
        Array(shuffled().prefix(n))
    }
}
