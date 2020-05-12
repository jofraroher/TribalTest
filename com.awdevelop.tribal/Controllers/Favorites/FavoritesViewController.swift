//
//  FavoritesViewController.swift
//  com.awdevelop.tribal
//
//  Created by Administrador on 11/05/20.
//  Copyright © 2020 Francisco Rosales. All rights reserved.
//

import UIKit

class FavoritesViewController: BaseViewController {
    
    @IBOutlet weak var favoritesCollectionView: UICollectionView!
    
    // MARK: - Injection
    let viewModel = FavoritesViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.initView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.updateValues()
    }
    
    func updateValues() {
        viewModel.fetchFavorites()
        favoritesCollectionView.reloadData()
        self.favoritesCollectionView.collectionViewLayout.invalidateLayout()
    }
    
    func initView() {
        favoritesCollectionView.delegate = self
        favoritesCollectionView.dataSource = self
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
