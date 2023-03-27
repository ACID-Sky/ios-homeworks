//
//  CoreDataService.swift
//  Navigation_Nebesniy
//
//  Created by Лёха Небесный on 27.03.2023.
//

import Foundation
import CoreData
import StorageService

protocol CoreDataService: AnyObject {
    func createPost(_ post: Post) -> Bool
    func fetchPost(predicate: NSPredicate?) -> [LikePostCoreDataModel]
    func deletePost(predicate: NSPredicate?) -> Bool
}

extension CoreDataService {

    func fetchPost() -> [LikePostCoreDataModel] {
        self.fetchPost(predicate: nil)
    }


    func deletePost() -> Bool {
        self.deletePost(predicate: nil)
    }
}

final class CoreDataServiceImp {

    private let objectModel: NSManagedObjectModel
    private let persistentStoreCoordinator: NSPersistentStoreCoordinator

    private lazy var context: NSManagedObjectContext = {
        let context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        context.persistentStoreCoordinator = self.persistentStoreCoordinator
        return context
    }()

    init() {
        guard let url = Bundle.main.url(forResource: "Navigation_Nebesniy", withExtension: "momd") else {
            fatalError("There is no xcdatamodeld file.")
        }

        let path = url.pathExtension
        guard let name = try? url.lastPathComponent.replace(path, replacement: "") else {
            fatalError()
        } // Navigation_Nebesniy.

        guard let model = NSManagedObjectModel(contentsOf: url) else {
            fatalError("Can't create NSManagedObjectModel")
        }
        self.objectModel = model

         self.persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: self.objectModel)


        let storeName = name + "sqlite"
        let documentsDirectoryUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        let persistantStoreUrl = documentsDirectoryUrl?.appendingPathComponent(storeName)

        guard let persistantStoreUrl = persistantStoreUrl else {
            return
        }

        let options = [NSMigratePersistentStoresAutomaticallyOption: true]
        do {
            try self.persistentStoreCoordinator.addPersistentStore(
                type: .sqlite,
                at: persistantStoreUrl,
                options: options
            )
        } catch {
            fatalError("Can't create NSPersistantStore")
        }
    }
}

extension CoreDataServiceImp: CoreDataService {

    func createPost(_ post: Post) -> Bool {
        let likePostCoreDataModel = LikePostCoreDataModel(context: self.context) 

        likePostCoreDataModel.postAuthor = post.author
        likePostCoreDataModel.postDescription = post.description
        likePostCoreDataModel.postImage = post.image
        likePostCoreDataModel.postLikes = Int16(post.likes)
        likePostCoreDataModel.postViews = Int16(post.views)

        guard self.context.hasChanges else {
            return false
        }

        do {
            try self.context.save()
            return true
        } catch {
            return false
        }
    }

    func fetchPost(predicate: NSPredicate?) -> [LikePostCoreDataModel] {
        let fetchRequest = LikePostCoreDataModel.fetchRequest()
        fetchRequest.predicate = predicate

        do {
            let storedPosts = try self.context.fetch(fetchRequest)
            return storedPosts
        } catch {
            return []
        }
    }

    func deletePost(predicate: NSPredicate?) -> Bool {
        let post = self.fetchPost(predicate: predicate)

        post.forEach {
            self.context.delete($0)
        }

        guard self.context.hasChanges else {
            return false
        }

        do {
            try self.context.save()
            return true
        } catch {
            return false
        }
    }

}
