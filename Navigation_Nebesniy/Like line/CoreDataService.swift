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
    func createPost(_ post: Post, completion: @escaping (Bool) -> Void)
    func fetchPost(predicate: NSPredicate?, completion: @escaping ([LikePostCoreDataModel]) -> Void)
    func deletePost(predicate: NSPredicate?, completion: @escaping (Bool) -> Void)
}

extension CoreDataService {

    func fetchPost(completion: @escaping ([LikePostCoreDataModel]) -> Void) {
        self.fetchPost(predicate: nil, completion: completion)
    }


    func deletePost(completion: @escaping (Bool) -> Void) {
        self.deletePost(predicate: nil, completion: completion)
    }
}

final class CoreDataServiceImp {

    private let objectModel: NSManagedObjectModel
    private let persistentStoreCoordinator: NSPersistentStoreCoordinator

    private lazy var mainContext: NSManagedObjectContext = {
        let context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        context.persistentStoreCoordinator = self.persistentStoreCoordinator
        return context
    }()

    private lazy var backgroundContext: NSManagedObjectContext = {
        let backgroundContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        backgroundContext.mergePolicy = NSOverwriteMergePolicy
        backgroundContext.persistentStoreCoordinator = self.persistentStoreCoordinator
        return backgroundContext
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

    func createPost(_ post: Post, completion: @escaping (Bool) -> Void) {
        self.backgroundContext.perform {

            let likePostCoreDataModel = LikePostCoreDataModel(context: self.backgroundContext)

            likePostCoreDataModel.postAuthor = post.author
            likePostCoreDataModel.postDescription = post.description
            likePostCoreDataModel.postImage = post.image
            likePostCoreDataModel.postLikes = Int64(post.likes)
            likePostCoreDataModel.postViews = Int64(post.views)
            likePostCoreDataModel.id = post.id

            guard self.backgroundContext.hasChanges else {
                self.mainContext.perform {
                    completion(false)
                }
                return
            }

            do {
                try self.backgroundContext.save()

                self.mainContext.perform {
                    completion(true)
                }
            } catch {
                self.mainContext.perform {
                    completion(false)
                }
            }
        }

    }

    func fetchPost(predicate: NSPredicate?, completion: @escaping ([LikePostCoreDataModel]) -> Void) {
        self.backgroundContext.perform {

            let fetchRequest = LikePostCoreDataModel.fetchRequest()
            fetchRequest.predicate = predicate

            do {
                let storedPosts = try self.backgroundContext.fetch(fetchRequest)

                self.mainContext.perform {
                    print("🍋 3", Thread.current)
                    completion(storedPosts)
                }
            } catch {
                self.mainContext.perform {
                    completion([])
                }
            }
        }
    }

    func deletePost(predicate: NSPredicate?, completion: @escaping (Bool) -> Void) {
        self.fetchPost(predicate: predicate) { post in
            self.backgroundContext.perform {

                post.forEach {
                    self.backgroundContext.delete($0)
                }

                guard self.backgroundContext.hasChanges else {
                    completion(false)
                    return
                }

                do {
                    try self.backgroundContext.save()

                    self.mainContext.perform {
                        completion(true)
                    }
                } catch {
                    self.mainContext.perform {
                        completion(false)
                    }
                }
            }
        }
    }

}
