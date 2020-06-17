//
//  SentMemesTableViewController.swift
//  MemeMe 2.0
//
//  Created by Kemal Kaynak on 17.06.20.
//  Copyright © 2020 Kemal Kaynak. All rights reserved.
//

import UIKit

let appDel = UIApplication.shared.delegate as! AppDelegate

class SentMemesTableViewController: UITableViewController {

    private let cellID = "tableCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Sent Memes"
        NotificationCenter.default.addObserver(self, selector: #selector(update), name: appDel.updateNotificationName, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: appDel.updateNotificationName, object: nil)
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return appDel.memes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let memeCell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as? MemesTableViewCell else { return UITableViewCell() }
        memeCell.setup(appDel.memes[indexPath.row])
        return memeCell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let detailVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "MemesDetail") as? MemesDetailViewController else { return }
        detailVC.meme = appDel.memes[indexPath.row]
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (action, sourceView, completionHandler) in
            appDel.memes.remove(at: indexPath.row)
            completionHandler(true)
        }
        let swipeConfig = UISwipeActionsConfiguration(actions: [deleteAction])
        swipeConfig.performsFirstActionWithFullSwipe = true
        return swipeConfig
    }
}

// MARK: - Update Notification -

extension SentMemesTableViewController {
    
    @objc func update() {
        tableView.reloadData()
    }
}

