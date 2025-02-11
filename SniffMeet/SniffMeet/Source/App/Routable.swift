//
//  Routable.swift
//  SniffMeet
//
//  Created by sole on 11/19/24.
//

import UIKit

protocol Routable {
    func push(from: UIViewController, to: UIViewController, animated: Bool)
    func pop(from: UIViewController, animated: Bool)
    func present(from: UIViewController, with: UIViewController, animated: Bool)
    func dismiss(from: UIViewController, animated: Bool)
    func pushNoBottomBar(from: UIViewController, to: UIViewController, animated: Bool)
    func fullScreen(from: UIViewController, with: UIViewController, animated: Bool)
}

extension Routable {
    func push(from: UIViewController, to: UIViewController, animated: Bool) {
        from.navigationController?.pushViewController(to, animated: animated)
    }

    func pop(from: UIViewController, animated: Bool) {
        from.navigationController?.popViewController(animated: animated)
    }

    func present(from: UIViewController, with: UIViewController, animated: Bool) {
        from.present(with, animated: animated)
    }

    func dismiss(from: UIViewController, animated: Bool) {
        from.dismiss(animated: animated)
    }

    func pushNoBottomBar(from: UIViewController, to: UIViewController, animated: Bool) {
        to.hidesBottomBarWhenPushed = true
        from.navigationController?.pushViewController(to, animated: animated)
    }

    func fullScreen(from: UIViewController, with: UIViewController, animated: Bool) {
        with.modalPresentationStyle = .overFullScreen
        from.present(with, animated: animated)
    }
}
