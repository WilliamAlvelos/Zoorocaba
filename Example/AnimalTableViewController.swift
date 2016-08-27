//
//  AnimalTableViewController.swift
//  Zoorocaba
//
//  Created by William Alvelos on 14/04/16.
//  Copyright © 2016 Metaio GmbH. All rights reserved.
//

import UIKit

class AnimalTableViewController: UITableViewController {
    
    
    var pageIndex: Int?
    var titleText : String!
    var imageName : String!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self

        
        self.navigationController?.title = titleText;
        
        self.colorNavigation(self.titleText)
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)

        // Configure the cell...

        return cell
    }

    
    
    func colorNavigation(text:String){
        
        if(text == "Mamíferos"){
            self.navigationController?.navigationBar.barTintColor = Mamifero.Fundo
        }else if(text == "Aves"){
            self.navigationController?.navigationBar.barTintColor = Aves.Fundo
        }else if(text == "Anfíbios"){
            self.navigationController?.navigationBar.barTintColor = Anfibios.Fundo
        }else if(text == "Répteis"){
            self.navigationController?.navigationBar.barTintColor = Repteis.Fundo
        }else if(text == "Aracnídeos"){
            self.navigationController?.navigationBar.barTintColor = Aracnideos.Fundo
        }
        
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
