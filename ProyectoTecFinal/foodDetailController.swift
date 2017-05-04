//
//  foodDetail.swift
//  ProyectoTecFinal
//
//  Created by Kipo on 5/3/17.
//  Copyright © 2017 Kipo. All rights reserved.
//

import UIKit
import AlamofireImage
import CoreData

class foodDetailController: UIViewController {
    
    var image: String?
    var name: String?
    var desc: String?
    var price: String?
    var id: String?
    
    
    @IBOutlet var foodImage: UIImageView!
    @IBOutlet var foodName: UILabel!
    @IBOutlet var foodDescription: UILabel!
    @IBOutlet var quantity: UITextField!
    @IBOutlet var foodPrice: UILabel!
    
    func getContext () -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
    @IBAction func addQuantity(_ sender: Any) {
        quantity.text = String(Int(quantity.text!)! + 1)
        let newQuantity = Int(quantity.text!)!
        let oldPrice = Int((((price!).components(separatedBy: "Q") as NSArray)[1]) as! String)
        
       foodPrice.text = "Q"+String(newQuantity*oldPrice!)
    }
    
    @IBAction func substractQuantity(_ sender: Any) {
        if(Int(quantity.text!)! > 1){
            quantity.text = String(Int(quantity.text!)! - 1)
            let newQuantity = Int(quantity.text!)!
            let oldPrice = Int((((price!).components(separatedBy: "Q") as NSArray)[1]) as! String)
            
            foodPrice.text = "Q"+String(newQuantity*oldPrice!)
        }
    }
    
    @IBAction func addToCart(_ sender: Any) {
        let context = self.getContext()
        let entity = NSEntityDescription.entity(forEntityName: "FoodCart", in: context)
        let newProduct = NSManagedObject(entity: entity!, insertInto: context)
        
        newProduct.setValue(foodName.text, forKey: "foodName")
        newProduct.setValue(Int((((price!).components(separatedBy: "Q") as NSArray)[1]) as! String), forKey: "foodPrice")
        newProduct.setValue(Int(quantity.text!), forKey: "foodQuantity")
        newProduct.setValue(image, forKey: "foodImageUrl")
        newProduct.setValue(id, forKey: "foodId")
        
        do {
            try context.save()
            let alertController = UIAlertController(title: "Se agrego tu pedido al carrito", message: "Puedes revisar tu pedido antes de comprar haciendo click en tu carrito en la parte superior.", preferredStyle: .alert)
            self.present(alertController, animated: true, completion: nil)
            let okAction = UIAlertAction(title:"Ok",style: .default) {(action:UIAlertAction) in
                 _ = self.navigationController?.popToRootViewController(animated: true)
            }
            alertController.addAction(okAction)
        } catch let error as NSError {
            print("No se obtener la información: \(error), \(error.userInfo)")
        }
        
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadDataToView()
    }
    
    func loadDataToView() {
        foodImage.af_setImage(withURL: URL(string: image!)!)
        foodName.text = name
        foodPrice.text = price
        foodDescription.text = desc
        
    }
    
}
