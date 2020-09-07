//
//  BBListDataSource.swift
//  BreakingBad
//
//  Created by Victor Ivanov on 9/5/20.
//  Copyright © 2020 ViktorIvanov. All rights reserved.
//

import UIKit
import Alamofire

extension BBCharacterList {
    
    /**
        Load the characters list and sets it to the UITableView Data Source delegate
    */
    func setupDataSource(){
        
        networking.getCharactersList(){ (charList) in
            self.charactersList = charList
            self.tableView.reloadData()
        }
        
    }
    
}
