//
//  AppHelper.swift
//  GitList
//
//  Created by Thales Toniolo on 22/04/20.
//  Copyright © 2020 Flameworks. All rights reserved.
//
import UIKit
import FCAlertView

class AppHelper: NSObject {
	// MARK: - Singleton

	// MARK: - Public Objects

	// MARK: - Life Cycle
	override init() {
		super.init()
	}

	// MARK: - Public Methods
	public class func createCircularView(forImageView anImageView: UIView, withBorderWidth borderWidth: CGFloat, andBorderColor borderColor: UIColor) {
		anImageView.clipsToBounds = true
		anImageView.layer.cornerRadius = anImageView.frame.size.width / 2.0
		if (borderWidth > 0.0) {
			anImageView.layer.borderWidth = borderWidth
			anImageView.layer.borderColor = borderColor.cgColor
		}
	}

	public class func createCustomizedAlert() -> FCAlertView {
		let alert = FCAlertView()
		alert.cornerRadius = 8
		alert.hideSeparatorLineView = true
		alert.titleColor = UIColor.black
		alert.titleFont = UIFont.systemFont(ofSize: 16)
		alert.subTitleColor = UIColor.lightGray
		alert.subtitleFont = UIFont.systemFont(ofSize: 14)
		alert.bounceAnimations = true

		// Animacoes de apresentacao
		alert.animateAlertInFromTop = true

		return alert
	}
}
