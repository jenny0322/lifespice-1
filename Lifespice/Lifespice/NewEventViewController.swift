//
//  NewEventViewController.swift
//  Lifespice
//
//  Created by Victoria Bian on 1/3/15.
//  Copyright (c) 2015 Lifespice. All rights reserved.
//

import UIKit
import CoreData

class NewEventViewController: UITableViewController {

    @IBOutlet weak var navBar: UINavigationItem!

    
    @IBOutlet weak var textFieldTitle: UITextField!
    
    
    @IBOutlet weak var detailDate: UILabel!
    
    
    @IBOutlet weak var detailCategory: UILabel!
    
    
    @IBOutlet weak var detailReminder: UILabel!
    
    
    @IBOutlet weak var detailRepeat: UILabel!
    

    @IBOutlet weak var switchImportant: UISwitch!

    
    @IBOutlet weak var datePickerCell: UITableViewCell!

    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    
    var myEvent: Event? {
        didSet {
            self.configureView()
            
        }
    }
    
    

    
    var selectedDate: NSDate = NSDate()
    var dateFormatter: NSDateFormatter = NSDateFormatter()
    var datePickerIsShown:Bool = false
    

    
    var reminder: String = Reminder.ReminderType().rawValue
    var repeat: String = Repeat.RepeatType().rawValue
    var category: String = Category.CategoryTag().rawValue

    
    func configureView() {
        if let detail: Event = self.myEvent {
            if let savedTitle = self.textFieldTitle {
                savedTitle.text = detail.eventTitle
            }
            if let savedDate = self.detailDate {
                let dateFormatter = NSDateFormatter()
                dateFormatter.dateStyle = .LongStyle
                dateFormatter.timeStyle = .NoStyle
                savedDate.text = dateFormatter.stringFromDate(detail.eventDate)
                datePicker.setDate(detail.eventDate, animated: true)
            }
            if let savedCategory = self.detailCategory {
                savedCategory.text = detail.eventCategory
                category = savedCategory.text!

            }
            if let savedReminder = self.detailReminder {
                savedReminder.text = detail.eventReminder
                reminder = savedReminder.text!

            }
            if let savedRepeat = self.detailRepeat {
                savedRepeat.text = detail.eventRepeat
                repeat = savedRepeat.text!

            }
            if let savedImportant = self.switchImportant {
                savedImportant.setOn(detail.eventImportant.boolValue, animated: true)
            }
        }
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        if myEvent != nil {
            navBar.title = "Edit Event"
        } else {
            navBar.title = "New Event"
        }
        self.initTableView()
        self.configureView()
        
    }
    

    
    func initTableView() {

        // Date
        self.setupDateLabel()
        self.datePicker.hidden = true
        self.signupForKeyboardNotification()
        self.datePicker.datePickerMode = .Date
        
        // Category
        detailCategory.text = category
        
        // Reminder
        
        detailReminder.text = reminder
        
        //Repeat
        detailRepeat.text = repeat
        
    }
    
    @IBAction func selectedReminder(segue:UIStoryboardSegue) {
        let setReminderViewController = segue.sourceViewController as SetReminderViewController
        if let selectedReminderType = setReminderViewController.selectedReminderType {
            detailReminder.text = selectedReminderType
            reminder = selectedReminderType
        }
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func selectedRepeat(segue:UIStoryboardSegue) {
        let setRepeatViewController = segue.sourceViewController as SetRepeatViewController
        if let selectedRepeatType = setRepeatViewController.selectedRepeatType {
            detailRepeat.text = selectedRepeatType
            repeat = selectedRepeatType
        }
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func selectedCategory(segue:UIStoryboardSegue) {
        let setCategoryViewController = segue.sourceViewController as SetCategoryViewController
        if let selectedCategoryTag = setCategoryViewController.selectedCategoryTag {
            detailCategory.text = selectedCategoryTag
            category = selectedCategoryTag
        }
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    

    
    func setupDateLabel() {
        self.dateFormatter = NSDateFormatter()
        self.dateFormatter.dateStyle = .LongStyle
        self.dateFormatter.timeStyle = .NoStyle
        var today: NSDate = NSDate()
        self.detailDate.text = self.dateFormatter.stringFromDate(today)
        self.selectedDate = today
        
    }
    
    func signupForKeyboardNotification() {
        var defaultCenter: NSNotificationCenter = NSNotificationCenter()
        defaultCenter.addObserver(self, selector: "keyboardWillShow", name: UIKeyboardWillShowNotification, object: nil)
    }
    
    func keyboardWillShow() {
        if (self.datePickerIsShown) {
            self.hideDatePickerCell()
        }
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {

        
        if (indexPath.row == 2 && indexPath.section == 0 && self.datePickerIsShown) {
            return CGFloat(166.0)
        } else if (indexPath.row == 2 && indexPath.section == 0 && !self.datePickerIsShown){
            return CGFloat(0.0)
        } else {
            return CGFloat(44.0)
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if (indexPath.row == 1 && indexPath.section == 0) {
            if (self.datePickerIsShown) {
                self.hideDatePickerCell()
            }else{
                self.showDatePickerCell()
            }
        } else {
            self.hideDatePickerCell() 
        }

        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func showDatePickerCell() {
        self.datePickerIsShown = true
        self.tableView.beginUpdates()
        self.tableView.endUpdates()
        self.datePicker.hidden = false
        self.datePicker.alpha = 0.0
        UIView.animateWithDuration(0.40, animations: {
            self.datePicker.alpha = 1.0
        })
    }
    
    func hideDatePickerCell() {
        self.datePickerIsShown = false
        self.tableView.beginUpdates()
        self.tableView.endUpdates()
        UIView.animateWithDuration(0.40, animations: {
            self.datePicker.alpha = 0.0
        })
        
        self.datePicker.hidden = true
        
    }
    
    @IBAction func dateAction(sender: UIDatePicker) {
        self.detailDate.text = self.dateFormatter.stringFromDate(sender.date)
        self.selectedDate = sender.date
    }

    
    
    @IBAction func endEditing(sender: UITextField) {
        self.resignFirstResponder()
    }

    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        if segue.identifier == "SaveEvent" {
            let appDel: AppDelegate = UIApplication.sharedApplication().delegate as AppDelegate
            
            let context: NSManagedObjectContext = appDel.managedObjectContext!
            
            let entity = NSEntityDescription.entityForName("Event", inManagedObjectContext: context)
            if myEvent != nil {
                let myTitle = textFieldTitle.text
                if myTitle == "" {
                    myEvent?.eventTitle = "Untitled Event"
                } else {
                    myEvent?.eventTitle = textFieldTitle.text
                }
                
                myEvent?.eventDate = dateFormatter.dateFromString(detailDate.text!)!
                myEvent?.eventCategory = detailCategory.text!
                myEvent?.eventReminder = detailReminder.text!
                myEvent?.eventRepeat = detailRepeat.text!
                
                if switchImportant.on {
                    myEvent?.eventImportant = true
                } else {
                    myEvent?.eventImportant = false
                }
                if let parseEvent = self.myEvent {
                    let event = self.myEvent
                    (segue.destinationViewController as DetailViewController).detailItem = event
                    
                }
            } else {
                let newEvent = Event(entity: entity!, insertIntoManagedObjectContext: context)
                let title = textFieldTitle.text
                if title == "" {
                    newEvent.eventTitle = "Untitled Event"
                } else {
                    newEvent.eventTitle = textFieldTitle.text
                }
                
                newEvent.eventDate = dateFormatter.dateFromString(detailDate.text!)!
                newEvent.eventCategory = detailCategory.text!
                newEvent.eventReminder = detailReminder.text!
                newEvent.eventRepeat = detailRepeat.text!
                if switchImportant.on {
                    newEvent.eventImportant = true
                } else {
                    newEvent.eventImportant = false
                }
            }


            context.save(nil)
        }
        
        if segue.identifier == "SetReminder" {
            let setReminderViewController = segue.destinationViewController as SetReminderViewController
            setReminderViewController.selectedReminderType = reminder
        }
        
        if segue.identifier == "SetRepeat" {
            let setRepeatViewController = segue.destinationViewController as SetRepeatViewController
            setRepeatViewController.selectedRepeatType = repeat
        }
        if segue.identifier == "SetCategory" {
            let setCategoryViewController = segue.destinationViewController as SetCategoryViewController
            setCategoryViewController.selectedCategoryTag = category
        }
        
    }

    
    
    
    
    
    
    
    // MARK: - Table view data source
    
    /*
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 0
    }
    */
    
    /*
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return 0
    }
    */

    
    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath) as UITableViewCell

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
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
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */


}
