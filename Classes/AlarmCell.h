//
//  AlarmCell.h
//  iTask-iPhone
//
//  Created by Denis Arsenault on 12/10/08.
//  Copyright 2008 Mybrightzone. All rights reserved.
// 
//

#import <UIKit/UIKit.h>


@class Alarm;

@interface AlarmCell : UITableViewCell {
	Alarm		*alarm;
	NSDate		*dueDate;
	
	UILabel		*label;
	UILabel		*alarmActionLabel;
	UILabel		*dateOffset;
	UILabel		*relativeDateLabel;
//	UILabel		*timeLabel;
	UILabel		*emailLabel;
	UILabel		*soundLabel;
	UILabel		*urlLabel;
	
	NSDateFormatter *dateFormatter;

}

@property (nonatomic, assign) Alarm		*alarm;
@property (nonatomic, assign) NSDate		*dueDate;
@property (nonatomic, retain) UILabel *label;
@property (nonatomic, retain) UILabel *alarmActionLabel;
@property (nonatomic, retain) UILabel *dateOffset;
@property (nonatomic, retain) UILabel *relativeDateLabel;
//@property (nonatomic, retain) UILabel *timeLabel;
@property (nonatomic, retain) UILabel *emailLabel;
@property (nonatomic, retain) UILabel *soundLabel;
@property (nonatomic, retain) UILabel *urlLabel;
@property (nonatomic, retain) NSDateFormatter *dateFormatter;


@end
