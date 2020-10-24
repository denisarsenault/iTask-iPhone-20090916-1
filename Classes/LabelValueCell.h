//
//  LabelValueCell.h
//  iTask-iPhone
//
//  Created by Denis Arsenault on 12/10/08.
//  Copyright 2008 Mybrightzone. All rights reserved.
//  
//

#import <UIKit/UIKit.h>


@interface LabelValueCell : UITableViewCell {
	UILabel		*label;
	UILabel		*value;
}

@property (nonatomic, retain) UILabel *value;
@property (nonatomic, retain) UILabel *label;

@end
