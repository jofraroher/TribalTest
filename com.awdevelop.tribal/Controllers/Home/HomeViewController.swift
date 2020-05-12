//
//  HomeViewController.swift
//  com.awdevelop.tribal
//
//  Created by Administrador on 08/05/20.
//  Copyright © 2020 Francisco Rosales. All rights reserved.
//

import UIKit
import Lottie

class HomeViewController: BaseViewController {
    
    @IBOutlet weak var homeCollectionView: UICollectionView!
        
    // MARK: - Injection
    let viewModel = HomeViewModel(dataService: DataService())

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.initView()
        attemptFetchPhoto()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        if self.children.count > 0{
            let viewControllers:[UIViewController] = self.children
            for viewContoller in viewControllers{
                viewContoller.willMove(toParent: nil)
                viewContoller.view.removeFromSuperview()
                viewContoller.removeFromParent()
            }
        }
    }
    
    func attemptFetchPhoto() {
        
        DispatchQueue.main.async{
            
            self.viewModel.isLoading = true
            
            self.viewModel.updateLoadingStatus = {
                let _ = self.viewModel.isLoading ? self.activityIndicatorStart() : self.activityIndicatorStop()
            }
            
                self.viewModel.fetchPhoto()

                self.viewModel.updateLoadingStatus = {
                    let _ = self.viewModel.isLoading ? self.activityIndicatorStart() : self.activityIndicatorStop()
                }

                self.viewModel.showAlertClosure = {
                    if let error = self.viewModel.error {
                        self.showAlertAction(title: "Error", message: error.localizedDescription)
                    }
                }

                self.viewModel.didFinishFetch = {
                    DispatchQueue.main.async{
                        self.homeCollectionView.reloadData()
                        self.homeCollectionView.collectionViewLayout.invalidateLayout()
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
        homeCollectionView.delegate = self
        homeCollectionView.dataSource = self
    }
    
    @IBAction func showSearch() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "searchVC") as! SearchViewController
        vc.addingSubView = true
        let transition = CATransition()
        transition.duration = 0.3
        transition.type = .push
        vc.view.layer.add(transition, forKey: nil)
        vc.view.tag = 100
        
        self.view.addSubview(vc.view)
        self.addChild(vc)
    }
}
