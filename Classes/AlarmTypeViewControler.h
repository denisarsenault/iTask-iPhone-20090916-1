//
//  AlarmTypeViewControler.h
//  iTask-iPhone
//
//  Created by Denis Arsenault on 12/10/08.
//  Copyright 2008 Mybrightzone. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Alarm;

@interface AlarmTypeViewController : UIViewController  <UITableViewDelegate, UITableViewDataSource>{
	NSArray *alarmTypes;
	UITableView *tableView;
    Alarm	*alarm;
	
}

@property (nonatomic, retain) NSArray *alarmTypes;
@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (nonatomic, assign) Alarm *alarm;


@end
