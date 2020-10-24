//
//  CustomUISwitch.h
//  iTask-iPhone
//
//  Created by Denis Arsenault on 12/10/08.
//  Copyright 2008 Mybrightzone. All rights reserved.
//  
//

#import <Foundation/Foundation.h>

@interface UISwitch (extended)
- (void) setAlternateColors:(BOOL) boolean;
@end

@interface _UISwitchSlider : UIView
@end

@interface CustomUISwitch : UISwitch {
}
	- (void) setLeftLabelText: (NSString *) labelText;
	- (void) setRightLabelText: (NSString *) labelText;
@end
