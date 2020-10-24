//
//  SegmentedControlCell.m
//  iTask-iPhone
//
//  Created by Denis Arsenault on 12/10/08.
//  Copyright 2008 Mybrightzone. All rights reserved.
//  
//

#import "SegmentedControlCell.h"


@implementation SegmentedControlCell

@synthesize label, segmentedControlView;

- (id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier items:(NSArray *)items
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
		
		label.text = NSLocalizedString(@"Priority", @"");
		
		// cells text field
        segmentedControlView = [[UISegmentedControl alloc] initWithItems:items];
        [self.contentView addSubview:segmentedControlView];
		
	}
	return self;
}

- (void)dealloc {
    // Release allocated resources.
    [segmentedControlView release];
	[label release];
    [super dealloc];
}

- (void)layoutSubviews {
	[super layoutSubviews];
	
    CGRect contentRect = [self.contentView bounds];
	
	// layout the  label
	CGRect frame = CGRectMake(contentRect.origin.x + 10.0, 5.0, 70, 30.0);
	label.frame = frame;
	
	// layout the control field
	frame = CGRectMake(contentRect.size.width - 200, 3.0, 195, 30);
	segmentedControlView.frame = frame;
	
}

@end
