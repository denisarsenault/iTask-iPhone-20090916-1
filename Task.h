//
//  Task.h
//  iTask-iPhone
//
//  Created by Denis Arsenault on 12/10/08.
//  Copyright 2008 Mybrightzone. All rights reserved.
// 
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

#import "Alarm.h"

//enum dueDates
//{
//	dueDateNone = 1,
//	dueDateToday,
//	dueDateTomorrow,
//	dueDate3days,
//	dueDate7days,
//	dueDate30days
//};
//
//enum {
//	PriorityNone     = 0,
//	PriorityHigh     = 1,
//	PriorityMedium   = 5,
//	PriorityLow      = 9
//};

@interface Task : NSObject {
	
	// Opaque reference to the underlying database.
    sqlite3 *database;
	
	 // Primary key in the database.
	NSInteger	taskID;
	
	// Dehydrated Attributes.
	NSString	*title;
	NSDate		*dueDate;
	NSDate		*completionDate;
	NSNumber	*priority;
	NSString	*desktopID;
	NSString	*notes;
	NSString	*URL;
	NSString	*defaultDueDateName;
	NSString	*calendar;	
	
    // Dirty tracks whether there are in-memory changes to data which have no been written to the database.
    BOOL dirty;
	
	NSMutableArray* alarms;
	
	
	BOOL modified;	// We need something else to tell us that this task was modified and needs to be written out to the AddressBook, because the
					// dirty flag gets cleared when the task gets saved to the SQL DB
	
	//NSData *data;
}

// Property exposure for primary key and other attributes. The primary key is 'assign' because it is not an object, 
// nonatomic because there is no need for concurrent access, and readonly because it cannot be changed without 
// corrupting the database.
@property (assign, nonatomic, readonly) NSInteger taskID;


// The remaining attributes are copied rather than retained because they are value objects.
@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSDate *dueDate;
@property (nonatomic, retain) NSDate *completionDate;
@property (nonatomic, retain) NSNumber *priority;
@property (nonatomic, retain) NSString *desktopID;
@property (nonatomic, retain) NSString *notes;
@property (nonatomic, retain) NSString *URL;
@property (nonatomic, retain) NSString *defaultDueDateName;
@property (nonatomic, retain) NSString *calendar;

@property (nonatomic, retain) NSMutableArray* alarms;


// Creates new task object with default settings
- (id) initWithDueDate:(NSDate*)aDueDate  priority:(NSNumber*)aPriority; 

// Creates the object with primary key
- (id)initWithPrimaryKey:(NSInteger)pk database:(sqlite3 *)db;
- (void)initAlarms;


- (id) initWithDictionary:(NSDictionary*) dictionary;
- (void) updateTaskWithDictionary:(NSDictionary*) dictionary;

// Inserts the task into the database and stores its primary key.
- (void)insertIntoDatabase:(sqlite3 *)database;

// Update the task object in the database
- (void)updateInDatabase;
- (void)updateAlarms;

// Remove the task complete from the database. In memory deletion to follow...
- (void)deleteFromDatabase;
- (void)deleteAlarms;

// Flas to 
- (void) setDirty:(BOOL) isDirty;
- (BOOL) dirty;


// Alarm Management
- (void) addAlarm:(Alarm*) inAlaram;
- (void) removeAlarm:(Alarm*) inAlaram;


- (void) addAlarms:(NSDictionary*) ItaskDict;


- (void) updateAlarms:(NSDictionary*) ItaskDict;

#pragma mark -
- (void) setModified:(BOOL) isModified;
- (BOOL) modified;
- (void) clearModified;


- (NSMutableDictionary*) createTaskDictionary;

- (void) clearAlarmsModified;

@end
