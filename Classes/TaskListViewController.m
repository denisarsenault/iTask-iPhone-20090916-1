//
//  TaskListViewController.m
//  iTask-iPhone
//
//  Created by Denis Arsenault on 12/5/08.
//  
// 1/7/09 - 1/14/09 DLA Fixed Add, Edit, Delete, memory management... etc... bugs and problems
// 1/15/2009 DLA fixed bugs related to scrolling and screen refresh

#import "TaskListViewController.h"
#import	"iTaskAppDelegate.h"
#import "TaskViewController.h"
#import "PreferencesViewController.h"
#import "AddTaskViewController.h"
#import "Task.h"
#import "TaskListCell.h"
#import "QuickTaskView.h"
//#import "Preferences.h"

// Private interface for MasterViewController - internal only methods.
@interface TaskListViewController ()

@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, retain) UINavigationController *addNavigationController;
@property (nonatomic, retain) TaskViewController *taskViewController;
@property (nonatomic, retain) PreferencesViewController *preferencesViewController;
@property (nonatomic, retain) AddTaskViewController *addTaskViewController;
@property (nonatomic, retain) UIView	*addTaskButtonsView;
@property (nonatomic, retain) UIBarButtonItem	*saveButtonItem;
@end

@implementation TaskListViewController

@synthesize tableView, addNavigationController, taskViewController, preferencesViewController, addTaskViewController, addTaskButtonsView, saveButtonItem;
@synthesize beenhere, shake;
//
//
//

+ (UIButton *)buttonWithTitle:	(NSString *)title
					   target:(id)target
					 selector:(SEL)selector
						frame:(CGRect)frame
						image:(UIImage *)image
				 imagePressed:(UIImage *)imagePressed
				darkTextColor:(BOOL)darkTextColor
{	
	UIButton *button = [[UIButton alloc] initWithFrame:frame];
	// or you can do this:
	//		UIButton *button = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
	//		button.frame = frame;
	
	button.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
	button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
	
	[button setTitle:title forState:UIControlStateNormal];	
	if (darkTextColor)
	{
		[button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
	}
	else
	{
		[button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	}
	
	UIImage *newImage = [image stretchableImageWithLeftCapWidth:12.0 topCapHeight:0.0];
	[button setBackgroundImage:newImage forState:UIControlStateNormal];
	
	UIImage *newPressedImage = [imagePressed stretchableImageWithLeftCapWidth:12.0 topCapHeight:0.0];
	[button setBackgroundImage:newPressedImage forState:UIControlStateHighlighted];
	
	[button addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
	
    // in case the parent view draws with a custom color or gradient, use a transparent color
	
	button.backgroundColor = [UIColor clearColor];
	
	return button;
}

//
// This builds the Navigation bar on MainWindow
//

- (id)initWithCoder:(NSCoder *)decoder{
    if (self = [super initWithCoder:decoder]) {
        // Title displayed by the navigation controller.
        self.title = @"iTask List";
        
		// initing the loading view
		// Should be a Xib resource
		
		CGRect frame = CGRectMake(0.0, 0.0, 110.0, 50.0);
	    UIView *addTaskButtons = [[[UIView alloc] initWithFrame:frame] autorelease];
		
		//	addTaskButtons.backgroundColor = [UIColor redColor];
		
		UIImage *buttonBackground = [UIImage imageNamed:@"quickadd.png"];
		UIImage *buttonBackgroundPressed = [UIImage imageNamed:@"blueButton.png"];
		buttonBackgroundPressed = nil;
		
		// add the quick task button
		CGRect buttonFrame = CGRectMake(30.0, 10.0, 33.0, 29.0);
		quickTaskButton = [TaskListViewController buttonWithTitle:@""
														   target:self
														 selector:@selector(quickAddTask:)
															frame:buttonFrame
															image:buttonBackground
													 imagePressed:buttonBackgroundPressed
													darkTextColor:YES];
		//	[quickTaskButton setImage:[UIImage imageNamed:@"UIButton_custom.png"] forState:UIControlStateNormal];
		[addTaskButtons addSubview:quickTaskButton];
		
		buttonBackground = [UIImage imageNamed:@"addTask.png"];
		//add the add task button
		buttonFrame = CGRectMake(75.0, 10.0, 33.0, 29.0);
		addTaskButton = [TaskListViewController buttonWithTitle:@""
														 target:self
													   selector:@selector(addTask:)
														  frame:buttonFrame
														  image:buttonBackground
												   imagePressed:buttonBackgroundPressed
												  darkTextColor:YES];
		
		[addTaskButtons addSubview:addTaskButton];		
		self.addTaskButtonsView = addTaskButtons;
		
		// initing the bar button
		UIBarButtonItem *addButtonsView = [[[UIBarButtonItem alloc] initWithCustomView:addTaskButtons] autorelease];
		addButtonsView.target = self;
		self.navigationItem.rightBarButtonItem = addButtonsView;

    }
    return self;
}

//
//
//

- (void)dealloc {
    // Release allocated resources.
    [tableView release];
    [addNavigationController release];
	[taskViewController release];
	[addTaskViewController release];
	[taskViewController release];
    [super dealloc];
}

//
// Set up the user interface.
//

- (void)viewDidLoad {
	// self.navigationItem.leftBarButtonItem = self.editButtonItem;

}

//
// Update the table before the view displays.
//

- (void)viewWillAppear:(BOOL)animated {
	// Turn on the Accelerometer
	[[UIAccelerometer sharedAccelerometer] setUpdateInterval:(1.0 / 40)];
    [[UIAccelerometer sharedAccelerometer] setDelegate:self];
	
	noRowSelecting = FALSE;
	iTaskAppDelegate *appDelegate = (iTaskAppDelegate *)[[UIApplication sharedApplication] delegate];
	[appDelegate readPreferences];
	[appDelegate updateTaskList];
	[self.tableView reloadData];
}

//
//
//

- (IBAction)completeChanged:(id)sender{
	shake = FALSE;
	iTaskAppDelegate *appDelegate = (iTaskAppDelegate *)[[UIApplication sharedApplication] delegate];
	
	[appDelegate updateTaskList];
	[self.tableView reloadData];
	
}

// ***************************************
// This method generated the QuickAddTask
// ***************************************

- (IBAction)quickAddTask:(id)sender {
	
	// Set the Accelerometer flag
	beenhere = FALSE;
	
	//	Display the quick task view
	[self.view addSubview:quickTaskView];
	
	// Repositions and resizes the view.
	CGRect tableRect = CGRectMake(0, 80, 320, 292);
	self.tableView.bounds = tableRect;	
	
	quickTaskView.titleField.clearButtonMode = UITextFieldViewModeWhileEditing;
	quickTaskView.titleField.font = [UIFont systemFontOfSize:18.0];
	
	//disable row selecting
	noRowSelecting = TRUE;
	
	//Reload the table view
	[self.tableView reloadData];
	
	CGRect frame = [self.tableView bounds];
	frame = CGRectMake(0.0, 0.0, frame.size.width, 10);
	[self.tableView scrollRectToVisible:frame animated:NO];
	
	
	[self.tableView setNeedsDisplay];
	
	//bring up the keyboard
	[quickTaskView.titleField becomeFirstResponder];
	
	UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] init];
	cancelButton.title = @"Cancel";
	cancelButton.target = self;
	cancelButton.action = @selector(cancel:);
	self.navigationItem.leftBarButtonItem = cancelButton;
	// Release manually added objects
	[cancelButton release];
}

// ***************************************
// This method hides the QuickAddTask View
// ***************************************

- (void)removeQuickTaskView
{
	noRowSelecting = FALSE;	
	[quickTaskView removeFromSuperview];
	
	// Repositions and resizes the view.
	CGRect tableRect = CGRectMake(0, 0, 320, 372);
	self.tableView.bounds = tableRect;

	//Reload the table view
	[self.tableView reloadData];
	
	self.navigationItem.leftBarButtonItem = nil;

}

// ***************************************
// Cancel button for removing the QuickAddTask View
// ***************************************

- (IBAction)cancel:(id)sender{

	[quickTaskView.titleField resignFirstResponder];
	[self removeQuickTaskView];
	beenhere = TRUE;
}

// ***************************************
// This will save the quick add task 
// ***************************************

- (IBAction)save:(id)sender{
	
	iTaskAppDelegate *appDelegate = (iTaskAppDelegate *)[[UIApplication sharedApplication] delegate];
	
	NSNumber *priority = appDelegate.defaultPriority;
	NSDate	*dueDate = nil;
	
	// create a new task
	NSDate  *testDate = appDelegate.defaultDueDate;
	if(testDate)
	{
		NSTimeInterval since1970  = [testDate timeIntervalSince1970];
		dueDate = [NSDate dateWithTimeIntervalSince1970:since1970];
	}
	
	Task* task = [[Task alloc] initWithDueDate:dueDate priority:priority];
	
	// set the task title
    task.title = quickTaskView.titleField.text;
	
	// insert the task
	
	[appDelegate addTask:task];
	beenhere = TRUE;
	[self removeQuickTaskView];
	
	// initing the bar button
//	UIBarButtonItem *addButtonsView = [[UIBarButtonItem alloc] initWithCustomView:addTaskButtonsView];
//	addButtonsView.target = self;
//	self.navigationItem.rightBarButtonItem = addButtonsView;

//	[task release];
	
//	noRowSelecting = FALSE;
	

}

//******************************************************************************************************
//
// Add Task view controller
//
//******************************************************************************************************

- (IBAction)addTask:(id)sender {
	
    AddTaskViewController *controller = self.addTaskViewController;
    
	iTaskAppDelegate *appDelegate = (iTaskAppDelegate *)[[UIApplication sharedApplication] delegate];
	
	NSNumber *priority = appDelegate.defaultPriority;
	NSDate	*dueDate = nil;
	
	NSDate  *testDate = appDelegate.defaultDueDate;
	if(testDate)
	{
		NSTimeInterval since1970  = [testDate timeIntervalSince1970];
		dueDate = [NSDate dateWithTimeIntervalSince1970:since1970];
	}
	
	
   /*
	if (addNavigationController == nil) {
        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:controller];
        self.addNavigationController = navController;
        [navController release];
    }
	*/
	
	controller.task = [[Task alloc] initWithDueDate:dueDate priority:priority];
	controller.numRows = 4;
	
	[self.navigationController pushViewController:controller animated:YES];

   // [self.navigationController presentModalViewController:addNavigationController animated:YES];
  //  [controller setEditing:NO animated:NO];
	
}

//******************************************************************************************************
//
// Allocate the Taskview Controller for Editing a task
//
//******************************************************************************************************

- (TaskViewController *)taskViewController {
    // Instantiate the task view controller if necessary.
    if (taskViewController == nil) {
        taskViewController = [[TaskViewController alloc] initWithNibName:@"TaskView" bundle:nil];
    }
	//[taskViewController autorelease];
    return taskViewController;
}

//******************************************************************************************************
//
// Allocate the AddTaskview Controller for Adding a task
//
//******************************************************************************************************

- (AddTaskViewController *)addTaskViewController {
    // Instantiate the add view controller if necessary.
    if (addTaskViewController == nil) {
        addTaskViewController = [[AddTaskViewController alloc] initWithNibName:@"TaskView" bundle:nil];
    }
	//[addTaskViewController autorelease];
    return addTaskViewController;
}

#pragma mark Table Delegate and Data Source Methods

//******************************************************************************************************
// These methods are all part of either the UITableViewDelegate or UITableViewDataSource protocols.
//
// Thie number of table sections are determined by the users preferences.
//******************************************************************************************************

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tv {
	iTaskAppDelegate *appDelegate = (iTaskAppDelegate *)[[UIApplication sharedApplication] delegate];
	
	return appDelegate.tasksArray.count;
}

//******************************************************************************************************
//
// For each section there is an array of tasks.
//
//******************************************************************************************************

- (NSInteger)tableView:(UITableView *)tv numberOfRowsInSection:(NSInteger)section {
    iTaskAppDelegate *appDelegate = (iTaskAppDelegate *)[[UIApplication sharedApplication] delegate];
    
	NSDictionary *item = [appDelegate.tasksArray objectAtIndex:section];
	NSArray *taskItems = [item objectForKey:@"Data"];
	
	return taskItems.count;
}

//******************************************************************************************************
//
// This generates the section list
//
//******************************************************************************************************

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
	
	iTaskAppDelegate *appDelegate = (iTaskAppDelegate *)[[UIApplication sharedApplication] delegate];
	
	if(appDelegate.showTableHeaders){
		NSDictionary *item = [appDelegate.tasksArray objectAtIndex:section];
		NSArray *taskItems = [item objectForKey:@"Data"];
		if ([taskItems count] > 0)
			return 24.0f;
		else
			return 0.0f;
	}else{
		return 0.0f;
	}
	
	return 24.0f;
}

//******************************************************************************************************
// 
// This generates the headers for sections
//
//******************************************************************************************************

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	
	iTaskAppDelegate *appDelegate = (iTaskAppDelegate *)[[UIApplication sharedApplication] delegate];
    
	NSString *headerTitle;
	
	if(appDelegate.showTableHeaders){
		NSDictionary *item = [appDelegate.tasksArray objectAtIndex:section];
		headerTitle =  [item objectForKey:@"Heading"];
	}else{
		headerTitle = @"";
	}
	
	return headerTitle;
}

//setDataSource
//
// 
//

- (UITableViewCellAccessoryType)tableView:(UITableView *)tv accessoryTypeForRowWithIndexPath:(NSIndexPath *)indexPath {
    // Show the disclosure indicator if editing.
    return UITableViewCellAccessoryDisclosureIndicator;
}

//******************************************************************************************************
//
// This is the method for entry point to identify the cell
//
//******************************************************************************************************

- (UITableViewCell *)tableView:(UITableView *)tv cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    TaskListCell *cell = (TaskListCell *)[self.tableView dequeueReusableCellWithIdentifier:@"TASK_CELL"];
    if (cell == nil) {
        // Create a new cell. CGRectZero allows the cell to determine the appropriate size.
        cell = [[[TaskListCell alloc] initWithFrame:CGRectZero reuseIdentifier:@"TASK_CELL"] autorelease];
    }
	

	UIImage *image = [UIImage imageNamed:@"checked.png"];
	UIImage *newImage = [image stretchableImageWithLeftCapWidth:12.0 topCapHeight:0.0];

	// currentBackgroundImage
	
	if (cell.checkButton.currentImage == nil){
		[cell.checkButton setBackgroundImage:newImage forState:UIControlEventTouchDown];
	}else{
		UIImage *image = [UIImage imageNamed:@"unchecked.png"];
		UIImage *newImage = [image stretchableImageWithLeftCapWidth:12.0 topCapHeight:0.0];
		[cell.checkButton setBackgroundImage:newImage forState:UIControlEventTouchDown];
	}

	
	// Retrieve the task object matching the row from the application delegate's array.
	iTaskAppDelegate *appDelegate = (iTaskAppDelegate *)[[UIApplication sharedApplication] delegate];
	NSDictionary *item = [appDelegate.tasksArray objectAtIndex:indexPath.section];
	NSArray *taskItems = [item objectForKey:@"Data"];
	Task *task = (Task *)[taskItems objectAtIndex:indexPath.row];
	
	cell.task = task;
	
	[cell.checkButton addTarget:self action:@selector(completeChanged:)  forControlEvents:UIControlEventTouchUpInside];
	
	[cell task];
	
	return cell;
}

//******************************************************************************************************
//
// This is the returned cell
//
//******************************************************************************************************

- (void)tableView:(UITableView *)tv didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	[tv deselectRowAtIndexPath:indexPath animated:YES];	
}

//******************************************************************************************************
//
// This will allow us to Edit an individual task
//
//******************************************************************************************************

- (NSIndexPath *)tableView:(UITableView *)tv willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	if(noRowSelecting == TRUE) return indexPath;
	
	// Retrieve the task object matching the row from the application delegate's array.
    iTaskAppDelegate *appDelegate = (iTaskAppDelegate *)[[UIApplication sharedApplication] delegate];
	
	// No retrieve the current task in this View Controller
    NSDictionary *item = [appDelegate.tasksArray objectAtIndex:indexPath.section];
	NSArray *taskItems = [item objectForKey:@"Data"];
	// This returns the task to be edited
	Task *task = (Task *)[taskItems objectAtIndex:indexPath.row];
	
    TaskViewController *controller = self.taskViewController;
	
    // Set the detail controller's inspected item to the currently-selected task.
    controller.task = task;
	controller.numRows = 4;
    // "Push" the detail view on to the navigation controller's stack.
    [self.navigationController pushViewController:controller animated:YES];

    return nil;
}

//
// This is the standard delete gesture response !!!!!
//

- (void)tableView:(UITableView *)tv commitEditingStyle:(UITableViewCellEditingStyle)editingStyle 
forRowAtIndexPath:(NSIndexPath *)indexPath {
	
    // If row is deleted, remove it from the list.
    if (editingStyle == UITableViewCellEditingStyleDelete) {
		// Retrieve the task object matching the row from the application delegate's array.
		iTaskAppDelegate *appDelegate = (iTaskAppDelegate *)[[UIApplication sharedApplication] delegate];
		NSDictionary *item = [appDelegate.tasksArray objectAtIndex:indexPath.section];
		NSArray *taskItems = [item objectForKey:@"Data"];
		// This returns the task to be edited
		Task *task = (Task *)[taskItems objectAtIndex:indexPath.row];
	
		[appDelegate removeTask:task];
		
		[self.tableView reloadData];
        
    }
}

//
// This method catches the return action
//

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	iTaskAppDelegate *appDelegate = (iTaskAppDelegate *)[[UIApplication sharedApplication] delegate];
	
	NSNumber *priority = appDelegate.defaultPriority;
	NSDate	*dueDate = nil;
	
	// create a new task
	NSDate  *testDate = appDelegate.defaultDueDate;
	if(testDate)
	{
		NSTimeInterval since1970  = [testDate timeIntervalSince1970];
		dueDate = [NSDate dateWithTimeIntervalSince1970:since1970];
	}
	
	if(textField.text.length > 0){
		Task* task = [[Task alloc] initWithDueDate:dueDate priority:priority];
		// set the task title
		task.title = textField.text;
		// insert the task if there is a valid titke
		[appDelegate addTask:task];
	}
	
	[textField resignFirstResponder];
	
	[self removeQuickTaskView];	
	
	return YES;
}

//
// This method will catch Accelerometer events for TasklistViewController
//

- (void)accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration {
	const float violence = 1.5;
	shake = FALSE;
	
	if (beenhere) {
		return;
	} else {
		if (acceleration.x > violence * 1.5 || acceleration.x < (-1.5* violence))
			shake = TRUE;
		if (acceleration.y > violence * 2 || acceleration.y < (-2 * violence))
			shake = TRUE;
		if (acceleration.z > violence * 3 || acceleration.z < (-3 * violence))
			shake = TRUE;
		if (shake) {
			if(noRowSelecting == FALSE) {// not adding a quicktask
				beenhere = TRUE;
				[self save:self];
			}else{ // For Quick add View only
				if(quickTaskView.titleField.text.length > 0){
					beenhere = TRUE;
					[self save:self];
				} else {
					beenhere = TRUE;				
					[self cancel:self];		
				}
			}
			
		}
			
	} 

}

//******************************************************************************************************
//
// Edit Preferences view controller
//
//******************************************************************************************************

- (IBAction)editPreferences:(id)sender { 
	
	PreferencesViewController *controller = self.preferencesViewController;

	controller.numRows = 4;
    // "Push" the detail view on to the navigation controller's stack.
	[self.navigationController pushViewController:controller animated:YES];
}
//******************************************************************************************************
//
// Allocate the Preferences view Controller for Preferences
//
//******************************************************************************************************

- (PreferencesViewController *)preferencesViewController {
    // Instantiate the task view controller if necessary.
    if (preferencesViewController == nil) {
        preferencesViewController = [[PreferencesViewController alloc] initWithNibName:@"PreferencesView" bundle:nil];
    }
    return preferencesViewController;
	[preferencesViewController release];
}
@end
