//
//  QuickTaskView.h
//  iTask-iPhone
//
//  Created by Denis Arsenault on 12/10/08.
//  Copyright 2008 Mybrightzone. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface QuickTaskView : UIView {
	IBOutlet UITextField *titleField;
}
@property (nonatomic, retain) UITextField *titleField;

@end
