//
//  PreferencesViewController.m
//  iTask-iPhone
//
//  Created by Denis Arsenault on 1/15/08.
//  
//

#import "PreferencesViewController.h"
#import "TitleCell.h"
#import "LabelValueCell.h"
#import "SegmentedControlCell.h"
#import "DateFieldCell.h"
#import "DefaultDueDateCell.h"
#import "DeleteCompletedTasksCell.h"
#import "SortOrderTasksCell.h"
#import "AlarmCell.h"
#import "TextViewCell.h"
#import "Task.h"
#import "Alarm.h"
#import "TaskListViewController.h"
#import "EditingViewController.h"
#import	"AlarmEditingViewController.h"
#import	"TextViewEditingController.h"
#import "CalendarListController.h"
#import "DefaultDueDateListController.h"
#import "DeleteCompletedTasksListController.h"
#import "SortOrderListController.h"
#import	"CustomUISwitch.h"
#import "DefaultDueDateName.h"
#import "DeleteCompletedTasksName.h"
#import "SortOrderName.h"
#import "Preferences.h"

#import "iTaskAppDelegate.h"

NSString *pDueDateKey					= @"dueDateKey";
NSString *pPriorityKey					= @"priorityKey";
//NSString *pDefaultCalendarKey			= @"defaultCalendarKey"; TBD later
NSString *pShowOverdueTasksKey			= @"showOverdueTasksKey";
NSString *pShowTodaysTasksKey			= @"showTodaysTasksKey";
NSString *pShowTomorrowsTasksKey		= @"showTomorrowsTasksKey";
NSString *pShowFutureTasksKey			= @"showFutureTasksKey";
NSString *pShowNoDueDateTasksKey		= @"showNoDueDateTasksKey";
NSString *pShowCompletedTasksKey		= @"showCompletedTasksKey";
NSString *pDeleteCompletedTasksKey		= @"deleteCompletedTasksKey";
NSString *pSortOrderKey					= @"sortOrderKey";
NSString *pShowDateGroupHeadingsKey		= @"showDateGroupHeadingsKey";
NSString *testValue;

#define KEYBOARD_HEIGHT_LANDSCAPE 160

#define	HEADER_ARRAY (NSArray arrayWithObjects: @"New Task Defaults", @"Show Tasks", nil)

//#define PREFERENCES_ARRAY (NSArray arrayWithObjects: @"None", @"Today", @"Tomorrow", @"+3 Days", @"+7 Days", @"+30 Days", nil)

//
// Private Methods
//

@implementation PreferencesViewController
//
@synthesize task, numRows, dateFormatter, selectedIndexPath, delRow, dueDate, dateOffset;
@synthesize defaultDueDate;
@synthesize defaultPriority;
@synthesize showOverdueTasks;
@synthesize showTodaysTasks;
@synthesize showTomorrowsTasks;
@synthesize showFutureTasks;
@synthesize showNoDueDateTasks;
@synthesize showCompletedTasks;
@synthesize deleteCompletedTasks;
@synthesize sortOrderTasks;
@synthesize showDateGroupTasks;
@synthesize defaultDueDateNames;
@synthesize deleteCompletedTasksNames;
@synthesize sortOrderNames;
@synthesize	deleteCompletedCell;
@synthesize	sortOrderCell;
@synthesize dueDateCell;
@synthesize preferences;
@synthesize priorityOffset;


//
//
//

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Title displayed by the navigation controller.
        self.title = @"iTask Settings";
		//
		delRow=0;
        // Create a date formatter to convert the date to a string format.
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
        [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
		
		//if (!titleCell) {
		//	titleCell = [[TitleCell alloc] initWithFrame:CGRectZero reuseIdentifier:@"TitleCell"];
		//	titleCell.titleField.delegate = self;
		//}
		
		if (!dueDateCell) {
			defaultDueDateNames = [NSArray arrayWithObjects: @"None", @"Today", @"Tomorrow", @"+3 Days", @"+7 Days", @"+30 Days", nil];
			dueDateCell = [[[DefaultDueDateCell alloc] initWithFrame:CGRectZero reuseIdentifier:@"DueDateCell"] init];
		}
		
		if (!priorityCell) {
			NSArray *priorityContent = [NSArray arrayWithObjects:@"High", @"Med", @"Low", @" - ",  nil];
			priorityCell = [[SegmentedControlCell alloc] initWithFrame:CGRectZero reuseIdentifier:@"PriorityCell" items:priorityContent];
			[priorityCell.segmentedControlView addTarget:self action:@selector(segmentControlChanged:) forControlEvents:UIControlEventValueChanged];
		}	
		
		if (!overdueSwitch) {
			overdueSwitch = [[[CustomUISwitch alloc] initWithFrame:CGRectZero] init];
			[overdueSwitch setCenter:CGPointMake(160.0f,230.0f)];
			[overdueSwitch setLeftLabelText: @"ON"];
			[overdueSwitch setRightLabelText: @"OFF"];
			[overdueSwitch addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];
		}
		
		if (!todaySwitch) {
			todaySwitch = [[[CustomUISwitch alloc] initWithFrame:CGRectZero] init];
			[todaySwitch setCenter:CGPointMake(160.0f,230.0f)];
			[todaySwitch setLeftLabelText: @"ON"];
			[todaySwitch setRightLabelText: @"OFF"];
			[todaySwitch addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];
		}
		
		if (!tomorrowSwitch) {
			tomorrowSwitch = [[[CustomUISwitch alloc] initWithFrame:CGRectZero] init];
			[tomorrowSwitch setCenter:CGPointMake(160.0f,230.0f)];
			[tomorrowSwitch setLeftLabelText: @"ON"];
			[tomorrowSwitch setRightLabelText: @"OFF"];
			[tomorrowSwitch addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];
		}		
		
		if (!futureSwitch) {
			futureSwitch = [[[CustomUISwitch alloc] initWithFrame:CGRectZero] init];
			[futureSwitch setCenter:CGPointMake(160.0f,230.0f)];
			[futureSwitch setLeftLabelText: @"ON"];
			[futureSwitch setRightLabelText: @"OFF"];
			[futureSwitch addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];
		}		
		
		if (!noDueDateSwitch) {
			noDueDateSwitch = [[[CustomUISwitch alloc] initWithFrame:CGRectZero] init];
			[noDueDateSwitch setCenter:CGPointMake(160.0f,230.0f)];
			[noDueDateSwitch setLeftLabelText: @"ON"];
			[noDueDateSwitch setRightLabelText: @"OFF"];
			[noDueDateSwitch addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];
		}	
		
		if (!completedSwitch)  {
			completedSwitch = [[[CustomUISwitch alloc] initWithFrame:CGRectZero] init];
			[completedSwitch setCenter:CGPointMake(160.0f,230.0f)];
			[completedSwitch setLeftLabelText: @"ON"];
			[completedSwitch setRightLabelText: @"OFF"];
			[completedSwitch addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];
		}	
		
		/*if (!deleteCompletedCell) {
			deleteCompletedTasksNames = [NSArray arrayWithObjects: @"Immediately", @"1 Week", @"1 Month", @"3 Months", @"12 Months", @"Never", nil];
			deleteCompletedCell = [[[DeleteCompletedTasksCell alloc] initWithFrame:CGRectZero reuseIdentifier:@"DeleteCompletedCell"] init];		
		}*/
		
		if (!deleteCompletedCell) {
			deleteCompletedTasksNames = [NSArray arrayWithObjects: @"None", @"Today", @"Tomorrow", @"+3 Days", @"+7 Days", @"+30 Days", nil];
			deleteCompletedCell = [[[DeleteCompletedTasksCell alloc] initWithFrame:CGRectZero reuseIdentifier:@"DeleteCompletedCell"] init];
		}
		
		if (!sortOrderCell) {
			sortOrderNames = [NSArray arrayWithObjects: @"Date then Priority", @"Priority then date", nil];
			sortOrderCell = [[[SortOrderTasksCell alloc] initWithFrame:CGRectZero reuseIdentifier:@"SortOrderCell"] init];
		}
		
		if (!showdategroupSwitch) {
			showdategroupSwitch = [[[CustomUISwitch alloc] initWithFrame:CGRectZero] init];
			[showdategroupSwitch setCenter:CGPointMake(160.0f,230.0f)];
			[showdategroupSwitch setLeftLabelText: @"ON"];
			[showdategroupSwitch setRightLabelText: @"OFF"];
			[showdategroupSwitch addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];
		}	
    }
    return self;
}

//
//
//

- (void)dealloc {
    // Release owned resources.
	
	[titleCell release];
	[completedSwitch release];
	[defaultPriority release];
	[dueDateCell release];
	[priorityCell release];
	[overdueSwitch release];
	[todaySwitch release];
	[tomorrowSwitch release];
	[futureSwitch release];
	[noDueDateSwitch release];
	[completedSwitch release];
	[deleteCompletedCell release];
	//0129 [sortOrderCell release];
	[showdategroupSwitch release];
	[testValue release];
    [selectedIndexPath release];
    //0129 [task release];
    [dateFormatter release];
	
	// 0129 DLA
	//[deleteCompletedTasks release];
	
    [super dealloc];
}
- (void)viewWillLoad{
	[self viewDidLoad];
}

//
// Get the preferences
//

- (void) readPreferences{
	
	NSString *testValue = [[[NSUserDefaults standardUserDefaults] stringForKey:pDueDateKey] init];
	if (testValue == nil)
	{
		// no default values have been set, create them here based on what's in our Settings bundle info
		//
		NSString *pathStr = [[NSBundle mainBundle] bundlePath];
		NSString *settingsBundlePath = [pathStr stringByAppendingPathComponent:@"Settings.bundle"];
		NSString *finalPath = [settingsBundlePath stringByAppendingPathComponent:@"Root.plist"];
		
		NSDictionary *settingsDict = [NSDictionary dictionaryWithContentsOfFile:finalPath];
		NSArray *prefSpecifierArray = [settingsDict objectForKey:@"PreferenceSpecifiers"];
		
		NSNumber *dueDateDefault;
		NSNumber *priorityDefault;
		
		Boolean	 showOverdueTasksDefault;
		Boolean	 showTodaysTasksDefault;
		Boolean	 showTomorrowsTasksDefault;
		Boolean	 showFutureTasksDefault;
		Boolean	 showNoDueDateDefault;
		Boolean	 showCompletedTasksDefault;
		NSNumber *deleteCompletedTasksDefault;
		NSNumber *sortOrderDefault;
		Boolean	 showDateGroupHeadersDefault;
		
		NSDictionary *prefItem;
		for (prefItem in prefSpecifierArray)
		{
			NSString *keyValueStr = [prefItem objectForKey:@"Key"];
			
			if ([keyValueStr isEqualToString:pDueDateKey])
			{
				dueDateDefault =[prefItem objectForKey:@"DefaultValue"];
			}
			else if ([keyValueStr isEqualToString:pPriorityKey])
			{
				priorityDefault = [prefItem objectForKey:@"DefaultValue"];
			}
			else if ([keyValueStr isEqualToString:pShowOverdueTasksKey])
			{
				showOverdueTasksDefault = [[prefItem valueForKey:@"DefaultValue"] boolValue];
			}
			else if ([keyValueStr isEqualToString:pShowTodaysTasksKey])
			{
				showTodaysTasksDefault = [[prefItem valueForKey:@"DefaultValue"] boolValue];
			}
			else if ([keyValueStr isEqualToString:pShowTomorrowsTasksKey])
			{
				showTomorrowsTasksDefault = [[prefItem valueForKey:@"DefaultValue"] boolValue];
			}
			else if ([keyValueStr isEqualToString:pShowFutureTasksKey])
			{
				showFutureTasksDefault = [[prefItem valueForKey:@"DefaultValue"] boolValue];
			}
			else if ([keyValueStr isEqualToString:pShowNoDueDateTasksKey])
			{
				showNoDueDateDefault = [[prefItem valueForKey:@"DefaultValue"] boolValue];
			}
			else if ([keyValueStr isEqualToString:pShowCompletedTasksKey])
			{
				showCompletedTasksDefault = [[prefItem valueForKey:@"DefaultValue"] boolValue];
			}
			else if([keyValueStr isEqualToString:pDeleteCompletedTasksKey])
			{
				deleteCompletedTasksDefault = [prefItem valueForKey:@"DefaultValue"];
			}
			else if ([keyValueStr isEqualToString:pSortOrderKey])
			{
				sortOrderDefault = [prefItem valueForKey:@"DefaultValue"];
			}
			else if ([keyValueStr isEqualToString:pShowDateGroupHeadingsKey])
			{
				showDateGroupHeadersDefault = [[prefItem valueForKey:@"DefaultValue"] boolValue];
			}
		}
		
		// since no default values have been set (i.e. no preferences file created), create it here
		NSDictionary *appDefaults =  [NSDictionary dictionaryWithObjectsAndKeys:
									  [NSNumber numberWithInt:1], pDueDateKey,
									  [NSNumber numberWithInt:1], pPriorityKey,
									  [NSNumber numberWithBool:YES], pShowOverdueTasksKey,
									  [NSNumber numberWithBool:YES], pShowTodaysTasksKey,
									  [NSNumber numberWithBool:YES], pShowTomorrowsTasksKey,
									  [NSNumber numberWithBool:YES], pShowFutureTasksKey,
									  [NSNumber numberWithBool:YES], pShowNoDueDateTasksKey,
									  [NSNumber numberWithBool:YES], pShowCompletedTasksKey,
									  [NSNumber numberWithInt:1], pDeleteCompletedTasksKey,
									  [NSNumber numberWithInt:1], pSortOrderKey,
									  [NSNumber numberWithBool:YES], pShowDateGroupHeadingsKey,
									  nil];
		
		[[NSUserDefaults standardUserDefaults] registerDefaults:appDefaults];
		[[NSUserDefaults standardUserDefaults] synchronize];
	}
	
	// we're ready to do, so lastly set the key preference values
	// read in the default dueDate offset.
	
	dateOffset = [[NSUserDefaults standardUserDefaults] integerForKey:pDueDateKey];
	//	defaultDueDate = 
	if(dateOffset == dueDateNone)
	{
		self.defaultDueDate = nil;
	}
	else if(dateOffset == dueDateToday)
	{
		self.defaultDueDate = [NSDate date];
	}
	else if(dateOffset == dueDateTomorrow)
	{
		NSTimeInterval secondsPerDay = 24 * 60 * 60;
		self.defaultDueDate = [NSDate dateWithTimeIntervalSinceNow:secondsPerDay];
	}
	else if(dateOffset == dueDate3days)
	{
		NSTimeInterval secondsPerDay = 24 * 60 * 60 * 3;
		self.defaultDueDate = [NSDate dateWithTimeIntervalSinceNow:secondsPerDay];
	}
	else if(dateOffset == dueDate7days)
	{
		NSTimeInterval secondsPerDay = 24 * 60 * 60 * 7;
		self.defaultDueDate = [NSDate dateWithTimeIntervalSinceNow:secondsPerDay];
	}
	else if(dateOffset == dueDate30days)
	{
		NSTimeInterval secondsPerDay = 24 * 60 * 60 * 7;
		self.defaultDueDate = [NSDate dateWithTimeIntervalSinceNow:secondsPerDay];
	}
	
	int	intPriority  = [[NSUserDefaults standardUserDefaults] integerForKey:pPriorityKey];
	self.defaultPriority = [NSNumber numberWithInt:intPriority];
	self.showOverdueTasks= [[NSUserDefaults standardUserDefaults] boolForKey:pShowOverdueTasksKey];
	self.showTodaysTasks= [[NSUserDefaults standardUserDefaults] boolForKey:pShowTodaysTasksKey];
	self.showTomorrowsTasks= [[NSUserDefaults standardUserDefaults] boolForKey:pShowTomorrowsTasksKey];
	self.showFutureTasks= [[NSUserDefaults standardUserDefaults] boolForKey:pShowFutureTasksKey];
	self.showNoDueDateTasks= [[NSUserDefaults standardUserDefaults] boolForKey:pShowNoDueDateTasksKey];
	self.showCompletedTasks= [[NSUserDefaults standardUserDefaults] boolForKey:pShowCompletedTasksKey];	
	NSInteger intdeleteCompletedTasks  = [[NSUserDefaults standardUserDefaults] integerForKey:pDeleteCompletedTasksKey];
	self.deleteCompletedTasks  = [NSNumber numberWithInt:intdeleteCompletedTasks];
	//self.deleteCompletedTasks= [NSNumber numberWithInt:intdeleteCompletedTasks];
	//self.sortOrderTasks  = [[NSUserDefaults standardUserDefaults] integerForKey:pSortOrderKey];
	NSInteger intsortOrderTasks = [[NSUserDefaults standardUserDefaults] integerForKey:pSortOrderKey];
	self.sortOrderTasks= [NSNumber numberWithInt:intsortOrderTasks];
	self.showDateGroupTasks = [[NSUserDefaults standardUserDefaults] boolForKey:pShowDateGroupHeadingsKey];

}

//
// This will populate the fields with the current preferences
//
// 1/27/2009 DLA Changed NSUserDefaults access routines in response to EXC-BAD_ACCESS error
//

- (void)viewDidAppear:(BOOL)animated {
	[self readPreferences];
	if (dueDateCell) {
		dueDateCell.value.textAlignment = UITextAlignmentCenter;
		if(dateOffset == dueDateNone)
		{
			self.defaultDueDate = nil;
			dueDateCell.value.text = @"None";
		}
		else if(dateOffset == dueDateToday)
		{
			self.defaultDueDate = [NSDate date];
			dueDateCell.value.text = @"Today";
		}
		else if(dateOffset == dueDateTomorrow)
		{
			NSTimeInterval secondsPerDay = 24 * 60 * 60;
			self.defaultDueDate = [NSDate dateWithTimeIntervalSinceNow:secondsPerDay];
			dueDateCell.value.text = @"Tomorrow";
		}
		else if(dateOffset == dueDate3days)
		{
			NSTimeInterval secondsPerDay = 24 * 60 * 60 * 3;
			self.defaultDueDate = [NSDate dateWithTimeIntervalSinceNow:secondsPerDay];
			dueDateCell.value.text = @"+3 Days";
		}
		else if(dateOffset == dueDate7days)
		{
			NSTimeInterval secondsPerDay = 24 * 60 * 60 * 7;
			self.defaultDueDate = [NSDate dateWithTimeIntervalSinceNow:secondsPerDay];
			dueDateCell.value.text = @"+7 Days";
		}
		else if(dateOffset == dueDate30days)
		{
			NSTimeInterval secondsPerDay = 24 * 60 * 60 * 7;
			self.defaultDueDate = [NSDate dateWithTimeIntervalSinceNow:secondsPerDay];
			dueDateCell.value.text = @"+30 Days";
		}
	}else{
		dueDateCell.value.text = @"None";
		
		// Save the current cell as a constant
	}
	
	dueDate = dueDateCell.value.text;
	//
		
	if(defaultPriority) {
			switch ([defaultPriority  intValue])
			{
				case 1:
					priorityCell.segmentedControlView.selectedSegmentIndex = 0;
					break;
				case 5:
					priorityCell.segmentedControlView.selectedSegmentIndex = 1;
					break;
				case 9:
					priorityCell.segmentedControlView.selectedSegmentIndex = 2;
					break;
				case 0:
					priorityCell.segmentedControlView.selectedSegmentIndex = 3;
					break;
				default:
					priorityCell.segmentedControlView.selectedSegmentIndex = 3;
					break;
			}
	}		
		
	if (showOverdueTasks) {
		BOOL overdue = showOverdueTasks;
		[overdueSwitch setOn:overdue animated:NO];
	}
	
	if (showTodaysTasks) {
		BOOL complete = showTodaysTasks;
		[todaySwitch setOn:complete animated:NO];
	}
	
	if (showTomorrowsTasks) {
		BOOL complete = showTomorrowsTasks;
		[tomorrowSwitch setOn:complete animated:NO];
	}
	
	if (showFutureTasks) {
		BOOL complete = showFutureTasks;
		[futureSwitch setOn:complete animated:NO];
	}
	
	if (showNoDueDateTasks) {
		BOOL complete = showNoDueDateTasks;
		[noDueDateSwitch setOn:complete animated:NO];
	}
	
	if (showCompletedTasks) {
		BOOL complete = showCompletedTasks;
		[completedSwitch setOn:complete animated:NO];
	}
	
	if (deleteCompletedTasks) {
		switch ([deleteCompletedTasks intValue])
		{
			case 1:
				deleteCompletedCell.value.text  = @"Immediately";
				break;
			case 2:
				deleteCompletedCell.value.text  = @"1 Week";
				break;
			case 3:
				deleteCompletedCell.value.text  = @"1 Month";
				break;
			case 4:
				deleteCompletedCell.value.text  = @"3 Months";
				break;
			case 5:
				deleteCompletedCell.value.text  = @"12 Months";
				break;
			case 6:
				deleteCompletedCell.value.text  = @"Never";
				break;
			default:
				deleteCompletedCell.value.text  = @"Never";
				break;
		}
	}
	
	if (sortOrderTasks) {
		
		switch ([sortOrderTasks intValue])
		{
			case 1:
				sortOrderCell.value.text  = @"Date Then Priority";
				break;
			case 2:
				sortOrderCell.value.text  = @"Priority then Date";
				break;
			default:
				sortOrderCell.value.text  = @"Priority then Date";
				break;
		}
	}
	
	if (showDateGroupTasks) {
		BOOL complete = showDateGroupTasks;
		[showdategroupSwitch setOn:complete animated:NO];
	}
	
	// 0129
	
	CGRect frame = [self.tableView bounds];
	frame = CGRectMake(0.0, 0.0, frame.size.width, 10);
	[self.tableView scrollRectToVisible:frame animated:NO];
	
	
	// register for keyboard notifications
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:self.view.window];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:self.view.window];
	
	
	
}
/*
 - (void)viewDidAppear:(BOOL)animated {
 [super viewDidAppear:animated];
 }
 */

//
//
//

- (void)prefssave{
	NSInteger tempInt = 0;
	NSString *tempString = dueDateCell.value.text;
	if(dueDateCell.value.text) {
		
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

	NSInteger tempPriority = priorityCell.segmentedControlView.selectedSegmentIndex;
	

		switch (tempPriority)
		{
			case 0:
				priorityOffset = PriorityHigh;
				break;
			case 1:
				priorityOffset = PriorityMedium;
				break;
			case 2:
				priorityOffset = PriorityLow;
				break;
			case 3:
				priorityOffset = PriorityNone;
				break;
			default:
				priorityOffset = PriorityNone;
				break;
		}

	
	NSUserDefaults *appDefaults = [NSUserDefaults standardUserDefaults];
	[appDefaults setObject:[NSNumber numberWithInt:priorityOffset] forKey:pPriorityKey];
	[appDefaults setObject:[NSNumber numberWithBool:showOverdueTasks] forKey:pShowOverdueTasksKey];
	[appDefaults setObject:[NSNumber numberWithBool:showTodaysTasks] forKey:pShowTodaysTasksKey];
	[appDefaults setObject:[NSNumber numberWithBool:showTomorrowsTasks] forKey:pShowTomorrowsTasksKey];
	[appDefaults setObject:[NSNumber numberWithBool:showFutureTasks] forKey:pShowFutureTasksKey];
	[appDefaults setObject:[NSNumber numberWithBool:showNoDueDateTasks] forKey:pShowNoDueDateTasksKey];
	[appDefaults setObject:[NSNumber numberWithBool:showCompletedTasks] forKey:pShowCompletedTasksKey];
	[appDefaults setObject:[NSNumber numberWithInt:(int)deleteCompletedTasks] forKey:pDeleteCompletedTasksKey];
	[appDefaults setObject:[NSNumber numberWithInt:(int)sortOrderTasks] forKey:pSortOrderKey];
	[appDefaults setObject:[NSNumber numberWithBool:showDateGroupTasks] forKey:pShowDateGroupHeadingsKey];
	[appDefaults synchronize];

	[[NSUserDefaults standardUserDefaults] synchronize];
}
- (void)viewWillDisappear:(BOOL)animated {
	[self prefssave];
	[super viewWillAppear:YES];
	//[super loadData];

}

//
//
//

- (void)keyboardDidShow:(NSNotification *)notif {
	// grab the keyboard height and save it
	CGRect keyboardRect;
	[[[notif userInfo] objectForKey:UIKeyboardBoundsUserInfoKey] getValue:&keyboardRect];
	
}

//
//
//

- (void)keyboardDidHide:(NSNotification *)notif {
	// grab the keyboard height and save it
	CGRect keyboardRect;
	[[[notif userInfo] objectForKey:UIKeyboardBoundsUserInfoKey] getValue:&keyboardRect];
	
}

// 
// The preferences 
// to be updated when this property changes, and this allows
// 


//
//
//
- (void)delete: (id) sender{
	[self dialogOKCancelAction];
}

//
//
//

- (void)dialogOKCancelAction
{
	// open a dialog with an OK and cancel button
	UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Confirm Delete"
															 delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"OK" otherButtonTitles:nil];
	actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
	[actionSheet showInView:self.view]; // show from our table view (pops up in the middle of the table)
	[actionSheet release];
}

#pragma mark -
#pragma mark <UITableViewDelegate, UITableViewDataSource> Methods

//
// Create the Headers
// 

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger) section{
	NSString *result = Nil;
	
	if(section == 0)
		result =  (NSString *)@"New Task Defaults";
	else if(section ==  1)
		result =  (NSString *)@"Show Tasks";
	
	return result;
}

//
//
//

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return self.numRows;
}

//
//
//

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	
	NSInteger result = 0;
	
	if(section == 0)
		result =  2;
	else if(section ==  1)
		result =  9;
	
	return result;
}

- (IBAction)save:(id)sender {
	
}

//
// Setup the cells for each row
//

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
	// Recover section and row info
	NSInteger row = [indexPath row];
	NSInteger section = [indexPath section];
	
	// Due Date Cell
	if(section == 0 && row == 0){
		
		dueDateCell.label.text = NSLocalizedString( @"Due Date", @"");
		//dueDateCell.value.text = dueDateCell;		
		return dueDateCell;
	}
	
	if(section == 0 && row == 1){
		
		return priorityCell;
	}
	
	// OverDue Cell
	if(section == 1 && row == 0){
		
		// Pull the cell
		UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"overdue-cell"];
		// If there's a new cell needed, add a custom switch
		if (cell == nil) {
			
			cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:@"overdue-cell"] autorelease];
			cell.indentationLevel = 5;
			
			// cell's  label
			UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
			label.backgroundColor = [UIColor clearColor];
			label.opaque = NO;
			label.textColor = [UIColor blackColor];
			label.highlightedTextColor = [UIColor whiteColor];
			label.font = [UIFont boldSystemFontOfSize:14.0];
			label.text = NSLocalizedString( @"OverDue", @"");
			[cell addSubview:label];
			
			// cell's custom switch we hold on to this
			[cell addSubview:overdueSwitch];
			
			// layout the controls
			CGRect contentRect = [cell.contentView bounds];
			CGRect frame = CGRectMake(contentRect.origin.x + 20.0, 5.0, 150, 30.0);
			label.frame = frame;
			
			frame = CGRectMake(contentRect.size.width - 110, 5.0, 94, 27.0);
			overdueSwitch.frame= frame;
			
			//[label release];
			//[completedSwitch release];
		}
		return cell;
	}
	
	// Today Cell
	if(section == 1 && row == 1){
		// Pull the cell
		UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"today-cell"];
		
		// If there's a new cell needed, add a custom switch
		if (cell == nil) {
			
			cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:@"today-cell"] autorelease];
			cell.indentationLevel = 5;
			
			// cell's  label
			UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
			label.backgroundColor = [UIColor clearColor];
			label.opaque = NO;
			label.textColor = [UIColor blackColor];
			label.highlightedTextColor = [UIColor whiteColor];
			label.font = [UIFont boldSystemFontOfSize:14.0];
			label.text = NSLocalizedString( @"Today", @"");
			[cell addSubview:label];
			
			// cell's custom switch we hold on to this
			[cell addSubview:todaySwitch];
			
			// layout the controls
			CGRect contentRect = [cell.contentView bounds];
			CGRect frame = CGRectMake(contentRect.origin.x + 20.0, 5.0, 150, 30.0);
			label.frame = frame;
			
			frame = CGRectMake(contentRect.size.width - 110, 5.0, 94, 27.0);
			todaySwitch.frame= frame;
			
			//[label release];
			//[todaySwitch release];
		}
		return cell;
	}
	
	// Tomorrow Cell
	if(section == 1 && row == 2){
		// Pull the cell
		UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"tomorrow-cell"];
		
		// If there's a new cell needed, add a custom switch
		if (cell == nil) {
			
			cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:@"tomorrow-cell"] autorelease];
			cell.indentationLevel = 5;
			
			// cell's  label
			UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
			label.backgroundColor = [UIColor clearColor];
			label.opaque = NO;
			label.textColor = [UIColor blackColor];
			label.highlightedTextColor = [UIColor whiteColor];
			label.font = [UIFont boldSystemFontOfSize:14.0];
			label.text = NSLocalizedString( @"Tomorrow", @"");
			[cell addSubview:label];
			
			// cell's custom switch we hold on to this
			[cell addSubview:tomorrowSwitch];
			
			// layout the controls
			CGRect contentRect = [cell.contentView bounds];
			CGRect frame = CGRectMake(contentRect.origin.x + 20.0, 5.0, 150, 30.0);
			label.frame = frame;
			
			frame = CGRectMake(contentRect.size.width - 110, 5.0, 94, 27.0);
			tomorrowSwitch.frame= frame;
			
			//[label release];
			//[tomorrowSwitch release];
		}
		return cell;
	}
	
	// Future Cell
	if(section == 1 && row == 3){
		// Pull the cell
		UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"future-cell"];
		
		// If there's a new cell needed, add a custom switch
		if (cell == nil) {
			
			cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:@"future-cell"] autorelease];
			cell.indentationLevel = 5;
			
			// cell's  label
			UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
			label.backgroundColor = [UIColor clearColor];
			label.opaque = NO;
			label.textColor = [UIColor blackColor];
			label.highlightedTextColor = [UIColor whiteColor];
			label.font = [UIFont boldSystemFontOfSize:14.0];
			label.text = NSLocalizedString( @"Future", @"");
			[cell addSubview:label];
			
			// cell's custom switch we hold on to this
			[cell addSubview:futureSwitch];
			
			// layout the controls
			CGRect contentRect = [cell.contentView bounds];
			CGRect frame = CGRectMake(contentRect.origin.x + 20.0, 5.0, 150, 30.0);
			label.frame = frame;
			
			frame = CGRectMake(contentRect.size.width - 110, 5.0, 94, 27.0);
			futureSwitch.frame= frame;
			
			//[label release];
			//[tomorrowSwitch release];
		}
		return cell;
	}
	
	// No Due Date Cell
	if(section == 1 && row == 4){
		
		// Pull the cell
		UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"noDueDate-cell"];
		
		// If there's a new cell needed, add a custom switch
		if (cell == nil) {
			
			cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:@"noDueDate-cell"] autorelease];
			cell.indentationLevel = 5;
			
			// cell's  label
			UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
			label.backgroundColor = [UIColor clearColor];
			label.opaque = NO;
			label.textColor = [UIColor blackColor];
			label.highlightedTextColor = [UIColor whiteColor];
			label.font = [UIFont boldSystemFontOfSize:14.0];
			label.text = NSLocalizedString( @"No Due Date", @"");
			[cell addSubview:label];
			
			// cell's custom switch we hold on to this
			[cell addSubview:noDueDateSwitch];
			
			// layout the controls
			CGRect contentRect = [cell.contentView bounds];
			CGRect frame = CGRectMake(contentRect.origin.x + 20.0, 5.0, 150, 30.0);
			label.frame = frame;
			
			frame = CGRectMake(contentRect.size.width - 110, 5.0, 94, 27.0);
			noDueDateSwitch.frame= frame;
			
			//[label release];
			//[tomorrowSwitch release];
		}
		return cell;
	}
	
	// Completed Date Cell
	if(section == 1 && row == 5){
		// Pull the cell
		UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"completedDate-cell"];
		
		// If there's a new cell needed, add a custom switch
		if (cell == nil) {
			
			cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:@"completedDate-cell"] autorelease];
			cell.indentationLevel = 5;
			
			// cell's  label
			UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
			label.backgroundColor = [UIColor clearColor];
			label.opaque = NO;
			label.textColor = [UIColor blackColor];
			label.highlightedTextColor = [UIColor whiteColor];
			label.font = [UIFont boldSystemFontOfSize:14.0];
			label.text = NSLocalizedString( @"Completed", @"");
			[cell addSubview:label];
			
			// cell's custom switch we hold on to this
			[cell addSubview:completedSwitch];
			
			// layout the controls
			CGRect contentRect = [cell.contentView bounds];
			CGRect frame = CGRectMake(contentRect.origin.x + 20.0, 5.0, 150, 30.0);
			label.frame = frame;
			
			frame = CGRectMake(contentRect.size.width - 110, 5.0, 94, 27.0);
			completedSwitch.frame= frame;
			
			//[label release];
			//[tomorrowSwitch release];
		}
		return cell;
	}
	
	// Delete Completed Cell
	if(section == 1 && row == 6){
		
		deleteCompletedCell.label.text = NSLocalizedString( @"Delete Completed Tasks", @"");
		return deleteCompletedCell;
	}
	
	// Sort Order Cell
	if(section == 1 && row == 7){
		sortOrderCell.label.text = NSLocalizedString( @"Sort Order", @"");
		return sortOrderCell;
	}
	
	// Show Date Group Cell
	if(section == 1 && row == 8){
		// Pull the cell
		UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"showdategroup-cell"];
		
		// If there's a new cell needed, add a custom switch
		if (cell == nil) {
			
			cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:@"showdategroup-cell"] autorelease];
			cell.indentationLevel = 5;
			
			// cell's  label
			UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
			label.backgroundColor = [UIColor clearColor];
			label.opaque = NO;
			label.textColor = [UIColor blackColor];
			label.highlightedTextColor = [UIColor whiteColor];
			label.font = [UIFont boldSystemFontOfSize:14.0];
			label.text = NSLocalizedString( @"Show Date Group Headers", @"");
			[cell addSubview:label];
			
			// cell's custom switch we hold on to this
			[cell addSubview:showdategroupSwitch];
			
			// layout the controls
			CGRect contentRect = [cell.contentView bounds];
			CGRect frame = CGRectMake(contentRect.origin.x + 20.0, 5.0, 150, 30.0);
			label.frame = frame;
			
			frame = CGRectMake(contentRect.size.width - 110, 5.0, 94, 27.0);
			showdategroupSwitch.frame= frame;
			
			//[label release];
			//[tomorrowSwitch release];
		}
		return cell;
	}
	
	TitleCell *cell = (TitleCell *)[tableView dequeueReusableCellWithIdentifier:@"title-cell"];
	
	if (cell == nil) {
		// Create a new cell. CGRectZero allows the cell to determine the appropriate size.
		cell = (TitleCell *)[[[TitleCell alloc] initWithFrame:CGRectZero reuseIdentifier:@"title-cell"] autorelease];
	}	return cell;
}

//
//
//

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	// Recover section and row info
	NSInteger row = [indexPath row];
	NSInteger section = [indexPath section];
	
	//Due Date
	if(section == 0 && row == 0){
		
		//DefaultDueDateListController *controller = [[DefaultDueDateListController alloc] initWithNibName:@"PreferencesView" bundle:nil];
		[self prefssave];
		DefaultDueDateListController *controller = [[DefaultDueDateListController alloc] initWithNibName:@"DueDateListView" bundle:nil];
		controller.defaultDueDateName = dueDateCell.value.text;
		self.selectedIndexPath = indexPath;
		[self.navigationController pushViewController:controller animated:YES];
		[self viewWillAppear:YES];
	}
	
	//Delete Completed
	if(section == 1 && row == 6){
		[self prefssave];
		DeleteCompletedTasksListController *controller = [[DeleteCompletedTasksListController alloc] initWithNibName:@"DeleteCompletedTasksListView" bundle:nil];
		controller.deleteCompletedTasksName = deleteCompletedCell.value.text;
		self.selectedIndexPath = indexPath;
		[self.navigationController pushViewController:controller animated:YES];
		[controller release];
	}

	//Sort Order
	if(section == 1 && row == 7){
		[self prefssave];
		SortOrderListController *controller = [[SortOrderListController alloc] initWithNibName:@"SortOrderListView" bundle:nil];
		controller.sortOrderName = sortOrderCell.value.text;
		self.selectedIndexPath = indexPath;
		[self.navigationController pushViewController:controller animated:YES];
		[controller release];
	}
}

//
//
//

- (void) switchChanged: (UIControl *) sender
{
	UISwitch *mySwitch = (UISwitch*)sender;
	
	if(mySwitch == completedSwitch){
		// user edited the completion date
		if(mySwitch.on){
			showCompletedTasks = TRUE;
		}else{
			showCompletedTasks = FALSE;
		}
	}
	
	if(mySwitch == overdueSwitch){
		// user edited the completion date
		if(mySwitch.on){
			showOverdueTasks = TRUE;
		}else{
			showOverdueTasks = FALSE;
		}
	}
	
	if(mySwitch == todaySwitch){
		// user edited the completion date
		if(mySwitch.on){
			showTodaysTasks = TRUE;
		}else{
			showTodaysTasks = FALSE;
		}
	}
	
	if(mySwitch == tomorrowSwitch){
		// user edited the completion date
		if(mySwitch.on){
			showTomorrowsTasks = TRUE;
		}else{
			showTomorrowsTasks = FALSE;
		}
	}
	
	if(mySwitch == futureSwitch){
		// user edited the completion date
		if(mySwitch.on){
			showFutureTasks = TRUE;
		}else{
			showFutureTasks = FALSE;
		}
	}
	
	if(mySwitch == noDueDateSwitch){
		// user edited the completion date
		if(mySwitch.on){
			showNoDueDateTasks = TRUE;
		}else{
			showNoDueDateTasks = FALSE;
		}
	}
	
	if(mySwitch == showdategroupSwitch){
		// user edited the completion date
		if(mySwitch.on){
			showDateGroupTasks = TRUE;
		}else{
			showDateGroupTasks = FALSE;
		}
	}
}

//
// This modifies the priority
//

- (void) segmentControlChanged: (UIControl *) sender
{
	UISegmentedControl *mySegmentedControl = (UISegmentedControl*)sender;
	
	if(mySegmentedControl == priorityCell.segmentedControlView){
		// user edited the priority
		if( [mySegmentedControl selectedSegmentIndex] == 0 )
			defaultPriority = [[NSNumber alloc] initWithInt:[mySegmentedControl selectedSegmentIndex]];
	}
	
/*	
	switch ([mySegmentedControl selectedSegmentIndex])
	{
		case 0: 
			dateOffset = PriorityHigh;
			break;
		case 1: 
			dateOffset = PriorityMedium;
			break;
		case 2: 
			dateOffset = PriorityLow;
			break;
		case 3:
			dateOffset = PriorityLow;
			break;
	}
 */
	// [defaultPriority release];
}

//
//
//

- (UITableViewCellAccessoryType)tableView:(UITableView *)tableView accessoryTypeForRowWithIndexPath:(NSIndexPath *)indexPath {
	
	NSInteger section = [indexPath section];
	NSInteger row = [indexPath row];
	
	if(section == 0 && row == 0){
		return UITableViewCellAccessoryDisclosureIndicator;
	}
	
	// This is for select Boxes
	if(section == 0 || section == 2){
		return UITableViewCellAccessoryNone;
	}
	// This is for extended text lookups
	if(section == 1 && row == 6){
		return UITableViewCellAccessoryDisclosureIndicator;
	}
	
	if(section == 1 && row == 7){
		return UITableViewCellAccessoryDisclosureIndicator;
	}
	
	return  UITableViewCellAccessoryNone;
}

@end
