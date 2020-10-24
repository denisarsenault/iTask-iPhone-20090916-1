//
//  SortOrderListController.h
//  iTask-iPhone
//
//  Created by Denis Arsenault on 1/23/09.
//  Copyright 2009 MyBrightzone. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DefaultDueDateName.h"
#import "PreferencesViewController.h"

@class Preferences;

@interface SortOrderListController :UIViewController  <UITableViewDelegate, UITableViewDataSource>{
	NSArray *sortOrderNames;
	UITableView *tableView;
	Task	*task;
	Preferences	*preferences;
	NSString *sortOrderName;
	NSString *dueDate;
}

@property (nonatomic, retain) NSArray *sortOrderNames;
@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (nonatomic, assign) Task *task;
@property (nonatomic, assign) Preferences *preferences;
@property (nonatomic, retain) NSString *sortOrderName;
@property (nonatomic, assign) NSString *dueDate;

@end
