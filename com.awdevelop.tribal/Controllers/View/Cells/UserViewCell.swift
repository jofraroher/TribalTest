//
//  UserViewCell.swift
//  com.awdevelop.tribal
//
//  Created by Administrador on 11/05/20.
//  Copyright © 2020 Francisco Rosales. All rights reserved.
//

import UIKit
import Nuke

class UserViewCell: UICollectionViewCell {
    
    @IBOutlet private weak var containerView: UIView!
    @IBOutlet weak var imageView: UIImageView!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    containerView.layer.cornerRadius = 6
    containerView.layer.masksToBounds = true
  }
    
    func configureView(url: String) {
        imageView.image = nil
        Nuke.loadImage(with: URL(string: url)!, into: imageView)
    }
}
