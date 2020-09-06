//
//  BBCharacter.swift
//  BreakingBad
//
//  Created by Victor Ivanov on 9/5/20.
//  Copyright © 2020 ViktorIvanov. All rights reserved.
//

import UIKit

class BBCharacter: NSObject, Decodable {
    
    var id: Int?
    @objc var name: String?
    var nickname: String?
    var status: String?
    var occupation: [String]?
    var appearance: [Int]?
    var imgURL: String?
    
    enum CodingKeys: String, CodingKey {
        case id = "char_id"
        case name = "name"
        case nickname = "nickname"
        case status = "status"
        case occupation = "occupation"
        case appearance = "appearance"
        case imgURL = "img"
    }

    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try? values.decode(Int.self, forKey: .id)
        name = try? values.decode(String.self, forKey: .name)
        nickname = try? values.decode(String.self, forKey: .nickname)
        status = try? values.decode(String.self, forKey: .status)
        occupation = try? values.decode([String].self, forKey: .occupation)
        appearance = try? values.decode([Int].self, forKey: .appearance)
        imgURL = try? values.decode(String.self, forKey: .imgURL)
    }
    
}
