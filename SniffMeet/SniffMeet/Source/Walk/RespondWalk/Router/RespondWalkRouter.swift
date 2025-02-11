//
//  RespondWalkRouter.swift
//  SniffMeet
//
//  Created by 윤지성 on 11/20/24.
//
import CoreLocation
import UIKit

protocol RespondWalkRoutable: AnyObject, Routable {
    func dismissView(view: any RespondWalkViewable)
    func showSelectedLocationMapView(view: any RespondWalkViewable, address: Address)
}

protocol RespondWalkBuildable {
    static func createRespondtWalkModule(walkNoti: WalkNoti) -> UIViewController
}

final class RespondWalkRouter: RespondWalkRoutable {
    func dismissView(view: any RespondWalkViewable) {
        guard let view = view as? UIViewController else { return }
        Task { @MainActor in
            view.dismiss(animated: true)
        }
    }
    func showSelectedLocationMapView(view: any RespondWalkViewable, address: Address) {
        guard let view = view as? UIViewController else { return }
        let selectedLocationView = RespondMapRouter.createRespondMapView(address: address)
        fullScreen(from: view, with: selectedLocationView, animated: true)
    }
}

extension RespondWalkRouter: RespondWalkBuildable {
    static func createRespondtWalkModule(walkNoti: WalkNoti) -> UIViewController {
        let requestUserInfoUseCase: RequestMateInfoUseCase = RequestMateInfoUsecaseImpl()
        let respondUseCase: RespondWalkRequestUseCase = RespondWalkRequestUseCaseImpl(
            remoteDatabaseManager: SupabaseDatabaseManager.shared
        )
        let calculateTimeUseCase: CalculateTimeLimitUseCase = CalculateTimeLimitUseCaseImpl()
        let convertLocationToTextUseCase: ConvertLocationToTextUseCase =
        ConvertLocationToTextUseCaseImpl()
        let requestProfileImageUseCase: RequestProfileImageUseCase =
RequestProfileImageUseCaseImpl(
            remoteImageManager: SupabaseStorageManager(
                networkProvider: SNMNetworkProvider()
            ),
            cacheManager: ImageNSCacheManager.shared
        )
        let loadUserUseCase = LoadUserInfoUseCaseImpl(
            dataLoadable: LocalDataManager(),
            imageManageable: SNMFileManager()
        )

        let view: RespondWalkViewable & UIViewController = RespondWalkViewController()
        let presenter: RespondWalkPresentable & RespondWalkInteractorOutput =
        RespondWalkPresenter(noti: walkNoti)
        let interactor: RespondWalkInteractable =
        RespondWalkInteractor(
            requestUserInfoUseCase: requestUserInfoUseCase,
            respondUseCase: respondUseCase,
            calculateTimeLimitUseCase: calculateTimeUseCase,
            convertLocationToTextUseCase: convertLocationToTextUseCase,
            requestProfileImageUseCase: requestProfileImageUseCase,
            loadUserUseCase: loadUserUseCase
        )

        let router: RespondWalkRoutable & RespondWalkBuildable = RespondWalkRouter()

        view.presenter = presenter
        presenter.view = view
        presenter.router = router
        presenter.interactor = interactor
        interactor.presenter = presenter

        return view
    }
}
