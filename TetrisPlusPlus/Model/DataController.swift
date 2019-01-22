//
//  DataController.swift
//  ios-tetrisPlusPlus
//
//  Created by Diego Neves on 21/01/19.
//  Copyright © 2019 dj. All rights reserved.
//

import CoreData

class DataController {
    
    let persistentContainer:NSPersistentContainer
    
    var viewContext:NSManagedObjectContext{
        return persistentContainer.viewContext
    }
    
    init(modelName:String){
        persistentContainer = NSPersistentContainer(name: modelName)
    }
    
    func load(completion: (() -> Void)? = nil){
        
        persistentContainer.loadPersistentStores { storeDescription, error in
            
            guard error == nil else{
                fatalError(error!.localizedDescription)
            }
            self.autoSaveViewContext()
            completion?()
            
        }
    }
    
}

extension DataController {
    
    func autoSaveViewContext(interval : TimeInterval = 30){
        print("autosaving")
        guard interval > 0 else {
            print("cannot set negative autosave interval")
            return
        }
        
        if viewContext.hasChanges {
            try? viewContext.save()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + interval){
            self.autoSaveViewContext(interval: interval)
        }
    }
    
    func delete(obj : NSManagedObject){
        
        viewContext.delete(obj)
        
        try?  viewContext.save()
        
    }
    
    
}

extension DataController {

    func findAllScores() -> [Score]{

        var images: [Score] = []
        let fetchRequest: NSFetchRequest<Score> = Score.fetchRequest()

        let predicate = NSPredicate(value: true)
        fetchRequest.predicate = predicate

        if let result = try? viewContext.fetch(fetchRequest){
            images = result
        }

        return images
    }

    func saveScore(scoreValue : Double, level : Int16){
        let score = Score(context: viewContext)
        score.level = level
        score.score = scoreValue

        try?  viewContext.save()

    }


}

