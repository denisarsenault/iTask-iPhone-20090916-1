//
//  iTaskSyncContacts.h
//  iTask-iPhone
//
//  Created by Denis Arsenault on 12/10/08.
//  Copyright 2008 Mybrightzone. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AddressBook/AddressBook.h> 
#import "iTaskAppDelegate.h"
//#import "Task.h"

enum
{
	TASK_NOT_MODIFIED = 0,
	TASK_CREATED_IN_ICAL,
	TASK_MODIFIED_IN_ICAL,
	TASK_DELETED_IN_ICAL,
	TASK_CREATED_IN_ITASKSYNC = 5,
	TASK_MODIFIED_IN_ITASKSYNC,
	TASK_DELETED_IN_ITASKSYNC
};

#define kScanAddressBookForTaskChanges		60.0		//??? Sixty seconds, we can change this
#define kScanTasksForChanges			    60.0


@interface iTaskSyncContacts : NSObject 
{
	ABAddressBookRef addressBook;
	
	NSMutableDictionary* addressBookTasks;
	
	NSMutableDictionary* addressBooks;
	
	NSMutableArray* calendarNames;
	
	NSTimer*	addressBookTasksChangedTimer;
	NSTimer*	taskChangesTimer;
	
}

@property (nonatomic, retain) NSMutableDictionary *addressBookTasks;
@property (nonatomic, retain) NSMutableDictionary *addressBooks;
@property (nonatomic, retain) NSMutableArray* calendarNames;

#pragma mark -
#pragma mark Singleton Methods

+ (id) sharedTaskSyncContacts;

#pragma mark -
#pragma mark Initialization/Deallocation

- (id) init;
- (void) dealloc;

#pragma mark -
#pragma mark Class Methods

- (BOOL) addNewTaskWithItaskData:(NSDictionary*) ItaskData andTaskUID:(NSString*) uid;
- (BOOL) modifyTaskWithItaskData:(NSDictionary*) ItaskData andTask:(Task*) inTask andTaskUID:(NSString*) taskUID;
- (BOOL) removeTaskFromDBWithTask:(Task*) inTask andUID:(NSString*) inUID;

- (void) getAddressBooks;


- (void) writeOutTasksToAddressBook;
- (ABRecordRef) getPersonRecord;
- (ABRecordRef) createPersonRecord;
- (void) checkForModifiedTasksFromAddressBook;

#pragma mark -
#pragma mark NSTimer Callbacks

- (void) checkForAddressBookTaskChanges:(NSTimer*)theTimer;
- (void) checkForTaskChanges:(NSTimer*)theTimer;

@end
