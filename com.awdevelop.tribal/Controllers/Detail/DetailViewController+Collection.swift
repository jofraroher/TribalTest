//
//  DetailViewController+Collection.swift
//  com.awdevelop.tribal
//
//  Created by Administrador on 11/05/20.
//  Copyright © 2020 Francisco Rosales. All rights reserved.
//

import Foundation

import UIKit

extension DetailViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if ((self.viewModel.user?.photos.count ?? 0) == 0) {
            self.userCollectionView.setEmptyMessage("No images were found.")
        } else {
            self.userCollectionView.restore()
        }

        return self.viewModel.user?.photos.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DetailUserCell", for: indexPath as IndexPath) as! UserViewCell
        cell.configureView(url: self.viewModel.user?.photos[indexPath.row].urls.regular ?? "")
        return cell
    }
}

extension DetailViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemSize = (collectionView.frame.height - (collectionView.contentInset.top + collectionView.contentInset.bottom + 10)) / 2
        return CGSize(width: itemSize, height: itemSize)
    }
}
