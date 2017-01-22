//
//  CoverTableViewController.swift
//  NAS-T
//
//  Created by Axel on 30/11/16.
//  Copyright © 2016 Axel. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class CoverTableViewController: UITableViewController {
    
    // Properties
    let coverRepository = CoverRepository()
    var covers = [Cover]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Load the sample data.
        // uploadSampleCovers();
        loadSampleCovers();
        
        tableView.allowsMultipleSelectionDuringEditing = true
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let archive = UITableViewRowAction(style: .normal, title: "Archiveer") { action, index in
            let cover = self.covers[index.item]
            self.coverRepository.archive(cover: cover) { isSuccess in
                if isSuccess {
                    self.covers.remove(at: index.item)
                    self.tableView.reloadData()
                }
            }
        }
        archive.backgroundColor = .orange
        
        return [archive]
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func uploadSampleCovers() {
        let covers = [Cover(type: "iPhone 6/6S", thumbnail: UIImage(named: "ip6")!),
                      Cover(type: "iPhone 6 Plus/6S Plus", thumbnail: UIImage(named: "ip6p")!),
                      Cover(type: "iPhone 7", thumbnail: UIImage(named: "ip7")!),
                      Cover(type: "iPhone 7 Plus", thumbnail: UIImage(named: "ip7p")!)]
        
        for cover in covers {
            coverRepository.add(cover: cover!) { isSuccess in
                print(isSuccess)
            }
        }
    }
    
    func loadSampleCovers() {
        coverRepository.getAll() { covers in
            self.covers = covers!
            self.tableView.reloadData()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return covers.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Table view cells are reused and should be dequeued using a cell identifier.
        let cellIdentifier = "CoverTableViewCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! CoverTableViewCell
        
        // Configure the cell...
        let cover = covers[indexPath.row]
        
        cell.typeLabel.text = cover.type
        cell.dateLabel.text = cover.stringDate()
        cell.photoImageView.image = cover.thumbnail

        return cell
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowDetail" {
            let coverDetailViewController = segue.destination as! CoverViewController
            // Get the cell that generated this segue.
            if let selectedMealCell = sender as? CoverTableViewCell {
                let indexPath = tableView.indexPath(for: selectedMealCell)!
                let selectedCover = covers[indexPath.row]
                coverDetailViewController.cover = selectedCover
            }
        }
    }

}
