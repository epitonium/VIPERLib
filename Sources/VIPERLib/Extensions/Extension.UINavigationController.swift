//
//  Extension.UINavigationController.swift
//  VIPER Implementation
//
//  Created by Vitalis on 13/12/2019.
//  Copyright © 2019 Neiron Digital. All rights reserved.
//

import UIKit
// ...........

public extension UINavigationController {
    // ...........
    enum GoBackStyle {
        case pop
        case unfade
        case unslide
    }
    //  MARK: - METHODS 🌐 PUBLIC
    // ///////////////////////////////////////////
    func push(module: Module, isAnimated: Bool = true) {
        let vc = module.getController()
        if let presentationSylable = (vc as? PresentationSylable) {
            presentationSylable.controllerPresentationStyle = .pushed(.default)
        }
        pushViewController(vc, animated: isAnimated)
    }
    // ...........
    
    func push<T: UIViewController>(module: Module, removing types: [T.Type], isAnimated: Bool = true) {
        // Get controller
        let vc = module.getController()
        // Set presentation
        if let presentationSylable = (vc as? PresentationSylable) {
            presentationSylable.controllerPresentationStyle = .pushed(.default)
        }
        // Remove specific controllers
        var viewControllerList = viewControllers.filter({ (viewController) -> Bool in
            return !types.contains(where: { String(describing: type(of: viewController)) == String(describing: $0)})
        })
        viewControllerList.append(vc)
        setViewControllers(viewControllerList, animated: isAnimated)
    }
    // ...........
    
    func fadeTo(module: Module) {
        let vc = module.getController()
        if let presentationSylable = (vc as? PresentationSylable) {
            presentationSylable.controllerPresentationStyle = .pushed(.fade)
        }
        let transition: CATransition = CATransition()
        transition.duration = 0.15
        transition.type = CATransitionType.fade
        view.layer.add(transition, forKey: nil)
        pushViewController(vc, animated: false)
    }
    
    // ...........
    func fadeTo<T: UIViewController>(module: Module, removing types: [T.Type] = []) {
        // Get controller
        let vc = module.getController()
        // Set presentation
        if let presentationSylable = (vc as? PresentationSylable) {
            presentationSylable.controllerPresentationStyle = .pushed(.fade)
        }
        // Remove specific controllers
        var viewControllerList = viewControllers.filter({ (viewController) -> Bool in
            return !types.contains(where: { String(describing: type(of: viewController)) == String(describing: $0)})
        })
        // Transition
        let transition: CATransition = CATransition()
        transition.duration = 0.15
        transition.type = CATransitionType.fade
        view.layer.add(transition, forKey: nil)
        viewControllerList.append(vc)
        setViewControllers(viewControllerList, animated: false)
    }
    // ...........
    
    func unfade() {
        let transition: CATransition = CATransition()
        transition.duration = 0.15
        transition.timingFunction = CAMediaTimingFunction(name: .easeOut)
        transition.type = CATransitionType.fade
        view.layer.add(transition, forKey: nil)
        popViewController(animated: false)
    }
    // ...........
    
    func slide(module: Module) {
        let vc = module.getController()
        if let presentationSylable = (vc as? PresentationSylable) {
            presentationSylable.controllerPresentationStyle = .pushed(.slide)
        }
        let transition: CATransition = CATransition()
        transition.duration = 0.3
        transition.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        transition.type = CATransitionType.moveIn
        transition.subtype = CATransitionSubtype.fromTop
        view.layer.add(transition, forKey: kCATransition)
        pushViewController(vc, animated: false)
    }
    // ...........
    
    func unslide() {
        let transition: CATransition = CATransition()
        transition.duration = 0.3
        transition.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        transition.type = CATransitionType.reveal
        transition.subtype = CATransitionSubtype.fromBottom
        view.layer.add(transition, forKey: kCATransition)
        popViewController(animated: false)
    }
    // ...........
    
    // Pop to controller
    func pop<T: UIViewController>(to controllerType: T.Type) {
        goBack(to: controllerType, style: .pop)
    }
    
    // Unfade to controller
    func unfade<T: UIViewController>(to controllerType: T.Type) {
        goBack(to: controllerType, style: .unfade)
    }
    
    // Unslide to controller
    func unslide<T: UIViewController>(to controllerType: T.Type) {
        goBack(to: controllerType, style: .unslide)
    }
    
    // Controllers stack
    func stack(with modules: [Module], style: ControllerPresentationStyle.PushedStyle = .default, isAnimated: Bool = false) {
        // Check modules
        guard !modules.isEmpty else {
            print("EMPTY MODULES LIST")
            return
        }
        // Declare controllers
        var controllersList = [UIViewController]()
        // Iterate
        modules.forEach { module in
            let vc = module.getController()
            if let presentationSylable = (vc as? PresentationSylable) {
                presentationSylable.controllerPresentationStyle = .pushed(style)
            }
            controllersList.append(vc)
        }
        // Check presentation style
        switch style {
        case .default:
            setViewControllers(controllersList, animated: isAnimated)
            // ...........
        case .fade:
            if isAnimated {
                let transition: CATransition = CATransition()
                transition.duration = 0.15
                transition.type = CATransitionType.fade
                view.layer.add(transition, forKey: nil)
            }
            setViewControllers(controllersList, animated: false)
            // ...........
        case .slide:
            if isAnimated {
                let transition: CATransition = CATransition()
                transition.duration = 0.3
                transition.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
                transition.type = CATransitionType.moveIn
                transition.subtype = CATransitionSubtype.fromTop
                view.layer.add(transition, forKey: nil)
            }
            setViewControllers(controllersList, animated: false)
        }
    }
    
    //  MARK: - METHODS 🔰 PRIVATE
    // ////////////////////////////////////
    private func goBack<T: UIViewController>(to controllerType: T.Type, style: GoBackStyle) {
        for vc in viewControllers {
            if vc.isKind(of: controllerType) {
                switch style {
                case .pop:
                    popToViewController(vc, animated: true)
                case .unfade:
                    popToViewController(vc, animated: false)
                case .unslide:
                    popToViewController(vc, animated: false)
                }
                return
            }
        }
        print("COULD NOT GO BACK TO '\(controllerType.self)' CONTROLLERS")
    }
}
// ...........

extension UINavigationController: Module {
    public func getController() -> UIViewController {
        self
    }
}
