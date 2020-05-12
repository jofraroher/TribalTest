//
//  BaseViewController.swift
//  com.awdevelop.tribal
//
//  Created by Administrador on 08/05/20.
//  Copyright © 2020 Francisco Rosales. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func showAlertAction(title: String, message: String, btnAccept: String = "OK", btnCancel: String? = "", okHandler: ((UIAlertAction) -> Void)? = nil, cancelHandler: ((UIAlertAction) -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        if !btnCancel!.isEmpty{
            let actCancel = UIAlertAction(title: btnCancel, style: .cancel, handler: cancelHandler)
            alert.addAction(actCancel)
        }
        
        let actAccept = UIAlertAction(title: btnAccept, style: .default, handler: okHandler)
        alert.addAction(actAccept)
        
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    func startActivity(){
        UIApplication.shared.keyWindow?.addSubview(Activity.indicador.view)
    }
    
    func stopActivity(){
        Activity.indicador.view.removeFromSuperview()
    }
}

extension UICollectionView {

    func setEmptyMessage(_ message: String) {
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
        messageLabel.text = message
        messageLabel.textColor = .black
        messageLabel.numberOfLines = 0;
        messageLabel.textAlignment = .center;
        messageLabel.font = UIFont(name: "TrebuchetMS", size: 15)
        messageLabel.sizeToFit()

        self.backgroundView = messageLabel;
    }

    func restore() {
        self.backgroundView = nil
    }
}

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        let newRed = CGFloat(red)/255
        let newGreen = CGFloat(green)/255
        let newBlue = CGFloat(blue)/255
        
        self.init(red: newRed, green: newGreen, blue: newBlue, alpha: 1.0)
    }
}
