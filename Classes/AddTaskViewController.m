//
//  AddTaskViewController.m
//  iTask-iPhone
//
//  Created by Denis Arsenault on 12/5/08.
//  
//

#import "AddTaskViewController.h"
#import "TitleCell.h"
#import "LabelValueCell.h"
#import "SegmentedControlCell.h"
#import "DateFieldCell.h"
#import "AlarmCell.h"
#import "TextViewCell.h"
#import "Task.h"
#import "Alarm.h"
#import "TaskListViewController.h"
#import "EditingViewController.h"
#import	"AlarmEditingViewController.h"
#import	"TextViewEditingController.h"
#import "CalendarListController.h"
#import	"CustomUISwitch.h"

#import "iTaskAppDelegate.h"

#define KEYBOARD_HEIGHT_LANDSCAPE 160

//
// Private Methods
//

@interface AddTaskViewController ()

@property (nonatomic, retain) NSDateFormatter *dateFormatter;
@property (nonatomic, retain) NSIndexPath *selectedIndexPath;

@end

@implementation AddTaskViewController

@synthesize task, numRows, dateFormatter, selectedIndexPath;
@synthesize addbeenhere, addshake;
//
//
//
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Title displayed by the navigation controller.
        self.title = @"Add iTask";
        // Create a date formatter to convert the date to a string format.
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
        [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
		
		if (!titleCell) {
			titleCell = [[TitleCell alloc] initWithFrame:CGRectZero reuseIdentifier:@"TitleCell"];
			titleCell.titleField.delegate = self;
		}
		
		if (!completedSwitch) {
			completedSwitch = [[CustomUISwitch alloc] initWithFrame:CGRectZero];
			[completedSwitch setCenter:CGPointMake(160.0f,230.0f)];
			[completedSwitch setLeftLabelText: @"YES"];
			[completedSwitch setRightLabelText: @"NO"];
			[completedSwitch addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];
		}
		
		if (!priorityCell) {
			NSArray *priorityContent = [NSArray arrayWithObjects:@"High", @"Med", @"Low", @" - ",  nil];
			priorityCell = [[SegmentedControlCell alloc] initWithFrame:CGRectZero reuseIdentifier:@"PriorityCell" items:priorityContent];
			[priorityCell.segmentedControlView addTarget:self action:@selector(segmentControlChanged:) forControlEvents:UIControlEventValueChanged];
		}
		
		if (!dueDateCell) {
			dueDateCell = [[DateFieldCell alloc] initWithFrame:CGRectZero reuseIdentifier:@"DueDateCell"];
		}
		
		if (!calendarCell) {
			calendarCell = [[LabelValueCell alloc] initWithFrame:CGRectZero reuseIdentifier:@"CalendarCell"];
		}
		
		if (!urlCell) {
			urlCell = [[LabelValueCell alloc] initWithFrame:CGRectZero reuseIdentifier:@"URLCell"];
		}
		
		if (!notesCell) {
			notesCell = [[TextViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:@"NotesCell"];
			notesCell.textView.delegate = self;
		}
		
    }
    return self;
}

//
//
//
- (void)dealloc {
    // Release owned resources.
	[alarmCells release];
	[titleCell release];
	[completedSwitch release];
	[priorityCell release];
	[dueDateCell release];
	
	[calendarCell release];
	[urlCell release];
	[notesCell release];
	
    [selectedIndexPath release];
    [task release];
    [dateFormatter release];
    [super dealloc];
}

//
// This produces the Add view 
//

- (void)viewDidLoad {
    [super viewDidLoad];
	// Override the DetailViewController viewDidLoad with different navigation bar items and title
    self.title = @"Add iTask";
	self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel 
																						   target:self action:@selector(cancel:)] autorelease];
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave 
																							target:self action:@selector(save:)] autorelease];

	}
//
// This populates the Add View
//
- (void)viewWillAppear:(BOOL)animated {
	// Turn on the Accelerometer 
	[[UIAccelerometer sharedAccelerometer] setUpdateInterval:(1.0 / 40)];
	[[UIAccelerometer sharedAccelerometer] setDelegate:self];
	// Set Accelerometer Flag
	addbeenhere = FALSE;
	// Remove any existing selection.
	[self.tableView deselectRowAtIndexPath:selectedIndexPath animated:NO];
    // Redisplay the data.
	if(dueDateCell){
		if(task.dueDate)
			dueDateCell.value.text = [dateFormatter stringFromDate:task.dueDate];
		else
			dueDateCell.value.text = @"No Due Date";
	}
	if(urlCell)
		urlCell.value.text = task.URL;
	
	if(notesCell)
		notesCell.textView.text = task.notes;
	
	if(calendarCell){
		iTaskAppDelegate *appDelegate = (iTaskAppDelegate *)[[UIApplication sharedApplication] delegate];
		NSString *displayString = [appDelegate calDisplayFromUID:task.calendar];
		calendarCell.value.text = displayString;
	}
	
	int numAlarms = [alarmCells count];
	// alarms in the 
	for(int i=0; i< numAlarms-1; i++){
		//only update real alarms
		AlarmCell* alarmCell = [alarmCells objectAtIndex:i];
		alarmCell.alarm = [task.alarms objectAtIndex:i];
		alarmCell.dueDate = task.dueDate;
	}
	
	CGRect frame = [self.tableView bounds];
	frame = CGRectMake(0.0, 0.0, frame.size.width, 10);
	[self.tableView scrollRectToVisible:frame animated:NO];
	
    [self.tableView reloadData];
	
	// register for keyboard notifications
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:self.view.window];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:self.view.window];
	
}
/*
 - (void)viewDidAppear:(BOOL)animated {
 [super viewDidAppear:animated];
 }
*/

//
// This handles the local ADD viewWillDisappear, remember that in the hierarchy there is a parent
//



- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];

	if(task){
		// set the title based on current cell contents.
		task.title = titleCell.titleField.text;
		[titleCell.titleField resignFirstResponder];
		
		// set the title based on current cell contents.
		task.URL = urlCell.value.text;
		
		// set the title based on current cell contents.
		task.notes = notesCell.textView.text;

		 }

	[[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil]; 
	[[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidHideNotification object:nil]; 
	[[UIAccelerometer sharedAccelerometer] setDelegate:NULL];
	addbeenhere = TRUE;
}


- (void)keyboardDidShow:(NSNotification *)notif {
	// grab the keyboard height and save it
	CGRect keyboardRect;
	[[[notif userInfo] objectForKey:UIKeyboardBoundsUserInfoKey] getValue:&keyboardRect];
	
}

- (void)keyboardDidHide:(NSNotification *)notif {
	// grab the keyboard height and save it
	CGRect keyboardRect;
	[[[notif userInfo] objectForKey:UIKeyboardBoundsUserInfoKey] getValue:&keyboardRect];
	

	
}

// The SetTask Object 
// we implement this because the tables custom cell values need
// to be updated when this property changes, and this allows
// for the changes to be encapsulated

- (void)setTask:(Task *)aTask {
	
	task = aTask;
	
	titleCell.label.text = NSLocalizedString( @"Title", @"");
    titleCell.titleField.text = [task title];
	
	BOOL complete = task.completionDate != nil;
    [completedSwitch setOn:complete animated:NO];
	
	
	switch ([task.priority intValue])
	{
		case PriorityHigh: 
			priorityCell.segmentedControlView.selectedSegmentIndex = 0;
			break;
		case PriorityMedium: 
			priorityCell.segmentedControlView.selectedSegmentIndex = 1;
			break;
		case PriorityLow: 
			priorityCell.segmentedControlView.selectedSegmentIndex = 2;
			break;
		case PriorityNone: 
			priorityCell.segmentedControlView.selectedSegmentIndex = 3; 
			break;
		default:
			priorityCell.segmentedControlView.selectedSegmentIndex = 3;
			break;
	}
	
	dueDateCell.label.text = NSLocalizedString( @"Due Date", @"");
    dueDateCell.value.text = [dateFormatter stringFromDate:task.dueDate];
	
	// we need an alarm cell for each alarm + 1 to add a new one.
	if(alarmCells){
		[alarmCells release];
		alarmCells = nil;
	}
	
	alarmCells = [[NSMutableArray alloc] init];
	
	int numAlarms = [task.alarms count];
	
	// alarms in the 
	for(int i=0; i< numAlarms; i++){
		NSString* resuseString = [[NSString alloc] initWithFormat:@"AlarmCell=%d", i];
		AlarmCell* alarmCell = [[AlarmCell alloc] initWithFrame:CGRectZero reuseIdentifier:resuseString];
		alarmCell.alarm = [task.alarms objectAtIndex:i];
		alarmCell.dueDate = task.dueDate;
		[alarmCells addObject:alarmCell];
	}
	// add the cell for the user to add a new alarm.
	AlarmCell* alarmCell = [[AlarmCell alloc] initWithFrame:CGRectZero reuseIdentifier:@"AlarmCell-None"];
	[alarmCells addObject:alarmCell];
	
	//
	//
	//
	
	calendarCell.label.text = NSLocalizedString(@"Calendar", @"");
    
	iTaskAppDelegate *appDelegate = (iTaskAppDelegate *)[[UIApplication sharedApplication] delegate];
	NSString *displayString = [appDelegate calDisplayFromUID:task.calendar];
	
	calendarCell.value.text = displayString;
	
	//
	// URL
	//
	
	urlCell.label.text = NSLocalizedString(@"URL", @"");
    urlCell.value.text = [task URL];
	
	notesCell.label.text = NSLocalizedString(@"Notes", @"");
    notesCell.textView.text = [task notes];
	
}

//
// This can be removed after QA
//

- (void)delete: (id) sender{
	[self dialogOKCancelAction];
}

//
// This removes an individual tasks
//

- (void)deleteTask{
	iTaskAppDelegate *appDelegate = (iTaskAppDelegate *)[[UIApplication sharedApplication] delegate];
	[appDelegate removeTask:task];
	[self.navigationController popViewControllerAnimated:YES];
	
}

//
//
//

- (void)dialogOKCancelAction
{
	// open a dialog with an OK and cancel button
	UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Confirm Delete"
															 delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"OK" otherButtonTitles:nil];
	actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
	[actionSheet showInView:self.view]; // show from our table view (pops up in the middle of the table)
	[actionSheet release];
}

#pragma mark -
#pragma mark <UITableViewDelegate, UITableViewDataSource> Methods

//
//
//

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return self.numRows;
}

//
//
//

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	
	NSInteger result = 0;
	
	if(section == 0)
		result =  2;
	else if(section ==  1){
		result = [task.alarms count] + 2;
	}else if(section ==  2)
		result =  3;
	else if(section ==  3)
		result =  1;
	
	return result;
}

//
//
//

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
	// Recover section and row info
	NSInteger row = [indexPath row];
	NSInteger section = [indexPath section];
	
	if(section == 0 && row == 0){
		return titleCell;
	}
	if(section == 0 && row == 1){
		
		// Pull the cell
		UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"completed-cell"];
		
		// If there's a new cell needed, add a custom switch
		if (cell == nil) {
			
			cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:@"completed-cell"] autorelease];
			cell.indentationLevel = 5;
			
			// cell's  label
			UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
			label.backgroundColor = [UIColor clearColor];
			label.opaque = NO;
			label.textColor = [UIColor blackColor];
			label.highlightedTextColor = [UIColor whiteColor];
			label.font = [UIFont boldSystemFontOfSize:14.0];
			label.text = NSLocalizedString( @"Completed", @"");
			[cell addSubview:label];
			
			// cell's custom switch we hold on to this
			[cell addSubview:completedSwitch];
			
			// layout the controls
			CGRect contentRect = [cell.contentView bounds];
			CGRect frame = CGRectMake(contentRect.origin.x + 20.0, 5.0, 150, 30.0);
			label.frame = frame;
			
			frame = CGRectMake(contentRect.size.width - 110, 5.0, 94, 27.0);
			completedSwitch.frame= frame;
			
			//[label release];
			//[completedSwitch release];
		}
		return cell;
		
	}
	if(section == 1 && row == 0){
		return priorityCell;
	}
	
	if(section == 1 && row == 1){
		return dueDateCell;
	}
/*	if(section == 1 && row > 0){
		AlarmCell* alarmCell = [alarmCells objectAtIndex:row-1];
		return alarmCell;
	}*/
	
	if(section == 2 && row == 0){
		return calendarCell;
	}
	if(section == 2 && row == 1){
		return urlCell;
	}
	if(section == 2 && row == 2){
		return notesCell;
	}
	
	// delete button
	/*if(section == 3 && row == 0){
		
		// Pull the cell
		UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"delete-cell"];
		
		// If there's a new cell needed, add a custom switch
		if (cell == nil) {
			cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:@"delete-cell"] autorelease];
			cell.selectionStyle = UITableViewCellSelectionStyleGray;
			cell.indentationLevel = 5;
			
			[cell addSubview:deleteButton];
			//[deleteButton release];
		}
		return cell;
	}

	*/
	TitleCell *cell = (TitleCell *)[tableView dequeueReusableCellWithIdentifier:@"title-cell"];
	
	if (cell == nil) {
		// Create a new cell. CGRectZero allows the cell to determine the appropriate size.
		cell = (TitleCell *)[[[TitleCell alloc] initWithFrame:CGRectZero reuseIdentifier:@"title-cell"] autorelease];
	}

	return cell;

}

//
//
//

- (UITableViewCellAccessoryType)tableView:(UITableView *)tableView accessoryTypeForRowWithIndexPath:(NSIndexPath *)indexPath {
	
	NSInteger section = [indexPath section];
	NSInteger row = [indexPath row];
	
	if(section == 0 ){
		return UITableViewCellAccessoryNone;
	}
	
	if(section == 1 && row == 0){
		return UITableViewCellAccessoryNone;
	}
	
	if(section == 1 && row == 1){
		return UITableViewCellAccessoryDisclosureIndicator;
	}
	
	if(section == 2){
		return UITableViewCellAccessoryDisclosureIndicator;
	}
	
	return  UITableViewCellAccessoryNone;
}

//
//
//

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	[tableView deselectRowAtIndexPath:indexPath animated:YES];	
	// Recover section and row info
	NSInteger row = [indexPath row];
	NSInteger section = [indexPath section];
	
	//Due Date
	if(section == 1 && row == 1){
		EditingViewController *controller = [[EditingViewController alloc] initWithNibName:@"EditingView" bundle:nil];
		
		controller.editedObject = task;
		controller.dateValue = task.dueDate;
		controller.editedFieldKey = @"dueDate";
		controller.dateEditing = YES;
		
		self.selectedIndexPath = indexPath;
		[self.navigationController pushViewController:controller animated:YES];
		[controller release];	
	}

	/*	
	 //Alarms
	 if(section == 1 && row > 0){
	 
	 int numAlarms = [alarmCells count];
	 
	 if(row == numAlarms){
	 // the add alarm row
	 AlarmEditingViewController *controller = [[AlarmEditingViewController alloc] initWithNibName:@"AlarmEditingView" bundle:nil];
	 controller.dueDate = task.dueDate;
	 controller.alarm = [[Alarm alloc] initWithTaskID:task.taskID];
	 self.selectedIndexPath = indexPath;
	 [self.navigationController pushViewController:controller animated:YES];
	 
	 }else{
	 // if it is a message alarm, allow editing.
	 Alarm* alarm = [task.alarms objectAtIndex:row-1];
	 if(alarm.alarmActionType == alarmActionMessage){
	 // the add alarm row
	 AlarmEditingViewController *controller = [[AlarmEditingViewController alloc] initWithNibName:@"AlarmEditingView" bundle:nil];
	 controller.dueDate = task.dueDate;
	 controller.alarm = [task.alarms objectAtIndex:row-1];
	 self.selectedIndexPath = indexPath;
	 [self.navigationController pushViewController:controller animated:YES];			}
	 }

	 }
	 */
	//Calendar
	if(section == 2 && row == 0){
		CalendarListController *controller = [[CalendarListController alloc] initWithNibName:@"CalendarList" bundle:nil];
		iTaskAppDelegate *appDelegate = (iTaskAppDelegate *)[[UIApplication sharedApplication] delegate];
		
		controller.task = task;
		controller.calendarNames = appDelegate.calendarNames;
		
        [self.navigationController pushViewController:controller animated:YES];
		[controller release]; 	
	}
	

	//URL
	if(section == 2 && row == 1){
		EditingViewController *controller = [[EditingViewController alloc] initWithNibName:@"EditingView" bundle:nil];
		
		controller.editedObject = task;
		controller.textValue = task.URL;
		controller.editedFieldKey = @"URL";
		controller.dateEditing = NO;
		
		self.selectedIndexPath = indexPath;
		[self.navigationController pushViewController:controller animated:YES];
		[controller release];
	}
	
	//Notes
	if(section == 2 && row == 2){
		TextViewEditingController *controller = [[TextViewEditingController alloc] initWithNibName:@"TextViewEditingController" bundle:nil];
		
		controller.editedObject = task;
		controller.textValue = task.notes;
		controller.editedFieldKey = @"notes";
		
		self.selectedIndexPath = indexPath;
		[self.navigationController pushViewController:controller animated:YES];
		[controller release];	
	}
	/*
	if(section == 3 && row == 0){
		[self delete:self];
	}
	*/
}

//
//
//

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	CGFloat		result = 44.0f;
	
	// Recover section and row info
	NSInteger row = [indexPath row];
	NSInteger section = [indexPath section];
	
	if(section == 0 && row == 0){
		return 35.0f;
	}
	if(section == 0 && row == 1){
		return 35.0f;
	}
	if(section == 0 && row == 2){
		return 35.0f;
	}
	
	if(section == 1 && row == 0){
		return 35.0f;
	}
	
	if(section == 1 && row > 0){
		int numAlarms = [alarmCells count];
		if(row == numAlarms)
			return 35.0f;
		else
			return 70.0f;
	}
	
	if(section == 2 && row == 0){
		return 35.0f;
	}
	if(section == 2 && row == 1){
		return 35.0f;
	}
	if(section == 2 && row == 2){
		NSString*	text = nil;
		CGFloat		width = 0;
		CGFloat		tableViewWidth;
		CGRect		bounds = [UIScreen mainScreen].bounds;
		
		noteIndexPath = [indexPath copy];
		
		if (UIInterfaceOrientationIsPortrait(self.interfaceOrientation))
			tableViewWidth = bounds.size.width;
		else
			tableViewWidth = bounds.size.height;
		
		width = tableViewWidth - 110;		// fudge factor
		text = task.notes;
		
		if (text)
		{
			// The notes can be of any height
			// This needs to work for both portrait and landscape orientations.
			// Calls to the table view to get the current cell and the rect for the 
			// current row are recursive and call back this method.
			CGSize		textSize = { width, 20000.0f };		// width and height of text area
			CGSize		size = [text sizeWithFont:[UIFont systemFontOfSize:14.0] constrainedToSize:textSize lineBreakMode:UILineBreakModeWordWrap];
			
			result = 44 + MAX(size.height, 44.0f);	// at least one row for the label then the note (44-2000)
		}
	}

	return result;
}


#pragma mark -
#pragma mark Custom Cell Control Delegete Methods

//
// This method catches the return action from the Title Field
//
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	[textField resignFirstResponder];
	
	return YES;
}

// This method catches the return action
- (void)textFieldDidEndEditing:(UITextField *)textField
{
	[textField resignFirstResponder];
	
}

//
// This modifies the Completed Status
//
- (void) switchChanged: (UIControl *) sender
{
	UISwitch *mySwitch = (UISwitch*)sender;
	
	if(mySwitch == completedSwitch){
		// user edited the completion date
		if(mySwitch.on){
			task.completionDate = [NSDate date];
		}else{
			[task.completionDate release];
			task.completionDate = nil;
		}
	}
}

//
// This modifies the Priority
//
- (void) segmentControlChanged: (UIControl *) sender
{
	UISegmentedControl *mySegmentedControl = (UISegmentedControl*)sender;
	
	if(mySegmentedControl == priorityCell.segmentedControlView){
		// user edited the priority
		if( [mySegmentedControl selectedSegmentIndex] == 0 )
			task.priority = [[NSNumber alloc] initWithInt:[mySegmentedControl selectedSegmentIndex]];
	}
	
	switch ([mySegmentedControl selectedSegmentIndex])
	{
		case 0: 
			task.priority = [[NSNumber alloc] initWithInt:1];
			break;
		case 1: 
			task.priority = [[NSNumber alloc] initWithInt:5];
			break;
		case 2: 
			task.priority = [[NSNumber alloc] initWithInt:9];
			break;
		case 3: 
			task.priority = [[NSNumber alloc] initWithInt:0]; 
			break;
		default:
			task.priority = [[NSNumber alloc] initWithInt:0];
			break;
	}
	
}



#pragma mark - UIActionSheetDelegate

//
//
//

- (IBAction)cancel:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
	addbeenhere = TRUE;
}

//
//
//

- (IBAction)save:(id)sender {
    iTaskAppDelegate *appDelegate = (iTaskAppDelegate *)[[UIApplication sharedApplication] delegate];
    // Add to the global array of tasks
    [appDelegate addTask:self.task];
    [self.task setModified:YES];
    // Dismiss the modal view to return to the main list
    [self.navigationController popViewControllerAnimated:YES];
	addbeenhere = TRUE;
}

//
//
//

- (void)accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration {
	const float violence = 1.5;
	addshake = FALSE;
	
	if (addbeenhere) {
		return;
	} else {
		if (acceleration.x > violence * 1.5 || acceleration.x < (-1.5* violence))
			addshake = TRUE;
		if (acceleration.y > violence * 2 || acceleration.y < (-2 * violence))
			addshake = TRUE;
		if (acceleration.z > violence * 3 || acceleration.z < (-3 * violence))
			addshake = TRUE;
		if (addshake) {
			if( titleCell.titleField.text.length > 0){
				addbeenhere = TRUE;
				addshake = FALSE;
				[self save:self];
			} else {
				addbeenhere = TRUE;	
				addshake = FALSE;
				[self cancel:self];		
			}
		}
	}
}

@end
