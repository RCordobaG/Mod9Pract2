//
//  AddItemViewController.swift
//  Mod9Pract2
//
//  Created by Rodrigo Córdoba on 21/07/24.
//

import Foundation
import UIKit
import AVFoundation

class AddItemViewController: UIViewController {
    
    @IBOutlet weak var cocktailTitle: UITextField!
    
    @IBOutlet weak var cocktailIngredients: UITextField!
    
    @IBOutlet weak var cocktailDescription: UITextView!
    
    @IBOutlet weak var imagePreview: UIImageView!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var newCocktail : Cocktail?
    var newCocktailJSON : CocktailJSON?
    
    let ipc = UIImagePickerController()
    
    var isEditOp : Bool = false
    
    var date : String?

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
    @IBAction func photoButtonPressed(_ sender: UIButton) {
        ipc.delegate = self
        ipc.allowsEditing = true
        ipc.sourceType = .photoLibrary
        
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            let ac = UIAlertController(title: "Add photo", message: "Use camera or choose photo from gallery", preferredStyle: .alert)
            
            let action1 = UIAlertAction(title: "Camera", style: .default){
                alertaction in
                self.ipc.sourceType = .camera
                ac.dismiss(animated: false)
                self.present(self.ipc, animated: true)
            }
            
            let action2 = UIAlertAction(title: "Gallery", style: .default){
                alertaction in
                self.ipc.sourceType = .photoLibrary
                ac.dismiss(animated: false)
                self.present(self.ipc, animated: true)
            }
            
            ac.addAction(action1)
            ac.addAction(action2)
            self.present(ac, animated: true)
        }
        
        else{
            self.present(self.ipc, animated: true)
        }
    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //newNote = Note(title: noteTitle.text ?? "", content: noteContent.text, date: Date())
        let destination = segue.destination as! CocktailViewController
        
        newCocktailJSON?.name = cocktailTitle.text ?? ""
        newCocktailJSON?.ingredients = cocktailIngredients.text ?? ""
        newCocktailJSON?.directions = cocktailDescription.text ?? ""
        newCocktailJSON?.img = (date ?? "0")+".jpg"
        
        destination.cocktailJSON = newCocktailJSON
        destination.isEdit = isEditOp
        
    }
    
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if(cocktailTitle.text!.isEmpty || cocktailDescription.text!.isEmpty || cocktailIngredients.text!.isEmpty){
            return false
        }
        
        else{
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

extension AddItemViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
                // Se configuro el recorte de la foto
                //La imagen se obtiene en la llave
        if let imagen = info[.originalImage] as? UIImage{
            // asignamos la foto al container, pero no se guarda en la galeria
            imagePreview.image = imagen
            
            //para guardar la imagen en la galeria:
            UIImageWriteToSavedPhotosAlbum(imagen, nil, nil, nil)
            saveToDocs(imagen)
        }
        picker.dismiss(animated: true)
                
                //Si se configuro el recorte de la foto
                // la imagen se obtiene en la llave
                if let imagen = info[.editedImage] as? UIImage{
                    // asignamos la foto al container, pero no se guarda en la galeria
                    imagePreview.image = imagen
                    
                    //para guardar la imagen en la galeria:
                    UIImageWriteToSavedPhotosAlbum(imagen, nil, nil, nil)
                    saveToDocs(imagen)
                }
                picker.dismiss(animated: true)
            }
            
            func saveToDocs (_ img: UIImage) {
                date = Date().ISO8601Format()
                //encontramos la url de documents directory:
                if var dUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first{
                    dUrl.append(path: date ?? "0" + ".jpg")
                    // obtener los bytes que representan la foto
                    let bytes = img.jpegData(compressionQuality: 0.5)
                    do {
                        try bytes?.write(to:dUrl, options:.atomic)
                        print("Image saved in \(dUrl.absoluteString)")
                    }
                    catch {
                        print("Error saving image")
                    }
                }
            }
}
