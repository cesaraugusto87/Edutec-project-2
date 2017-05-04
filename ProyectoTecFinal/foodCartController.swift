//
//  foodCartController.swift
//  ProyectoTecFinal
//
//  Created by Kipo on 5/4/17.
//  Copyright © 2017 Kipo. All rights reserved.
//

import UIKit
import CoreData

class foodCartController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var cartTable: UITableView!
  
    var cartItems: [NSManagedObject] = []
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        cartTable?.dataSource = self
        cartTable?.delegate = self
        getData()
        
    }

    
    @IBAction func payFood(_ sender: Any) {
        
        if(cartItems.count > 0){
    
        var totalQuantity = 0
        var totalPrice = 0
        
        for foods in cartItems  as [NSManagedObject] {
            totalQuantity = totalQuantity + (foods.value(forKey: "foodQuantity") as? Int)!
            totalPrice = totalPrice + ((foods.value(forKey: "foodPrice") as? Int)! * (foods.value(forKey: "foodQuantity") as? Int)!)
        }
        let alertController = UIAlertController(title: "Resumen de compra", message: "Su pedido es de \(totalQuantity) Hamburgesas por un total de Q\(totalPrice) ¿Desea continuar con su pago?", preferredStyle: .alert)
        self.present(alertController, animated: true, completion: nil)
        let okAction = UIAlertAction(title:"Ok",style: .default) {(action:UIAlertAction) in
            let context = self.getContext()
            
            let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "FoodCart")
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
            
            do {
                try context.execute(deleteRequest)
                try context.save()
            } catch {
                print ("Error al eliminar")
            }
            let alertController = UIAlertController(title: "Pedido Completado", message: "Gracias por ordenar comida con nosotros.", preferredStyle: .alert)
            self.present(alertController, animated: true, completion: nil)
            let okAction = UIAlertAction(title:"Ok",style: .default) {(action:UIAlertAction) in
                _ = self.navigationController?.popToRootViewController(animated: true)
            }
            alertController.addAction(okAction)
        }
        let cancelAction = UIAlertAction(title:"Cancelar",style: .default) {(action:UIAlertAction) in
            }
            
    
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        }else{
            let alertController = UIAlertController(title: "No hay items en su carrito", message: "Debe agregar items para poder proceder a pagar.", preferredStyle: .alert)
            self.present(alertController, animated: true, completion: nil)
            let okAction = UIAlertAction(title:"Ok",style: .default) {(action:UIAlertAction) in
                _ = self.navigationController?.popToRootViewController(animated: true)
            }
            alertController.addAction(okAction)
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cartItems.count
    }
    
    func getContext () -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cartCell", for: indexPath) as! cartCell
        let food = cartItems[indexPath.row]
        
        cell.foodName?.text = (food.value(forKey: "foodName") as? String)?.capitalized
        cell.foodPrice?.text = "Q"+String((food.value(forKey: "foodPrice") as? Int)! * (food.value(forKey: "foodQuantity") as? Int)!)
        cell.foodQuantity?.text = String(format: "%i",(food.value(forKey: "foodQuantity") as? Int)!)
        cell.foodImage?.af_setImage(withURL: URL(string: (food.value(forKey: "foodImageUrl") as? String)!)!)
        cell.food = cartItems[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            
            let context = getContext()
            do {
                context.delete(self.cartItems[indexPath.row])
                try context.save()
                self.cartItems.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
            } catch let error as NSError {
                print("No se obtener la información: \(error), \(error.userInfo)")
            }
        }
    }
    
    
    func getData() {
        do {
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "FoodCart")
            cartItems = try context.fetch(fetchRequest) as [NSManagedObject]!
        }
        catch {
            print("Fetching Failed")
        }
    }
    
}
