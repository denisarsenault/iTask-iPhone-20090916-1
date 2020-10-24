//
//  Preferences.m
//  iTask-iPhone
//
//  Created by Denis Arsenault on 12/10/08.
//  Copyright 2008 Mybrightzone. All rights reserved.
//  
//

#import "Preferences.h"
#import "Alarm.h"

// Static variables for compiled SQL queries. This implementation choice is to be able to share a one time
// compilation of each query across all instances of the class. Each time a query is used, variables may be bound
// to it, it will be "stepped", and then reset for the next usage. When the application begins to terminate,
// a class method will be invoked to "finalize" (delete) the compiled queries - this must happen before the database
// can be closed.

@implementation Preferences

@synthesize pdateOffset, pdefaultDueDate, pdefaultPriority, pshowOverdueTasks, pdefaultDueDateName,
pshowTodaysTasks, pshowTomorrowsTasks, pshowFutureTasks, pshowNoDueDateTasks, pshowCompletedTasks, pdeleteCompletedTasks, psortOrderTasks;

- (void) dealloc {

	[super dealloc];

}

//
//
//
//
//
//
- (id) initWithDueDate:(NSDate*)aDueDate
{
	self = [super init];
	if (self != nil) 
	{
		self.pdateOffset = 0;
		self.pdefaultDueDate = aDueDate;
		self.pdefaultPriority = 0;
		self.pshowOverdueTasks = 0;
		self.pdefaultDueDateName = @"";
		self.pshowTodaysTasks = 0;
		self.pshowTomorrowsTasks = 0;
		self.pshowFutureTasks = 0;
		self.pshowNoDueDateTasks = 0;
		self.pshowCompletedTasks = 0;
		self.pdeleteCompletedTasks = @"";
		self.psortOrderTasks = @"";
		
	}
	return self;
}
@end
