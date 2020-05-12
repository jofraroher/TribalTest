//
//  DetailListPhotosViewController+Collection.swift
//  com.awdevelop.tribal
//
//  Created by Administrador on 11/05/20.
//  Copyright © 2020 Francisco Rosales. All rights reserved.
//

import UIKit

extension DetailListPhotosViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if ((self.viewModel.numberOfItems() ?? 0) == 0) {
            self.listPhotosCollectionView.setEmptyMessage("No images were found.")
        } else {
            self.listPhotosCollectionView.restore()
        }
        
        return self.viewModel.numberOfItems() ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DetailPhotoListCell", for: indexPath as IndexPath) as! HomeViewCell
        cell.photo = self.viewModel.detailListViewModel(at: indexPath.row)
        cell.delegate = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == ((self.viewModel.numberOfItems() ?? 1) - 1) && !self.viewModel.isLoading {
            self.attemptFetchPhoto()
        }
    }
}

extension DetailListPhotosViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemSize = (collectionView.frame.width - (collectionView.contentInset.left + collectionView.contentInset.right + 10)) / 2
        return CGSize(width: itemSize, height: itemSize)
    }
}

extension DetailListPhotosViewController: HomeDelegate {
    func addImageToFavorite(photo: PhotoElement, isFavorite: UIButton, isSelected: Bool) {
        let item = FavoriteItem.existObject(id: photo.id)
        if(item != nil) {
            let isDeleted = FavoriteItem.deleteItem(id: photo.id)
            if(isDeleted) {
                self.showAlertAction(title: "Success", message: "The image has been removed from your favorites")
                isFavorite.setImage(UIImage(named: "favNotSelected"), for: .normal)
            }else {
                self.showAlertAction(title: "Error", message: "An error occurred while deleting the image, please try again.")
            }
        }else {
            _ = FavoriteItem.add(id: photo.id, username: photo.user.username, likes: photo.likes, profileImage: photo.user.profileImage.medium, photo: photo.urls.regular)
            self.showAlertAction(title: "Success", message: "The image was added to your favorites.")
            isFavorite.setImage(UIImage(named: "favSelected"), for: .normal)
        }
    }
}
