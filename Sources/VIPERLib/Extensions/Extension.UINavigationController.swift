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
    // ...........
    enum StackAction {
        case new
        case add
    }
    // ...........
    enum StackPrintingType {
        case initial
        case final([UIViewController])
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
    func stack(_ stackAction: StackAction, with modules: [Module], style: ControllerPresentationStyle.PushedStyle = .default, isAnimated: Bool = false) {
        // Check modules
        guard !modules.isEmpty else {
            print("EMPTY MODULES LIST")
            return
        }
        // Declare controllers
        var controllersList = [UIViewController]()
        // Handle stack action
        switch stackAction {
        case .new:
            break
        // ...........
        case .add:
            controllersList.append(contentsOf: viewControllers)
        }
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
    // ...........
    func push<T: UIViewController>(module: Module, removingTill type: T.Type, isAnimated: Bool = true) {
        printStack(.initial)
        // Get controller and set presentation style
        let vc = getController(from: module, forPresentationStyle: .pushed(.default))
        // Remove specific controllers
        let newControllerList = getList(removingTill: type, andAdding: vc)
        printStack(.final(newControllerList))
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
        printStack(.initial)
        // Get controller and set presentation style
        let vc = getController(from: module, forPresentationStyle: .pushed(.fade))
        // Remove specific controllers
        let newControllerList = getList(removingTill: type, andAdding: vc)
        printStack(.final(newControllerList))
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
    // Unfade to specified controller removing till specific type
    func unfadeTo<T: UIViewController>(module: Module, removingTill type: T.Type, leaving leavingTypesList: [T.Type]) {
        printStack(.initial)
        // Get controller and set presentation style
        let vc = getController(from: module, forPresentationStyle: .pushed(.fade))
        // Remove specific controllers
        let newControllerList = getList(removingTill: type, leaving: leavingTypesList, andAdding: vc)
        printStack(.final(newControllerList))
        // Transition
        setTransition(.unfade, view)
        // Execute
        setViewControllers(newControllerList, animated: false)
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
    private func getList<T: UIViewController>(removingTill finalType: T.Type, leaving leavingTypesList: [T.Type] = [], andAdding vc: UIViewController) -> [UIViewController] {
        // Check controllers count
        guard viewControllers.count > 1 else {
            return chainContollers(viewControllers, [vc])
        }
        // Get last needed controller index
        guard let finalIndex = getControllerIndex(forType: finalType) else {
            return chainContollers(viewControllers, [vc])
        }
        // Get forward slice array
        let forwardSliceList = Array(viewControllers[viewControllers.startIndex...finalIndex])
        // Create next index
        let nextIndex = finalIndex + 1
        // Check next index
        guard viewControllers.indices.contains(nextIndex) else {
            return chainContollers(forwardSliceList, [vc])
        }
        // Check leaving list
        guard !leavingTypesList.isEmpty else {
            return chainContollers(forwardSliceList, [vc])
        }
        // Get last slice array
        let lastSlice = viewControllers[nextIndex..<viewControllers.endIndex]
        // Filter last slice
        let newLastSlice: [UIViewController] = lastSlice.filter({ item in leavingTypesList.contains { (leaveItem: UIViewController.Type) -> Bool in
            leaveItem == type(of: item)
        }})
        // Concat
        return chainContollers(forwardSliceList, newLastSlice, [vc])
    }
    // ...........
    private func chainContollers(_ lists: [UIViewController]...) -> [UIViewController] {
        var newArray: [UIViewController] = []
        for array in lists {
            newArray.append(contentsOf: array)
        }
        return newArray
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
    // ...........
    private func printStack(_ type: StackPrintingType) {
        switch type {
        case .initial:
            print("\n🔵 INITIAL STACK")
            viewControllers.forEach { vc in
                print(vc)
            }
        // ...........
        case .final(let list):
            print("\n🔵 FINAL STACK")
            list.forEach { vc in
                print(vc)
            }
        }
    }
}

//                                      MARK: - Module
//..............................................................................................
extension UINavigationController: Module {
    public func getController() -> UIViewController {
        self
    }
}
