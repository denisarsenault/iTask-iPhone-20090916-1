//
//  TextViewEditingController.h
//  iTask-iPhone
//
//  Created by Denis Arsenault on 12/11/08.
//  
//

#import <UIKit/UIKit.h>


@interface TextViewEditingController : UIViewController {
	NSString *textValue;
    id editedObject;
    NSString *editedFieldKey;
    IBOutlet UITextView *textView;
}

@property (nonatomic, retain) id editedObject;
@property (nonatomic, retain) NSString *textValue;
@property (nonatomic, retain) NSString *editedFieldKey;
@property (nonatomic, readonly) UITextView *textView;

- (IBAction)cancel:(id)sender;
- (IBAction)save:(id)sender;

@end
