//
//  ProfileCreateRouter.swift
//  SniffMeet
//
//  Created by 윤지성 on 11/14/24.
//
import UIKit

protocol ProfileCreateRoutable {
    static func createProfileCreateModule(dogDetailInfo: DogDetailInfo) -> UIViewController
    func presentMainScreen(from view: ProfileCreateViewable)
}

final class ProfileCreateRouter: ProfileCreateRoutable {
    static func createProfileCreateModule(dogDetailInfo: DogDetailInfo) -> UIViewController {
        let storeDogInfoUsecase: StoreDogInfoUseCase =
        StoreDogInfoUserCaseImpl(localDataManager: LocalDataManager())

        let view: ProfileCreateViewable & UIViewController = ProfileCreateViewController()
        let presenter: ProfileCreatePresentable & DogInfoInteractorOutput
        = ProfileCreatePresenter(dogInfo: dogDetailInfo)
        let interactor: ProfileCreateInteractable =
        ProfileCreateInteractor(usecase: storeDogInfoUsecase)
        let router: ProfileCreateRoutable = ProfileCreateRouter()

        view.presenter = presenter
        presenter.view = view
        presenter.router = router
        presenter.interactor = interactor
        interactor.presenter = presenter

        return view
    }
    
    func presentMainScreen(from view: any ProfileCreateViewable) {
        if let sceneDelegate = UIApplication.shared.connectedScenes
            .first(where: { $0.activationState == .foregroundActive })?
            .delegate as? SceneDelegate {
            if let router = sceneDelegate.appRouter {
                router.moveToHomeScreen()
            }
        }
    }
}
