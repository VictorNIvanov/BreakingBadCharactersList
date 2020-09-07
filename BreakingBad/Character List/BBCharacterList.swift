//
//  BBCharacterList.swift
//  BreakingBad
//
//  Created by Victor Ivanov on 9/5/20.
//  Copyright © 2020 ViktorIvanov. All rights reserved.
//

import UIKit
import AlamofireImage

class BBCharacterList: UITableViewController {
    
    let tableViewCellIdentifier = "bblistcell"
    
    let imageCache = AutoPurgingImageCache()
    let networking = BBNetworking()
    
    let searchController = UISearchController(searchResultsController: nil)
    
    var charactersList: [BBCharacter] = []
    
    var charactersListFiltered: [BBCharacter] = []
    
    var isSearchBarEmpty: Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    var isFiltering: Bool {
        let searchBarScopeIsFiltering = searchController.searchBar.selectedScopeButtonIndex != 0
        return (!isSearchBarEmpty || searchBarScopeIsFiltering)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let navlogo = UIImage(named: "bblogo_navbar.png")
        let navImage = UIImageView(image:navlogo)
        navImage.contentMode = .scaleAspectFit
        self.navigationItem.titleView = navImage
        
        
        let nib = UINib(nibName: "BBListCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: tableViewCellIdentifier)
        
        setupDataSource()
        
        setupSearchBar()
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        styleNavBar()
    }
    
    func setupSearchBar(){

        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Characters"

        searchController.searchBar.scopeButtonTitles = ["All", "Seas. 1", "Seas. 2", "Seas. 3", "Seas. 4", "Seas. 5"]
        searchController.searchBar.delegate = self
        
        navigationItem.searchController = searchController
        definesPresentationContext = true
        
    }
    
    func styleNavBar(){
        
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.tintColor = .darkGray
        navigationController?.view.backgroundColor = .white
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering {
          return charactersListFiltered.count
        }
        return charactersList.count
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: tableViewCellIdentifier, for: indexPath) as! BBListCell

        let character: BBCharacter
        
        if isFiltering {
            character = charactersListFiltered[indexPath.row]
        }else{
            character = charactersList[indexPath.row]
        }
        
        cell.name!.text = character.name
        cell.nickname!.text = character.nickname
        
        
        // check if we have cached the thumbnail already, if not download it
        
        let cache_id = "photo_\(character.id ?? 0)"
        
        if let image = imageCache.image(withIdentifier: cache_id){
            cell.photo.image = image
        }else{
            
            cell.photo.image = UIImage(named: "nophoto_thumb")

            networking.downloadImage(imagePath: character.imgURL!){ (image) in

                let scaledImage = image.af.imageAspectScaled(toFill: CGSize(width: 100, height: 100))
                
                if let cellToUpdate: BBListCell = tableView.cellForRow(at: indexPath) as? BBListCell {
                    cellToUpdate.photo?.image = scaledImage
                    cellToUpdate.setNeedsLayout()
                }
                self.imageCache.add(scaledImage, withIdentifier: cache_id)
                
            }
         
        }

        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let character: BBCharacter
        
        if isFiltering {
            character = charactersListFiltered[indexPath.row]
        }else{
            character = charactersList[indexPath.row]
        }

        let charDetailsScreen = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "characterDetails") as! BBCharacterDetails
        charDetailsScreen.character = character
        
        navigationController?.pushViewController(charDetailsScreen, animated: true)

        tableView.deselectRow(at: indexPath, animated: false)
    }

    
    func filterContentForSearchText(_ searchText: String, season: Int) {
        
        charactersListFiltered = charactersList.filter { (char: BBCharacter) -> Bool in
            
            var appearsInSeason: Bool!
            if(season == 0){
                appearsInSeason = true
            }else{
                appearsInSeason = char.appearance?.contains(season)
            }
            
            if isSearchBarEmpty {
              return appearsInSeason
            } else {
                return appearsInSeason && char.name!.lowercased().contains(searchText.lowercased())
            }
        }
      
        tableView.reloadData()
    }

}

extension BBCharacterList: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        let season = searchBar.selectedScopeButtonIndex
        filterContentForSearchText(searchBar.text!, season: season)
    }
    
}

extension BBCharacterList: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        let seasonFilter = selectedScope
        filterContentForSearchText(searchBar.text!, season: seasonFilter)
    }
    
}
