//
//  iTask_iPhoneAppDelegate.m
//  iTask-iPhone
//
//  Created by Denis Arsenault
//  1/02/2009 DLA Identified delay in drawing screen fixed
//  1/13/2009 DLA Modified Memory Management
//  1/24/2009 DLA Fixed Preferences issues and re-assigned Tasks attributes correctly

#import "iTaskAppDelegate.h"
#import "TaskListViewController.h"
#import "PreferencesViewController.h"
#import "InfoViewController.h"
#import "Task.h"
#import "constants.h"
#import "Alarm.h"
#import "CalendarName.h"
#import "iTaskSyncContacts.h"
#import "ItaskStrings.h"

NSString *kDueDateKey					= @"dueDateKey";
NSString *kPriorityKey					= @"priorityKey";
//NSString *kDefaultCalendarKey			= @"defaultCalendarKey"; TBD later
NSString *kShowOverdueTasksKey			= @"showOverdueTasksKey";
NSString *kShowTodaysTasksKey			= @"showTodaysTasksKey";
NSString *kShowTomorrowsTasksKey		= @"showTomorrowsTasksKey";
NSString *kShowFutureTasksKey			= @"showFutureTasksKey";
NSString *kShowNoDueDateTasksKey		= @"showNoDueDateTasksKey";
NSString *kShowCompletedTasksKey		= @"showCompletedTasksKey";
NSString *kDeleteCompletedTasksAfterKey	= @"deleteCompletedTasksAfterKey";
NSString *kSortOrderKey					= @"sortOrderKey";
NSString *kShowDateGroupHeadingsKey		= @"showDateGroupHeadingsKey";

//
// Private interface for AppDelegate - internal only methods.
//

@interface iTaskAppDelegate (Private)
- (void)createEditableCopyOfDatabaseIfNeeded;
- (void)initializeDatabase;
@end

@implementation iTaskAppDelegate

static iTaskAppDelegate* sSharedAppDelegate = nil;

@synthesize window;
@synthesize navigationController;
@synthesize addNavigationController;
@synthesize preferencesViewController;
@synthesize tasks;
@synthesize tasksArray;
@synthesize calendarNames;
@synthesize defaultDueDate;
@synthesize defaultPriority;
@synthesize showOverdueTasks;
@synthesize showTodaysTasks;
@synthesize showTomorrowsTasks;
@synthesize showFutureTasks;
@synthesize showNoDueDateTasks;
@synthesize showCompletedTasks;
@synthesize	deleteCompletedTasks;
@synthesize sortOrderTasks;
@synthesize showTableHeaders;
@synthesize defaultDueDateNames;
@synthesize dueDateNumber;

#pragma mark -
#pragma mark Singleton Methods

//
//
//

+ (id) sharedAppDelegate
{
	return sSharedAppDelegate;
}

#pragma mark -
#pragma mark Allocation/Deallocation

//
// The init routine
//

- (id) init
{
	self = [super init];
	if ( self != nil )
	{
		sSharedAppDelegate = self;
	}
	return self;
}

#pragma mark -

//
// Every good appllication needs one
//

- (void)applicationDidFinishLaunching:(UIApplication *)application {
	
	
	// Configure and show the window
	[window addSubview:[navigationController view]];
	[window makeKeyAndVisible];
	
	// Override point for customization after app launch	
	iTaskAppDelegate *appDelegate = (iTaskAppDelegate *)[[UIApplication sharedApplication] delegate];
	[appDelegate loadData];	
	
	// Load tasks list initially
	[self performSelector:@selector(showTaskList:)
			   withObject:navigationController 
			   afterDelay:0.0];
	
}

//
// Checked out
//

- (void) showTaskList:(UIViewController*) previousView
{
	iTaskSyncContacts* addressSyncContacts = [[iTaskSyncContacts alloc] init];
	
	// get the calendars and store locally
	[addressSyncContacts getAddressBooks];	
	calendarNames  = [addressSyncContacts.calendarNames copy];
	//calendarNames = nil;
	
	[addressSyncContacts checkForModifiedTasksFromAddressBook];
	
}

//
// loading data
//

- (void) loadData{
	
	// Read in the application preferences
	[self readPreferences];
	
	// so we need to create a copy of it in the application's Documents directory.     
    [self createEditableCopyOfDatabaseIfNeeded];
	
    // Call internal method to initialize database connection
    [self initializeDatabase];

}

//
// Get the preferences
//

- (void) readPreferences{
	
	NSString *testValue = [[NSUserDefaults standardUserDefaults] stringForKey:kDueDateKey];
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
		Boolean	 showFutureTaskseDefault;
		Boolean	 showNoDueDateDefault;
		Boolean	 showCompletedTasksDefault;
		
		Boolean	 showDateGroupHeadersDefault;
		
		NSDictionary *prefItem;
		

			for (prefItem in prefSpecifierArray)
			{
				NSString *keyValueStr = [prefItem objectForKey:@"Key"];
				if ([keyValueStr isEqualToString:kDueDateKey])
				{
					dueDateDefault =[prefItem objectForKey:@"DefaultValue"];
				}
				else if ([keyValueStr isEqualToString:kPriorityKey])
				{
					priorityDefault = [prefItem objectForKey:@"DefaultValue"];
				}
				else if ([keyValueStr isEqualToString:kShowOverdueTasksKey])
				{
					showOverdueTasksDefault = [[prefItem valueForKey:@"DefaultValue"] boolValue];
				}
				else if ([keyValueStr isEqualToString:kShowTodaysTasksKey])
				{
					showTodaysTasksDefault = [[prefItem valueForKey:@"DefaultValue"] boolValue];
				}
				else if ([keyValueStr isEqualToString:kShowTomorrowsTasksKey])
				{
					showTomorrowsTasksDefault = [[prefItem valueForKey:@"DefaultValue"] boolValue];
				}
				else if ([keyValueStr isEqualToString:kShowFutureTasksKey])
				{
					showFutureTaskseDefault = [[prefItem valueForKey:@"DefaultValue"] boolValue];
				}
				else if ([keyValueStr isEqualToString:kShowNoDueDateTasksKey])
				{
					showNoDueDateDefault = [[prefItem valueForKey:@"DefaultValue"] boolValue];
				}
				else if ([keyValueStr isEqualToString:kShowCompletedTasksKey])
				{
					showCompletedTasksDefault = [[prefItem valueForKey:@"DefaultValue"] boolValue];
				}
				else if ([keyValueStr isEqualToString:kShowDateGroupHeadingsKey])
				{
				showDateGroupHeadersDefault = [[prefItem valueForKey:@"DefaultValue"] boolValue];
				}
			}


		// since no default values have been set (i.e. no preferences file created), create it here
		NSDictionary *appDefaults =  [NSDictionary dictionaryWithObjectsAndKeys:
									  [NSNumber numberWithInt:1], kDueDateKey,
									  [NSNumber numberWithInt:1], kPriorityKey,
									  [NSNumber numberWithBool:YES], kShowOverdueTasksKey,
									  [NSNumber numberWithBool:YES], kShowTodaysTasksKey,
									  [NSNumber numberWithBool:YES], kShowTomorrowsTasksKey,
									  [NSNumber numberWithBool:YES], kShowFutureTasksKey,
									  [NSNumber numberWithBool:YES], kShowNoDueDateTasksKey,
									  [NSNumber numberWithBool:YES], kShowCompletedTasksKey,
									  [NSNumber numberWithBool:YES], kShowDateGroupHeadingsKey,
									  nil];
		
		[[NSUserDefaults standardUserDefaults] registerDefaults:appDefaults];
		[[NSUserDefaults standardUserDefaults] synchronize];
		}
	// we're ready to do, so lastly set the key preference values
	// read in the default dueDate offset.
	
	NSInteger dateOffset = [[NSUserDefaults standardUserDefaults] integerForKey:kDueDateKey];
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
	
	int	intPriority  = [[NSUserDefaults standardUserDefaults] integerForKey:kPriorityKey];
	
	self.defaultPriority = [NSNumber numberWithInt:intPriority];
	
	self.showOverdueTasks= [[NSUserDefaults standardUserDefaults] boolForKey:kShowOverdueTasksKey];
	self.showTodaysTasks= [[NSUserDefaults standardUserDefaults] boolForKey:kShowTodaysTasksKey];
	self.showTomorrowsTasks= [[NSUserDefaults standardUserDefaults] boolForKey:kShowTomorrowsTasksKey];
	self.showFutureTasks= [[NSUserDefaults standardUserDefaults] boolForKey:kShowFutureTasksKey];
	self.showNoDueDateTasks= [[NSUserDefaults standardUserDefaults] boolForKey:kShowNoDueDateTasksKey];
	self.showCompletedTasks= [[NSUserDefaults standardUserDefaults] boolForKey:kShowCompletedTasksKey];	
	self.showTableHeaders = [[NSUserDefaults standardUserDefaults] boolForKey:kShowDateGroupHeadingsKey];

}

//
// Check for memory bad thing
//

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    NSLog(@" Main Memory Warning!!!");
	// "dehydrate" all data objects - flushes changes back to the database, removes objects from memory
 //   [tasks makeObjectsPerformSelector:@selector(udpateInDatabase)];
	
}

//
//
//

- (void)dealloc {
	[navigationController release];
	[PreferencesViewController release];

	[window release];
	[tasks release];
	[super dealloc];
}

//
// Creates a writable copy of the bundled default database in the application Documents directory.
//

- (void)createEditableCopyOfDatabaseIfNeeded {
    // First, test for existence.
    BOOL success;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *writableDBPath = [documentsDirectory stringByAppendingPathComponent:@"iTask.db"];
    success = [fileManager fileExistsAtPath:writableDBPath];
    if (success) return;
    // The writable database does not exist, so copy the default to the appropriate location.
    NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"iTask.db"];
    success = [fileManager copyItemAtPath:defaultDBPath toPath:writableDBPath error:&error];
    if (!success) {
        NSAssert1(0, @"Failed to create writable database file with message '%@'.", [error localizedDescription]);
    }
}

//
// This is the location of the local database store
// Open the database connection and retrieve minimal information for all objects.
//

- (void)initializeDatabase {
    NSMutableArray *taskArray = [[NSMutableArray alloc] init];
    self.tasks = taskArray;
    [taskArray release];
	
	// what should we do with Alarms here????
	
    // The database is stored in the application bundle. 
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"iTask.db"];
    // Open the database. The database was prepared outside the application.
    if (sqlite3_open([path UTF8String], &database) == SQLITE_OK) {
		// 
        // Get the primary key for all Tasks.
		//
        const char *sql = "SELECT taskID FROM tasks";
        sqlite3_stmt *statement;
        // Preparing a statement compiles the SQL query into a byte-code program in the SQLite library.
        // The third parameter is either the length of the SQL string or -1 to read up to the first null terminator.        
        if (sqlite3_prepare_v2(database, sql, -1, &statement, NULL) == SQLITE_OK) {
            // We "step" through the results - once for each row.
            while (sqlite3_step(statement) == SQLITE_ROW) {
                // The second parameter indicates the column index into the result set.
                int taskID = sqlite3_column_int(statement, 0);
                // We avoid the alloc-init-autorelease pattern here because we are in a tight loop and
                // autorelease is slightly more expensive than release. This design choice has nothing to do with
                // actual memory management - at the end of this block of code, all the task objects allocated
                // here will be in memory regardless of whether we use autorelease or release, because they are
                // retained by the tasks array.
				// DLA
                Task *task = [[[Task alloc] initWithPrimaryKey:taskID database:database] autorelease];
                [tasks addObject:task];
				// DLA
				//[task release];

            }
        }
		
		// "Finalize" the statement - releases the resources associated with the statement.
        sqlite3_finalize(statement);
		
	} else {
        // Even though the open failed, call close to properly clean up resources.
        sqlite3_close(database);
        NSAssert1(0, @"Failed to open database with message '%s'.", sqlite3_errmsg(database));
        // Additional error handling, as appropriate...
    }
	
	[self updateTaskList];

}

//
// This is where the tasks list gets updated
//

- (void) updateTaskList{
	
	if(tasksArray){
		// DLA
		[tasksArray release];
		tasksArray = nil;
	}
	
	NSMutableArray* newTaskList = [[NSMutableArray alloc] init];
	self.tasksArray = newTaskList;
	//DLA
	[newTaskList release];
	NSInteger displayTasks = 0;
	if(showOverdueTasks){
		NSArray* overdueTasksArray = [self overdueTasks];
		displayTasks = 1;
		[tasksArray addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:
							  NSLocalizedString( @"Overdue", @""), @"Heading",
							  overdueTasksArray, @"Data",
							  nil]];

	}
	
	if(showTodaysTasks){
		NSArray* todaysTasksArray = [self todaysTasks];
		displayTasks = 1;
		[tasksArray addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:
							   NSLocalizedString( @"Today", @""), @"Heading",
							   todaysTasksArray, @"Data",
							   nil]];

	}
	
	if(showTomorrowsTasks){
		NSArray* tomorrowsTasksArray = [self tomorrowsTasks];
		displayTasks = 1;
		[tasksArray addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:
							   NSLocalizedString( @"Tomorrow", @""), @"Heading",
							   tomorrowsTasksArray, @"Data",
							   nil]];

	}
	
	if(showFutureTasks){
		
		NSArray* futureTasksArray = [self futureTasks];
		displayTasks = 1;
		[tasksArray addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:
							   NSLocalizedString( @"Future", @""), @"Heading",
							   futureTasksArray, @"Data",
							   nil]];

	}
	
	if(showNoDueDateTasks){
		NSArray* noDueDateTasksArray = [self noDueDateTasks];
		displayTasks = 1;
		[tasksArray addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:
							   NSLocalizedString( @"No Due Date", @""), @"Heading",
							   noDueDateTasksArray, @"Data",
							   nil]];

	}
	
	if(showCompletedTasks){
		NSArray* completedTasksArray = [self completedTasks];
		displayTasks = 1;
		[tasksArray addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:
							   NSLocalizedString( @"Completed", @""), @"Heading",
							   completedTasksArray, @"Data",
							   nil]];
	}
		
	if (displayTasks == 0){
		NSArray* todaysTasksArray = [self todaysTasks];
		displayTasks = 1;
		[tasksArray addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:
							   NSLocalizedString( @"Today", @""), @"Heading",
							   todaysTasksArray, @"Data",
							   nil]];
	}
}

//
//
//

- (NSArray *)overdueTasks{
	NSDate *today = [NSDate date];
	NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
	unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit;
	NSDateComponents *todayComponents =[gregorian components:unitFlags fromDate:today];
	[todayComponents setHour:0];
	[todayComponents setMinute:0];
	[todayComponents setSecond:0];
	
	NSDate *referenceDate = [gregorian dateFromComponents:todayComponents];
	

	NSMutableArray *filteredArray = [[NSMutableArray alloc] init];
	unsigned int i;
	for (i = 0; i < [tasks count]; i++) {
		Task *task = [tasks objectAtIndex: i];
		NSDate *dueDate  = task.dueDate;
		
		if ([dueDate compare:referenceDate] == NSOrderedAscending && task.completionDate == nil ) {
			[filteredArray addObject:task];
		}
	}
	
	//NSLog(@"Overdue Tasks Array = %@", filteredArray);
	[gregorian release];
	return filteredArray;
	
}

//
//
//

- (NSArray *)todaysTasks{	
	NSDate *today = [NSDate date];
	NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
	unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit;
	NSDateComponents *todayComponents =[gregorian components:unitFlags fromDate:today];
	int todayMonth = [todayComponents month];
	int todayDay = [todayComponents day];
	int todayYear = [todayComponents year];
	[gregorian release];
	
	NSMutableArray *filteredArray = [[NSMutableArray alloc] init];
	unsigned int i;
	for (i = 0; i < [tasks count]; i++) {
		Task *task = [tasks objectAtIndex: i];
		NSDate *dueDate  = task.dueDate;
		
		NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
		NSDateComponents *dueDateComponents =[gregorian components:unitFlags fromDate:dueDate];
		int dueDateMonth = [dueDateComponents month];
		int dueDateDay = [dueDateComponents day];
		int dueDateYear = [dueDateComponents year];
		[gregorian release]; 
		
		if (dueDateMonth == todayMonth && dueDateDay == todayDay &&  dueDateYear == todayYear && task.completionDate == nil) {
			[filteredArray addObject:task];
		}
	}
	//NSLog(@"Todays Tasks Array = %@", filteredArray);
	return filteredArray;
	
}

//
//
//

- (NSArray *)tomorrowsTasks{
	
	NSTimeInterval secondsPerDay = 24 * 60 * 60;
	NSDate *tomorrow = [NSDate dateWithTimeIntervalSinceNow:secondsPerDay];
	
	NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
	unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit;
	NSDateComponents *tomorrowComponents =[gregorian components:unitFlags fromDate:tomorrow];
	int tomorrowMonth = [tomorrowComponents month];
	int tomorrowDay = [tomorrowComponents day];
	int tomorrowYear = [tomorrowComponents year];
	[gregorian release];
	
	
	NSMutableArray *filteredArray = [[NSMutableArray alloc] init];
	unsigned int i;
	for (i = 0; i < [tasks count]; i++) {
		Task *task = [tasks objectAtIndex: i];
		NSDate *dueDate  = task.dueDate;
		
		NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
		NSDateComponents *dueDateComponents =[gregorian components:unitFlags fromDate:dueDate];
		int dueDateMonth = [dueDateComponents month];
		int dueDateDay = [dueDateComponents day];
		int dueDateYear = [dueDateComponents year];
		[gregorian release];
		
		if (dueDateMonth == tomorrowMonth && dueDateDay == tomorrowDay &&  dueDateYear == tomorrowYear && task.completionDate == nil) {
			[filteredArray addObject:task];
		}
	}
	//NSLog(@"Tomorrows Tasks Array = %@", filteredArray);
	return filteredArray;
}

//
//
//

- (NSArray *)futureTasks{
	NSTimeInterval secondsPerDay = 24 * 60 * 60;
	NSDate *tomorrow = [NSDate dateWithTimeIntervalSinceNow:secondsPerDay];
	
	NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
	unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit;
	NSDateComponents *tomorrowComponents =[gregorian components:unitFlags fromDate:tomorrow];
	[tomorrowComponents setHour:23];
	[tomorrowComponents setMinute:59];
	[tomorrowComponents setSecond:59];
	
	NSDate *referenceDate = [gregorian dateFromComponents:tomorrowComponents];
	[gregorian release];
	
	
	NSMutableArray *filteredArray = [[NSMutableArray alloc] init];
	unsigned int i;
	for (i = 0; i < [tasks count]; i++) {
		Task *task = [tasks objectAtIndex: i];
		NSDate *dueDate  = task.dueDate;
		
		if ([dueDate compare:referenceDate] == NSOrderedDescending && task.completionDate == nil) {
			[filteredArray addObject:task];
		}
	}
	
	//NSLog(@"Future Tasks Array = %@", filteredArray);
	return filteredArray;
	
}

//
//
//

- (NSArray *)noDueDateTasks{
	NSMutableArray *filteredArray = [[NSMutableArray alloc] init];
	
	unsigned int i;
	for (i = 0; i < [tasks count]; i++) {
		Task *task = [tasks objectAtIndex: i];
		if (task.dueDate == nil && task.completionDate == nil) {
			[filteredArray addObject:task];
		}
	}
	
	//NSLog(@"No Due Date Tasks Array = %@", filteredArray);
	return filteredArray;
}

//
//
//

- (NSArray *)completedTasks{
	NSMutableArray *filteredArray = [[NSMutableArray alloc] init];
	
	unsigned int i;
	for (i = 0; i < [tasks count]; i++) {
		Task *task = [tasks objectAtIndex: i];
		if (task.completionDate != nil) {
			[filteredArray addObject:task];
		}
	}
	
	//NSLog(@"Completed Tasks Array = %@", filteredArray);
	return filteredArray;
}

//
// Save all changes to the database, then close it.
//

- (void)applicationWillTerminate:(UIApplication *)application {
    // Save changes.
//	[[iTaskSyncContacts sharedTaskSyncContacts] writeOutTasksToAddressBook];
    [tasks makeObjectsPerformSelector:@selector(updateInDatabase)];
	
    // Close the database.
    if (sqlite3_close(database) != SQLITE_OK) {
        NSAssert1(0, @"Error: failed to close database with message '%s'.", sqlite3_errmsg(database));
    }
	
	//Show overdue and today tasks via a badge.
	int badgeNum = [[self overdueTasks] count] + [[self todaysTasks] count];
	NSString* badgeStr;
	if(badgeNum > 0)
		badgeStr = [[NSString alloc] initWithFormat:@"%d", badgeNum];
	else
		badgeStr = @"";
	
	[[UIApplication sharedApplication] setApplicationIconBadgeNumber:badgeNum];
    [badgeStr release];
	//[UIApplication setApplicationBadge:badgeStr];
}

//
// Remove a specific task from the array of tasks and also from the database.
//

- (void)removeTask:(Task *)task {
    // Delete from the database first. The task knows how to do this (see Task.m)
    [task deleteFromDatabase];
	[tasks removeObject:task];
	[self updateTaskList];
}

//
// Insert a new task into the database and add it to the array of tasks.
//

- (void)addTask:(Task *)task {
    // Create a new record in the database and get its automatically generated primary key.
    [task insertIntoDatabase:database];
	[task setModified:YES];
	[tasks addObject:task];
    [self updateTaskList];
}

//
// Completed a  task, update the list of tasks
//

- (void)completedTask:(Task *)task{
	[self updateTaskList];
}


//
// Display the help screen.
//

//******************************************************************************************************
//
// Allocate the Preferences view Controller for Preferences
//
//******************************************************************************************************

- (IBAction)info:(id)sender {
	
    PreferencesViewController *controller = self.preferencesViewController;
	
	controller.numRows = 13;
	[self.navigationController pushViewController:controller animated:YES];
    [controller setEditing:NO animated:NO];
	
}

//******************************************************************************************************
//
// Allocate the Preferences view Controller for Preferences
//
//******************************************************************************************************

- (PreferencesViewController *)preferencesViewController {
    // Instantiate the task view controller if necessary.
    if (preferencesViewController == nil) {
        preferencesViewController = [[PreferencesViewController alloc] initWithNibName:@"PreferencesView" bundle:nil];
    }
	//[preferencesViewController autorelease];
    return preferencesViewController;
}

//
//
//

- (void) unloadInfo
{		
	if(infoViewController != nil) {
		
		[UIView beginAnimations:nil	context:NULL];
		[UIView setAnimationDuration:1.0];
		[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight
							   forView:window 
								 cache:YES];
		
		[[infoViewController view] removeFromSuperview];
		[window addSubview:navigationController.view];
		
		[UIView commitAnimations];
	}
}

//
//
//

- (NSString*)calDisplayFromUID:(NSString *)uid{
	for(CalendarName* cal in calendarNames)
	{
		if([cal.UID isEqualToString:uid])
			return cal.name;
	}
	return @"Default";
}

@end
