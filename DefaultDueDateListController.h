//
//  DefaultDueDateListController.h
//  iTask-iPhone
//
//  Created by Denis Arsenault on 1/23/09.
//  Copyright 2009 MyBrightzone. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DefaultDueDateName.h"
#import "PreferencesViewController.h"

@class Preferences;

@interface DefaultDueDateListController :UIViewController <UITableViewDelegate, UITableViewDataSource> {
	NSArray *defaultDueDateNames;
	UITableView *tableView;
	Preferences	*preferences;
	NSString *defaultDueDateName;
	NSString *dueDate;
	Task	*task;

}

@property (nonatomic, retain) NSArray *defaultDueDateNames;
@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (nonatomic, assign) Preferences *preferences;
@property (nonatomic, retain) NSString *defaultDueDateName;
@property (nonatomic, assign) NSString *dueDate;
@property (nonatomic, assign) Task *task;


@end
