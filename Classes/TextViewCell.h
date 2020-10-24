//
//  TextViewCell.h
//  iTask-iPhone
//
//  Created by Denis Arsenault on 12/10/08.
//  Copyright 2008 Mybrightzone. All rights reserved.
//  
//

#import <UIKit/UIKit.h>


@interface TextViewCell : UITableViewCell {
	UILabel		*label;
	UITextView  *textView;
}

@property (nonatomic, retain) UITextView *textView;
@property (nonatomic, retain) UILabel *label;

@end
