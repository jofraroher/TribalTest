//
//  FavoritesViewController+Collection.swift
//  com.awdevelop.tribal
//
//  Created by Administrador on 11/05/20.
//  Copyright © 2020 Francisco Rosales. All rights reserved.
//

import UIKit

extension FavoritesViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if ((self.viewModel.numberOfItems() ?? 0) == 0) {
            self.favoritesCollectionView.setEmptyMessage("There are no images stored as favorites.")
        } else {
            self.favoritesCollectionView.restore()
        }

        return self.viewModel.numberOfItems() ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DetailPhotoCell", for: indexPath as IndexPath) as! FavoriteViewCell
        let item = self.viewModel.favoritesListViewModel(at: indexPath.row)
        cell.configureView(id: item?.id ?? "", username: item?.username ?? "", likes: item?.likes ?? 0, profileImage: item?.profileImage ?? "", photo: item?.photo ?? "")
        cell.delegate = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "DetailVC") as! DetailViewController
        let item = self.viewModel.favoritesListViewModel(at: indexPath.row)
        vc.usernameSelected = item?.username ?? ""
        let transition = CATransition()
        transition.duration = 0.3
        transition.type = .push
        vc.view.layer.add(transition, forKey: nil)
        vc.view.tag = 100
        
        self.view.addSubview(vc.view)
        self.addChild(vc)
    }
}


extension FavoritesViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemSize = (collectionView.frame.width - (collectionView.contentInset.left + collectionView.contentInset.right + 10)) / 2
        return CGSize(width: itemSize, height: itemSize)
    }
}

extension FavoritesViewController: FavoriteDelegate {
    func deleteImageToFavorite(id: String, isFavorite: UIButton, isSelected: Bool) {
        let item = FavoriteItem.existObject(id: id)
        if(item != nil) {
            let isDeleted = FavoriteItem.deleteItem(id: id)
            if(isDeleted) {
                self.showAlertAction(title: "Success", message: "The image has been removed from your favorites")
                isFavorite.setImage(UIImage(named: "favNotSelected"), for: .normal)
            }else {
                self.showAlertAction(title: "Error", message: "An error occurred while deleting the image, please try again.")
            }
        }
        self.updateValues()
    }
}
