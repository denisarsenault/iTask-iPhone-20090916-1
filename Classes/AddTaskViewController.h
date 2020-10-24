//
//  AddTaskViewController.h
//  iTask-iPhone
//
//  Created by Denis Arsenault on 12/5/08.
//  
//

#import <UIKit/UIKit.h>

@class Task, TitleCell, LabelValueCell, SegmentedControlCell, DateFieldCell, TextViewCell, CustomUISwitch, AlarmCell;

@interface AddTaskViewController : UITableViewController <UITextFieldDelegate, UIAccelerometerDelegate, UITextViewDelegate, UIActionSheetDelegate >{
	Task *task;
	
	NSDateFormatter *dateFormatter;
    NSIndexPath *selectedIndexPath;
	
	// Cells for Form like editing
	TitleCell	*titleCell;
	
	CustomUISwitch	*completedSwitch;
	
	SegmentedControlCell	*priorityCell;
	
	DateFieldCell	*dueDateCell;
	
	NSMutableArray  *alarmCells;
	
	LabelValueCell	*calendarCell;
	LabelValueCell	*urlCell;
	TextViewCell	*notesCell;
	
//	UIButton		*deleteButton;
	
	NSIndexPath* noteIndexPath;
	NSInteger		numRows;
	
	BOOL		taskNewFlag;
	
	BOOL addbeenhere;
	BOOL addshake;
}

- (void)dialogOKCancelAction;
- (void)keyboardDidShow:(NSNotification *)notif;
- (void)keyboardDidHide:(NSNotification *)notif;

- (void)delete: (id) sender;

// Expose the task property to other objects (the AddTaskListViewController).
@property (nonatomic, assign) Task *task;
@property (nonatomic, assign) NSInteger		numRows;

@property (nonatomic, assign) BOOL addbeenhere;
@property (nonatomic, assign) BOOL addshake;

- (IBAction)cancel:(id)sender;
- (IBAction)save:(id)sender;

@end

