//
//  ViewController.swift
//  Mod9Pract2
//
//  Created by Rodrigo Córdoba on 05/07/24.
//

import UIKit

class CocktailViewController: UIViewController {
    
    @IBOutlet var emptyCocktailView: UIView!
    @IBOutlet weak var cocktailTableView: UITableView!
    @IBOutlet weak var addCocktailButton: UIBarButtonItem!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var cocktailManager : CocktailManager?
    var cocktailJSON : CocktailJSON?
    
    var cocktailJSONList : [CocktailJSON] = []
    
    var isEdit : Bool = false
    var editIndex : Int = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        cocktailManager = CocktailManager(context: context)
        cocktailManager?.loadJSON()
        cocktailJSONList = (cocktailManager?.getCocktailList())!
        print(cocktailJSONList)
        
        if cocktailManager?.getCocktailCount() == 0{
            emptyCocktailView.isHidden = false
            cocktailTableView.backgroundView = emptyCocktailView
        }
        
        else{
            emptyCocktailView.isHidden = true
        }
    }
    @IBAction func editButtonTapped(_ sender: UIBarButtonItem) {
        
        if cocktailTableView.isEditing{
            cocktailTableView.setEditing(false, animated: true)
            sender.title = "Edit"
            addCocktailButton.isEnabled = true
            
        }
        
        else{
            cocktailTableView.setEditing(true, animated: true)
            sender.title = "Done"
            addCocktailButton.isEnabled = false
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if segue.identifier == "editTaskAction"{
            let destination = segue.destination as! AddItemViewController
            destination.newCocktailJSON = cocktailManager?.getCocktailList()[cocktailTableView.indexPathForSelectedRow!.row]
        }
    }
}

extension CocktailViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        cocktailJSONList = (cocktailManager?.getCocktailList())!
        var data : Data?
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? CocktailCell
        cell?.nameLabel.text = cocktailJSONList[indexPath.row].name
        cell?.ingredientsLabel.text = cocktailJSONList[indexPath.row].ingredients
        cell?.descriptionLabel.text = cocktailJSONList[indexPath.row].directions
        let imageString = cocktailJSONList[indexPath.row].img
        if let imageUrl = URL(string: imageString){
            let fileManager = FileManager.default
            let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
            print ("Sexxo con el DR JRR")
            print(cocktailJSONList[indexPath.row].img)
            let cocktailsURL = documentsDirectory.appending(path: cocktailJSONList[indexPath.row].img)
            
            //Check if file exists
            if fileManager.fileExists(atPath: cocktailsURL.path){
                do{
                    data = try Data(contentsOf: imageUrl)
                    cell?.cocktailImage.image = UIImage(data: data!)
                }
                
                catch{
                    print(error)
                }
                
                
            }
            else{
                cocktailManager?.getCocktail(at: indexPath.row)
            }
        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if cocktailManager?.getCocktailCount() == 0{
            emptyCocktailView.isHidden = false
            cocktailTableView.backgroundView = emptyCocktailView
        }
        
        else{
            emptyCocktailView.isHidden = true
        }
        
        return cocktailManager!.getCocktailCount()
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        editIndex = indexPath.row
        performSegue(withIdentifier: "editTaskAction", sender: self)
        //
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            cocktailManager?.deleteCocktail(at: indexPath.row)
            cocktailManager?.saveCocktails()
        }
        
        cocktailManager?.loadCocktails()
        cocktailTableView.reloadData()
    }
    
    //Unwind segue
    @IBAction func unwindToCocktailViewController(segue : UIStoryboardSegue){
        //print("Unwind Segue!")
        let source = segue.source as! AddItemViewController
        cocktailJSON = source.newCocktailJSON
        isEdit = source.isEditOp
        if (isEdit){
            cocktailManager?.updateCocktail(at: editIndex, cocktail: cocktailJSON!)
            cocktailManager?.saveCocktails()
        }
        
        else{
            cocktailManager?.createCocktail(cocktail: cocktailJSON!)
            cocktailManager?.saveCocktails()
        }
        
        
        
        cocktailManager?.loadCocktails()
        //reload table view
        cocktailTableView.reloadData()
    }
    

}
