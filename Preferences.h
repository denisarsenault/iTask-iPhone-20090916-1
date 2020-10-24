//
//  Preferences.h
//  iPreferences-iPhone
//
//  Created by Denis Arsenault on 12/10/08.
//  Copyright 2008 Mybrightzone. All rights reserved.
// 
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

#import "Alarm.h"


@interface Preferences : NSObject {
	
	//  Attributes.
	NSInteger pdateOffset;
	NSDate	 *pdefaultDueDate;
	NSNumber *pdefaultPriority;
	
	Boolean	 pshowOverdueTasks;
	Boolean	 pshowTodaysTasks;
	Boolean	 pshowTomorrowsTasks;
	Boolean	 pshowFutureTasks;
	Boolean	 pshowNoDueDateTasks;
	Boolean	 pshowCompletedTasks;
	NSString *pdeleteCompletedTasks;
	NSString *psortOrderTasks;
	NSString *pdefaultDueDateName;

}

// Property exposure for primary key and other attributes. The primary key is 'assign' because it is not an object, 
// nonatomic because there is no need for concurrent access, and readonly because it cannot be changed without 
// corrupting the database.

// The remaining attributes are copied rather than retained because they are value objects.
@property (nonatomic, assign) NSInteger pdateOffset;
@property (nonatomic, retain) NSDate	*pdefaultDueDate;
@property (nonatomic, retain) NSNumber *pdefaultPriority;
@property (nonatomic, assign) Boolean	pshowOverdueTasks;
@property (nonatomic, assign) Boolean	 pshowTodaysTasks;
@property (nonatomic, assign) Boolean	 pshowTomorrowsTasks;
@property (nonatomic, assign) Boolean	 pshowFutureTasks;
@property (nonatomic, assign) Boolean	 pshowNoDueDateTasks;
@property (nonatomic, assign) Boolean	 pshowCompletedTasks;
@property (nonatomic, retain) NSString *pdeleteCompletedTasks;
@property (nonatomic, retain) NSString *psortOrderTasks;
@property (nonatomic, retain) NSString *pdefaultDueDateName;

// Creates new task object with default settings
- (id) initWithDueDate:(NSDate*)aDueDate; 
@end
