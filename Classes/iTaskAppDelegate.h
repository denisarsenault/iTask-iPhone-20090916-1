//
//  iTask_iPhoneAppDelegate.h
//  iTask-iPhone
//
//  Created by Denis Arsenault on 12/4/08.
//  Copyright 2008 Mybrightzone. All rights reserved.
//  
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>

@class Task, InfoViewController, PreferencesViewController, DefaultDueDateListController ;

@interface iTaskAppDelegate : NSObject <UIApplicationDelegate> {
    
    UIWindow *window;
    UINavigationController *navigationController;
	UINavigationController *addNavigationController;
	
	PreferencesViewController *preferencesViewController;
	InfoViewController *infoViewController;
	
	// Opaque reference to the SQLite database.
    sqlite3 *database;
	
	//To hold a list of all Task objects
	NSMutableArray *tasks;
	
	//To hold a Array of dictionary  objects wrapped around filteres task arrays
	NSMutableArray *tasksArray;
	
	//To hold a Array of all Alarm Objects
	NSMutableArray* alarms;
	
	//To hold a Array of all Calendar Objects
	NSArray *calendarNames;
	NSArray *defaultDueDateNames;
	
	// user preferences
	NSDate	 *defaultDueDate;
	NSNumber *defaultPriority;
	NSNumber *dueDateNumber;
	
	Boolean	 showOverdueTasks;
	Boolean	 showTodaysTasks;
	Boolean	 showTomorrowsTasks;
	Boolean	 showFutureTasks;
	Boolean	 showNoDueDateTasks;
	Boolean	 showCompletedTasks;
	NSNumber *deleteCompletedTasks;
	NSNumber *sortOrderTasks;
	Boolean	 showTableHeaders;
	
	UIAccelerationValue		accel[3];
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UINavigationController *navigationController;
@property (nonatomic, retain) UINavigationController *addNavigationController;
@property (nonatomic, retain) PreferencesViewController *preferencesViewController;

@property (nonatomic, retain) NSMutableArray *tasks;
@property (nonatomic, retain) NSMutableArray *tasksArray;

@property (nonatomic, retain) NSArray *calendarNames;
@property (nonatomic, retain) NSArray *defaultDueDateNames;




// These are the preference default values
@property (nonatomic, retain) NSDate* defaultDueDate;
@property (nonatomic, retain) NSNumber *defaultPriority;
@property (nonatomic, assign) Boolean	showOverdueTasks;
@property (nonatomic, assign) Boolean	showTodaysTasks;
@property (nonatomic, assign) Boolean	showTomorrowsTasks;
@property (nonatomic, assign) Boolean	showFutureTasks;
@property (nonatomic, assign) Boolean	showNoDueDateTasks;
@property (nonatomic, assign) Boolean	showCompletedTasks;
@property (nonatomic, assign) NSNumber*	deleteCompletedTasks;
@property (nonatomic, assign) NSNumber*	sortOrderTasks;
@property (nonatomic, assign) Boolean	showTableHeaders;
@property (nonatomic, retain) NSNumber *dueDateNumber;

#pragma mark -
#pragma mark Singleton Methods

+ (id) sharedAppDelegate;

#pragma mark -
#pragma mark Allocation/Deallocation

- (id) init;
- (void) readPreferences;

#pragma mark -

- (void) loadData;
- (void) showTaskList:(UIViewController*) previousView;

// Create the dictionary used for display of the tasks
- (void) updateTaskList;

// Retrieve all objects from the database
- (NSArray *)overdueTasks;
- (NSArray *)todaysTasks;
- (NSArray *)tomorrowsTasks;
- (NSArray *)futureTasks;
- (NSArray *)noDueDateTasks;
- (NSArray *)completedTasks;

// Removes a task from the array of tasks, and also deletes it from the database. There is no undo.
- (IBAction)removeTask:(Task *)task;

// Creates a new task object with default data. 
- (void)addTask:(Task *)task;

// Completed a task, update the list of tasks
- (void)completedTask:(Task *)task;

- (IBAction)info:(id)sender;
- (void) unloadInfo;

- (NSString*)calDisplayFromUID:(NSString *)uid;

@end

