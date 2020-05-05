//
//  MainTableViewController.swift
//  GitList
//
//  Created by Thales Toniolo on 22/04/20.
//  Copyright © 2020 Flameworks. All rights reserved.
//
import UIKit
import RSLoadingView
import FCAlertView

// MARK: - Class Declaration
class MainTableViewController: UITableViewController {
	// MARK: - Public Objects
	
	// MARK: - Private Objects
	var currentPage: Int = 1
	var acabouListagem: Bool = false
	var isLoadingMore: Bool = false
	var arrInfos: [VOGitInfo] = [VOGitInfo]()
	var didFirstRequest: Bool = false

	// MARK: - Interface Objects
	
	// MARK: - Life Cycle
	override func viewDidLoad() {
		super.viewDidLoad()

		self.refreshControl = UIRefreshControl()
		self.refreshControl!.addTarget(self, action: #selector(refreshGitList), for: UIControl.Event.valueChanged)
		self.refreshControl!.tintColor = UIColor.red
	}

	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)

		self.getGitList()
	}

	// MARK: - Privates Methods
	@objc func refreshGitList() {
		DispatchQueue.main.async {
			self.currentPage = 1
			self.arrInfos.removeAll(keepingCapacity: false)
			self.tableView.reloadData()
			self.callGetGitInfo()
		}
	}

	func getGitList() {
		self.currentPage = 1
		self.arrInfos.removeAll(keepingCapacity: false)
		RSLoadingView().showOnKeyWindow()
		self.callGetGitInfo()
		didFirstRequest = true
	}

	func loadMoreItems() {
		self.currentPage += 1
		self.callGetGitInfo()
	}

	func callGetGitInfo() {
		self.isLoadingMore = true
		WSGitInfo.getGitInfo(withPage: self.currentPage) { (gitInfos, error) in
			RSLoadingView.hideFromKeyWindow()
			self.refreshControl!.endRefreshing()
			if (error == nil) {
				if (gitInfos != nil && gitInfos!.count > 0) {
					self.arrInfos.append(contentsOf: gitInfos!)
					self.tableView.reloadData()
				} else {
					self.acabouListagem = true
				}
			} else {
				self.acabouListagem = true
				// Caso nao tenha nenhuma info
				if (self.arrInfos.count == 0) {
					let alert: FCAlertView = AppHelper.createCustomizedAlert()
					alert.showAlert(in: UIApplication.shared.keyWindow!, withTitle: "Ooops", withSubtitle: error!.errorMessage, withCustomImage: nil, withDoneButtonTitle: "Ok", andButtons: nil)
				}
			}
			self.isLoadingMore = false
		}
	}

	// MARK: - Actions Methods
	
	// MARK: - Publics Methods
	
	// MARK: - UITableViewDataSource / UITableViewDelegate
	override func numberOfSections(in tableView: UITableView) -> Int {
		return 2
	}
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if (section == 0) {
			return self.arrInfos.count
		} else if (section == 1 && self.isLoadingMore && !self.acabouListagem) {
			return 1
		}
		return 0
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		if (indexPath.section == 0) {
			let cell: MainTableViewCell = tableView.dequeueReusableCell(withIdentifier: "CellID", for: indexPath) as! MainTableViewCell

			let gitInfo: VOGitInfo = self.arrInfos[indexPath.row]
			cell.setupCell(gitInfo)
			
			return cell
		} else {
			let cell: LoadingTebleViewCell = tableView.dequeueReusableCell(withIdentifier: "loadingCell", for: indexPath) as! LoadingTebleViewCell
			return cell
		}
	}

	override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		if (indexPath.section == 0) {
			return 146.0
		} else if (indexPath.section == 1 && self.isLoadingMore && !self.acabouListagem) {
			return 60.0
		}

		return 0
	}

	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)

		let gitInfo: VOGitInfo = self.arrInfos[indexPath.row]
		if let url2Open = URL(string: gitInfo.repoURL) {
			if (UIApplication.shared.canOpenURL(url2Open)) {
				UIApplication.shared.open(url2Open)
			}
		}
	}

	override func scrollViewDidScroll(_ scrollView:UIScrollView) {
		let offsetY = scrollView.contentOffset.y
		let contentHeight = scrollView.contentSize.height
		if (offsetY >= contentHeight - scrollView.frame.height) {
			if (!self.isLoadingMore && !self.acabouListagem && self.didFirstRequest) {
				self.loadMoreItems()
			}
		}
	}

	// MARK: - Delegate/Datasource
	
	// MARK: - Navigation
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if (segue.identifier == "mySegue") {
			//...
		}
	}
	
	// MARK: - Death Cycle
	deinit {
		//...
	}
	
	override func viewDidDisappear(_ animated: Bool) {
		super.viewDidDisappear(animated)
		//...
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
}

