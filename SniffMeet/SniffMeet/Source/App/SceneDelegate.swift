//
//  SceneDelegate.swift
//  SniffMeet
//
//  Created by sole on 11/4/24.
//

import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    var appRouter: AppRouter?
    private weak var sessionController: SessionViewController?
//    private let convertToRequestAPS: any ConvertToRequestAPSUseCase = ConverToRequestAPSUseCaseImpl()
//    private let convertToResponsdAPS: any ConvertToRespondAPSUseCase = ConvertToRespondAPSUseCaseImpl()

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        appRouter = AppRouter(window: window)
        let sessionController = SessionViewController(appRouter: appRouter)
        self.sessionController = sessionController

        if let response = connectionOptions.notificationResponse {
            routePushNotification(response: response)
        }
        window?.rootViewController = sessionController
        window?.makeKeyAndVisible()
    }

    /// push notification을 통해 앱에 처음 진입한 경우 라우팅을 진행합니다.
    private func routePushNotification(response: UNNotificationResponse) {
        let userInfo = response.notification.request.content.userInfo
//        if let requestAPS = convertToRequestAPS.execute(userInfo: userInfo) {
//            sessionController?.walkNoti = requestAPS.walkRequest.toEntity()
//        } else if let respondAPS = convertToResponsdAPS.execute(userInfo: userInfo) {
//            // TODO: 산책 거절 / 수락 화면으로 라우팅
//            sessionController?.isAccepted = respondAPS.isAccepted
//        }
    }
}
