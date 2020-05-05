//
//  MainTableViewCell.swift
//  GitList
//
//  Created by Thales Toniolo on 22/04/20.
//  Copyright © 2020 Flameworks. All rights reserved.
//
import UIKit
import Kingfisher

class MainTableViewCell: UITableViewCell {
	var gitInfo: VOGitInfo!

	@IBOutlet weak var repoNameLabel: UILabel!
	@IBOutlet weak var starCountLabel: UILabel!
	@IBOutlet weak var userImageView: UIImageView!
	@IBOutlet weak var authorNameLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

	func setupCell(_ info: VOGitInfo) {
		self.gitInfo = info

		AppHelper.createCircularView(forImageView: self.userImageView, withBorderWidth: 0.0, andBorderColor: UIColor.clear)

		self.userImageView.backgroundColor = UIColor.clear
		if (self.gitInfo.photoURL != "") {
			self.userImageView.kf.setImage(with: URL(string: self.gitInfo.photoURL)!, placeholder: UIImage(named: "imgnopicuser"), options: nil, progressBlock: nil) { (image, error, cache, url) in
				if (error == nil) {
					self.userImageView.backgroundColor = UIColor.white
				}
			}
		}
		self.repoNameLabel.text = String(format: "Repo: %@", self.gitInfo.repoName)
		self.starCountLabel.text = String(format: "%d ⭐️", self.gitInfo.starCount)
		self.authorNameLabel.text = String(format: "Autor: %@", self.gitInfo.authorName)
	}
}
