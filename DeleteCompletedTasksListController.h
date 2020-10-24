//
//  DeleteCompletedTasksListController.h
//  iTask-iPhone
//
//  Created by Denis Arsenault on 1/23/09.
//  Copyright 2009 MyBrightzone. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DefaultDueDateName.h"
#import "PreferencesViewController.h"

@class Preferences;

@interface DeleteCompletedTasksListController :UIViewController  <UITableViewDelegate, UITableViewDataSource>{
	NSArray *deleteCompletedTasksNames;
	UITableView *tableView;
	Task	*task;
	NSString *deleteCompletedTasksName;
	Preferences *preferences;
	NSString *dueDate;
}

@property (nonatomic, retain) NSArray *deleteCompletedTasksNames;
@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (nonatomic, assign) Task *task;
@property (nonatomic, assign) Preferences *preferences;
@property (nonatomic, retain) NSString *deleteCompletedTasksName;
@property (nonatomic, assign) NSString *dueDate;



@end
