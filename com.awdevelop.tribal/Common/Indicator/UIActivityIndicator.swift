//
//  UIActivityIndicator.swift
//  com.awdevelop.tribal
//
//  Created by Administrador on 08/05/20.
//  Copyright © 2020 Francisco Rosales. All rights reserved.
//

import UIKit
import Lottie

class UIActivityIndicator: UIViewController {

    @IBOutlet weak var containerView: UIView!
    let animationView = AnimationView(name: "progress")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.frame = UIScreen.main.bounds
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        animationView.frame = self.containerView.bounds
        animationView.center = self.containerView.center
        
        animationView.loopMode = .loop
        animationView.contentMode = .scaleAspectFill
        animationView.animationSpeed = 1.0
        
        view.addSubview(animationView)
        
        animationView.play()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        animationView.removeFromSuperview()
    }
    
}

class Activity{
   static let indicador:UIActivityIndicator! = UIActivityIndicator(nibName:"UIActivityIndicator", bundle: nil)

}
