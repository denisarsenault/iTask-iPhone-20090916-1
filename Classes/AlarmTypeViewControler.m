//
//  AlarmTypeViewControler.m
//  iTask-iPhone
//
//  Created by Denis Arsenault on 12/10/08.
//  Copyright 2008 Mybrightzone. All rights reserved.
//

#import "AlarmTypeViewControler.h"
#import "Alarm.h"


@implementation AlarmTypeViewController

@synthesize alarmTypes, alarm, tableView;

- (id)initWithNibName:(NSString *)nibName bundle:(NSBundle *)bundle {
    if (self = [super initWithNibName:nibName bundle:bundle]) {
        self.title = @"Alarm Type";
		
		self.alarmTypes = [NSArray arrayWithObjects:@"None", @"Message", @"Message with sound", @"Email", @"Open file", @"Run script", nil];
		
    }
    return self;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview.
}

- (void)dealloc {
    [alarmTypes release];
    [tableView release];
    [super dealloc];
}

- (void)viewWillAppear:(BOOL)animated {
    // Remove any previous selection.
    NSIndexPath *tableSelection = [tableView indexPathForSelectedRow];
	[tableView deselectRowAtIndexPath:tableSelection animated:NO];
    [tableView reloadData];
}

// Return a checkmark accessory for only the currently designated type of the editing item.
- (UITableViewCellAccessoryType)tableView:(UITableView *)aTableView accessoryTypeForRowWithIndexPath:(NSIndexPath *)indexPath {
    
	NSString* alarmTypeName = [alarmTypes objectAtIndex:indexPath.row];
	NSString* currAlarmActionName = [alarm getActionString];
	
	
	return ([alarmTypeName isEqualToString:currAlarmActionName]) ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
}

// Selection updates the editing item's type and navigates to the previous view controller.
- (NSIndexPath *)tableView:(UITableView *)aTableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString* alarmTypeName = [alarmTypes objectAtIndex:indexPath.row];
	
	// We can only select None of Message. None will delete the alarm
	
	if([alarmTypeName isEqualToString:@"None"]){
		alarm.alarmActionType = alarmActionNone;
		
	}
	
	if([alarmTypeName isEqualToString:@"Message"]){
		alarm.alarmActionType =alarmActionMessage;
	}
		
//	if([alarmTypeName isEqualToString:@"Email"]){
//		alarm.action = @"EMAIL";
//	}
									
											
    [self.navigationController popViewControllerAnimated:YES];
    return indexPath;
}

// The table uses standard UITableViewCells. The text for a cell is simply the string value of the matching type.
- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TypeCell"];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:@"TypeCell"] autorelease];
    }
	
    cell.text = [alarmTypes objectAtIndex:indexPath.row];
	
	
	
	
	
    return cell;
}

// The table has one row for each possible type.
- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)section {
    return [alarmTypes count];
}

@end
