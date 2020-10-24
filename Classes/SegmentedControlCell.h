//
//  SegmentedControlCell.h
//  iTask-iPhone
//
//  Created by Denis Arsenault on 12/10/08.
//  Copyright 2008 Mybrightzone. All rights reserved.
//  
//

#import <UIKit/UIKit.h>


@interface SegmentedControlCell : UITableViewCell {
	UILabel				*label;
	UISegmentedControl	*segmentedControlView;
}

@property (nonatomic, retain) UILabel	*label;
@property (nonatomic, retain) UISegmentedControl	*segmentedControlView;

- (id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier items:(NSArray *)items;


@end
