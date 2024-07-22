//
//  AddItemViewController.swift
//  Mod9Pract2
//
//  Created by Rodrigo Córdoba on 21/07/24.
//

import Foundation
import UIKit

class AddItemViewController: UIViewController {
    
    @IBOutlet weak var cocktailTitle: UITextField!
    
    @IBOutlet weak var cocktailIngredients: UITextField!
    
    @IBOutlet weak var cocktailDescription: UITextView!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var newCocktail : Cocktail?
    var newCocktailJSON : CocktailJSON?
    
    var isEditOp : Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if newCocktailJSON == nil{
            isEditOp = false
            cocktailTitle.text = ""
            cocktailIngredients.text = ""
            cocktailDescription.text = ""
            newCocktailJSON = CocktailJSON(name: "", ingredients: "", directions: "", img: "")
        }
        
        else{
            isEditOp = true
            cocktailTitle.text = newCocktailJSON?.name
            cocktailIngredients.text = newCocktailJSON?.ingredients
            cocktailDescription.text = newCocktailJSON?.directions
        }

        // Do any additional setup after loading the view.
    }
    
    @IBAction func cxancelButtonPressed(_ sender: UIButton) {
        let isModal = self.presentingViewController is UINavigationController
        if isModal{
            self.dismiss(animated: true)
        }
        
        else{
            navigationController?.popViewController(animated: true)
        }
        
        
    }
    @IBAction func cancelButtonTapped(_ sender: UIBarButtonItem) {
        
    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //newNote = Note(title: noteTitle.text ?? "", content: noteContent.text, date: Date())
        let destination = segue.destination as! CocktailViewController
        
        newCocktailJSON?.name = cocktailTitle.text ?? ""
        newCocktailJSON?.ingredients = cocktailIngredients.text ?? ""
        newCocktailJSON?.directions = cocktailDescription.text ?? ""
        destination.cocktailJSON = newCocktailJSON
        destination.isEdit = isEditOp
        
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if(cocktailTitle.text!.isEmpty || cocktailDescription.text!.isEmpty || cocktailIngredients.text!.isEmpty){
            print("Sexo")
            return false
        }
        
        else{
            print("Dr Jr")
            return true
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
