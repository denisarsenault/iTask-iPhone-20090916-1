//
//  Task.m
//  iTask-iPhone
//
//  Created by Denis Arsenault on 12/10/08.
//  Copyright 2008 Mybrightzone. All rights reserved.
//  
//

#import "Task.h"
#import "Alarm.h"

// Static variables for compiled SQL queries. This implementation choice is to be able to share a one time
// compilation of each query across all instances of the class. Each time a query is used, variables may be bound
// to it, it will be "stepped", and then reset for the next usage. When the application begins to terminate,
// a class method will be invoked to "finalize" (delete) the compiled queries - this must happen before the database
// can be closed.

@implementation Task

@synthesize calendar;

- (void) dealloc {
	
	[alarms release];
	[title release];
	[dueDate release];
	[completionDate release];
	[priority release];
	[desktopID release];
	[notes release];
	[URL release];
//	[defaultDueDateName release];
	[calendar release];
	[super dealloc];

}

//
//
//

- (id) initWithDueDate:(NSDate*)aDueDate  priority:(NSNumber*)aPriority
{
	self = [super init];
	if (self != nil) 
	{
		if(aDueDate)
			self.dueDate = aDueDate;
		
		if(aPriority)
			self.priority = aPriority;
		else
			self.priority = 0;
		
		self.title = @"";
		self.desktopID = @"";
		self.notes = @"";
		self.URL = @"";
		self.calendar = @"default";
		
	}
	return self;
}

//
//
//

- (id) initWithDictionary:(NSDictionary*) dictionary
{
	self = [super init];
	if (self != nil) 
	{
		NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
		//NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init]  autorelease];
		[dateFormatter setDateFormat:@"MM/dd/yyyy"];
		
		self.title = [dictionary objectForKey:NSLocalizedString(@"TASK_TITLE", @"")];
		
		if ( ![[dictionary objectForKey:NSLocalizedString(@"TASK_DUE_DATE", @"")] isEqualToString:@""] )
			self.dueDate = [dateFormatter dateFromString:[dictionary objectForKey:NSLocalizedString(@"TASK_DUE_DATE", @"")]];
		
		if ( ![[dictionary objectForKey:NSLocalizedString(@"TASK_COMPLETED", @"")] isEqualToString:@""] )
			self.completionDate = [dateFormatter dateFromString:[dictionary objectForKey:NSLocalizedString(@"TASK_COMPLETED", @"")]];
		
		self.priority = [NSNumber numberWithInteger:[[dictionary objectForKey:NSLocalizedString(@"TASK_PRIORITY", @"")] integerValue]];
		self.desktopID = [dictionary objectForKey:NSLocalizedString(@"TASK_ICAL_UID", @"")];
		self.notes = [dictionary objectForKey:NSLocalizedString(@"TASK_NOTES", @"")];
		self.URL = [dictionary objectForKey:NSLocalizedString(@"TASK_URL", @"")];
		self.calendar = [dictionary objectForKey:NSLocalizedString(@"TASK_CALENDAR", @"")];	
		[dateFormatter release];
	}
	return self;
}

//
//
//

- (void) updateTaskWithDictionary:(NSDictionary*) dictionary
{
	NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init]  autorelease];
	[dateFormatter setDateFormat:@"MM/dd/yyyy"];
	
	self.title = [dictionary objectForKey:NSLocalizedString(@"TASK_TITLE", @"")];
	if ( ![[dictionary objectForKey:NSLocalizedString(@"TASK_DUE_DATE", @"")] isEqualToString:@""] )
		self.dueDate = [dateFormatter dateFromString:[dictionary objectForKey:NSLocalizedString(@"TASK_DUE_DATE", @"")]];
	
	if ( ![[dictionary objectForKey:NSLocalizedString(@"TASK_COMPLETED", @"")] isEqualToString:@""] )
		self.completionDate = [dateFormatter dateFromString:[dictionary objectForKey:NSLocalizedString(@"TASK_COMPLETED", @"")]];
	
	self.priority = [NSNumber numberWithInteger:[[dictionary objectForKey:NSLocalizedString(@"TASK_PRIORITY", @"")] integerValue]];
	self.notes = [dictionary objectForKey:NSLocalizedString(@"TASK_NOTES", @"")];
	self.URL = [dictionary objectForKey:NSLocalizedString(@"TASK_URL", @"")];
	self.calendar = [dictionary objectForKey:NSLocalizedString(@"TASK_CALENDAR", @"")];
	
	// now we need to do something with the Alarms ???
	[self updateAlarms:[dictionary objectForKey:NSLocalizedString(@"TASK_ALARMS", @"")]];

}

#pragma mark 
#pragma mark -
#pragma mark Database access

//
// Creates the object with primary key bring the tasks list information into memory.
//

- (id)initWithPrimaryKey:(NSInteger)pk database:(sqlite3 *)db {
    if (self = [super init]) {
        
		taskID = pk;
        database = db;
		
        // Compile the query for retrieving task data. See insertNewTaskIntoDatabase: for more detail.
		sqlite3_stmt *init_statement;
        const char *sql = "SELECT title, dueDate, completionDate, priority, desktopID, notes, URL, calendar FROM tasks WHERE taskID=?";
		if (sqlite3_prepare_v2(database, sql, -1, &init_statement, NULL) != SQLITE_OK) {
			NSAssert1(0, @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(database));
		}
       
        
		// Bind the primary key variable.
        sqlite3_bind_int(init_statement, 1, taskID);
		
		// Execute the query.
		int success =sqlite3_step(init_statement);
		
        if (success == SQLITE_ROW) {
			
			char*	dbStr;
			
			dbStr = (char *)sqlite3_column_text(init_statement, 0);
			if(dbStr)
				self.title = [NSString stringWithUTF8String:dbStr];
			
			NSNumber *dateNum = [NSNumber numberWithDouble:sqlite3_column_double(init_statement, 1)];
			if([dateNum intValue] != 0)
				self.dueDate = [NSDate dateWithTimeIntervalSince1970:[dateNum doubleValue]];
			
			dateNum = [NSNumber numberWithDouble:sqlite3_column_double(init_statement, 2)];
			if([dateNum intValue] != 0)
				self.completionDate = [NSDate dateWithTimeIntervalSince1970:[dateNum doubleValue]];
			
			self.priority = [NSNumber numberWithInt:sqlite3_column_double(init_statement, 3)];
			
			dbStr = (char *)sqlite3_column_text(init_statement, 4);
			if(dbStr)
				self.desktopID = [NSString stringWithUTF8String:dbStr];
			
			dbStr = (char *)sqlite3_column_text(init_statement, 5);
			if(dbStr)
				self.notes = [NSString stringWithUTF8String:dbStr];
			
			dbStr = (char *)sqlite3_column_text(init_statement, 6);
			if(dbStr)
				self.URL = [NSString stringWithUTF8String:dbStr];
			
			dbStr = (char *)sqlite3_column_text(init_statement, 7);
			if(dbStr)
				self.calendar = [NSString stringWithUTF8String:dbStr];

		} 
		
        sqlite3_finalize(init_statement);
		
		[self initAlarms];
		
        dirty = NO;
    }
    return self;
}

//
// Brings the alarms into memory. If already in memory, no action is taken (harmless no-op).
//
- (void)initAlarms {

	if(alarms){
		[alarms release];
		alarms = nil;
	}
	
	alarms = [[NSMutableArray alloc] init];
	
	sqlite3_stmt *hydrate_statement;
	const char *sql = "SELECT alarmID FROM alarms WHERE taskID = ?";
	if (sqlite3_prepare_v2(database, sql, -1, &hydrate_statement, NULL) != SQLITE_OK) {
		NSAssert1(0, @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(database));
	}
	
	// Bind the task ID variable.
	sqlite3_bind_int(hydrate_statement, 1, taskID);
	
	// We "step" through the results - once for each row.
	while (sqlite3_step(hydrate_statement) == SQLITE_ROW) 
	{
		int alarmID = sqlite3_column_int(hydrate_statement, 0);
		Alarm *alarm = [[Alarm alloc] initWithPrimaryKey:alarmID database:database];
		[alarms addObject:alarm];
		[alarm release];
		
	}
	 
    sqlite3_finalize(hydrate_statement);

}

//
//
// Update the task and an alarms in the db. Flush the alarms from memory.
//

- (void)updateInDatabase {
   
	if (dirty) {
        // Write any changes to the database.
        sqlite3_stmt *dehydrate_statement;
		const char *sql = "UPDATE tasks SET title=?, dueDate=?, completionDate=?, priority=?, desktopID=?, notes=?, URL=?, calendar=? WHERE taskID=?";
		if (sqlite3_prepare_v2(database, sql, -1, &dehydrate_statement, NULL) != SQLITE_OK) {
			NSAssert1(0, @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(database));
		}
        
		
		// Bind the query variables.
		int var = 1;
		if (title)
			sqlite3_bind_text(dehydrate_statement, var++, [title UTF8String], -1, SQLITE_TRANSIENT);
		else
			sqlite3_bind_null(dehydrate_statement, var++);
		
		if (dueDate)
			sqlite3_bind_double(dehydrate_statement, var++, [dueDate timeIntervalSince1970]);
		else
			sqlite3_bind_null(dehydrate_statement, var++);
		
		if (completionDate)
			sqlite3_bind_double(dehydrate_statement, var++, [completionDate timeIntervalSince1970]);
		else
			sqlite3_bind_null(dehydrate_statement, var++);
		
		if (priority)
			sqlite3_bind_int(dehydrate_statement, var++, [priority intValue]);
		else
			sqlite3_bind_null(dehydrate_statement, var++);
		
		if (desktopID)
			sqlite3_bind_text(dehydrate_statement, var++, [desktopID UTF8String], -1, SQLITE_TRANSIENT);
		else
			sqlite3_bind_null(dehydrate_statement, var++);
		
		if (notes)
			sqlite3_bind_text(dehydrate_statement, var++, [notes UTF8String], -1, SQLITE_TRANSIENT);
		else
			sqlite3_bind_null(dehydrate_statement, var++);
		
		if (URL)
			sqlite3_bind_text(dehydrate_statement, var++, [URL UTF8String], -1, SQLITE_TRANSIENT);
		else
			sqlite3_bind_null(dehydrate_statement, var++);
		
		if (calendar)
			sqlite3_bind_text(dehydrate_statement, var++, [calendar UTF8String], -1, SQLITE_TRANSIENT);
		else
			sqlite3_bind_null(dehydrate_statement, var++);
		
        sqlite3_bind_int(dehydrate_statement, var++, taskID);
		
        // Execute the query.
        int success = sqlite3_step(dehydrate_statement);
        
		
        sqlite3_finalize(dehydrate_statement);
		
        // Handle errors.
        if (success != SQLITE_DONE) {
            NSAssert1(0, @"Error: failed to dehydrate with message '%s'.", sqlite3_errmsg(database));
        }
        // Update the object state with respect to unwritten changes.
        dirty = NO;
    }
    
	// no more alarm updating!!!!!!!
	//	[self updateAlarms];

}

//
//
//
- (void) updateAlarms{
	
	for(Alarm* alarm in alarms)
	{
		[alarm updateInDatabase];
	}
}

//
// This inserts a record into the iPhone SQL Database
//
- (void)insertIntoDatabase:(sqlite3 *)db {
    database = db;
    
	sqlite3_stmt *insert_statement;
	char *sql = "INSERT INTO tasks (title, dueDate, completionDate, priority, desktopID, notes, URL, calendar) VALUES(?, ?, ?, ?, ?, ?, ?, ?)";
	if (sqlite3_prepare_v2(database, sql, -1, &insert_statement, NULL) != SQLITE_OK) {
		NSAssert1(0, @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(database));
	}
    
	// Bind the query variables.
	int var = 1;
	if (title)
		sqlite3_bind_text(insert_statement, var++, [title UTF8String], -1, SQLITE_TRANSIENT);
	else
		sqlite3_bind_null(insert_statement, var++);
	
	if (dueDate)
		sqlite3_bind_double(insert_statement, var++, [dueDate timeIntervalSince1970]);
	else
		sqlite3_bind_null(insert_statement, var++);
	
	if (completionDate)
		sqlite3_bind_double(insert_statement, var++, [completionDate timeIntervalSince1970]);
	else
		sqlite3_bind_null(insert_statement, var++);
	
	if (priority)
		sqlite3_bind_int(insert_statement, var++, [priority intValue]);
	else
		sqlite3_bind_null(insert_statement, var++);
	
	if (desktopID)
		sqlite3_bind_text(insert_statement, var++, [desktopID UTF8String], -1, SQLITE_TRANSIENT);
	else
		sqlite3_bind_null(insert_statement, var++);
	
	if (notes)
		sqlite3_bind_text(insert_statement, var++, [notes UTF8String], -1, SQLITE_TRANSIENT);
	else
		sqlite3_bind_null(insert_statement, var++);
	
	if (URL)
		sqlite3_bind_text(insert_statement, var++, [URL UTF8String], -1, SQLITE_TRANSIENT);
	else
		sqlite3_bind_null(insert_statement, var++);
	
	if (calendar)
		sqlite3_bind_text(insert_statement, var++, [calendar UTF8String], -1, SQLITE_TRANSIENT);
	else
		sqlite3_bind_null(insert_statement, var++);

	
	int success = sqlite3_step(insert_statement);
    
    sqlite3_finalize(insert_statement);
    
	if (success == SQLITE_ERROR) {
        NSAssert1(0, @"Error: failed to insert into the database with message '%s'.", sqlite3_errmsg(database));
    } else {
        // SQLite provides a method which retrieves the value of the most recently auto-generated primary key sequence
        // in the database. To access this functionality, the table should have a column declared of type 
        // "INTEGER PRIMARY KEY"
        taskID = sqlite3_last_insert_rowid(database);
    }
   
}

//
// This will delete a task from the iPhone SQL database
//
- (void)deleteFromDatabase {
   
	// also delete the alarms
	[self deleteAlarms];
	
	sqlite3_stmt *delete_statement;
	const char *sql = "DELETE FROM tasks WHERE taskID=?";
	
	
	if (sqlite3_prepare_v2(database, sql, -1, &delete_statement, NULL) != SQLITE_OK) {
		NSAssert1(0, @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(database));
	}
    
    // Bind the primary key variable.
    sqlite3_bind_int(delete_statement, 1, taskID);
    // Execute the query.
    int success = sqlite3_step(delete_statement);
   
	
	// Reset the statement for future use.
    sqlite3_finalize(delete_statement);
   
	// Handle errors.
    if (success != SQLITE_DONE) {
        NSAssert1(0, @"Error: failed to delete from database with message '%s'.", sqlite3_errmsg(database));
    }
}

//
// This deletes the associated alarms
//
- (void) deleteAlarms
{
	// we need to delete from the DB and remove it for the task alarm array
	for(Alarm* alarm in alarms)
	{
		[alarm deleteFromDatabase];
		[alarms removeObject:alarm];
	}
}



#pragma mark -
#pragma mark  Properties

//
//
//
- (NSInteger)taskID {
    return taskID;
}

//
//
//
- (NSString *)title {
    return title;
}

//
//
//
- (void)setTitle:(NSString *)aString {
    if ((!title && !aString) || (title && aString && [title isEqualToString:aString])) return;
	[self setDirty:YES];
	[title release];
    title = [aString copy];
}

//
//
//
- (NSDate *)dueDate {
     return dueDate;
}

//
// This routine sets the due date for the tasks in the list
//
- (void)setDueDate:(NSDate *)aDate {
    if ((!dueDate && !aDate) || (dueDate && aDate && [dueDate isEqualToDate:aDate])) return;
    [self setDirty:YES];
    [dueDate release];
    dueDate = [aDate copy];
}

//
//
//
- (NSDate *)completionDate {
    return completionDate;
}

//
//
//
- (void)setCompletionDate:(NSDate *)aDate {
    if ((!completionDate && !aDate) || (completionDate && aDate && [completionDate isEqualToDate:aDate])) return;
    [self setDirty:YES];
    //[completionDate release];
    completionDate = [aDate copy];
}

//
//
//
- (NSNumber*)priority {
    return priority;
}

//
// This routine sets the priority of the task in the list
//
- (void)setPriority:(NSNumber*)anInteger {
    if ((!priority && !anInteger) || (priority && anInteger && [priority isEqualToNumber:anInteger])) return;
    [self setDirty:YES];
    [priority release];
    priority = [anInteger copy];
}

//
//
//
- (NSString *)desktopID {
    return desktopID;
}

//
//
//
- (void)setDesktopID:(NSString *)aString {
    if ((!desktopID && !aString) || (desktopID && aString && [desktopID isEqualToString:aString])) return;
    [self setDirty:YES];
    [desktopID release];
    desktopID = [aString copy];
}

//
//
//
- (NSString *)notes {
    return notes;
}

//
//
//
- (void)setNotes:(NSString *)aString {
    if ((!notes && !aString) || (notes && aString && [notes isEqualToString:aString])) return;
    [self setDirty:YES];
    [notes release];
    notes = [aString copy];
}

//
//
//
- (NSString *)URL {
    return URL;
}

//
//
//
- (void)setURL:(NSString *)aString {
    if ((!URL && !aString) || (URL && aString && [URL isEqualToString:aString])) return;
    [self setDirty:YES];
    [URL release];
    URL = [aString copy];
}

//
//
//
- (NSString *)defaultDueDateName {
    return defaultDueDateName;
}


//
//
- (void)setDefaultDueDateName:(NSString *)aString {
    if ((!defaultDueDateName && !aString) || (defaultDueDateName && aString && [defaultDueDateName isEqualToString:aString])) return;
    [self setDirty:YES];
    [defaultDueDateName release];
    defaultDueDateName = [aString copy];
}

//
//
//
- (NSString *)calendar {
    return calendar;
}

//
//
//
- (void)setCalendar:(NSString *)aString {
    if ((!calendar && !aString) || (calendar && aString && [calendar isEqualToString:aString])) return;
    [self setDirty:YES];
    [calendar release];
    calendar = [aString copy];
}

//
//
//
- (NSMutableArray*) alarms
{
	return alarms;
}

//
//
//
- (void) setAlarms:(NSMutableArray*) inArray
{
	if ( (!alarms && !inArray) || (alarms && inArray && [alarms isEqualToArray:inArray]))
		return;
	[self setDirty:YES];
	[alarms release];
	alarms = [inArray copy];
}

//
//
//
- (void) setModified:(BOOL) isModified
{
	modified = isModified;
}

//
//
//
- (BOOL) modified
{
	return modified;
}

//
//
//
- (void) clearModified
{
	modified = NO;
	[self clearAlarmsModified];
}

//
//
//
- (void) setDirty:(BOOL) isDirty
{
	if ( isDirty)
		[self setModified:YES];
	else if (dirty)
		[self setModified:YES];
	
	dirty = isDirty;
}

//
//
//
- (BOOL) dirty
{
	return dirty;
}


#pragma mark -
#pragma mark Class Methods

//
//
//
- (void) addAlarm:(Alarm*) inAlaram
{
	[inAlaram insertIntoDatabase:database];
	if ( alarms == nil )
		alarms = [[NSMutableArray alloc] init];
    [alarms addObject:inAlaram];
}

//
//
//
- (void) removeAlarm:(Alarm*) inAlaram
{
	[inAlaram deleteFromDatabase];
    [alarms removeObject:inAlaram];
}

//
//
//
- (void) addAlarms:(NSDictionary*) ItaskDict
{
	NSArray* alarmArray = [ItaskDict objectForKey:NSLocalizedString(@"TASK_ALARMS", @"")];
	
	if ( alarmArray != nil )
	{
		for(NSDictionary* alarmDict in alarmArray)
		{
				// we need to create the alarm form the Dictionary and then add it
				// the the tasks alarm array
			Alarm* newAlarm = [[Alarm alloc] initWithDictionary:alarmDict andTaskID:[self taskID]];
			[self addAlarm:newAlarm];
			[newAlarm release];
		}
	}
}

//
//
//
- (void) updateAlarms:(NSDictionary*) ItaskDict
{
	NSArray* alarmArray = [ItaskDict objectForKey:NSLocalizedString(@"TASK_ALARMS", @"")];
	
	if ( alarmArray != nil )
	{
		for(NSDictionary* alarmDict in alarmArray)
		{
			NSNumber* alarmID = [alarmDict objectForKey:NSLocalizedString(@"ALARM_UID", @"")];
		
			if ( [alarmID integerValue] == 0 )
			{
					// then we have a new alarm to add to the task
				Alarm* newAlarm = [[Alarm alloc] initWithDictionary:alarmDict];
				[self addAlarm:newAlarm];
				[newAlarm release];
			}
			else
			{
					// we need to update the alarm 
					// so first we need to find the alarm in the Tasks alarm array
				for(Alarm* updatedAlaram in alarmArray)
				{
					if ( [updatedAlaram alarmID] == [alarmID integerValue] )
					{
						[updatedAlaram updateAlarmWithDictionary:alarmDict];
						break;
					}
				}
			}
		}
	}
}

#pragma mark - Syncing

//
//
//
- (NSMutableDictionary*) createTaskDictionary
{
		// ok we need to create the task dictionary
	NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init]  autorelease];
	[dateFormatter setDateFormat:@"MM/dd/yyyy"];
	
	NSMutableDictionary* taskDict = [[NSMutableDictionary alloc] init];
	
	[taskDict setObject:[[NSNumber numberWithInteger:taskID] stringValue] forKey:NSLocalizedString(@"TASK_IPHONE_UID", @"")];
	[taskDict setObject:title forKey:NSLocalizedString(@"TASK_TITLE", @"")];
	if ( dueDate == nil )
		[taskDict setObject:[NSString string] 
					forKey:NSLocalizedString(@"TASK_DUE_DATE", @"")];
	else
		[taskDict setObject:[dateFormatter stringFromDate:dueDate] 
					 forKey:NSLocalizedString(@"TASK_DUE_DATE", @"")];
	if ( completionDate == nil )
		[taskDict setObject:[NSString string] 
					 forKey:NSLocalizedString(@"TASK_COMPLETED", @"")];
	else
		[taskDict setObject:[dateFormatter stringFromDate:completionDate] 
					 forKey:NSLocalizedString(@"TASK_COMPLETED", @"")];
	[taskDict setObject:[priority stringValue] forKey:NSLocalizedString(@"TASK_PRIORITY", @"")];
	
	if ( desktopID == nil )
		[taskDict setObject:[NSString string] forKey:NSLocalizedString(@"TASK_ICAL_UID", @"")];
	else
		[taskDict setObject:desktopID forKey:NSLocalizedString(@"TASK_ICAL_UID", @"")];
	
	if ( notes == nil )
		[taskDict setObject:[NSString string] forKey:NSLocalizedString(@"TASK_NOTES", @"")];
	else
		[taskDict setObject:notes forKey:NSLocalizedString(@"TASK_NOTES", @"")];
	
	if ( URL == nil )
		[taskDict setObject:[NSString string] forKey:NSLocalizedString(@"TASK_URL", @"")];
	else
		[taskDict setObject:URL forKey:NSLocalizedString(@"TASK_URL", @"")];
	
	if ( calendar == nil )
		[taskDict setObject:[NSString string] forKey:NSLocalizedString(@"TASK_CALENDAR", @"")];
	else
		[taskDict setObject:calendar forKey:NSLocalizedString(@"TASK_CALENDAR", @"")];
	
	NSMutableArray* alarmArray = [[NSMutableArray alloc] init];
	
	NSMutableDictionary* alarmDict = nil;
		// ok we need to add the alarms to the dictionary
	for(Alarm* alarm in alarms)
	{
		alarmDict = [alarm createAlarmDictionary];
		[alarmArray addObject:alarmDict];
		[alarmDict release];
	}
	
	[taskDict setObject:alarmArray forKey:NSLocalizedString(@"TASK_ALARMS", @"")];
	[alarmArray release];
	
	return taskDict;
}

//
//
//
- (void) clearAlarmsModified
{
	for(Alarm* alarm in alarms)
	{
		[alarm clearModified];
	}
}

@end
