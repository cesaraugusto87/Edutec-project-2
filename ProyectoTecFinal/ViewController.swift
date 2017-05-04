//
//  ViewController.swift
//  ProyectoTecFinal
//
//  Created by Kipo on 4/26/17.
//  Copyright © 2017 Kipo. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage
import SwiftyJSON

class RestaurantsController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    
    @IBOutlet var restaurantsTable: UITableView!
    
    var restaurantsList: NSArray? = NSArray()
    var apiUrl = "http://54.236.40.158:9000/restaurants"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        restaurantsTable.dataSource = self
        restaurantsTable.delegate = self
        loadDataFromApi(url: apiUrl)
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return restaurantsList!.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let details = storyboard?.instantiateViewController(withIdentifier: "foodsController") as! foodsController
        let restaurantId = restaurantsList?[indexPath.row] as! NSDictionary
        
        details.restaurantId = restaurantId.object(forKey: "_id") as? String
        
        tableView.deselectRow(at: indexPath, animated: false)
        self.navigationController?.pushViewController(details, animated: true)
    }
    
   func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "restaurantsCell", for: indexPath) as! restaurantsCellController
    
    let restaurant = (restaurantsList?[indexPath.row]) as! NSDictionary
    
    let urlImage: String = restaurant.object(forKey: "image") as! String
    
    cell.restaurantImage?.af_setImage(withURL: URL(string: urlImage)!)
    
    cell.name?.text = restaurant.object(forKey: "name") as? String
    cell.restaurantInfo?.text = restaurant.object(forKey: "slug") as? String
    
    let starCount: Int = (restaurant.object(forKey: "stars") as! Int)
    let priceCount: Int = (restaurant.object(forKey: "price") as! Int)
    
    cell.star1?.isHidden = true
    cell.star2?.isHidden = true
    cell.star3?.isHidden = true
    cell.star4?.isHidden = true
    cell.star5?.isHidden = true
    
    cell.money1?.isHidden = true
    cell.money2?.isHidden = true
    cell.maney3?.isHidden = true
    cell.money4?.isHidden = true
    cell.money5?.isHidden = true
    
    for x in 1...starCount {
        switch x {
        case 1:
            cell.star1?.isHidden = false
        case 2:
            cell.star2?.isHidden = false
        case 3:
            cell.star3?.isHidden = false
        case 4:
            cell.star4?.isHidden = false
        case 5:
            cell.star5?.isHidden = false
        default:
            cell.star5?.isHidden = false
        }
    }
    
    for x in 1...priceCount {
        switch x {
        case 1:
            cell.money1?.isHidden = false
        case 2:
            cell.money2?.isHidden = false
        case 3:
            cell.maney3?.isHidden = false
        case 4:
            cell.money4?.isHidden = false
        case 5:
            cell.money5?.isHidden = false
        default:
            cell.money5?.isHidden = false
        }
    }
    
        return cell
    }

    func loadDataFromApi(url: String) -> Void {
        
        Alamofire.request(url).responseJSON
            { response in
                switch (response.result) {
                case .success:
                    if let JSON = response.result.value {
                        self.restaurantsList = JSON as? NSArray
                        self.restaurantsTable?.reloadData()
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

