//
//  UIViewController+Extensions.swift
//  MobileShop
//
//  Created by Srđan Stanić on 09/12/2020.
//

import UIKit

extension UIViewController {
    /// Creates an instance of `ViewControllerType` defined in a storyboard.
    ///
    /// The setup for this method to work is the following:
    /// 1. The storyboard needs to have a single view controller of the type `ViewControllerType`
    /// 2. This view controller needs to be set as the initial view controller
    /// 3. The name of the view controller needs to match the name of the storyboard and end with `ViewController`.
    ///   e.g. `Some.storyboard` and `SomeViewController`
    static func initFromStoryboard<ViewControllerType: UIViewController>() -> ViewControllerType {
        initFromStoryboard { storyboard in
            storyboard.instantiateInitialViewController() as? ViewControllerType
        }
    }

    /// Creates an instance of `ViewControllerType` defined in a storyboard.
    ///
    /// The setup for this method to work is the following:
    /// 1. The storyboard needs to have a single view controller of the type `ViewControllerType`
    /// 2. This view controller needs to be set as the initial view controller
    /// 3. The name of the view controller needs to match the name of the storyboard and end with `ViewController`.
    ///   e.g. `Some.storyboard` and `SomeViewController`
    static func initFromStoryboard<ViewControllerType: UIViewController>(creator: @escaping (NSCoder) -> ViewControllerType?) -> ViewControllerType {
        initFromStoryboard { storyboard in
            storyboard.instantiateInitialViewController(creator: creator)
        }
    }

    private static func initFromStoryboard<ViewControllerType: UIViewController>(
        instantiateViewController: @escaping (UIStoryboard) -> ViewControllerType?
    ) -> ViewControllerType {
        let bundle = Bundle(for: self)
        let name = String(describing: self).replacingOccurrences(of: "ViewController", with: "")
        let storyboard = UIStoryboard(name: name, bundle: bundle)

        guard let viewController = instantiateViewController(storyboard) else {
            let error = """
            ViewController of type \(self) failed to instantiate.
            Check if the ViewController is set as initial in the Storyboard
            and that it's set to a correct custom class.
            """
            fatalError(error)
        }
        return viewController
    }
}
