//
//  DeleteCompletedCell.m
//  iTask-iPhone
//
//  Created by Denis Arsenault on 1/23/09.
//  Copyright 2009 MyBrightzone. All rights reserved.
//

#import "DeleteCompletedCell.h"


@implementation DeleteCompletedCell

@synthesize label, value;

- (id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithFrame:frame reuseIdentifier:reuseIdentifier])
	{
		self.target = self;
		self.accessoryType = UITableViewCellAccessoryNone;
		self.accessoryAction = @selector(onClick:);
		
		// cell's  label
		label = [[UILabel alloc] initWithFrame:CGRectZero];
		label.backgroundColor = [UIColor clearColor];
		label.opaque = NO;
		label.textColor = [UIColor blackColor];
		label.highlightedTextColor = [UIColor whiteColor];
		label.font = [UIFont boldSystemFontOfSize:14.0];
		[self.contentView addSubview:label];
		
		// cell's  value
		value = [[UILabel alloc] initWithFrame:CGRectZero];
		value.backgroundColor = [UIColor clearColor];
		value.opaque = NO;
		value.textColor = [UIColor colorWithRed:0 green:0 blue:.9 alpha:.85];
		value.textAlignment = UITextAlignmentRight;
		value.highlightedTextColor = [UIColor whiteColor];
		value.font = [UIFont systemFontOfSize:14.0];
		[self.contentView addSubview:value];
		
	}
	return self;
}

- (void)dealloc {
    // Release allocated resources.
    [value release];
	[label release];
    [super dealloc];
}

- (void)layoutSubviews {
	[super layoutSubviews];
	
    CGRect contentRect = [self.contentView bounds];
	
	// layout the check title label
	CGRect frame = CGRectMake(contentRect.origin.x + 10.0, 5.0, 150, 30.0);
	label.frame = frame;
	
	// layout the text field
	frame = CGRectMake(contentRect.size.width - 180, 5.0, contentRect.size.width - 10, 30.0);
	value.frame = frame;
	
}


@end
