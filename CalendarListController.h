//
//  CalendarListController.h
//  iTask-iPhone
//
//  Created by Denis Arsenault on 12/10/08.
//  Copyright 2008 Mybrightzone. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Task;

@interface CalendarListController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
    NSArray *calendarNames;
	UITableView *tableView;
    Task	*task;

}

@property (nonatomic, retain) NSArray *calendarNames;
@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (nonatomic, assign) Task *task;


@end
