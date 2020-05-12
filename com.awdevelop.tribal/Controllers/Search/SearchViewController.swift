//
//  SearchViewController.swift
//  com.awdevelop.tribal
//
//  Created by Administrador on 11/05/20.
//  Copyright © 2020 Francisco Rosales. All rights reserved.
//

import UIKit
import Nuke

protocol SearchResultsDelegate {
    func searchResult(username: String, controller: UIViewController)
}

class SearchViewController: BaseViewController {
    
    let viewModel = SearchViewModel(dataService: DataService())
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var closeBtn: UIButton!
    var delegate: SearchResultsDelegate?
    private let searchController = UISearchController(searchResultsController: nil)
    private var previousRun = Date()
    private let minInterval = 0.05
    var userName: String = ""
    var textToSearch: String = ""
    var addingSubView = false
    @IBOutlet weak var heightButton: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        setupTableViewBackgroundView()
        setupSearchBar()
    }
    
    private func setupTableViewBackgroundView() {
       let backgroundViewLabel = UILabel(frame: .zero)
       backgroundViewLabel.textColor = .darkGray
       backgroundViewLabel.numberOfLines = 0
       backgroundViewLabel.text = " No results to show."
       backgroundViewLabel.textAlignment = NSTextAlignment.center
       backgroundViewLabel.font.withSize(20)
       tableView.backgroundView = backgroundViewLabel
    }
    
    private func setupSearchBar() {
        searchController.searchBar.delegate = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.placeholder = "Search user"
        definesPresentationContext = true
        if(addingSubView){
            self.heightButton.constant = 30
        }
        tableView.tableHeaderView = searchController.searchBar
    }
    
    @IBAction func close() {
        UIView.animate(withDuration: 0.5, delay: 0.1, options: .transitionFlipFromRight, animations: {
            self.view.alpha = 1
            self.view.alpha = 0
        }) { (finished) in
            self.willMove(toParent: nil)
            self.view.removeFromSuperview()
            self.removeFromParent()
        }
    }
    
    // MARK: - UI Setup
    private func activityIndicatorStart() {
        self.startActivity()
    }
    
    private func activityIndicatorStop() {
        self.stopActivity()
    }
}

extension SearchViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if var list = self.viewModel.searchResult?.results {
            list.removeAll()
        }
        guard let textToSearch = searchBar.text, !textToSearch.isEmpty else {
            return
        }
        
        if Date().timeIntervalSince(previousRun) > minInterval {
            previousRun = Date()
            self.textToSearch = textToSearch
            fetchResults(for: self.textToSearch)
        }
    }
    
    func fetchResults(for userName: String) {
            
            self.viewModel.updateLoadingStatus = {
                let _ = self.viewModel.isLoading ? self.activityIndicatorStart() : self.activityIndicatorStop()
            }
            
                self.viewModel.fetchUser(pageIndex: 1, username: userName)

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
                        self.tableView.reloadData()
                    }
                }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.viewModel.searchResult?.results.removeAll()
        self.tableView.reloadData()
    }

}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.searchResult?.results.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell",
                                                 for: indexPath) as! SearchTableViewCell
        
        let item = self.viewModel.searchResult?.results[indexPath.row]
        cell.usernameLabel.text = item?.username ?? ""
        
        // SET IMAGE PROFILE
        Nuke.loadImage(with: URL(string: item?.profileImage.medium ?? "")!, into: cell.profileImage)
        cell.profileImage.makeRounded()
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        searchController.isActive = false
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "DetailVC") as! DetailViewController
        vc.usernameSelected = self.viewModel.searchResult?.results[indexPath.row].username ?? ""
        let transition = CATransition()
        transition.duration = 0.3
        transition.type = .push
        vc.view.layer.add(transition, forKey: nil)
        vc.view.tag = 100
        
        self.view.addSubview(vc.view)
        self.addChild(vc)
    }
}
