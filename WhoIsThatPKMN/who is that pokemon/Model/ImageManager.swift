//
//  ImageManager.swift
//  who is that pokemon
//
//  Created by Guadalupe Morales carmona on 21/11/22.
//

import Foundation


protocol ImageManagerDelegate {
    func didUpdatePokeImage(image: ImageModel)
    func didFailWithErrorPokeImage(error: Error)
}


struct ImageManager {
    
    var delegate: ImageManagerDelegate?
    
    func fetchPokeImage(url: String) {
        performRequest(with: url)
    }
    
    private func performRequest(with urlString: String){
        if let url = URL(string: urlString){
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url){data, response, error in
                if error != nil{
                    self.delegate?.didFailWithErrorPokeImage(error: error!)
                }else{
                    if let safeImage = data{
                        if let pokeImage = self.parseJSON(imageData: safeImage){
                            self.delegate?.didUpdatePokeImage(image: pokeImage)
                        }
                    }
                   
                }
            }
            
            task.resume()
        }
        
        
    }
    
    private func parseJSON(imageData: Data) -> ImageModel? {
        let decoder = JSONDecoder()
        do{
            let decodeData = try decoder.decode(ImageData.self, from: imageData)
            let image = decodeData.sprites.other?.officialArtwork?.frontDefault ?? ""
            return ImageModel(imageURL: image)
        }catch{
            return nil
        }    }
}

