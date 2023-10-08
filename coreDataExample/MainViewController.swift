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
	private var emojis = [Emoji]()

	// MARK: - Lifecycle
	override func viewDidLoad() {
		super.viewDidLoad()
		setupNavigationBar()
		setupSubviews()
		loadData()
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

	private func loadData() {
		emojis = CoreDataManager.shared.readEmojis()
		tableView.reloadData()
	}

	// MARK: - Tap Actions
	@objc
	private func plusButtonDidTap() {
		let emoji = CoreDataManager.shared.createEmoji()
		emojis.append(emoji)
		emojis.sort {
			guard let firstDateCreated = $0.dateCreated, let secondDateCreated = $1.dateCreated else { return false }
			return firstDateCreated > secondDateCreated
		}
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
		contentConfiguration.text = emojis[indexPath.row].content
		contentConfiguration.secondaryText = emojis[indexPath.row].dateCreated?.formatted()
		cell.contentConfiguration = contentConfiguration

		return cell
	}
}

// MARK: - UITableViewDelegate
extension MainViewController: UITableViewDelegate {
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		CoreDataManager.shared.deleteEmoji(emojis[indexPath.row])
		emojis.remove(at: indexPath.row)
		tableView.deleteRows(at: [indexPath], with: .fade)
	}
}
