//
//  BBNetworking.swift
//  BreakingBad
//
//  Created by Victor Ivanov on 9/5/20.
//  Copyright © 2020 ViktorIvanov. All rights reserved.
//

import UIKit

import Alamofire
import AlamofireImage

class BBNetworking {
    
    /**
        Gets the Breaking Bad character list from API

        - Parameters:
            - completionHandler: What to do with the request results
    */
    func getCharactersList( completionHandler: @escaping ([BBCharacter]) -> ()) {

            
        let urlStr = "https://breakingbadapi.com/api/characters"
        AF.request(urlStr)
        .validate()
        .responseDecodable(of: [BBCharacter].self) { (response) in
            guard let charList = response.value else { return }
            completionHandler(charList.filter{ $0.appearance?.count != 0 }) // filter only the ones that appear in Breaking Bad and ignore characters that ONLY appear in Better Call Saul
        }
              
    }
    
    /**
        Downloads a character image

        - Parameters:
            - imagePath: URL of the image
            - completionHandler: What to do with the loaded image
     */
    func downloadImage(imagePath: String, completionHandler: @escaping (UIImage) -> ()) {
        
        if let url = URL(string: imagePath) {
            AF.request(url).responseImage { response in
                if case .success(let image) = response.result {
                    DispatchQueue.main.async {
                        completionHandler(image)
                    }
                }
            }
        }
        
    }

}
