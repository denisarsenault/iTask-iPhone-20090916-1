//
//  DefaultDueDateListController.m
//  iTask-iPhone
//
//  Created by Denis Arsenault on 1/23/09.
//  Copyright 2009 MyBrightzone. All rights reserved.
//

#import "DefaultDueDateListController.h"
#import "DefaultDueDateName.h"
#import "Task.h"
#import "Preferences.h"

@implementation DefaultDueDateListController

@synthesize task, tableView, defaultDueDateName, dueDate, defaultDueDateNames;
@synthesize preferences;


- (id)initWithNibName:(NSString *)nibName bundle:(NSBundle *)bundle {
    if (self = [super initWithNibName:nibName bundle:bundle]) {
        self.title = @"Due Date";
		self.defaultDueDateNames = [[NSArray arrayWithObjects:@"None", @"Today", @"Tomorrow", @"+3 Days", @"+7 Days", @"+30 Days", nil] init];
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
    [defaultDueDateNames release];
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
    
	NSString *cal = [defaultDueDateNames objectAtIndex:indexPath.row];
	NSString *listUID = cal;
	NSString *taskCalUID = defaultDueDateName;
	
	return ([listUID isEqualToString:taskCalUID]) ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
}

// Selection updates the editing item's type and navigates to the previous view controller.
- (NSIndexPath *)tableView:(UITableView *)aTableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	NSString *cal = [defaultDueDateNames objectAtIndex:indexPath.row];
    //CalendarName *cal = [calendarNames objectAtIndex:indexPath.row];
	//controller.task = [[Task alloc] initWithDueDate:dueDate priority:priority];
	preferences = [Preferences alloc];
	preferences.pdefaultDueDateName = cal;
	defaultDueDateName = cal;
    [self.navigationController popViewControllerAnimated:YES];

	NSInteger tempInt = 0;
	NSString *tempString = cal;
	if(cal) {
		
		if (tempString == @"None")
			tempInt = 1;
		if (tempString == @"Today")
			tempInt = 2;
		if (tempString == @"Tomorrow")
			tempInt = 3;
		if (tempString == @"+3 Days")
			tempInt = 4;
		if (tempString == @"+7 Days")
			tempInt = 5;
		if (tempString == @"+30 Days")
			tempInt = 6;
	}
	
	NSUserDefaults *appDefaults = [NSUserDefaults standardUserDefaults];
	[appDefaults setObject:[NSNumber numberWithInt:tempInt]	forKey:@"dueDateKey"];
	[appDefaults synchronize];

	[[NSUserDefaults standardUserDefaults] synchronize];
	[super viewWillAppear:YES];
	return indexPath;
}

// The table uses standard UITableViewCells. The text for a cell is simply the string value of the matching type.
- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *kCustomCellID = @"MyCellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCustomCellID];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:kCustomCellID] autorelease];
    }
	
	NSString *cal = [defaultDueDateNames objectAtIndex:indexPath.row];
    cell.text = cal;
    return cell;
}

// The table has one row for each possible type.
- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)section {
    return [defaultDueDateNames count];
}

@end
