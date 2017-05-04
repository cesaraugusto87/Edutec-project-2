//
//  cartCell.swift
//  ProyectoTecFinal
//
//  Created by Kipo on 5/4/17.
//  Copyright © 2017 Kipo. All rights reserved.
//

import UIKit
import CoreData


class cartCell: UITableViewCell {
    
    @IBOutlet var foodImage: UIImageView!
    @IBOutlet var foodName: UILabel!
    @IBOutlet var foodPrice: UILabel!
    @IBOutlet var foodQuantity: UITextField!
    
    var food: NSManagedObject?
    
    func getContext () -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }

    
    @IBAction func substractFood(_ sender: Any) {
        
        if(Int(foodQuantity.text!)! > 1){
            let context = self.getContext()
            
            foodQuantity.text = String(Int(foodQuantity.text!)! - 1)
            let newQuantity = Int(foodQuantity.text!)!
            let oldPrice = (food?.value(forKey: "foodPrice") as? Int)
            
            foodPrice.text = "Q"+String(newQuantity*oldPrice!)
            food?.setValue(Int(foodQuantity.text!), forKey: "foodQuantity")
            
            do {
                try context.save()
                // self.navigationController?.popViewController(animated: true)
            } catch let error as NSError {
                print("No se pudo guardar: \(error), \(error.userInfo)")
            }
        }

        
    }
    @IBAction func addFood(_ sender: Any) {
        let context = self.getContext()
        
        foodQuantity.text = String(Int(foodQuantity.text!)! + 1)
        let newQuantity = Int(foodQuantity.text!)!
        let oldPrice = (food?.value(forKey: "foodPrice") as? Int)
        
        foodPrice.text = "Q"+String(newQuantity*oldPrice!)
        food?.setValue(Int(foodQuantity.text!), forKey: "foodQuantity")
        
        do {
            try context.save()
  //          self.navigationController?.popViewController(animated: true)
        } catch let error as NSError {
            print("No se pudo guardar: \(error), \(error.userInfo)")
        }
        
    }
   
    
}
