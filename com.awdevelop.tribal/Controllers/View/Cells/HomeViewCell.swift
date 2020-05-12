//
//  HomeViewCell.swift
//  com.awdevelop.tribal
//
//  Created by Administrador on 08/05/20.
//  Copyright © 2020 Francisco Rosales. All rights reserved.
//

import UIKit
import Nuke

protocol HomeDelegate {
    func addImageToFavorite(photo: PhotoElement, isFavorite: UIButton, isSelected: Bool)
}

class HomeViewCell: UICollectionViewCell {
    
    @IBOutlet private weak var containerView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet private weak var userLabel: UILabel!
    @IBOutlet private weak var likesLabel: UILabel!
    @IBOutlet private weak var isFavorite: UIButton!
    var imageIsFavorite = false
    var delegate: HomeDelegate?
    var item: FavoriteItem?
  
  override func awakeFromNib() {
    super.awakeFromNib()
    containerView.layer.cornerRadius = 6
    containerView.layer.masksToBounds = true
  }

  var photo: PhotoElement? {
    didSet {
      if let photo = photo {
        likesLabel.text = "Total Likes: \(photo.likes)"
        userLabel.text = photo.user.username
        imageView.image = nil
        profileImageView.image = nil
        Nuke.loadImage(with: URL(string: photo.urls.regular)!, into: imageView)
        Nuke.loadImage(with: URL(string: photo.user.profileImage.medium)!, into: profileImageView)
        profileImageView.makeRounded()
        item = nil
        item = FavoriteItem.existObject(id: photo.id)
        if(item != nil) {
            self.imageIsFavorite = true
            isFavorite.setImage(UIImage(named: "favSelected"), for: .normal)
        } else {
            self.imageIsFavorite = false
            isFavorite.setImage(UIImage(named: "favNotSelected"), for: .normal)
        }
      }
    }
  }
    
    func configureView(id: String, username: String, likes: Int, profileImage: String, photo: String) {
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
        delegate?.addImageToFavorite(photo: self.photo!, isFavorite: self.isFavorite, isSelected: self.imageIsFavorite)
    }
}

extension UIImageView {

    func makeRounded() {

        self.layer.masksToBounds = false
        self.layer.borderColor = UIColor.black.cgColor
        self.layer.cornerRadius = self.frame.height / 2
        self.clipsToBounds = true
    }
}
