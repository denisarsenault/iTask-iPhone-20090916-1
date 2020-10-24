//
//  DeleteCompletedCell.h
//  iTask-iPhone
//
//  Created by Denis Arsenault on 1/23/09.
//  Copyright 2009 MyBrightzone. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface DeleteCompletedCell : UITableViewCell {
	UILabel		*label;
	UILabel		*value;
}

@property (nonatomic, retain) UILabel *value;
@property (nonatomic, retain) UILabel *label;

@end
