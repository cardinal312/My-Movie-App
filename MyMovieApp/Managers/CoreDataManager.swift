//
//  CoreDataManager.swift
//  MyMovieApp
//
//  Created by Macbook on 7/5/24.
//

import Foundation
import CoreData

final class CoreDataManager {
    
    //MARK: - For Error Handling
    enum DataBaseError: Error {
        case failedToSaveData
        case failedToFetchDataFromDataBase
        case deleteDataFromCoreData
    }
    
    // MARK: - Variables
    static let shared = CoreDataManager()
    private let queue = DispatchQueue(label: "queue", attributes: .concurrent)
    
    // MARK: Core Data Stack
    lazy var persistentContainer: NSPersistentContainer = { // persistent container
        let container = NSPersistentContainer(name: "MyMovieAppModel")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: Core Data Saving Support
    func saveContext() { // Context Manager
        let context = persistentContainer.viewContext
        
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as? NSError
                fatalError("Unresolved error \(error) <<<--- NSERROR")
            }
        }
    }
    
    // MARK: - Addition Method
    func downloadTitleWith(model: Title, compleation: @escaping (Result<Void, DataBaseError>) -> Void) {
        
        // MARK: - Readers and Writers Problem Resolving (Multi Threding)
        let context = persistentContainer.viewContext
        let item = TitleItem(context: context)
        
        queue.async(flags: .barrier) { [weak self] in
            guard let self = self else { return }
            item.original_title = model.original_title
            item.id = Int64(model.id)
            item.original_name = model.original_name
            item.overview = model.overview
            item.media_type = model.media_type
            item.poster_path = model.poster_path
            item.release_date = model.release_date
            item.vote_count = Int64(model.vote_count)
            item.vote_average = model.vote_average
        }
        
        do {
            try context.save()
            compleation(.success(()))
        } catch {
            compleation(.failure(.failedToSaveData))
            print(error.localizedDescription)
        }
    }
    
    func fetchingTitlesFromDataBase(compleation: @escaping (Result<[TitleItem], DataBaseError>) -> Void) {
        
        let context = persistentContainer.viewContext
        let request: NSFetchRequest<TitleItem>
        request = TitleItem.fetchRequest()
        
        do {
            let titles = try context.fetch(request)
            compleation(.success(titles))
        } catch {
            compleation(.failure(.failedToFetchDataFromDataBase))
        }
    }
    
    func deleteTitleWith(model: TitleItem, compleation: @escaping (Result<Void, DataBaseError>) -> Void) {
        
        let context = persistentContainer.viewContext
        
        context.delete(model)
        
        do {
            try context.save()
            compleation(.success(()))
        } catch {
            compleation(.failure(.deleteDataFromCoreData))
        }
    }
}


