//
//  SortOrderName.h
//  iTask-iPhone
//
//  Created by Denis Arsenault on 12/10/08.
//  Copyright 2008 Mybrightzone. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface SortOrderName : NSObject {
	NSString*	UID;
	NSString*	name;
}

@property (nonatomic, retain) NSString *UID;
@property (nonatomic, retain) NSString *name;

// Creates new task object with default settings
- (id) initWithUID:(NSString*)aUID  name:(NSString*)aName; 


@end
