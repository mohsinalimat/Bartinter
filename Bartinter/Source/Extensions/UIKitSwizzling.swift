//
//  UIKitSwizzling.swift
//  Yoga
//
//  Created by Maxim Kotliar on 6/19/18.
//  Copyright © 2018 Wikrgroup. All rights reserved.
//

import UIKit.UIViewController

extension UIViewController {

    @objc var swizzledChildViewControllerForStatusBarStyle: UIViewController? {
        return statusBarUpdater ?? self.swizzledChildViewControllerForStatusBarStyle
    }

    fileprivate static func setupChildViewControllerForStatusBarStyleSwizzling() {
        let original = #selector(getter: UIViewController.childViewControllerForStatusBarStyle)
        let swizzled = #selector(getter: UIViewController.swizzledChildViewControllerForStatusBarStyle)

        let originalMethod = class_getInstanceMethod(UIViewController.self,
                                                     original)
        let swizzledMethod = class_getInstanceMethod(UIViewController.self,
                                                     swizzled)

        method_exchangeImplementations(originalMethod!, swizzledMethod!)
    }
}

protocol UIViewRedrawDelegate: class {
    func didLayoutSubviews()
}

private var redrawDelegateHandle = "redrawDelegateHandle"
extension UIView {

    @objc func swizzledLayoutSubviews() {
        self.swizzledLayoutSubviews()
        redrawDelegate?.didLayoutSubviews()
    }

    fileprivate static func setupSetNeedsLayoutSwizzling() {
        let original = #selector(UIView.layoutSubviews)
        let swizzled = #selector(UIView.swizzledLayoutSubviews)

        let originalMethod = class_getInstanceMethod(UIView.self,
                                                     original)
        let swizzledMethod = class_getInstanceMethod(UIView.self,
                                                     swizzled)

        method_exchangeImplementations(originalMethod!, swizzledMethod!)
    }
}

extension Bartinter {
    static func swizzle() {
        UIViewController.setupChildViewControllerForStatusBarStyleSwizzling()
        UIView.setupSetNeedsLayoutSwizzling()
    }
}
