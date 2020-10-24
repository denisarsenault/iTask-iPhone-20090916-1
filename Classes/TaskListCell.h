//
//  TaskListCell.h
//  iTask-iPhone
//
//  Created by Denis Arsenault on 12/10/08.
//  Copyright 2008 Mybrightzone. All rights reserved.
//  
//

#import <UIKit/UIKit.h>

@class Task;

@interface TaskListCell : UITableViewCell {
	Task		*task;
	
	UIButton *checkButton;
	UILabel *titleLabel;
	UILabel *dueDateLabel;
	UILabel *priorityLabel;
	
	NSDateFormatter *dateFormatter;

}


@property (nonatomic, assign) Task *task;
@property (nonatomic, retain) UIButton *checkButton;
@property (nonatomic, retain) NSDateFormatter *dateFormatter;

- (void)checkAction:(id)sender;

@end
