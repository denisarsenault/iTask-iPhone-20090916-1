//
//  SortOrderListController.m
//  iTask-iPhone
//
//  Created by Denis Arsenault on 1/23/09.
//  Copyright 2009 MyBrightzone. All rights reserved.
//

#import "SortOrderName.h"
#import "Task.h"
#import "SortOrderListController.h"
#import "PreferencesViewController.h"
#import "Preferences.h"

@implementation SortOrderListController

@synthesize sortOrderNames, task, tableView, sortOrderName, dueDate;
@synthesize preferences;

- (id)initWithNibName:(NSString *)nibName bundle:(NSBundle *)bundle {
    if (self = [super initWithNibName:nibName bundle:bundle]) {
        self.title = @"Due Date";
		self.sortOrderNames = [[NSArray arrayWithObjects:@"Date Then Priority", @"Priority then Date",nil] init];
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
    [sortOrderNames release];
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
    
	NSString *cal = [sortOrderNames objectAtIndex:indexPath.row];
	NSString *listUID = cal;
	NSString *taskCalUID = sortOrderName;
	
	return ([listUID isEqualToString:taskCalUID]) ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
}

// Selection updates the editing item's type and navigates to the previous view controller.
- (NSIndexPath *)tableView:(UITableView *)aTableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //DefaultDueDateName *cal = [defaultDueDateNames objectAtIndex:indexPath.row];
	NSString *cal = [sortOrderNames objectAtIndex:indexPath.row];
	preferences = [Preferences alloc];
	preferences.psortOrderTasks = cal;
    [self.navigationController popViewControllerAnimated:YES];
	
	NSInteger tempInt = 0;
	NSString *tempString = cal;
	if(cal) {
		
		if (tempString == @"Date Then Priority")
			tempInt = 1;
		if (tempString == @"Priority then Date")
			tempInt = 2;
	}
	
	NSUserDefaults *appDefaults = [NSUserDefaults standardUserDefaults];
	[appDefaults setObject:[NSNumber numberWithInt:tempInt]	forKey:@"sortOrderKey"];
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
	
	NSString *cal = [sortOrderNames objectAtIndex:indexPath.row];
    cell.text = cal;
    return cell;
}

// The table has one row for each possible type.
- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)section {
    return [sortOrderNames count];
}

@end
