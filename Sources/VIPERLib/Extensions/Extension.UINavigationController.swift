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
    enum Transition {
        case fade
        case unfade
        case slide
        case unslide
    }
    
    //  MARK: - PROPERTIES 🔰 PRIVATE
    // ////////////////////////////////////
    private var fadeInterval: TimeInterval { 0.15 }
    private var slideInterval: TimeInterval { 0.3 }
    
    //  MARK: - METHODS 🌐 PUBLIC
    // ///////////////////////////////////////////
    
    
    //                                      MARK: - STACK
    //..............................................................................................
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
            // Get controller and set presentation style
            let vc = getController(from: module, forPresentationStyle: .pushed(style))
            // Append to the list
            controllersList.append(vc)
        }
        // Check presentation style
        switch style {
        case .default:
            // Execute
            setViewControllers(controllersList, animated: isAnimated)
            // ...........
        case .fade:
            if isAnimated {
                // Transition
                setTransition(.fade, view)
            }
            // Execute
            setViewControllers(controllersList, animated: false)
            // ...........
        case .slide:
            if isAnimated {
                // Transition
                setTransition(.slide, view)
            }
            // Execute
            setViewControllers(controllersList, animated: false)
        }
    }
    
    //                                      MARK: - PUSH
    //..............................................................................................
    func push(module: Module, isAnimated: Bool = true) {
        // Get controller and set presentation style
        let vc = getController(from: module, forPresentationStyle: .pushed(.default))
        // Execute
        pushViewController(vc, animated: isAnimated)
    }
    // ...........
    func push<T: UIViewController>(module: Module, removing types: [T.Type], isAnimated: Bool = true) {
        // Get controller and set presentation style
        let vc = getController(from: module, forPresentationStyle: .pushed(.default))
        // Remove specific controllers
        let newControllerList = getList(removing: types, andAdding: vc)
        // Execute
        setViewControllers(newControllerList, animated: isAnimated)
    }
    
    //                                      MARK: - POP
    //..............................................................................................
    // Pop to controller
    func pop<T: UIViewController>(to controllerType: T.Type) {
        // Get controller
        guard let vc = getController(forType: controllerType) else {
            return
        }
        // Execute
        popToViewController(vc, animated: true)
    }
    
    //                                      MARK: - FADE
    //..............................................................................................
    func fadeTo(module: Module) {
        // Get controller and set presentation style
        let vc = getController(from: module, forPresentationStyle: .pushed(.fade))
        // Transition
        setTransition(.fade, view)
        // Execute
        pushViewController(vc, animated: false)
    }
    // ...........
    func fadeTo<T: UIViewController>(module: Module, removing types: [T.Type] = []) {
        // Get controller and set presentation style
        let vc = getController(from: module, forPresentationStyle: .pushed(.fade))
        // Remove specific controllers
        let newControllerList = getList(removing: types, andAdding: vc)
        // Transition
        setTransition(.fade, view)
        // Execute
        setViewControllers(newControllerList, animated: false)
    }
    // ...........
    func fadeTo<T: UIViewController>(module: Module, removingTill type: T.Type) {
        viewControllers.forEach { vc in
            print(vc, "\n")
        }
        // Get controller and set presentation style
        let vc = getController(from: module, forPresentationStyle: .pushed(.fade))
        // Remove specific controllers
        let newControllerList = getList(removingTill: type, andAdding: vc)
        
        newControllerList.forEach { vc in
            print(vc, "\n")
        }
        // Transition
        setTransition(.fade, view)
        // Execute
        setViewControllers(newControllerList, animated: false)
    }
    
    //                                      MARK: - UNFADE
    //..............................................................................................
    func unfade() {
        // Transition
        setTransition(.unfade, view)
        // Execute
        popViewController(animated: false)
    }
    // Unfade to controller
    func unfade<T: UIViewController>(to controllerType: T.Type) {
        // Get controller
        guard let vc = getController(forType: controllerType) else {
            return
        }
        // Transition
        setTransition(.unfade, view)
        // Execute
        popToViewController(vc, animated: false)
    }
    
    //                                      MARK: - SLIDE
    //..............................................................................................
    func slide(module: Module) {
        // Get controller and set presentation style
        let vc = getController(from: module, forPresentationStyle: .pushed(.slide))
        // Transition
        setTransition(.slide, view)
        // Execute
        pushViewController(vc, animated: false)
    }
    
    //                                      MARK: - UNSLIDE
    //..............................................................................................
    func unslide() {
        // Transition
        setTransition(.unslide, view)
        // Execute
        popViewController(animated: false)
    }
    // Unslide to controller
    func unslide<T: UIViewController>(to controllerType: T.Type) {
        // Get controller
        guard let vc = getController(forType: controllerType) else {
            return
        }
        // Transition
        setTransition(.unslide, view)
        // Execute
        popToViewController(vc, animated: false)
    }

    //  MARK: - METHODS 🔰 PRIVATE
    // ////////////////////////////////////
    private func getController(from module: Module, forPresentationStyle presentationStyle: ControllerPresentationStyle) -> UIViewController {
        // Get controller
        let vc = module.getController()
        // Cast to PresentationSylable
        guard let presentationSylable = (vc as? PresentationSylable) else {
            print("COULD NOT CAST TO PresentationSylable")
            return vc
        }
        // Set presentation
        presentationSylable.controllerPresentationStyle = presentationStyle
        // Return
        return vc
    }
    // ...........
    private func getList<T: UIViewController>(removing types: [T.Type], andAdding vc: UIViewController) -> [UIViewController] {
        // Remove types
        var viewControllerList = viewControllers.filter({ (viewController) -> Bool in
            return !types.contains(where: { String(describing: type(of: viewController)) == String(describing: $0)})
        })
        // Append controller
        viewControllerList.append(vc)
        // Return
        return viewControllerList
    }
    // ...........
    private func getList<T: UIViewController>(removingTill type: T.Type, andAdding vc: UIViewController) -> [UIViewController] {
        // Get last needed controller index
        guard let tillControllerIndex = getControllerIndex(forType: type) else {
            return viewControllers
        }
        // Check indexes
        guard viewControllers.count > tillControllerIndex else {
            print("INDEXES ERROR")
            return viewControllers
        }
        // Get new slices array
        var slicedList = viewControllers[0...tillControllerIndex]
        // Append controller
        slicedList.append(vc)
        // Return
        return Array(slicedList)
    }
    // ...........
    private func setTransition(_ transitionType: Transition, _ view: UIView) -> () {
        // Declare transition
        let transition: CATransition = CATransition()
        // Handle type
        switch transitionType {
        case .fade:
            transition.duration = fadeInterval
            transition.type = CATransitionType.fade
        // ...........
        case .unfade:
            transition.duration = fadeInterval
            transition.timingFunction = CAMediaTimingFunction(name: .easeOut)
            transition.type = CATransitionType.fade
        // ...........
        case .slide:
            transition.duration = slideInterval
            transition.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
            transition.type = CATransitionType.moveIn
            transition.subtype = CATransitionSubtype.fromTop
        // ...........
        case .unslide:
            transition.duration = slideInterval
            transition.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
            transition.type = CATransitionType.reveal
            transition.subtype = CATransitionSubtype.fromBottom
        }
        // Add transition to the view
        view.layer.add(transition, forKey: nil)
    }
    // ...........
    private func getController<T: UIViewController>(forType controllerType: T.Type) -> UIViewController? {
        // Find controller type
        for vc in viewControllers {
            if vc.isKind(of: controllerType) {
                return vc
            }
        }
        print("COULD NOT GET '\(controllerType.self)' CONTROLLER")
        return nil
    }
    // ...........
    private func getControllerIndex<T: UIViewController>(forType controllerType: T.Type) -> Int? {
        // Get controller
        guard let controller = getController(forType: controllerType) else {
            return nil
        }
        // Get controller index
        guard let index = viewControllers.firstIndex(of: controller) else {
            print("COULD NOT GET INDEX OF CONTROLLER")
            return nil
        }
        return index
    }
}

//                                      MARK: - Module
//..............................................................................................
extension UINavigationController: Module {
    public func getController() -> UIViewController {
        self
    }
}
