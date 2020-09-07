//
//  BBCharacterDetails.swift
//  BreakingBad
//
//  Created by Victor Ivanov on 9/5/20.
//  Copyright © 2020 ViktorIvanov. All rights reserved.
//

import UIKit

class BBCharacterDetails: UIViewController {

    @IBOutlet weak var detailsView: UIView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var nickname: UILabel!
    @IBOutlet weak var status: UILabel!
    @IBOutlet weak var occupation: UILabel!
    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var seasons: UIStackView!
    
    @IBOutlet weak var occupationHeight: NSLayoutConstraint!
    
    var character: BBCharacter?
    
    var networking = BBNetworking()
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        navigationItem.title = character?.name
        
        styleNavBar()
        
        styleDetailsView()
        
        
        navigationController?.navigationBar.tintColor = .white
        
        name.text = character?.name
        nickname.text = "(\(character?.nickname ?? ""))"
        
        status.text = character?.status
        if(status.text != "Alive"){
            status.textColor = .red
        }
        

        occupation.text = character?.occupation!.joined(separator: "\n")
        occupationHeight.constant = CGFloat((character?.occupation!.count)! * 21)
        
        
        networking.downloadImage(imagePath: character!.imgURL!){ (image) in
            self.photo.image = image
            self.photo.contentMode = .scaleAspectFill
        }
        
        checkSeasonAppearance()
    }
    
    func styleNavBar(){
        
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.tintColor = .white
        navigationController?.view.backgroundColor = .clear

    }
    
    
    func styleDetailsView(){
        
        detailsView.layer.cornerRadius = 12
        detailsView.layer.masksToBounds = true
        detailsView.backgroundColor = .clear
        
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.extraLight)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = detailsView.bounds
        blurEffectView.alpha = 0.95
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        detailsView.insertSubview(blurEffectView, at: 0)
        
    }
    
    func checkSeasonAppearance(){
        
        var sIndex = 1
        for sLBL in seasons.subviews {
            styleSeasonLabel(charAppears: (character?.appearance!.contains(sIndex))!, lbl: sLBL as! UILabel)
            sIndex += 1
        }
        
    }
    
    func styleSeasonLabel(charAppears: Bool, lbl: UILabel){
        
        lbl.layer.cornerRadius = lbl.frame.size.height/2
        lbl.layer.masksToBounds = true
        
        if(charAppears){
            lbl.backgroundColor = .gray
            lbl.textColor = .white
        }else{
            lbl.backgroundColor = .white
            lbl.textColor = .lightGray
            lbl.alpha = 0.3
        }
        
    }

}
