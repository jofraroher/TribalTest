//
//  TabBarViewController.swift
//  com.awdevelop.tribal
//
//  Created by Administrador on 08/05/20.
//  Copyright © 2020 Francisco Rosales. All rights reserved.
//

import UIKit
import RevealingSplashView

class TabBarViewController: BaseViewController {
    
    // LIST CONTROLLERS
    var homeCollectionViewController: UIViewController!
    var favoritesViewController: UIViewController!
    var detailViewController: UIViewController!
    var notAvailableViewController: UIViewController!
    var searchViewController: UIViewController!
    // TAB BAR NAVIGATION CONTROLLER
    var navigationviewControllers: [UIViewController]!
    // FIRST SELECTED ITEM
    var selectedIndex: Int = 0
    // BUTTONS ARRAY TAB BAR
    @IBOutlet var tabBarButtons: [UIButton]!
    // MAIN CONTENT
    @IBOutlet weak var contentView: UIView!
    
    // Splash Revealing
    let revealingSplashView = RevealingSplashView(iconImage: #imageLiteral(resourceName: "RevealingSplashViewIcon"), iconInitialSize: CGSize(width: 123, height: 123), backgroundColor: UIColor(red: 78, green: 172, blue: 248))

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(revealingSplashView)
        setUpControllers()
        setUpInitialSelected()
        revealingSplashView.startAnimation()
    }
    
    func setUpControllers() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        homeCollectionViewController = storyboard.instantiateViewController(withIdentifier: "HomeVC")
        favoritesViewController = storyboard.instantiateViewController(withIdentifier: "FavoritesVC")
        notAvailableViewController = storyboard.instantiateViewController(withIdentifier: "notAvailableVC")
        searchViewController = storyboard.instantiateViewController(withIdentifier: "searchVC")
        navigationviewControllers = [homeCollectionViewController, favoritesViewController, notAvailableViewController, searchViewController, notAvailableViewController]
    }
    
    func setUpInitialSelected() {
        tabBarButtons[selectedIndex].isSelected = true
        didPressTab(sender: tabBarButtons[selectedIndex])
    }
    
    @IBAction func didPressTab(sender: UIButton) {
        let previousIndex = selectedIndex
        selectedIndex = sender.tag
        tabBarButtons[previousIndex].isSelected = false
        let previousVC = navigationviewControllers[previousIndex]
        dismissVC(previousVC: previousVC)
        sender.isSelected = true
        let vc = navigationviewControllers[selectedIndex]
        showVC(showVc: vc)
    }
    
    func dismissVC(previousVC: UIViewController) {
        previousVC.willMove(toParent: nil)
        previousVC.view.removeFromSuperview()
        previousVC.removeFromParent()
    }
    
    func showVC(showVc: UIViewController) {
        addChild(showVc)
        showVc.view.frame = contentView.bounds
        contentView.addSubview(showVc.view)
        showVc.didMove(toParent: self)
    }
}

