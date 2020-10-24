//
//  AlarmEditingViewController.m
//  iTask-iPhone
//
//  Created by Denis Arsenault on 12/10/08.
//  Copyright 2008 Mybrightzone. All rights reserved.
//

#import "AlarmEditingViewController.h"
#import	"Alarm.h"
#import "LabelValueCell.h"
#import "DateTimeEditorViewController.h"
#import "AlarmTypeViewControler.h"


@implementation AlarmEditingViewController

@synthesize alarm, dueDate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Title displayed by the navigation controller.
        self.title = @"Edit Alarm";
        // Create a date formatter to convert the date to a string format.
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
        [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
		
		
		
		if (!typeCell) {
			typeCell = [[LabelValueCell alloc] initWithFrame:CGRectZero reuseIdentifier:@"URLCell"];
			typeCell.label.text = NSLocalizedString(@"ALARM_TYPE", @"");
		}
		
		if (!relativeCell) {
			relativeCell = [[LabelValueCell alloc] initWithFrame:CGRectZero reuseIdentifier:@"URLCell"];
					}
		
		
		if (!dateCell) {
			dateCell = [[LabelValueCell alloc] initWithFrame:CGRectZero reuseIdentifier:@"URLCell"];
			dateCell.label.text = NSLocalizedString(@"ALARM_DATE", @"");
		}
		
		if (!timeCell) {
			timeCell = [[LabelValueCell alloc] initWithFrame:CGRectZero reuseIdentifier:@"URLCell"];
			timeCell.label.text = NSLocalizedString(@"ALARM_TIME", @"");
		}
		
    }
    return self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}


- (void)dealloc {
    [super dealloc];
}


// the Alarm setter
// we implement this because the tables custom cell values need
// to be updated when this property changes, and this allows
// for the changes to be encapsulated
- (void)setAlarm:(Alarm *)anAlarm {
	
	alarm = anAlarm;
	
	typeCell.value.text = [alarm getActionString];
	
	dateCell.value.text = [alarm getAlarmDateStringWithDueDate:dueDate];
	timeCell.value.text = [alarm getAlarmTimeStringWithDueDate:dueDate];
}



- (IBAction)cancel:(id)sender {
    // cancel edits, restore all values from the copy
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)save:(id)sender {
    // save edits to the editing item and add new item to the content.
     [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated {
   
	self.title = [dateFormatter stringFromDate:dueDate];
	
	typeCell.value.text = [alarm getActionString];
	
	dateCell.value.text = [alarm getAlarmDateStringWithDueDate:dueDate];
	timeCell.value.text = [alarm getAlarmTimeStringWithDueDate:dueDate];

	
	[self.tableView reloadData];
}

- (NSIndexPath *)tableView:(UITableView *)aTableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
       return indexPath;
}



// Have an accessory view for the second section only
- (UITableViewCellAccessoryType)tableView:(UITableView *)aTableView accessoryTypeForRowWithIndexPath:(NSIndexPath *)indexPath {
	
	return UITableViewCellAccessoryDisclosureIndicator;
}


- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // Recover section and row info
	NSInteger section = [indexPath section];
	
	if(section == 0)
		return typeCell;
	
	if(section == 1)
		return dateCell;
	
	if(section == 2)
		return timeCell;
	
	return typeCell;

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)aTableView {
    
	/*
	 alarmActionNone = 1,
	 alarmActionMessage,
	 alarmActionMessageWithSound,
	 alarmActionEmail,
	 alarmActionOpenFile,
	 alarmActionRunScript
	 
	 */
	
	NSInteger numSections = 1;
	
	switch (alarm.alarmActionType) {
		case alarmActionNone:
			numSections = 1;
			break;
		case alarmActionMessage:
			numSections = 3;
			break;
		case alarmActionMessageWithSound:
			numSections = 4;
			break;
		case alarmActionEmail:
			numSections = 4;
			break;
		case alarmActionOpenFile:
			numSections = 4;
			break;
		case alarmActionRunScript:
			numSections = 4;
			break;
		default:
			break;
	}
	
	return numSections;
}

- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	[tableView deselectRowAtIndexPath:indexPath animated:YES];	

	// Recover section and row info
	NSInteger row = [indexPath row];
	NSInteger section = [indexPath section];
	
	//Select an alarm type
	if(section == 0 && row == 0){
		AlarmTypeViewController *controller = [[AlarmTypeViewController alloc] initWithNibName:@"AlarmTypeListView" bundle:nil];
		
		controller.alarm = alarm;
		
		[self.navigationController pushViewController:controller animated:YES];
	}
	
	//Select a date and time.
	if(section == 1 && row == 0){
		DateTimeEditorViewController *controller = [[DateTimeEditorViewController alloc] initWithNibName:@"DateEditorView" bundle:nil];

		controller.dateValue = [alarm getAlarmDateWithDueDate:dueDate] ;
		controller.dateEditing = YES;
		
		[self.navigationController pushViewController:controller animated:YES];
	}
	if(section == 2 && row == 0){
		DateTimeEditorViewController *controller = [[DateTimeEditorViewController alloc] initWithNibName:@"TimeEditorView" bundle:nil];
		
		controller.dateValue = [alarm getAlarmDateWithDueDate:dueDate] ;
		controller.dateEditing = NO;
		
		[self.navigationController pushViewController:controller animated:YES];
	}
	
}

@end
