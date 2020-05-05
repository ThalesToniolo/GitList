//
//  AppDelegate.swift
//  GitList
//
//  Created by Thales Toniolo on 22/04/20.
//  Copyright © 2020 Flameworks. All rights reserved.
//
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
	
	var window: UIWindow?

	// MARK: - Life Cycle
	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
		// Override point for customization after application launch.
		return true
	}

	//MARK: - Background Delegates
	func applicationDidEnterBackground(_ application: UIApplication) {
		//...
	}

	func applicationWillEnterForeground(_ application: UIApplication) {
		//...
	}

	func applicationDidBecomeActive(_ application: UIApplication) {
		//...
	}

	func applicationWillResignActive(_ application: UIApplication) {
		//...
	}

	func applicationWillTerminate(_ application: UIApplication) {
		//...
	}
}

