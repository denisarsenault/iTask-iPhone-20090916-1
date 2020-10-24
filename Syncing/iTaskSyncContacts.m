//
//  iTaskSyncContacts.m
//  iTask-iPhone
//
//  Created by Mybrightzone on 12/8/08.
//

#import "iTaskSyncContacts.h"
#import "iTaskAppDelegate.h"
#import "Task.h"
#import "CalendarName.h"
//#import "Calendar.h"
#import <AddressBook/AddressBook.h>

#import "ItaskStrings.h"

@implementation iTaskSyncContacts

static iTaskSyncContacts* sSharedTaskSyncContacts = nil;

@synthesize addressBookTasks;
@synthesize addressBooks;
@synthesize calendarNames;

#pragma mark -
#pragma mark Singleton Methods

+ (id) sharedTaskSyncContacts
{
	return sSharedTaskSyncContacts;
}

#pragma mark -
#pragma mark Initialization/Deallocation

//
//
//

- (id) init
{
	self = [super init];
	if (self != nil) 
	{
		//[self readTaskData];
		addressBookTasks = nil;
		addressBook = ABAddressBookCreate();
		addressBooks = nil;
	/*	
		addressBookTasksChangedTimer = [NSTimer scheduledTimerWithTimeInterval:kScanAddressBookForTaskChanges
																		target:self
																	  selector:@selector(checkForAddressBookTaskChanges:)
																	  userInfo:nil
																	   repeats:YES];
		taskChangesTimer = [NSTimer scheduledTimerWithTimeInterval:kScanTasksForChanges
															   target:self
															 selector:@selector(checkForTaskChanges:)
															 userInfo:nil
															  repeats:YES];
	*/
		sSharedTaskSyncContacts = self;
	}
	return self;
}

//
//
//

- (void) dealloc
{
	[calendarNames release];
	//CFRelease(person);
	CFRelease(addressBook); 
	[super dealloc];
}

#pragma mark -
#pragma mark Class Methods

//
//
//
- (BOOL) addNewTaskWithItaskData:(NSDictionary*) ItaskData andTaskUID:(NSString*) uid
{
	BOOL result = YES;
		// we need to add a new task but then modify the dictionary
	Task* newTask = [[Task alloc] initWithDictionary:ItaskData];
	[[iTaskAppDelegate sharedAppDelegate] addTask:newTask];
	[newTask addAlarms:ItaskData];
	
	[newTask release];
	
		// now we need to mark the status field to no modifications, so it can be written back out properly
	NSMutableDictionary* dict = [addressBookTasks objectForKey:uid];
	[dict setObject:[NSNumber numberWithInteger:TASK_NOT_MODIFIED]
			 forKey:@"taskStatus"];
	
	return result;
}

//
//
//

- (BOOL) removeTaskFromDBWithTask:(Task*) inTask andUID:(NSString*) inUID
{
	BOOL result = YES;
	
	[[iTaskAppDelegate sharedAppDelegate] removeTask:inTask];
	
		// now we need to remove the task from the tasks dictionaray array
	[addressBookTasks removeObjectForKey:inUID];
	
	return result;
}

//
//
//

- (BOOL) modifyTaskWithItaskData:(NSDictionary*) ItaskData andTask:(Task*) inTask andTaskUID:(NSString*) taskUID
{
	BOOL result = YES;
	
		// we need to update the task object
	[inTask updateTaskWithDictionary:ItaskData];
	
		// now we need to update task array saved data, so it can be written out
	NSMutableDictionary* dict = [addressBookTasks objectForKey:taskUID];
	[dict setObject:[NSNumber numberWithInteger:TASK_NOT_MODIFIED]
			 forKey:@"taskStatus"];	
	
	if ( ItaskData == nil )
	{
		//NSLog(@" WARNING-- WARNING -- ItaskResult == nil ");
	}
	[dict setObject:ItaskData
				 forKey:@"ItaskDictionary"];
	
							
	return result;
}

//
//
//

- (void) writeOutTasksToAddressBook
{
	//NSLog(@"writeOutTasksToAddressBook() -- entered");
	ABRecordRef person;
	CFErrorRef myErr;
	
	person = [self getPersonRecord];
	
	ABMutableMultiValueRef addressProp = ABMultiValueCreateMutable (kABPersonAddressProperty);
	
	NSError* err;
	NSMutableDictionary* addressDict = nil;
	ABMultiValueIdentifier outIdentifier;
	NSMutableDictionary* taskDict = nil;
	NSMutableDictionary* savedDict = nil;
	
	SBItask *ItaskParser = [SBItask new];
	NSInteger count = 0;
	NSString* dictKey = nil;
	
	NSMutableDictionary* newTasksDict = [[NSMutableDictionary alloc] init];
	
	NSMutableArray* tasks = [[iTaskAppDelegate sharedAppDelegate] tasks];
	
		// first we need to see if any tasks are modified
	for(Task* task in tasks)
	{
		if ( [task modified] )
		{
				// now check to see if the task has been written out already
			NSString* iCalUID = [task desktopID];
			addressDict = [[NSMutableDictionary alloc] init];
			
			if ( (iCalUID == nil) || ([iCalUID length] == 0))
			{
				NSString* iphoneUID = [[NSNumber numberWithInteger:[task taskID]] stringValue];
				savedDict = [addressBookTasks objectForKey:iphoneUID];
				if ( savedDict != nil )
				{
					//NSLog(@" --- New Task added in iphone task sync, was already saved in addressbook, but has been modified again---");
					//NSLog(@" Task Name = %@", [task title]);
					// this is a new task so we need to add it the Address Book
					
					taskDict = [task createTaskDictionary];
					
					NSString* ItaskString = [ItaskParser stringWithObject:taskDict 
																  error:&err];
					[addressDict setObject:ItaskString 
									forKey:(NSString*) kABPersonAddressStreetKey];
					[addressDict setObject:[[NSNumber numberWithInt:TASK_CREATED_IN_ITASKSYNC] stringValue] 
									forKey:(NSString*) kABPersonAddressCityKey];
					
					NSString* tasksTitleID = [NSString stringWithString:[[NSNumber numberWithInteger:[task taskID]] stringValue]];
					
					savedDict = [addressBookTasks objectForKey:tasksTitleID];
					
					if ( savedDict != nil )
						[addressBookTasks removeObjectForKey:tasksTitleID];
					
					savedDict = [[NSMutableDictionary alloc] init];
					
					[savedDict setObject:ItaskString forKey:@"ItaskDictionary"];
					[savedDict setObject:[NSNumber numberWithInteger:TASK_CREATED_IN_ITASKSYNC] forKey:@"taskStatus"];
					
					[newTasksDict setObject:savedDict 
									 forKey:tasksTitleID];
					[savedDict release];
					dictKey = tasksTitleID;
				}
				else
				{
					//NSLog(@" --- New Task added in iphone task sync, has not beed added to the addressbook, so it is new---");
					//NSLog(@" Task Name = %@", [task title]);
					
					// this is a new task so we need to add it the Address Book
					taskDict = [task createTaskDictionary];
					
					NSString* ItaskString = [ItaskParser stringWithObject:taskDict 
																  error:&err];
					[addressDict setObject:ItaskString 
									forKey:(NSString*) kABPersonAddressStreetKey];
					[addressDict setObject:[[NSNumber numberWithInt:TASK_CREATED_IN_ITASKSYNC] stringValue] 
									forKey:(NSString*) kABPersonAddressCityKey];
					
					NSString* tasksTitleID = [NSString stringWithString:[[NSNumber numberWithInteger:[task taskID]] stringValue]];
										
					savedDict = [[NSMutableDictionary alloc] init];
					
					[savedDict setObject:ItaskString forKey:@"ItaskDictionary"];
					[savedDict setObject:[NSNumber numberWithInteger:TASK_CREATED_IN_ITASKSYNC] forKey:@"taskStatus"];
					
					[newTasksDict setObject:savedDict 
									 forKey:tasksTitleID];
					[savedDict release];
					dictKey = tasksTitleID;
				}
			}
			else
			{
				//NSLog(@" --- Task from iCal has been modified---");
				//NSLog(@" Task Name = %@", [task title]);
				// task has been modified but already is in iCal
				// this is a new task so we need to add it the Address Book
				taskDict = [task createTaskDictionary];
				
				NSString* ItaskString = [ItaskParser stringWithObject:taskDict 
															  error:&err];
				[addressDict setObject:ItaskString 
								forKey:(NSString*) kABPersonAddressStreetKey];
																
				[addressDict setObject:[[NSNumber numberWithInteger:TASK_MODIFIED_IN_ITASKSYNC] stringValue] 
								forKey:(NSString*) kABPersonAddressCityKey];
				
				[addressBookTasks removeObjectForKey:iCalUID];
				
				savedDict = [[NSMutableDictionary alloc] init];
				
				[savedDict setObject:ItaskString forKey:@"ItaskDictionary"];
				[savedDict setObject:[NSNumber numberWithInteger:TASK_MODIFIED_IN_ITASKSYNC] forKey:@"taskStatus"];
				
				[newTasksDict setObject:savedDict 
								 forKey:iCalUID];
				[savedDict release];
				dictKey = iCalUID;
				
				[addressBookTasks removeObjectForKey:iCalUID];
			}
			
		}
		else
		{		
			//NSLog(@" --- Task was not modified so we need to write out the saved data we already wrote out---");
			//NSLog(@" Task Name = %@", [task title]);
			
			addressDict = [[NSMutableDictionary alloc] init];
			
			NSString* keyID = nil;
				// see if the task is either been added to iCal or it is a new task that was created here
			NSString* iCalUID = [task desktopID];
			if ( (iCalUID == nil) || ([iCalUID length] == 0))
			{
					// so it has not been added to iCal yet, so we use the DB taskID
				keyID = [[NSNumber numberWithInteger:[task taskID]] stringValue];
			}
			else
			{
				keyID = iCalUID;
			}
			
			savedDict = [addressBookTasks objectForKey:keyID];
			
			NSString* ItaskString = [ItaskParser stringWithObject:[savedDict objectForKey:@"ItaskDictionary"] 
														  error:&err];
			
				// task is not modified just use the old info for it
			[addressDict setObject:ItaskString
							forKey:(NSString*) kABPersonAddressStreetKey];
			[addressDict setObject:[[savedDict objectForKey:@"taskStatus"] stringValue] 
							forKey:(NSString*) kABPersonAddressCityKey];
			
			[newTasksDict setObject:savedDict 
							 forKey:keyID];
			
			[addressBookTasks removeObjectForKey:keyID];
			
			
			dictKey = keyID;
		}
		
		ABMultiValueInsertValueAndLabelAtIndex (addressProp,
												(CFTypeRef) addressDict,
												(CFStringRef) dictKey,
												count,
												&outIdentifier);
		[addressDict release];
		count++;
		
	}
	
	// now we need to see if any tasks where deleted
	
	for(NSString* key in [addressBookTasks allKeys] )
	{
		savedDict = [addressBookTasks objectForKey:key];
		
		NSString* iCalUID = [[savedDict objectForKey:@"ItaskDictionary"] objectForKey:NSLocalizedString(@"TASK_ICAL_UID", @"")];
		
		if ( (iCalUID != nil) || ([iCalUID length] != 0)) 
		{
			// we do this because we may have a new task that was created on the iphone in this session and has not been
			// saved in iCal yet, so it does not have a Task UID yet. So no reason tell iCal about it because it does not know about it
			
			//NSLog(@" --- Task has been deleted---");
			//NSLog(@" Task Name = %@", [[savedDict objectForKey:@"ItaskDictionary"] objectForKey:NSLocalizedString(@"TASK_TITLE", @"")]);
			
			
			addressDict = [[NSMutableDictionary alloc] init];
			NSString* ItaskString = [ItaskParser stringWithObject:[savedDict objectForKey:@"ItaskDictionary"]
														  error:&err];
			[addressDict setObject:ItaskString 
							forKey:(NSString*) kABPersonAddressStreetKey];
			[addressDict setObject:[[NSNumber numberWithInteger:TASK_DELETED_IN_ITASKSYNC] stringValue] 
							forKey:(NSString*) kABPersonAddressCityKey];
			
			savedDict = [[NSMutableDictionary alloc] init];
			
			[savedDict setObject:ItaskString forKey:@"ItaskDictionary"];
			[savedDict setObject:[NSNumber numberWithInteger:TASK_DELETED_IN_ITASKSYNC] forKey:@"taskStatus"];
			
			[addressBookTasks removeObjectForKey:key];
			[newTasksDict setObject:savedDict 
							 forKey:key];
			[savedDict release];
			
			ABMultiValueInsertValueAndLabelAtIndex (addressProp,
													(CFTypeRef) addressDict,
													(CFStringRef) key,
													count,
													&outIdentifier);
			count++;
		}
	}

	[addressBookTasks release];
	addressBookTasks = newTasksDict;
    [savedDict release];
	[ItaskParser release];

	ABRecordSetValue (person,
					  kABPersonAddressProperty,
					  addressProp,
					  &myErr);
		
	ABAddressBookSave(addressBook, &myErr);

	// now we need to reset the tasks modified back to NO
	for(Task* task in tasks)
	{
		[task setModified:NO];
	}
	//NSLog(@"writeOutTasksToAddressBook() -- leaving");
}

//
// Get a Person Record
//

- (ABRecordRef) getPersonRecord
{
	ABRecordRef person;
	
	//NSLog(@"************ getPersonRecord() -- Entry *************");
	NSArray* personArray = (NSArray*) ABAddressBookCopyPeopleWithName(addressBook, 
																	  (CFStringRef) NSLocalizedString(@"ADDRESS_ITEM_NAME", @""));
	if ( [personArray count] > 0 )
	{
		// we found the the person
		person = [personArray objectAtIndex:0];
	}
	else
	{
			// we need to create that person record
		person = [self createPersonRecord];
	}
		//NSLog(@"************ getPersonRecord() -- Leave *************");
	return (CFRetain(person));
}

//
// Create Person Record
//

- (ABRecordRef) createPersonRecord
{
	//NSLog(@"************ createPersonRecord() -- Entry *************");
	// oops not found, need to create the address book item
	ABRecordRef  person = ABPersonCreate ();
	
	CFErrorRef err;	
	ABMultiValueIdentifier outIdentifier;
	
	// set the the Oragnization name
	ABRecordSetValue (person, kABPersonOrganizationProperty,(CFTypeRef) NSLocalizedString(@"ADDRESS_ITEM_NAME", nil),&err);
	
	// set the email field as 'Other'
	ABMutableMultiValueRef emailProperty = ABMultiValueCreateMutable (kABMultiStringPropertyType);
	
	ABMultiValueInsertValueAndLabelAtIndex (emailProperty,
											(CFTypeRef) NSLocalizedString(@"OTHER_EMAIL_VALUE", nil),
											(CFTypeRef) NSLocalizedString(@"OTHER_EMAIL_NAME", nil),
											0,
											&outIdentifier);
	ABRecordSetValue (person, kABPersonEmailProperty,emailProperty,&err);
	
	ABRecordSetValue (person, kABPersonKindProperty,(CFNumberRef) kABPersonKindOrganization,&err);
	
	ABAddressBookAddRecord (addressBook,person,&err);
	
	ABAddressBookSave(addressBook, &err);

	//NSLog(@"************ createPersonRecord() -- Leaving *************");
	return (CFRetain(person));
}

//
// Check for modified Tasks
//

- (void) checkForModifiedTasksFromAddressBook
{	
	//NSLog(@"************ checkForModifiedTasksFromAddressBook() -- entered ************ ");
	ABRecordRef person;
	
	person = [self getPersonRecord];
	CFTypeRef addressProp = ABRecordCopyValue (person, kABPersonAddressProperty);
	
	int i;
	CFIndex count = ABMultiValueGetCount(addressProp);
	
	// ********************************** Why reset?
	if ( addressBookTasks != nil)
		[addressBookTasks release];
	
	addressBookTasks = [[NSMutableDictionary alloc] init];
	
	for (i = 0; i < count; i++)
	{
		NSString* uid = (NSString*) ABMultiValueCopyLabelAtIndex (addressProp, i);
		//NSLog(@"uid = %@", uid);
		
		NSMutableDictionary* taskDict = (NSMutableDictionary*) ABMultiValueCopyValueAtIndex (addressProp, i);
		//NSLog(@"taskDict = %@", taskDict);
		
		NSString* ItaskData = [taskDict objectForKey:(NSString*) kABPersonAddressStreetKey];
		NSString* taskStatus = [taskDict objectForKey:(NSString*) kABPersonAddressCityKey];
		NSUInteger status = [taskStatus integerValue];
		
		// Parse the Itask into an Object
		NSError* err;
		
		SBItask *ItaskParser = [SBItask new];
		NSDictionary *ItaskResult = (NSDictionary *)[ItaskParser objectWithString:ItaskData error:&err];
		if (ItaskResult == nil) 
		{
			while (err != nil) 
			{
				//NSLog(@"%@", [err userInfo]);
				err = [[err userInfo] objectForKey:@"NSUnderlyingError"];
			}
		}
		else
		{
			//NSLog(@"ItaskResult = %@", ItaskResult);
		}
		[ItaskParser release];
		NSMutableDictionary* savedDict = [[NSMutableDictionary alloc] init];
		
		if ( ItaskResult == nil )
		{
			//NSLog(@" WARNING-- WARNING -- ItaskResult == nil ");
		}
		[savedDict setObject:ItaskResult forKey:@"ItaskDictionary"];
		[savedDict setObject:[NSNumber numberWithInteger:[taskStatus integerValue]] forKey:@"taskStatus"];
		
		[addressBookTasks setObject:savedDict
							 forKey:(NSString*) uid];
		
		[savedDict release];
		
		NSString* iPhone_UID = [ItaskResult objectForKey:NSLocalizedString(@"TASK_IPHONE_UID", @"")];
		
		switch ( status )
		{
			case TASK_CREATED_IN_ICAL:
			{
				if ( [iPhone_UID isEqualToString:@"0"] )
				{
					// we have a new task that needs to be added to the iPhone SQL DB for tasks
					if ( [self addNewTaskWithItaskData:ItaskResult andTaskUID:uid] )
					{
						NSLog(@"checkForModifiedTasksFromAddressBook() -- created new Task");
					}
					
				}
				else
				{
					// we have a problem here and should never get here
					// what should we do???
				}
				
				
				break;
			}
			case TASK_MODIFIED_IN_ICAL:
			{
				if ( [iPhone_UID isEqualToString:@"0"] )
				{
					// so the task has been modified but does not look like this task is in the DB
					// so we need to add it
					
					if ( [self addNewTaskWithItaskData:ItaskResult andTaskUID:uid] )
					{
						//NSLog(@"checkForModifiedTasksFromAddressBook() -- created new Task");
					}
				}
				else
				{
					// else we just need to update the task already in the DB
					NSMutableArray* tasksArray = [[iTaskAppDelegate sharedAppDelegate] tasks];
					
					int i;
					for(i = 0; i < [tasksArray count]; i++ )
					{
						Task* task = [tasksArray objectAtIndex:i];
						if ( [[task desktopID] isEqualToString:uid] )
						{
							if ( [self modifyTaskWithItaskData:ItaskResult andTask:task andTaskUID:uid] )
							{
								//NSLog(@"checkForModifiedTasksFromAddressBook() -- modified previously saved task");
							}
							break;
						}
					}
				}
				
				break;
			}
			case TASK_DELETED_IN_ICAL:
			{
				if ( [iPhone_UID isEqualToString:@"0"] )
				{
					// we just need to remove this task from the task list
					[addressBookTasks removeObjectForKey:uid];
					//NSLog(@"checkForModifiedTasksFromAddressBook() -- deleting task");
				}
				else
				{
					
					// we have a deleted task that is already on the iPhone/iPod and we need to delete it
					Task* newTask = [[Task alloc] initWithDictionary:ItaskResult];
					
					[self removeTaskFromDBWithTask:newTask andUID:uid];
					//NSLog(@"checkForModifiedTasksFromAddressBook() -- deleting task");
				}
				
				break;
			}
			case TASK_NOT_MODIFIED:
			{
				if ( [iPhone_UID isEqualToString:@"0"] )
				{
					// then this task has not been added yet, and is new to the DB
					if ( [self addNewTaskWithItaskData:ItaskResult andTaskUID:uid] )
					{
						//NSLog(@"checkForModifiedTasksFromAddressBook() -- task is not modified");
					}
				}
			}
		}
	}
	// need to write out the Tasks to the AddressBook
	[self writeOutTasksToAddressBook];
	//NSLog(@"checkForModifiedTasksFromAddressBook() -- leaving");
}

//
// Get the Address Book list
//

- (void) getAddressBooks
{
	ABRecordRef person;
	
	if ( addressBooks != nil )
		[addressBooks release];
	
	person = [self getPersonRecord];
	CFTypeRef noteProp = ABRecordCopyValue (person, kABPersonNoteProperty);
	
	NSError* err;
	SBItask *ItaskParser = [SBItask new];
	NSDictionary *ItaskResult = (NSDictionary *)[ItaskParser objectWithString:(NSString*) noteProp error:&err];
	
	if(calendarNames){
		[calendarNames release];
		calendarNames = nil;
	}
	calendarNames = [[NSMutableArray alloc] init];
	
	// Create a predicate to fetch all events for this year
	// Get all the Calendar objects for this year
	//=============================================================================================================================
	/*
	NSDate *nowDate = [NSDate date];
	// Take the Current date and find the time since 1970
	NSTimeInterval now = [nowDate timeIntervalSince1970];
	// Take the time since 1970 and subtract the number of seconds in a week.
	NSTimeInterval weekAgo = (now - 604800);
	
	// Create the Predicate to do the Filtering.
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"startDateTime >= %@", NSDate dateWithTimeIntervalSince1970: weekAgo];
	
	// Load a New array with all of the sessions.
	*NSMutableArray filteredArray = [NSMutableArray alloc initWithArray:appDelegate sessions];
	
	// Fiter that new Array.
	*filteredArray filterUsingPredicate:predicate; *icateWithStartDate:startDate endDate:endDate
																		 calendars:[[CalCalendarStore defaultCalendarStore] calendars]];
	//NSArray *standardCalendarName = [[CalCalendarStore defaultCalendarStore] nameWithPredicate:predicate];
	*/
	//=============================================================================================================================
	//Always add a default row.
	CalendarName* defaultItem = [[CalendarName alloc] initWithUID:@"default" name:@"Default"];
	[calendarNames	addObject:defaultItem];
	CalendarName* personalItem = [[CalendarName alloc] initWithUID:@"personal" name:@"Personal"];
	[calendarNames	addObject:personalItem];
	[personalItem release];
	
	if (ItaskResult == nil) 
	{
		while (err != nil) 
		{
			//NSLog(@"%@", [err userInfo]);
			err = [[err userInfo] objectForKey:@"NSUnderlyingError"];
		}
	}
	else
	{
		// parse the calendar items
		NSEnumerator *enumerator = [ItaskResult keyEnumerator];
		id key;
				
		while ((key = [enumerator nextObject])) {
			/* code that acts on the dictionary’s values */
			
			NSString *calUID = (NSString*)key;
			NSString *calName = [ItaskResult objectForKey:key];
			
			if(calUID && key){
				CalendarName* calItem = [[CalendarName alloc] initWithUID:calUID name:calName];
				[calendarNames	addObject:calItem];
			}
		}
		
		//NSLog(@"ItaskResult = %@", ItaskResult);
	}
	[ItaskParser release];
	
	addressBooks = [ItaskResult retain];
}

#pragma mark -
#pragma mark NSTimer Callbacks

//
// Address Book Updates
//

- (void) checkForAddressBookTaskChanges:(NSTimer*)theTimer
{
	//NSLog(@"checkForAddressBookTaskChanges() -- entered");
	[self checkForModifiedTasksFromAddressBook];
	[self getAddressBooks];
	//NSLog(@"checkForAddressBookTaskChanges() -- leaving");
}

- (void) checkForTaskChanges:(NSTimer*)theTimer
{
	//NSLog(@"checkForTaskChanges() -- entered");
		// here we need to go through the Array of tasks and see if they are dirty, if so we need
		// to update the addressbook
	
		//  THIS IS NOT IDEAL AND I HOPE TO GET A NOTIFICATION SENT TO THIS OBJECT WHEN A TASK
		//	IS CHANGED BY THE USER
	
	NSArray* tasksArray = [[iTaskAppDelegate sharedAppDelegate] tasks];
	for( Task* task in tasksArray)
	{
			// so now we need to figure out what chages where made and what type of change
			// meaning, was it created here in the iPhone/iPod, was it just modified, or was it deleted
		
		if( [task modified] )
		{
			//NSLog(@"checkForTaskChanges() -- **********************tasks have been modified");
			[self writeOutTasksToAddressBook];
			break;
		}
	}
	//NSLog(@"checkForTaskChanges() -- leaving");
}

@end
