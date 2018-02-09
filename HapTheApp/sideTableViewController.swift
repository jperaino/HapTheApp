//
//  sideTableViewController.swift
//  HapTheApp
//
//  Created by Jim Peraino on 2/8/18.
//  Copyright © 2018 James Peraino. All rights reserved.
//

import UIKit

class sideTableViewController: UITableViewController {

    var TableArray = [backMenuItem]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        TableArray = [
            backMenuItem(title: "About", action: nil),
            backMenuItem(title: "Invite Friends", action: nil),
            backMenuItem(title: "Notifications", action: nil),
            backMenuItem(title: "Settings", action: nil),
            backMenuItem(title: "Logout", action: "signMeOut"),
            ]
            
        print(TableArray)
        
        
        
    }
    
    func testAction() {
        
        print("I'm doing this test action I hope you like it")
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        switch (section) {
        case 0:
            return 1
        case 1:
            return TableArray.count;
        default:
            return 0
            
        }

    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = sideTableViewCell()
        
        switch (indexPath.section) {
        case 0:
            cell = tableView.dequeueReusableCell(withIdentifier: "sideHeaderCell", for: indexPath) as! sideTableViewCell
        default:
            cell = tableView.dequeueReusableCell(withIdentifier: "sideMenuCell", for: indexPath) as! sideTableViewCell
            cell.title.text = TableArray[indexPath.row].title
            print("made a cell")
        }
            return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let myAction = TableArray[indexPath.row].action {
            print("about to do an action")
            
            if myAction == "signMeOut" {
                placePickerViewController.signMeOut()
            }
            
            print("did an action")
        }
        
    }
 

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
