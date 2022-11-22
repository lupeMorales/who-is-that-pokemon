//
//  PokemonManager.swift
//  who is that pokemon
//
//  Created by Guadalupe Morales carmona on 21/11/22.
//


//lógica para el consumo de API
//creamos structuras porque no vamos a generar distintas instancias

import Foundation


    protocol PokemonManagerDelegate {
        func didUpdatePokemon(pokemons: [PokemonModel])
        func didFailWithError(error: Error)
    }
    
    
    struct PokemonManager {
        let pokemonURL: String = "https://pokeapi.co/api/v2/pokemon?limit=898&offset=0"
        var delegate: PokemonManagerDelegate?
    
        func fetchPokemonAPI(){
            performRequest(with: pokemonURL)
        }
        private func performRequest(with urlString: String){
            //1. get URL
            if let url = URL(string: urlString) {
                //2. Create de URL Session
                let session = URLSession(configuration: .default)
                //3. Give the session a task
                let task = session.dataTask(with: url) {data, response,error in
                    if error != nil {
                        self.delegate?.didFailWithError(error: error!)
                    }else{
                        if let safeData = data {
                            if let pokemon = self.parseJSON(pokemonData: safeData){
                                self.delegate?.didUpdatePokemon(pokemons: pokemon)
    
                            }
                        }
                    }
    
                }
    
                //4. Start the task
                task.resume()
    
            }
    
        }
    
        private func parseJSON(pokemonData : Data) -> [PokemonModel]? {
            let decoder = JSONDecoder()
            do{
                let decodeData = try decoder.decode(PokemonData.self, from: pokemonData)
                let pokemon = decodeData.results?.map{
                    PokemonModel(name: $0.name, imageURL: $0.url )
                }
                return pokemon
            }
            catch{
                return nil
            }
        }
    
    }
