//
//  VIPER.Base.Router.swift
//  VIPER Implementation
//
//  Created by Vitalis on 12/12/2019.
//  Copyright © 2019 Neiron Digital. All rights reserved.
//

import UIKit
// ...........

open class Router: RouterInterface {
    //  MARK: - METHODS 🔰 PRIVATE
    // ///////////////////////////////////////////
    private unowned let controller: UIViewController
    
    // ...........
    private var navigationController: UINavigationController? {
        return controller.navigationController
    }
    
    //  MARK: - INITS
    // ////////////////////////////////////
    required public init(controller: UIViewController) {
        self.controller = controller
    }
    
    //  MARK: - LIFECYCLE
    // ////////////////////////////////////
    deinit {
        print("DEINIT ROUTER:     \(Self.self)")
    }
    
    //  MARK: - METHODS 🌐 PUBLIC
    // ///////////////////////////////////////////
    public func getNavigationControllerLastControllerType() -> UIViewController.Type? {
        guard let vc = navigationController?.viewControllers.last else {
            print("COULD NOT GET navigationController LAST")
            return nil
        }
        return type(of: vc)
    }
    // Present
    public func present(module: Module, isAnimated: Bool = true, completion: (() -> Void)? = nil) {
        controller.present(module: module, isAnimated: isAnimated, completion: completion)
    }
    // ...........
    
    public func dismiss(isAnimated: Bool, completion: (() -> Void)? = nil )  {
        navigationController?.dismiss(animated: isAnimated, completion: completion)
    }

    // Push
    public func push(module: Module, isAnimated: Bool = true) {
        navigationController?.push(module: module, isAnimated: isAnimated)
    }
    // ...........
    
    public func push<T: UIViewController>(module: Module, removing types: [T.Type], isAnimated: Bool = true) {
        navigationController?.push(module: module, removing: types, isAnimated: isAnimated)
    }
    // ...........
    
    public func popModule(isAnimated: Bool = true) {
        navigationController?.popViewController(animated: isAnimated)
    }
    // ...........
    
    public func fadeTo(module: Module) {
        navigationController?.fadeTo(module: module)
    }
    // ...........
    
    public func fadeTo<T: UIViewController>(module: Module, removing types: [T.Type]) {
        navigationController?.fadeTo(module: module, removing: types)
    }
    // ...........
    
    public func fadeTo<T: UIViewController>(module: Module, removingTill type: T.Type) {
        navigationController?.fadeTo(module: module, removingTill: type)
    }
    // ...........
    
    public func unfade() {
        navigationController?.unfade()
    }
    // ...........
    
    public func unfade<T: UIViewController>(to type: T.Type) {
        navigationController?.unfade(to: type)
    }
    // ...........
    
    public func slideTo(module: Module) {
        navigationController?.slide(module: module)
    }
    // ...........
    
    public func unslide() {
        navigationController?.unslide()
    }
    // ...........
    
    public func hideSuitably() {
        controller.hideSuitably()
    }
    // ...........

    public func hideSuitably<T: UIViewController>(to controllerType: T.Type) {
        controller.hideSuitably(to: controllerType)
    }
    // ...........
    
    public func stack(with modules: [Module], style: ControllerPresentationStyle.PushedStyle = .default, isAnimated: Bool = false) {
        navigationController?.stack(with: modules, style: style, isAnimated: isAnimated)
    }
    
    // Window
    public func newRoot(module: Module, isAnimated: Bool = true, completion: (() -> Void)? = nil) {
        Utils.newRoot(module: module, isAnimated: isAnimated, completion: completion)
    }
}

