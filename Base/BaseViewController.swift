
//
//  BaseViewController.swift
//  BreakingBadCharacters
//
//  Created by ALY on 24/06/2021.
//

import UIKit

class BaseViewController: UIViewController {

    // MARK: - Variables
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
  


}
// MARK: - Functions
extension BaseViewController{
    
    // MARK: - Rechability Method
    func isConnectedToNetwork() -> Bool {
        
        if (currentReachabilityStatus == ReachabilityStatus.reachableViaWiFi)
        {
            return true
        }
        else if (currentReachabilityStatus == ReachabilityStatus.reachableViaWWAN)
        {
            return true
            
        }
        else
        {
            return false
        }
    }
}
