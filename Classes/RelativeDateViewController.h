//
//  RelativeDateViewController.h
//  iTask-iPhone
//
//  Created by Denis Arsenault on 12/10/08.
//  Copyright 2008 Mybrightzone. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface RelativeDateViewController :UIViewController  <UITableViewDelegate, UITableViewDataSource>{
	NSArray *relativeDateTypes;
	UITableView *tableView;

	
}

@property (nonatomic, retain) NSArray *relativeDateTypes;
@property (nonatomic, retain) IBOutlet UITableView *tableView;



@end
