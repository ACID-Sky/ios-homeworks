//
//  CoreDataService.swift
//  Navigation_Nebesniy
//
//  Created by Лёха Небесный on 27.03.2023.
//

import Foundation
import CoreData
import StorageService
import UIKit

protocol CoreDataService: AnyObject {
    func createPost(_ post: Post)
    func getSection() -> [NSFetchedResultsSectionInfo]
    func getObject(index: IndexPath) -> LikePostCoreDataModel?
    func getObjects() -> [LikePostCoreDataModel]
    func deletePost(postModel: LikePostCoreDataModel)
    func fetchFilterPost(predicate: NSPredicate?)
}

final class CoreDataServiceImp {

    private var context: NSManagedObjectContext?
    private var fecthedResultsController: NSFetchedResultsController<LikePostCoreDataModel>?

    init(delegate: NSFetchedResultsControllerDelegate?) {
        self.setupFecthedResultsController()
        self.fecthedResultsController?.delegate = delegate
        self.fetchPost()
    }

    private func setupFecthedResultsController() {
        self.context = (UIApplication.shared.delegate as? AppDelegate)?.container?.viewContext

        guard let context = self.context else { fatalError() }

        let fetchRequest = LikePostCoreDataModel.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "id", ascending: true)
        fetchRequest.sortDescriptors = [
            sortDescriptor
        ]

        self.fecthedResultsController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: context,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
    }

    private func fetchPost() {
        do {
            try self.fecthedResultsController?.performFetch()

        } catch {
            fatalError("Can't fetch data from db")
        }

    }
    private func saveContext(context: NSManagedObjectContext) {
        do {
            try context.save()

        } catch {
            fatalError()
        }
    }
}

extension CoreDataServiceImp: CoreDataService {
    func getObjects() -> [LikePostCoreDataModel] {
        guard let likedPosts = self.fecthedResultsController?.fetchedObjects else { return [] }
        return likedPosts
    }


    func getSection() -> [NSFetchedResultsSectionInfo] {
        guard let sections = self.fecthedResultsController?.sections else { return []}
        return sections
    }

    func getObject(index indexPath: IndexPath) -> LikePostCoreDataModel? {
        guard let likedPost = self.fecthedResultsController?.object(at: indexPath) else { return nil }
        return likedPost
    }

    func createPost(_ post: Post) {
        guard let context = self.context else { return }

        let postModel = LikePostCoreDataModel(context: context)
        postModel.postAuthor = post.author
        postModel.id = post.id
        postModel.postImage = post.image
        postModel.postDescription = post.description
        postModel.postViews = Int64(post.views)
        postModel.postLikes = Int64(post.likes)

        self.saveContext(context: context)
    }


    func fetchFilterPost(predicate: NSPredicate?) {
        self.fecthedResultsController?.fetchRequest.predicate = predicate
        self.fetchPost()
    }

    func deletePost(postModel: LikePostCoreDataModel) {
        guard let context = self.context else { return }

        context.delete(postModel)
        self.saveContext(context: context)
    }

}
