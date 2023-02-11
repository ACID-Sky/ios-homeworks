////
////  ProfileViewModel.swift
////  Navigation_Nebesniy
////
////  Created by Лёха Небесный on 10.02.2023.
////
//
//import Foundation
//
//protocol ProfileViewModelProtocol: ViewModelProtocol {
//    var onStateDidChange: ((ProfileViewModel.State) -> Void)? { get set }
//    func updateState(viewInput: ProfileViewModel.ViewInput)
//}
//
//final class ProfileViewModel: ProfileViewModelProtocol {
//    enum State {
//        case initial
////        case newStatus
////        case showAvatar
////        case hidenAvatar
//
////        case loading
////        case loaded(books: [Book])
////        case error(Error)
//    }
//
//    enum ViewInput {
////        case setStatusButtonDidTap
////        case avatarDidTap
////        case closeButtonDidTap
//        case cellPhotosDidTap
//        
////        case loadButtonDidTap
////        case bookDidSelect(Book)
//    }
//
//    weak var coordinator: BooksListCoordinator?
//    var onStateDidChange: ((State) -> Void)?
//
//    private(set) var state: State = .initial {
//        didSet {
//            onStateDidChange?(state)
//        }
//    }
//
////    private let networkService: NetworkServiceProtocol
////
////    init(networkService: NetworkServiceProtocol) {
////        self.networkService = networkService
////    }
//
//    func updateState(viewInput: ViewInput) {
//        switch viewInput {
////        case .setStatusButtonDidTap:
////
////        case .avatarDidTap:
////
////        case .closeButtonDidTap:
//
//        case .cellPhotosDidTap:
//            coordinator?.pushBookViewController(forBook: book)
////        case .loadButtonDidTap:
////            state = .loading
////            networkService.loadBooks { [weak self] result in
////                switch result {
////                case .success(let books):
////                    self?.state = .loaded(books: books)
////                case .failure(let error):
////                    self?.state = .error(error)
////                }
////            }
////        case let .bookDidSelect(book):
////            coordinator?.pushBookViewController(forBook: book)
//        }
//    }
//
//}
