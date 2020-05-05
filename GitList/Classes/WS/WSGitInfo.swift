//
//  WSGitInfo.swift
//  GitList
//
//  Created by Thales Toniolo on 22/04/20.
//  Copyright © 2020 Flameworks. All rights reserved.
//
import UIKit

class WSGitInfo: WSBase {

	// MARK: - Public Methods
	public class func getGitInfo(withPage aPage: Int, completionHandler: @escaping (_ gitInfos: [VOGitInfo]?, _ error: VOError?) -> Void) {
		let fullURL: String = String(format: kGitStarListService, aPage)
		
		self.executeGet(fullURL) { (result, error) in
			if (error == nil) {
				var arrRet: [VOGitInfo] = [VOGitInfo]()

				if let items = result!["items"] as? [[String: Any]] {
					for item: [String: Any] in items {
						let vo: VOGitInfo = VOGitInfo()

						if let item = item["name"] as? String {
							vo.repoName = item
						}
						if let item = item["html_url"] as? String {
							vo.repoURL = item
						}

						if let item = item["html_url"] as? String {
							vo.repoURL = item
						}

						if let item = item["stargazers_count"] as? Int {
							vo.starCount = item
						}

						if let owner = item["owner"] as? [String: Any] {
							if let item = owner["avatar_url"] as? String {
								vo.photoURL = item
							}

							if let item = owner["login"] as? String {
								vo.authorName = item
							}
						}

						arrRet.append(vo)
					}
				}

				completionHandler(arrRet, nil)
			} else {
				completionHandler(nil, error)
			}
		}
	}

}
