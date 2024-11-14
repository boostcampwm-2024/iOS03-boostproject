//
//  Untitled.swift
//  SniffMeet
//
//  Created by 윤지성 on 11/14/24.
//
import UIKit

protocol ProfileInputRoutable {
    static func createProfileInputModule() -> UIViewController
    func navigateToNextScreen()
}

final class ProfileInputRouter: ProfileInputRoutable {
    static func createProfileInputModule() -> UIViewController {
        let view: ProfileInputViewable & UIViewController = ProfileInputViewController()
        var presenter: ProfileInputPresentable = ProfileInputPresenter()
        let router: ProfileInputRoutable = ProfileInputRouter()

        view.presenter = presenter
        presenter.view = view
        presenter.router = router

        return view
    }
    
    func navigateToNextScreen() {
        
    }
}
