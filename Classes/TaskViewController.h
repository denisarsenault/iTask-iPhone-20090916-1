//
//  TaskViewController.h
//  iTask-iPhone
//
//  Created by Denis Arsenault on 12/5/08.
//  
//

#import <UIKit/UIKit.h>

@class Task, TitleCell, LabelValueCell, SegmentedControlCell, DateFieldCell, TextViewCell, CustomUISwitch, AlarmCell;

@interface TaskViewController : UITableViewController <UITextFieldDelegate, UIAccelerometerDelegate, UITextViewDelegate, UIActionSheetDelegate >{
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
	
	UIButton		*deleteButton;
	
	NSIndexPath* noteIndexPath;
	NSInteger		numRows;
	NSInteger		delRow;
	
	BOOL beenhere;
	BOOL shake;
	
}

@property (nonatomic, assign) BOOL beenhere;
@property (nonatomic, assign) BOOL shake;

- (void)dialogOKCancelAction;
- (void)keyboardDidShow:(NSNotification *)notif;
- (void)keyboardDidHide:(NSNotification *)notif;

- (void)delete: (id) sender;

// Expose the task property to other objects (the TaskListViewController).
@property (nonatomic, assign) Task *task;
@property (nonatomic, assign) NSInteger		numRows;
@property (nonatomic, assign) NSInteger	    delRow ;

@end
