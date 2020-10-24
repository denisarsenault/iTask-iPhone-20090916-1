//
//  AddTaskViewController.h
//  iTask-iPhone
//
//  Created by Denis Arsenault on 1/2/09.
//  Copyright 2009  All rights reserved.
//

#import <UIKit/UIKit.h>


@interface EditingViewController : UIViewController {
	NSString *textValue;
    id editedObject;
    NSString *editedFieldKey;
    IBOutlet UITextField *textField;
    BOOL dateEditing;
    NSDate *dateValue;
    IBOutlet UIDatePicker *datePicker;
    NSDateFormatter *dateFormatter;
}

@property (nonatomic, retain) id editedObject;
@property (nonatomic, retain) NSString *textValue;
@property (nonatomic, retain) NSDate *dateValue;
@property (nonatomic, retain) NSString *editedFieldKey;
@property (nonatomic, assign) BOOL dateEditing;
@property (nonatomic, readonly) UITextField *textField;
@property (nonatomic, retain) NSDateFormatter *dateFormatter;

- (IBAction)cancel:(id)sender;
- (IBAction)save:(id)sender;
- (IBAction)dateChanged:(id)sender;

@end
