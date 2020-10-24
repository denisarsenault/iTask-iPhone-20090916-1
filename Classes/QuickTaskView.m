//
//  QuickTaskView.m
//  iTask-iPhone
//
//  Created by Denis Arsenault on 12/10/08.
//  Copyright 2008 Mybrightzone. All rights reserved.
//

#import "QuickTaskView.h"


@implementation QuickTaskView
@synthesize titleField;

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
    }
    return self;
}


- (void)drawRect:(CGRect)rect {
    // Drawing code
}


- (void)dealloc {
    [titleField release];
	[super dealloc];
}


@end
