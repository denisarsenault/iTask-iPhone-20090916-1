//
//  TextViewCell.m
//  iTask-iPhone
//
//  Created by Denis Arsenault on 12/10/08.
//  Copyright 2008 Mybrightzone. All rights reserved.
//  
//

#import "TextViewCell.h"

@implementation TextViewCell

@synthesize label, textView;

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
		
		// cells text field
        textView = [[UITextView alloc] initWithFrame:CGRectZero];
		textView.returnKeyType = UIReturnKeyDefault;
        textView.font = [UIFont systemFontOfSize:14.0];
		textView.textColor = [UIColor colorWithRed:0 green:0 blue:.9 alpha:.85];
		textView.textAlignment = UITextAlignmentLeft;
		textView.scrollEnabled = FALSE;
		textView.userInteractionEnabled = FALSE;
		
        [self.contentView addSubview:textView];
		
	}
	return self;
}

- (void)dealloc {
    // Release allocated resources.
    [textView release];
	[label release];
    [super dealloc];
}

- (void)layoutSubviews {
	[super layoutSubviews];
	
    CGRect contentRect = [self.contentView bounds];
	
	// layout the check title label
	CGRect frame = CGRectMake(contentRect.origin.x + 10.0, 5.0, 60, 30.0);
	label.frame = frame;
	
	frame = CGRectMake(contentRect.origin.x + 90.0, contentRect.origin.y + 10.0, contentRect.size.width - 70, contentRect.size.height-30);
	textView.frame = frame;
	
}
@end
