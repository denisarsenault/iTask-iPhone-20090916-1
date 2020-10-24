//
//  TextViewEditingController.m
//  iTask-iPhone
//
//  Created by Denis Arsenault on 12/11/08.
//  Copyright 2008 Mybrightzone. All rights reserved.
//

#import "TextViewEditingController.h"


@implementation TextViewEditingController

@synthesize textValue, editedObject, editedFieldKey, textView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
	}
    return self;
}

- (void)viewDidLoad {
    // Adjust the text field size and font.
    CGRect frame = textView.frame;
    frame.size.height += 10;
    textView.frame = frame;
    textView.font = [UIFont boldSystemFontOfSize:16];
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc {
    [textValue release];
    [editedObject release];
    [editedFieldKey release];
    [super dealloc];
}

- (IBAction)cancel:(id)sender {
    // cancel edits
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)save:(id)sender {
    // save edits
	[editedObject setValue:textView.text forKey:editedFieldKey];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    NSString *capitalizedKey = [editedFieldKey capitalizedString];
    self.title = capitalizedKey;
   
	textView.text = textValue;
	[textView becomeFirstResponder];
}

@end

