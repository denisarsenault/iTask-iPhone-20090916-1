//
//  TaskListViewController.h
//  iTask-iPhone
//
//  Created by Denis Arsenault on 12/5/08.
// 
//

#import <UIKit/UIKit.h>

@class TaskViewController, AddTaskViewController, PreferencesViewController, Task, QuickTaskView;

@interface TaskListViewController : UIViewController <UITextFieldDelegate, UIAccelerometerDelegate, UITableViewDelegate, UITableViewDataSource> {
	IBOutlet UITableView *tableView;
    UINavigationController *addNavigationController;
	TaskViewController *taskViewController;
	PreferencesViewController *preferencesViewController;
	AddTaskViewController *addTaskViewController;
	
	UIView	*addTaskButtonsView;
	IBOutlet QuickTaskView	*quickTaskView;
	
	UIButton* addTaskButton;
	UIButton* quickTaskButton;
	
	IBOutlet UIBarButtonItem	*saveButtonItem;
	BOOL	noRowSelecting;
	BOOL beenhere;
	BOOL shake;

}

@property (nonatomic, assign) BOOL beenhere;
@property (nonatomic, assign) BOOL shake;

- (IBAction)completeChanged:(id)sender;
- (IBAction)addTask:(id)sender;
- (IBAction)editPreferences:(id)sender;

// When the user clicks the quick task, they need to hit the save button to save it.

- (IBAction)quickAddTask:(id)sender;
- (IBAction)save:(id)sender;
- (IBAction)cancel:(id)sender;

@end
