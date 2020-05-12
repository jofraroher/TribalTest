//
//  DetailListPhotosViewController.swift
//  com.awdevelop.tribal
//
//  Created by Administrador on 11/05/20.
//  Copyright © 2020 Francisco Rosales. All rights reserved.
//

import UIKit
import Nuke

class DetailListPhotosViewController: BaseViewController {

    @IBOutlet weak var listPhotosCollectionView: UICollectionView!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var bioTextLabel: UILabel!
    
    // MARK: - Injection
    let viewModel = DetailListViewModel(dataService: DataService())
    
    var urlImagesUser = ""
    var urlProfile = ""
    var bioText = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.initView()
        attemptFetchPhoto()
    }
    
    func attemptFetchPhoto() {
        
        DispatchQueue.main.async{
            
            self.viewModel.isLoading = true
            
            self.viewModel.updateLoadingStatus = {
                let _ = self.viewModel.isLoading ? self.activityIndicatorStart() : self.activityIndicatorStop()
            }
            
            self.viewModel.fetchPhoto(url: self.urlImagesUser)

                self.viewModel.updateLoadingStatus = {
                    let _ = self.viewModel.isLoading ? self.activityIndicatorStart() : self.activityIndicatorStop()
                }

                self.viewModel.showAlertClosure = {
                    if let error = self.viewModel.error {
                        self.showAlertAction(title: "Error", message: error.localizedDescription)
                    }
                }

                self.viewModel.didFinishFetch = {
                    
                    // SET IMAGE PROFILE
                    Nuke.loadImage(with: URL(string: self.urlProfile)!, into: self.profileImage)
                    self.profileImage.makeRounded()
                    
                    self.bioTextLabel.text = self.bioText
                    
                    DispatchQueue.main.async{
                        self.listPhotosCollectionView.reloadData()
                        self.listPhotosCollectionView.collectionViewLayout.invalidateLayout()
                    }
                }
        }
    }
    
    // MARK: - UI Setup
    private func activityIndicatorStart() {
        self.startActivity()
    }
    
    private func activityIndicatorStop() {
        self.stopActivity()
    }

    func initView() {
        listPhotosCollectionView.delegate = self
        listPhotosCollectionView.dataSource = self
    }
    
    @IBAction func removeDetail(){
        UIView.animate(withDuration: 0.5, delay: 0.1, options: .transitionFlipFromRight, animations: {
            self.view.alpha = 1
            self.view.alpha = 0
        }) { (finished) in
            self.willMove(toParent: nil)
            self.view.removeFromSuperview()
            self.removeFromParent()
        }
    }
}
