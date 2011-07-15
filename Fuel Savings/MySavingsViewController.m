//
//  MySavingsViewController.m
//  Fuel Savings
//
//  Created by arn on 6/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MySavingsViewController.h"
#import "Savings.h"
#import "FuelSavingsViewController.h"

@interface MySavingsViewController (Private)

- (void)setupSegmentedControl;
- (void)reloadTableData;

@end

@implementation MySavingsViewController

@synthesize segmentedControl = segmentedControl_;

- (id)init
{
	self = [super initWithNibName:@"MySavingsViewController" bundle:nil];
	if (self) {
		// Initialization Code
	}
	return self;
}

- (id)initWithTabBar
{
	self = [self init];
	if (self) {
		savingsData_ = [SavingsData sharedSavingsData];
		self.title = @"Saved";
		self.navigationItem.title = @"Saved";
		self.tabBarItem.image = [UIImage imageNamed:@"saved_tab.png"];
	}
	return self;
}

- (void)dealloc
{
	[segmentedControl_ release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	[self setupSegmentedControl];
	self.navigationItem.titleView = self.segmentedControl;
	[self.segmentedControl setSelectedSegmentIndex:0];
	
	self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
	self.segmentedControl = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	[self reloadTableData];
}

#pragma mark - Custom Actions

- (void)changedSegmentedControlAction
{
	if ([self.segmentedControl selectedSegmentIndex] == 0) {
		tableData_ = savingsData_.savedCalculations;
	} else {
		tableData_ = nil;
	}
	[self reloadTableData];
}

- (void)deleteAllAction
{
	[self setEditing:NO animated:YES];
	[tableData_ removeAllObjects];
	[self reloadTableData];
	
}

- (void)deleteAllOptionsAction:(id)sender {
	// open a dialog with two custom buttons	
	
	UIActionSheet *actionSheet = [[UIActionSheet alloc]
								  initWithTitle:nil
								  delegate:self
								  cancelButtonTitle:@"Cancel"
								  destructiveButtonTitle:@"Delete All"
								  otherButtonTitles:nil];
	
	[actionSheet showFromTabBar:self.tabBarController.tabBar];
	[actionSheet release];	
}


#pragma mark - Private Methods

- (void)setupSegmentedControl
{	
	UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"Savings", @"Trips", nil]];
	[segmentedControl setSegmentedControlStyle:UISegmentedControlStyleBar];
	[segmentedControl setMomentary:NO];
	[segmentedControl addTarget:self action:@selector(changedSegmentedControlAction) forControlEvents:UIControlEventValueChanged];
	
	
	[segmentedControl setWidth:80.0 forSegmentAtIndex:0];
	[segmentedControl setWidth:80.0 forSegmentAtIndex:1];
	
	self.segmentedControl = segmentedControl;
	[segmentedControl release];
}

- (void)reloadTableData
{
	if ([tableData_ count] > 0) {
		self.navigationItem.rightBarButtonItem.enabled = YES;
	} else {
		self.navigationItem.rightBarButtonItem.enabled = NO;
	}
	[self.tableView reloadData];
}

#pragma mark - UITableView Methods

- (void)setEditing:(BOOL)flag animated:(BOOL)animated
{
	// Always call super implementation of this method, it needs to do some work
	[super setEditing:flag animated:animated];
	
	// We need to insert/remove a new row in to table view to say "Add New Item..."
	if (flag && [tableData_ count] > 0) {
		[self.tableView insertSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationFade];
	} else if (!flag && [tableData_ count] > 0) {
		[self.tableView deleteSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationFade];
	}
	self.segmentedControl.enabled = !self.segmentedControl.enabled;
}

#pragma mark - UITableView Datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	if (tableData_ == nil) {
		return 0;
	}
	NSInteger sections = 1;
	if ([self isEditing]) {
		sections = 2;
	}
	return sections;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	if (section == 0) {
		return [tableData_ count];
	}
	return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (indexPath.section == 1) {
		static NSString *ButtonCellIdentifier = @"ButtonCell";
		
		UITableViewCell *buttonCell = [tableView dequeueReusableCellWithIdentifier:ButtonCellIdentifier];
		
		if (buttonCell == nil) {
			buttonCell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ButtonCellIdentifier] autorelease];
		}
		
		UIView *backView = [[[UIView alloc] initWithFrame:CGRectZero] autorelease];
		buttonCell.backgroundColor = [UIColor clearColor];
		buttonCell.backgroundView = backView;
		buttonCell.selectionStyle = UITableViewCellEditingStyleNone;
		
		UIButton *button = [[UIButton buttonWithType:UIButtonTypeRoundedRect] retain];
		CGFloat buttonWidth = [UIScreen mainScreen].bounds.size.width - 20.0;
		button.frame = CGRectMake(0.0, 0.0, buttonWidth, 44.0);
		
		[button addTarget:self action:@selector(deleteAllOptionsAction:) forControlEvents:UIControlEventTouchDown];
		[button setTitle:@"Delete All" forState:UIControlStateNormal];
		
		buttonCell.editingAccessoryView = button;
		
		[button release];
		
		return buttonCell;
	}
	
	static NSString *CellIdentifier = @"Cell";
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
	}
	
	NSString *textLabelString = nil;
	
	if ([self.segmentedControl selectedSegmentIndex] == 0) {
		Savings *calculation = [tableData_ objectAtIndex:indexPath.row];
		textLabelString = calculation.name;
	}
	
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	cell.editingAccessoryType = UITableViewCellAccessoryDetailDisclosureButton;
	cell.selectionStyle = UITableViewCellSelectionStyleBlue;
	cell.textLabel.text = textLabelString;
	
	return cell;
}

#pragma mark - UITableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	
	UIViewController *currentController = nil;
	
	if ([self.segmentedControl selectedSegmentIndex] == 0) {
		FuelSavingsViewController *fuelSavingsViewController = [[FuelSavingsViewController alloc] init];
		
		Savings *calculation = [tableData_ objectAtIndex:indexPath.row];
		
		fuelSavingsViewController.title	= calculation.name;
		fuelSavingsViewController.savingsCalculation = calculation;
		
		currentController = fuelSavingsViewController;
	}
	
	if (currentController) {
		[self.navigationController pushViewController:currentController animated:YES];
		[currentController release];
	}
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
	NSString *name = nil;
	if ([self.segmentedControl selectedSegmentIndex] == 0) {
		Savings *calculation = [tableData_ objectAtIndex:indexPath.row];
		name = calculation.name;
	}
	
	NameInputViewController *inputViewController = [[NameInputViewController alloc] initWithNavigationButtons];
	inputViewController.delegate = self;
	inputViewController.currentName = name;
	
	selectedIndex_ = indexPath.row;
	
	UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:inputViewController];
	
	[inputViewController release];
	
	[self presentModalViewController:navController animated:YES];
	
	[navController release];
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath 
{		
	if ([self isEditing] && indexPath.section == 1) {
		// During editing...
		// The last row during editing will show an insert style button
		return UITableViewCellEditingStyleNone;
	}
	return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath 
{
	// If the table view is asking to commit a delete command...
	if (editingStyle == UITableViewCellEditingStyleDelete) {
		// We remove the row being deleted from the possessions array
		[tableData_ removeObjectAtIndex:indexPath.row];
		// We also remove that row from the table view with an animation
		[tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
	}
}

#pragma mark - View Controller Delegates

- (void)nameInputViewControllerDidFinish:(NameInputViewController *)controller save:(BOOL)save
{
	if (save) {
		[[tableData_ objectAtIndex:selectedIndex_] setName:controller.currentName];
		[self reloadTableData];
	}
	[self dismissModalViewControllerAnimated:YES];
}

#pragma mark - UIActionSheet Delegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
		if (buttonIndex == 0) {
			[self performSelector:@selector(deleteAllAction)];
		}
}

@end
