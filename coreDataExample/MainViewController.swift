//
//  MainViewController.swift
//  coreDataExample
//
//  Created by Игорь Чернышов on 08.10.2023.
//

import UIKit

final class MainViewController: UIViewController {

	// MARK: - Subviews
	private lazy var tableView: UITableView = {
		let tableView = UITableView()
		tableView.dataSource = self
		tableView.delegate = self
		tableView.register(UITableViewCell.self, forCellReuseIdentifier: "CellReuseID")
		tableView.translatesAutoresizingMaskIntoConstraints = false
		return tableView
	}()

	// MARK: - State
	private var emojis = [String]()

	// MARK: - Lifecycle
	override func viewDidLoad() {
		super.viewDidLoad()
		setupNavigationBar()
		setupSubviews()
	}

	// MARK: - UI Configuration
	private func setupNavigationBar() {
		navigationItem.title = "😏 Core Data Example 🍌"
		navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus.circle"),
															style: .plain,
															target: self,
															action: #selector(plusButtonDidTap))
	}

	private func setupSubviews() {
		view.backgroundColor = .systemBackground
		view.addSubview(tableView)
		tableView.backgroundColor = .systemBackground
		NSLayoutConstraint.activate([
			tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
			tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
			tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
		])
	}

	// MARK: - Tap Actions
	@objc
	private func plusButtonDidTap() {
		emojis.append(.randomEmoji)
		tableView.reloadData()
	}
}

// MARK: - UITableViewDataSource
extension MainViewController: UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		emojis.count
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "CellReuseID", for: indexPath)

		var contentConfiguration = cell.defaultContentConfiguration()
		contentConfiguration.text = emojis[indexPath.row]
		cell.contentConfiguration = contentConfiguration

		return cell
	}
}

// MARK: - UITableViewDelegate
extension MainViewController: UITableViewDelegate {
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		emojis.remove(at: indexPath.row)
		tableView.deleteRows(at: [indexPath], with: .fade)
	}
}
