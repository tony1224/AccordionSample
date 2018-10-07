//
//  ViewController.swift
//  AccordionSample
//
//  Created by Morita Jun on 2018/09/26.
//  Copyright © 2018 Morita Jun. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    // MARK: - Properties
    @IBOutlet private weak var myTableView: UITableView!
    private var items1 = ["ねずみ", "うし", "とら", "うさぎ", "りゅう"]
    private var items2 = ["へび", "うま", "ひつじ", "さる", "とり", "いぬ", "いのしし", "ねこ", "しまうま"]
    private var items3 = ["やぎ", "くま", "しろくま", "こぶら", "ごりら", "ぶた", "ぞう", "おおかみ"]
    private var sections = [[String]]()
    
    // MARK: - LifeCycle Method

    override func viewDidLoad() {
        super.viewDidLoad()
        // セクションを配列に設定する。
        sections.append(items1)
        sections.append(items2)
        sections.append(items3)
    }

}

// MARK: - UITableViewDataSource

extension ViewController: UITableViewDataSource {
    
    // セクションの数を返す。
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.sections.count
    }
    
    // セクションのタイトルを返す。
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        var title = ""
        switch section {
        case 0:
            title = "セクション1"
        case 1:
            title = "セクション2"
        case 2:
            title = "セクション3"
        default:
            break
        }
        return title
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:  "cell", for:indexPath as IndexPath)
        let itemName = sections[indexPath.section][indexPath.row]
        cell.textLabel?.text = itemName
        return cell
    }
}

// MARK: - UITableViewDelegate

extension ViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let myView: UIView = UIView()
        myView.backgroundColor = UIColor.green
        myView.tag = section
        myView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.tapHeader(gestureRecognizer:))))
        
        return myView
    }
    
    @objc func tapHeader(gestureRecognizer: UITapGestureRecognizer) {
        guard let section = gestureRecognizer.view?.tag as Int? else {
            return
        }

        let rowCount = myTableView.numberOfRows(inSection: section)
        let beforeItem = getUpadateBeforeItem(section: section)
        let differentCount = rowCount - beforeItem.count
        let updateItem = differentCount >= 0 ? [] : beforeItem

        sections.remove(at: section)
        sections.insert(updateItem, at: section)
        
        myTableView.beginUpdates()
        if differentCount >= 0 {
            let indexPaths = Array(differentCount..<rowCount).map { IndexPath(row: $0, section: section)}
            myTableView.deleteRows(at: indexPaths, with: .none)
        } else {
            let indexPaths = Array(rowCount..<(-differentCount)).map { IndexPath(row: $0, section: section) }
            myTableView.insertRows(at: indexPaths, with: .none)
        }
        myTableView.endUpdates()
    }
    
    private func getUpadateBeforeItem(section: Int) -> [String] {
        switch section {
        case 0:
            return items1
        case 1:
            return items2
        case 2:
            return items3
        default:
            return []
        }
    }
    
}
