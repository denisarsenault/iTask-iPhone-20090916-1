//
//  TaskViewController.h
//  iTask-iPhone
//
//  Created by Denis Arsenault on 12/5/08.
//  Copyright 2008 Mybrightzone. All rights reserved. 
//

#import <UIKit/UIKit.h>

@class Preferences, Task, TitleCell, LabelValueCell, SegmentedControlCell, DateFieldCell, PreferencesViewController, TextViewCell, CustomUISwitch, AlarmCell;

@interface PreferencesViewController : UITableViewController <UITextFieldDelegate, UITextViewDelegate, UIActionSheetDelegate >{
	Task  *task;
	Preferences *preferences;
	
	// This is for the sections array
	
	NSMutableArray *sectionArray;
	int			   fullCount;
	
	// Do we still need both of these?
	
	NSArray		*defaultDueDateNames;
	NSArray		*deleteCompletedTasksNames;
	NSArray		*sortOrderNames;
	NSDateFormatter *dateFormatter;
    NSIndexPath *selectedIndexPath;

	
	// Cells for Form like editing
	TitleCell	*titleCell;
	TitleCell	*titleCell2;
	
	CustomUISwitch	*overdueSwitch;
	CustomUISwitch	*todaySwitch;
	CustomUISwitch	*tomorrowSwitch;
	CustomUISwitch	*futureSwitch;
	CustomUISwitch	*noDueDateSwitch;
	CustomUISwitch	*completedSwitch;
	CustomUISwitch	*showdategroupSwitch;
	SegmentedControlCell	*priorityCell;
	LabelValueCell	*deleteCompletedCell;
	LabelValueCell	*sortOrderCell;
	LabelValueCell	*dueDateCell;
	
	NSMutableArray  *alarmCells;
	
	LabelValueCell	*calendarCell;
	LabelValueCell	*urlCell;
	TextViewCell	*notesCell;
	
	UIButton		*deleteButton;
	
	NSIndexPath*    noteIndexPath;
	NSInteger		numRows;
	NSInteger		delRow;
	NSString		*dueDate;
	
	// user preferences
	
	NSInteger dateOffset;
	NSInteger priorityOffset;
	NSDate	 *defaultDueDate;
	NSNumber *defaultPriority;
	
	Boolean	 showOverdueTasks;
	Boolean	 showTodaysTasks;
	Boolean	 showTomorrowsTasks;
	Boolean	 showFutureTasks;
	Boolean	 showNoDueDateTasks;
	Boolean	 showCompletedTasks;
	NSNumber *deleteCompletedTasks;
	NSNumber *sortOrderTasks;
	Boolean  showDateGroupTasks;
	
}

//- (IBAction)save:(id)sender;
- (void)dialogOKCancelAction;
- (void)readPreferences;
- (void)keyboardDidShow:(NSNotification *)notif;
- (void)keyboardDidHide:(NSNotification *)notif;
//- (void) readPreferences;

//- (void)delete: (id) sender;

// Expose the task property to other objects (the PreferencesViewController).
@property (nonatomic, assign) Task *task;
@property (nonatomic, assign) Preferences *preferences;
@property (nonatomic, assign) NSInteger		numRows;
@property (nonatomic, assign) NSInteger	    delRow ;
@property (nonatomic, retain) NSDateFormatter *dateFormatter;
@property (nonatomic, retain) NSIndexPath *selectedIndexPath;
@property (nonatomic, retain) NSDate* defaultDueDate;
@property (nonatomic, retain) NSNumber *defaultPriority;
@property (nonatomic, assign) Boolean	showOverdueTasks;
@property (nonatomic, assign) Boolean	showTodaysTasks;
@property (nonatomic, assign) Boolean	showTomorrowsTasks;
@property (nonatomic, assign) Boolean	showFutureTasks;
@property (nonatomic, assign) Boolean	showNoDueDateTasks;
@property (nonatomic, assign) Boolean	showCompletedTasks;
@property (nonatomic, assign) NSNumber *deleteCompletedTasks;
@property (nonatomic, assign) NSNumber *sortOrderTasks;
@property (nonatomic, assign) Boolean	showDateGroupTasks;
@property (nonatomic, retain) NSArray  *defaultDueDateNames;
@property (nonatomic, retain) NSArray	*deleteCompletedTasksNames;
@property (nonatomic, retain) NSArray	*sortOrderNames;
@property (nonatomic, assign) NSString	*dueDate;
@property (nonatomic, assign) NSInteger	dateOffset;
@property (nonatomic, assign) NSInteger priorityOffset;
@property (nonatomic, assign) LabelValueCell	*deleteCompletedCell;
@property (nonatomic, assign) LabelValueCell	*sortOrderCell;
@property (nonatomic, assign) LabelValueCell	*dueDateCell;


@end
