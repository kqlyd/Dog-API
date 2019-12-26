//
//  ViewController.swift
//  BreedApi
//
//  Created by Denis Zhukov on 10/12/2019.
//  Copyright © 2019 Denis Zhukov. All rights reserved.
//

import UIKit
import ResourceNetworking
import Foundation


class ViewController: UITableViewController {
    
    
    let network = NetworkHelper(reachability: FakeReachability(isReachable: true))
    
    let myRefreshConstrol: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(downloadData), for: .valueChanged)
        return refreshControl
    }()
    
    enum CellIdentifiers: String {
        case BreedTableViewCell
    }
    
    var breedList: [Breed] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.refreshControl = myRefreshConstrol
//        tableView.refreshControl = UIRefreshControl()
//        tableView.refreshControl?.addTarget(self, action: #selector(downloadData), for: .valueChanged)

        tableView.register(UINib(nibName: CellIdentifiers.BreedTableViewCell.rawValue, bundle: nil), forCellReuseIdentifier:
        CellIdentifiers.BreedTableViewCell.rawValue)
        downloadData()
    }
    
    @objc func downloadData() {
        _ = network.load(resource: ResourceFactory().createResource(), completion: { [weak self] (result) in
            switch result{
            case .success(let data):
                for dic in data.message{
                    switch dic.value.count{
                    case 0:
                        let breed = Breed(breed: dic.key)
                        self?.breedList.append(breed)
                        breed.delegate = self
                    default:
                        for subbreed in dic.value{
                            let breed = Breed(breed: dic.key, subBreed: subbreed)
                            breed.delegate = self
                            self?.breedList.append(breed)
                        }
                    }
                }
                DispatchQueue.main.async { [weak self] in
                    self?.tableView.reloadData()
                    self?.refreshControl?.endRefreshing()
                }
                //self.updateView()
                
                //self.activityIndicator.stopAnimating()
            case .failure(let error):
                print(error)
            }
        })
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return breedList.count
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        self.breedList[indexPath.row].downloadIcon(with: network, subName: self.breedList[indexPath.row].subBreedName ?? nil , index: indexPath.row)
    }
    
    override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        self.breedList[indexPath.row].cancelDownloadIcon()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers.BreedTableViewCell.rawValue) as! BreedTableViewCell
        cell.configuration(breed: breedList[indexPath.row], index: indexPath )
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85
    }
}

extension ViewController: BreedDelegate {
    func iconDidLoaded(breed: Breed) {
        guard let row = breedList.firstIndex(of: breed) else {
            return
        }
        DispatchQueue.main.async {
            self.tableView.reloadRows(at: [IndexPath(row: row, section: 0)], with: .automatic)
        }
    }
}
