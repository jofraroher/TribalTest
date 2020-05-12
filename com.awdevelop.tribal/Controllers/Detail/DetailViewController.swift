//
//  DetailViewController.swift
//  com.awdevelop.tribal
//
//  Created by Administrador on 11/05/20.
//  Copyright © 2020 Francisco Rosales. All rights reserved.
//

import UIKit
import Nuke

class DetailViewController: BaseViewController {
    
    var usernameSelected: String?
    
    @IBOutlet weak var userCollectionView: UICollectionView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var fullNameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var totalPhotosLabel: UILabel!
    @IBOutlet weak var totalCollectionsLabel: UILabel!
    @IBOutlet weak var totalLikesLabel: UILabel!
    
    let viewModel = DetailViewModel(dataService: DataService())

    override func viewDidLoad() {
        super.viewDidLoad()
        self.initView()
        attemptFetcUser()
    }
    
    func attemptFetcUser() {
        
        DispatchQueue.main.async{
            
            self.viewModel.isLoading = true
            
            self.viewModel.updateLoadingStatus = {
                let _ = self.viewModel.isLoading ? self.activityIndicatorStart() : self.activityIndicatorStop()
            }
            
            self.viewModel.fetchUser(username: self.usernameSelected ?? "")

                self.viewModel.updateLoadingStatus = {
                    let _ = self.viewModel.isLoading ? self.activityIndicatorStart() : self.activityIndicatorStop()
                }

                self.viewModel.showAlertClosure = {
                    if let error = self.viewModel.error {
                        self.showAlertAction(title: "Error", message: error.localizedDescription)
                        self.removeDetail()
                    }
                }

                self.viewModel.didFinishFetch = {
                    
                    // SET IMAGE PROFILE
                    Nuke.loadImage(with: URL(string: self.viewModel.user?.profileImage.medium ?? "")!, into: self.profileImageView)
                    self.profileImageView.makeRounded()
                    
                    // SET FIRSTNAME AND LAST NAME
                    let firstName = self.viewModel.user?.firstName ?? ""
                    let lastName = self.viewModel.user?.lastName ?? ""
                    let fullName = firstName + " " + lastName
                    self.fullNameLabel.text = fullName
                    
                    // SET DESCRIPTION
                    self.descriptionLabel.text = self.viewModel.user?.bio ?? ""
                    
                    // SET LOCATION
                    self.locationLabel.text = "\(self.viewModel.user?.location ?? "ND")"
                    
                    // SET VALUES IN COUNTERS
                    self.totalPhotosLabel.text = "\(self.viewModel.user?.totalPhotos ?? 0)"
                    self.totalCollectionsLabel.text = "\(self.viewModel.user?.totalCollections ?? 0)"
                    self.totalLikesLabel.text = "\(self.viewModel.user?.totalLikes ?? 0)"
                    
                    
                    DispatchQueue.main.async{
                        self.userCollectionView.reloadData()
                        self.userCollectionView.collectionViewLayout.invalidateLayout()
                    }
                }
        }
        
        
            
        //}
        
        //self.activityIndicatorStart()
    }
    
    // MARK: - UI Setup
    private func activityIndicatorStart() {
        self.startActivity()
    }
    
    private func activityIndicatorStop() {
        self.stopActivity()
    }

    func initView() {
        userCollectionView.delegate = self
        userCollectionView.dataSource = self
    }
    
    @IBAction func showCompleteList(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "DetailListPhotosVC") as! DetailListPhotosViewController
        vc.bioText = self.viewModel.user?.bio ?? ""
        vc.urlProfile = self.viewModel.user?.profileImage.medium ?? ""
        vc.urlImagesUser = self.viewModel.user?.links.photos ?? ""
        let transition = CATransition()
        transition.duration = 0.3
        transition.type = .push
        vc.view.layer.add(transition, forKey: nil)
        vc.view.tag = 100
        
        self.view.addSubview(vc.view)
        self.addChild(vc)
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
