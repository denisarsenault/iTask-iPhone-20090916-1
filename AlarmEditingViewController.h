//
//  AlarmEditingViewController.h
//  iTask-iPhone
//
//  Created by Denis Arsenault on 12/10/08.
//  Copyright 2008 Mybrightzone. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Alarm, LabelValueCell;

@interface AlarmEditingViewController : UITableViewController {
	
	LabelValueCell	*typeCell;
	LabelValueCell	*relativeCell;
	LabelValueCell	*dateCell;
	LabelValueCell	*timeCell;
	
	Alarm		*alarm;
	NSDate		*dueDate;
	
	NSDateFormatter *dateFormatter;

}
// Expose the task property to other objects (the TaskListViewController).
@property (nonatomic, assign) Alarm *alarm;
@property (nonatomic, assign) NSDate *dueDate;

- (IBAction)cancel:(id)sender;
- (IBAction)save:(id)sender;


@end
