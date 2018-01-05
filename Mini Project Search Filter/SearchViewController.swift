//
//  SearchViewController.swift
//  Mini Project Search Filter
//
//  Created by Gams-Mac on 04/01/2018.
//  Copyright © 2018 Gamma Rizkinata Satriana. All rights reserved.
//

import UIKit
import SwiftyJSON
import Kingfisher
import ESPullToRefresh

class SearchViewController: UIViewController {
    
    @IBOutlet weak var productCv: UICollectionView!
    var query = ""
    var count = 0
    var results = [JSON]()
    var minPrice = 50000
    var maxPrice = 500000
    var wholesale = false
    var official = false
    var gold = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.productCv.delegate = self
        self.productCv.dataSource = self
        productCv.es.addInfiniteScrolling {
            
            let urlString = "https://ace.tokopedia.com/search/v2.5/product?q=\(self.query)&pmin=\(self.minPrice)&pmax=\(self.maxPrice)&wholesale=\(self.wholesale)&official=\(self.official)&fshop=\(self.gold)&start=\(self.count)&rows=10"
            
            
            let url = URL(string: urlString)
            let urlRequest = URLRequest(url: url!)
            let session = URLSession(configuration: .default)
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
            let task = session.dataTask(with: urlRequest, completionHandler: {(data, response, error) in
                guard error == nil else {
                    print(error?.localizedDescription as Any)
                    return
                }
                guard let responseData = data else {
                    print("Did not receive any data")
                    return
                }
                let json = JSON(responseData)
                self.results.append(contentsOf: json["data"].array!)
                //print(self.results)
                if json.count == 0 {
                    print("empty")
                }else if json.count > 3{
                    DispatchQueue.main.sync {
                        UIApplication.shared.isNetworkActivityIndicatorVisible = false
                        self.count += (self.results.count)
                        self.productCv.reloadData()
                    }
                }
                
            })
            
            
            task.resume()

            
        self.productCv.es.noticeNoMoreData()
        }
       
        

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       let urlString = "https://ace.tokopedia.com/search/v2.5/product?q=\(self.query)&pmin=\(self.minPrice)&pmax=\(self.maxPrice)&wholesale=\(self.wholesale)&official=\(self.official)&fshop=\(self.gold)&start=\(self.count)&rows=10"
        
        
        let url = URL(string: urlString)
        let urlRequest = URLRequest(url: url!)
        let session = URLSession(configuration: .default)
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        let task = session.dataTask(with: urlRequest, completionHandler: {(data, response, error) in
            guard error == nil else {
                print(error?.localizedDescription as Any)
                return
            }
            guard let responseData = data else {
                print("Did not receive any data")
                return
            }
            let json = JSON(responseData)
            self.results.append(contentsOf: json["data"].array!)
            //print(self.results)
            if json.count == 0 {
                print("empty")
            }else if json.count > 3{
                DispatchQueue.main.sync {
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                    self.count += (self.results.count)
                    self.productCv.reloadData()
                }
            }
           
        })
        
        
        task.resume()
        
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
    }
    
    @IBAction func showFilter(_ sender: Any) {
        let mainstoryboard = UIStoryboard(name: "Main", bundle: nil)
        let viewcontroller = mainstoryboard.instantiateViewController(withIdentifier: "filter") as! FilterViewController
        viewcontroller.query = query
        viewcontroller.minPrice = minPrice
        viewcontroller.maxPrice = maxPrice
        viewcontroller.gold = gold
        viewcontroller.wholesale = wholesale
        viewcontroller.official = official
   navigationController?.pushViewController(viewcontroller, animated: true)
        
    }
    
    

}
extension SearchViewController: UICollectionViewDelegate{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
     
        return 2
    }
    
  
}

extension SearchViewController: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
      
        return results.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
      
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductCell", for: indexPath) as! ItemsCollectionViewCell
            cell.image.kf.setImage(with: results[indexPath.row]["image_uri"].url)
            cell.lblProduct.text = results[indexPath.row]["name"].stringValue
            cell.lblPrice.text = results[indexPath.row]["price"].stringValue
            
        
        return cell
    }
    
    
    
}
extension SearchViewController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: self.view.frame.size.width / 2, height: 250.0)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
}
    
   
    
    
    

