//
//  ViewController.swift
//  Mini Project Search Filter
//
//  Created by Gams-Mac on 03/01/2018.
//  Copyright © 2018 Gamma Rizkinata Satriana. All rights reserved.
//

import UIKit
import SwiftyJSON
import SystemConfiguration
class ViewController: UIViewController {
    @IBOutlet weak var txtSearch: DesignableUITextField!
    
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = true
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }

    @IBAction func searchProd(_ sender: Any) {
        if (txtSearch.text?.isEmpty)!{
            let alert = UIAlertController(title: "Reminder", message: "The search query is empty", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
            
        }else{
            if isConnectedToNetwork(){
                let mainstoryboard = UIStoryboard(name: "Main", bundle: nil)
                let viewcontroller = mainstoryboard.instantiateViewController(withIdentifier: "search") as! SearchViewController
                let q = txtSearch.text?.lowercased().replacingOccurrences(of: " ", with: "+")
                viewcontroller.query = q!
                navigationController?.pushViewController(viewcontroller, animated: true)
            }else{
                let alert = UIAlertController(title: "Reminder", message: "You need to have an internet connection to use the app", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                
            }
        }
        
    }
    
    func isConnectedToNetwork() -> Bool {
        guard let flags = getFlags() else {return false}
        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)
        return (isReachable && !needsConnection)
    }
    
    func getFlags() -> SCNetworkReachabilityFlags? {
        guard let reachability = ipv4Reachability() ?? ipv6Reachability() else {
            return nil
        }
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(reachability, &flags) {
            return nil
        }
        return flags
    }
    
    func ipv6Reachability() -> SCNetworkReachability? {
        var zeroAddress = sockaddr_in6()
        zeroAddress.sin6_len = UInt8(MemoryLayout<sockaddr_in>.size)
        zeroAddress.sin6_family = sa_family_t(AF_INET6)
        
        return withUnsafePointer(to: &zeroAddress, {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                SCNetworkReachabilityCreateWithAddress(nil, $0)
            }
        })
    }
    
    func ipv4Reachability() -> SCNetworkReachability? {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout<sockaddr_in>.size)
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        return withUnsafePointer(to: &zeroAddress, {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                SCNetworkReachabilityCreateWithAddress(nil, $0)
            }
        })
    }
    
    }
    


