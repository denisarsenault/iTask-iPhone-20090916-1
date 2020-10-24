//
//  DeleteCompletedTasksName.m
//  iTask-iPhone
//
//  Created by Denis Arsenault on 12/10/08.
//  Copyright 2008 Mybrightzone. All rights reserved.
//

#import "DeleteCompletedTasksName.h"


@implementation DeleteCompletedTasksName

@synthesize UID, name;

- (id) initWithUID:(NSString*)aUID  name:(NSString*)aName
{
	self = [super init];
	if (self != nil) 
	{
		if(aUID)
			self.UID = aUID;
		
		if(aName)
			self.name = aName;
		
	}
	return self;
}

@end
