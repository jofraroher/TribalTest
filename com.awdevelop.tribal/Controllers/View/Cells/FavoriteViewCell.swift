//
//  FavoriteViewCell.swift
//  com.awdevelop.tribal
//
//  Created by Administrador on 11/05/20.
//  Copyright © 2020 Francisco Rosales. All rights reserved.
//

import UIKit
import Nuke

protocol FavoriteDelegate {
    func deleteImageToFavorite(id: String, isFavorite: UIButton, isSelected: Bool)
}

class FavoriteViewCell: UICollectionViewCell {
    
    @IBOutlet private weak var containerView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet private weak var userLabel: UILabel!
    @IBOutlet private weak var likesLabel: UILabel!
    @IBOutlet private weak var isFavorite: UIButton!
    var imageIsFavorite = false
    var delegate: FavoriteDelegate?
    var item: FavoriteItem?
    var id = ""
  
  override func awakeFromNib() {
    super.awakeFromNib()
    containerView.layer.cornerRadius = 6
    containerView.layer.masksToBounds = true
  }
    
    func configureView(id: String, username: String, likes: Int, profileImage: String, photo: String) {
        self.id = id
        likesLabel.text = "Total Likes: \(likes)"
        userLabel.text = username
        imageView.image = nil
        profileImageView.image = nil
        Nuke.loadImage(with: URL(string: photo)!, into: imageView)
        Nuke.loadImage(with: URL(string: profileImage)!, into: profileImageView)
        profileImageView.makeRounded()
        item = nil
        item = FavoriteItem.existObject(id: id)
        if(item != nil) {
            self.imageIsFavorite = true
            isFavorite.setImage(UIImage(named: "favSelected"), for: .normal)
        } else {
            self.imageIsFavorite = false
            isFavorite.setImage(UIImage(named: "favNotSelected"), for: .normal)
        }
    }
    
    @IBAction func saveImage(){
        delegate?.deleteImageToFavorite(id: self.id, isFavorite: self.isFavorite, isSelected: self.imageIsFavorite)
    }
}
