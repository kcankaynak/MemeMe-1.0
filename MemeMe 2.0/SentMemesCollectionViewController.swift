//
//  SentMemesCollectionViewController.swift
//  MemeMe 2.0
//
//  Created by Kemal Kaynak on 17.06.20.
//  Copyright © 2020 Kemal Kaynak. All rights reserved.
//

import UIKit

class SentMemesCollectionViewController: UICollectionViewController {

    private let cellID = "collectionCell"
    
    let space: CGFloat = 1.0
    lazy var collectionSize: CGSize = {
        return CGSize(width: (view.frame.size.width - (2 * space)) / 3, height: (view.frame.size.width - (2 * space)) / 3)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Sent Memes"
        NotificationCenter.default.addObserver(self, selector: #selector(update), name: appDel.updateNotificationName, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: appDel.updateNotificationName, object: nil)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return appDel.memes.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let memeCell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as? MemesCollectionViewCell else { return UICollectionViewCell() }
        memeCell.setup(appDel.memes[indexPath.item])
        return memeCell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let detailVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "MemesDetail") as? MemesDetailViewController else { return }
        detailVC.meme = appDel.memes[indexPath.item]
        navigationController?.pushViewController(detailVC, animated: true)
    }
}

// MARK: - UICollectionFlowLayout Delegate -

extension SentMemesCollectionViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionSize
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return space
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return space
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .zero
    }
}

// MARK: - Update Notification -

extension SentMemesCollectionViewController {
    
    @objc func update() {
        collectionView.reloadData()
    }
}
