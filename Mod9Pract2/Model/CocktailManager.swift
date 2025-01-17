//
//  CocktailManager.swift
//  Mod9Pract2
//
//  Created by Rodrigo Córdoba on 21/07/24.
//

import Foundation
import CoreData

class CocktailManager{
    
    let monitor = NetworkMonitor()
    
    private var cocktailList: [CocktailJSON] = []
    private var context : NSManagedObjectContext
    
    let baseStr = "http://janzelaznog.com/DDAM/iOS/"
    let imagesString = "drinksimages/"
    
    init (context : NSManagedObjectContext){
        self.context = context
    }
    
    func loadJSON(){
        let jsonStr = baseStr + "drinks.json"
        if let cocktailJSONStr = URL(string: jsonStr){
            let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            let cocktailsURL = documentsDirectory.appending(path: "drinks.json")
            if FileManager.default.fileExists(atPath: cocktailsURL.path){
                
            }
            else{
                if monitor.isReachable && monitor.connectionType == "WiFi"{
                    URLSession.shared.downloadTask(with: cocktailJSONStr){location, response, error in
                        guard let location = location, error == nil else{return}
                        do{
                            try FileManager.default.moveItem(at: location, to: cocktailsURL)
                            print("File downloaded to Documents")
                        }
                        catch{
                            print (error)
                        }
                    }.resume()
                    return
                }
            }
        }
    }
    
    //CRUD: Create
    func createCocktail(cocktail: CocktailJSON){
        cocktailList.append(cocktail)
    }
    
    //CRUD: Read
    func getCocktailList() -> [CocktailJSON]{
        loadCocktails()
        return cocktailList
    }
    
    func getCocktail(at index : Int) -> CocktailJSON{
        let cocktailImageString = baseStr + imagesString + cocktailList[index].img
        print(cocktailImageString)
        if let cocktailsURL = URL(string: cocktailImageString){
            let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            let cocktailsDirectory = documentsDirectory.appending(path: cocktailList[index].img)
            
            if FileManager.default.fileExists(atPath: cocktailsURL.path){
                
            }
            else{
                if monitor.isReachable && monitor.connectionType == "WiFi"{
                    URLSession.shared.downloadTask(with: cocktailsURL){location, response, error in
                        guard let location = location, error == nil else{return}
                        do{
                            try FileManager.default.moveItem(at: location, to: cocktailsDirectory)
                            print("File \(self.cocktailList[index].img) downloaded to Documents")
                        }
                        catch{
                            print(error)
                        }
                    }.resume()
                }
            }
        }
        return cocktailList[index]
    }
    
    func getCocktailCount() -> Int{
        return cocktailList.count
    }
    
    func loadCocktails(){
        let fileManager = FileManager.default
        let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        let cocktailsURL = documentsDirectory.appending(path: "drinks.json")
        
        //Check if file exists
        if fileManager.fileExists(atPath: cocktailsURL.path){
            do{
                let jsonData = fileManager.contents(atPath: cocktailsURL.path)
                //Decode json file into array
                self.cocktailList = try JSONDecoder().decode([CocktailJSON].self, from: jsonData!)
            }
            
            catch let error{
                print("Error loading: ",error)
            }
        }
        
        else{
            print("Unable to load file")
        }
    }
    
    //CRUD: Update
    func updateCocktail(at index:Int, cocktail : CocktailJSON){
        cocktailList[index] = cocktail
    }
    
    func saveCocktails(){
        let fileManager = FileManager.default
        let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        print("DocDir: ", documentsDirectory)
        
        let cocktailURL = documentsDirectory.appendingPathComponent("drinks.json")
        print("CocktailURL: ", cocktailURL)
        
        let cocktailURL2 = documentsDirectory.appending(path: "drinks.json")
        print("CocktailURL2: ", cocktailURL2)
        
        //Save [Cocktail] to JSON file
        do{
            let jsonData = try JSONEncoder().encode(cocktailList)
            fileManager.createFile(atPath: cocktailURL2.path, contents: jsonData)
        }
        catch let error{
            print(error)
        }
    }
    
    
    //CRUD: Delete
    func deleteCocktail(at index : Int){
        cocktailList.remove(at: index)
    }
    
    
}
