//
//  TempViewController.swift
//  HapTheApp
//
//  Created by Jim Peraino on 2/8/18.
//  Copyright © 2018 James Peraino. All rights reserved.
//

import UIKit

class TempViewController: UIViewController {

    @IBOutlet weak var Open: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        Open.target = self.revealViewController()
        Open.action = Selector("revealToggle:")
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
