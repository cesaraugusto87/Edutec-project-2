//
//  foodsController.swift
//  ProyectoTecFinal
//
//  Created by Kipo on 5/3/17.
//  Copyright © 2017 Kipo. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

class foodsController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    var foodsList: NSArray? = NSArray()
    var restaurantId: String?
    var apiUrl = "http://54.236.40.158:9000/restaurants/"
    
    @IBOutlet var foodsTable: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        foodsTable.dataSource = self
        foodsTable.delegate = self
        
        loadDataFromApi(url: apiUrl)
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (foodsList?.count)!
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "foodsCell", for: indexPath) as! foodsCell
        
        let food = (foodsList?[indexPath.row]) as! NSDictionary
        
        let urlImage: String = food.object(forKey: "image") as! String
        
        cell.foodPicture?.af_setImage(withURL: URL(string: urlImage)!)
        
        cell.foodName.text = food.object(forKey: "name") as? String
    
        cell.foodPrice.text = "Q"+String(format: "%i", food.object(forKey: "price") as!
        Int)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let details = storyboard?.instantiateViewController(withIdentifier: "foodDetailController") as! foodDetailController
        let foodDetails = foodsList?[indexPath.row] as! NSDictionary
        
        details.price = "Q"+String(format: "%i", foodDetails.object(forKey: "price") as! Int)
        details.name = foodDetails.object(forKey: "name") as? String
        details.desc = foodDetails.object(forKey: "description") as? String
        details.image = foodDetails.object(forKey: "image") as? String
        details.id = foodDetails.object(forKey: "_id") as? String
        
        collectionView.deselectItem(at: indexPath, animated: true)
        self.navigationController?.pushViewController(details, animated: true)
    }
   
    func loadDataFromApi(url: String) -> Void {
        
        Alamofire.request(url+restaurantId!+"/foods").responseJSON
            { response in
                switch (response.result) {
                case .success:
                    if let JSON = response.result.value {
                        self.foodsList = JSON as? NSArray
                        self.foodsTable?.reloadData()
                    }
                    break
                case .failure(let error):
                    if error._code == NSURLErrorTimedOut {
                        print("Server Down")
                    }
                    print("\n\nAuth request failed with error:\n \(error)")
                    break
                }
        }
    }
    
}
