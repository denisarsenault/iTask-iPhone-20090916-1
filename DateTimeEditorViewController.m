//
//  DateTimeEditor.m
//  iTask-iPhone
//
//  Created by Denis Arsenault on 12/10/08.
//  Copyright 2008 Mybrightzone. All rights reserved.
//

#import "DateTimeEditorViewController.h"


@implementation DateTimeEditorViewController

@synthesize textValue, dateEditing, dateValue, textField, dateFormatter, timeFormatter;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Create a date formatter to convert the date to a string format.
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
        [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
		
		
		// Create a date formatter to convert the date to a string format.
        timeFormatter = [[NSDateFormatter alloc] init];
        [timeFormatter setDateStyle:NSDateFormatterNoStyle];
        [timeFormatter setTimeStyle:NSDateFormatterShortStyle];
    }
    return self;
}

- (void)viewDidLoad {
    // Adjust the text field size and font.
    CGRect frame = textField.frame;
    frame.size.height += 10;
    textField.frame = frame;
    textField.font = [UIFont boldSystemFontOfSize:16];
    // Set the view background to match the grouped tables in the other views.
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc {
    [dateFormatter release];
    [datePicker release];
    [textValue release];
    [dateValue release];
    [super dealloc];
}

- (IBAction)cancel:(id)sender {
    // cancel edits
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)save:(id)sender {
    // save edits
    if (dateEditing) {
		
		
    } else {
       
		
    }
    [self.navigationController popViewControllerAnimated:YES];
}

//
// Initialize the view
//
- (void)viewWillAppear:(BOOL)animated {
    
    if (dateEditing) {
		self.title = @"Edit Date";
        textField.enabled = NO;
        if (dateValue == nil) self.dateValue = [NSDate date];
        textField.text = [dateFormatter stringFromDate:dateValue];
        datePicker.date = dateValue;
    } else {
		self.title = @"Edit Time";
        textField.enabled = NO;
        if (dateValue == nil) self.dateValue = [NSDate date];
        textField.text = [timeFormatter stringFromDate:dateValue];
        timePicker.date = dateValue;
    }
}

//
// Change the field holding the date
//
- (IBAction)dateChanged:(id)sender {
    if (dateEditing)
		textField.text = [dateFormatter stringFromDate:datePicker.date];
	else
		textField.text = [timeFormatter stringFromDate:timePicker.date];
}


@end

