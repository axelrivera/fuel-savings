//
//  TripViewController.m
//  Fuel Savings
//
//  Created by arn on 7/1/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "TripViewController.h"

#define TRIP_NEW_TAG 1
#define TRIP_DELETE_TAG 2

@implementation TripViewController

@synthesize tripCalculation = tripCalculation_;
@synthesize backupCopy = backupCopy_;
@synthesize tripCost = tripCost_;

- (id)init
{
	self = [super initWithNibName:@"TripViewController" bundle:nil];
	if (self) {
		tripData_ = [TripData sharedTripData];
		currencyFormatter_ = [[NSNumberFormatter alloc] init];
		[currencyFormatter_ setNumberStyle:NSNumberFormatterCurrencyStyle];
		[currencyFormatter_ setMaximumFractionDigits:0];
		self.tripCalculation = nil;
		self.backupCopy = nil;
		isNewTrip_ = NO;
		showNewAction_ = NO;
		hasTabBar_ = NO;
	}
	return self;
}

- (id)initWithTabBar
{
	self = [self init];
	if (self) {
		self.title = @"Trip";
		self.navigationItem.title = @"Analyze Trip";
		self.tabBarItem.image = [UIImage imageNamed:@"trip_tab.png"];
		hasTabBar_ = YES;
	}
	return self;
}

- (void)dealloc
{
	[currencyFormatter_ release];
	[tripCalculation_ release];
	[backupCopy_ release];
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
	
	UIBarButtonItem *editButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit
																				target:self
																				action:@selector(editAction)];
	self.navigationItem.rightBarButtonItem = editButton;
	[editButton release];
	
	if (hasTabBar_) {
		UIBarButtonItem *newButton = [[UIBarButtonItem alloc] initWithTitle:@"New"
																	  style:UIBarButtonItemStyleBordered
																	 target:self
																	 action:@selector(newCheckAction)];
		self.navigationItem.leftBarButtonItem = newButton;
		[newButton release];
	}
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	
	self.navigationItem.rightBarButtonItem.enabled = NO;
	
	if (hasTabBar_) {
		self.tripCalculation = tripData_.tripCalculation;
	} else {
		if (self.tripCalculation == nil) {
			[self.navigationController popToRootViewControllerAnimated:YES];
		}
	}
	
	if (self.tripCalculation) {
		self.navigationItem.rightBarButtonItem.enabled = YES;
		if ([self.tripCalculation.vehicle hasDataReady]) {
			self.tripCost = [self.tripCalculation tripCost];
		} else {
			self.tripCost = [NSNumber numberWithFloat:0.0];
		}
	}
	[self.tableView reloadData];
}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
	
	if (showNewAction_ == YES) {
		showNewAction_ = NO;
		[self performSelector:@selector(newAction)];
	}
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
	
	if (hasTabBar_) {
		tripData_.tripCalculation = self.tripCalculation;
	}
}

#pragma mark - Custom Actions

- (void)newCheckAction
{
	if (self.tripCalculation == nil) {
		[self performSelector:@selector(newAction)];
	} else {
		[self performSelector:@selector(newOptionsAction:)];
	}
}

- (void)newAction
{
	self.tripCalculation = [Trip calculation];
	tripData_.currentCalculation = self.tripCalculation;
	CurrentTripViewController *currentTripViewController = [[CurrentTripViewController alloc] init];
	currentTripViewController.delegate = self;
	
	UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:currentTripViewController];
	
	[currentTripViewController release];
	
	[self presentModalViewController:navController animated:YES];
	
	[navController release];
}

- (void)editAction
{
	self.backupCopy = self.tripCalculation;
	tripData_.currentCalculation = self.tripCalculation;
	CurrentTripViewController *currentTripViewController = [[CurrentTripViewController alloc] init];
	currentTripViewController.delegate = self;
	currentTripViewController.isEditingTrip = YES;
	
	UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:currentTripViewController];
	
	[currentTripViewController release];
	
	[self presentModalViewController:navController animated:YES];
	
	[navController release];
}

- (void)saveAction
{
	[self performSelector:@selector(displayNameAction)];
}


- (void)deleteAction
{
	self.tripCalculation = nil;
	self.navigationItem.rightBarButtonItem.enabled = NO;
	[self.tableView reloadData];
}

- (void)displayNameAction
{
	NameInputViewController *inputViewController = [[NameInputViewController alloc] initWithNavigationButtons];
	inputViewController.delegate = self;
	
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
	[dateFormatter setDateStyle:NSDateFormatterShortStyle];
	[dateFormatter setTimeStyle:NSDateFormatterMediumStyle];
	
	inputViewController.currentName = [NSString stringWithFormat:@"Untitled %@", [dateFormatter stringFromDate:[NSDate date]]];
	
	[dateFormatter release];
	
	UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:inputViewController];
	
	[inputViewController release];
	
	[self presentModalViewController:navController animated:YES];
	
	[navController release];
}

- (void)newOptionsAction:(id)sender {	
	UIActionSheet *actionSheet = [[UIActionSheet alloc]
								  initWithTitle:@"You have a Current Trip. What would you like to do before creating a New Trip?"
								  delegate:self
								  cancelButtonTitle:@"Cancel"
								  destructiveButtonTitle:@"Delete Current"
								  otherButtonTitles:@"Save Current As...", nil];
	
	actionSheet.tag = TRIP_NEW_TAG;
	
	[actionSheet showFromTabBar:self.tabBarController.tabBar];
	[actionSheet release];	
}

- (void)deleteOptionsAction:(id)sender {
	// open a dialog with two custom buttons	
	
	UIActionSheet *actionSheet = [[UIActionSheet alloc]
								  initWithTitle:@"Are you sure? The information on your Current Trip will be lost."
								  delegate:self
								  cancelButtonTitle:@"Cancel"
								  destructiveButtonTitle:@"Delete Current"
								  otherButtonTitles:nil];
	
	actionSheet.tag = TRIP_DELETE_TAG;
	
	[actionSheet showFromTabBar:self.tabBarController.tabBar];
	[actionSheet release];	
}

#pragma mark - View Controller Delegates

- (void)currentTripViewControllerDelegateDidFinish:(CurrentTripViewController *)controller save:(BOOL)save
{
	if (!save) {
		if (controller.isEditingTrip == YES) {
			self.tripCalculation = self.backupCopy;
		} else {
			self.tripCalculation = nil;
		}
	}
	tripData_.currentCalculation = nil;
	[self dismissModalViewControllerAnimated:YES];
}

- (void)nameInputViewControllerDidFinish:(NameInputViewController *)controller save:(BOOL)save
{
	if (save) {
		self.tripCalculation.name = controller.currentName;
		[tripData_.savedCalculations addObject:[self.tripCalculation copy]];
		if (isNewTrip_) {
			isNewTrip_ = NO;
			showNewAction_ = YES;
		}
	}
	[self dismissModalViewControllerAnimated:YES];
}

#pragma mark - UITableView Datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	if (self.tripCalculation == nil) {
		return 0;
	}
	
	NSInteger sections = 2;
	
	if (hasTabBar_) {
		sections = sections + 2;
	}
	
	return sections;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	NSInteger rows = 0;
	
	if (section == 0) {
		rows = 1;
	} else if (section == 1) {
		rows = 2;
	} else {
		rows = 1;
	}
	
	return rows;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (indexPath.section == 0) {
		static NSString *CostCellIdentifier = @"CostCell";
		
		UITableViewCell *costCell = [tableView dequeueReusableCellWithIdentifier:CostCellIdentifier];
		
		if (costCell == nil) {
			costCell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CostCellIdentifier] autorelease];
		}
		
		NSString *textLabelString = nil;
		NSString *detailTextLabelString = nil;
		
		textLabelString = self.tripCalculation.vehicle.name;
		detailTextLabelString = [currencyFormatter_ stringFromNumber:self.tripCost];
		
		costCell.accessoryType = UITableViewCellAccessoryNone;
		costCell.selectionStyle = UITableViewCellSelectionStyleNone;
		
		costCell.textLabel.font = [UIFont boldSystemFontOfSize:15.0];
		costCell.detailTextLabel.font = [UIFont systemFontOfSize:15.0];
		
		costCell.textLabel.text = textLabelString;
		costCell.detailTextLabel.text = detailTextLabelString;
		
		return costCell;
	} else if (indexPath.section == 1) {
		static NSString *InfoCellIdentifier = @"InfoCell";
		
		UITableViewCell *infoCell = [tableView dequeueReusableCellWithIdentifier:InfoCellIdentifier];
		
		if (infoCell == nil) {
			infoCell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:InfoCellIdentifier] autorelease];
		}
		
		NSString *textLabelString = nil;
		NSString *detailTextLabelString = nil;
		
		if (indexPath.row == 0) {
			textLabelString = @"Fuel Price";
			
			NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
			[formatter setNumberStyle:NSNumberFormatterCurrencyStyle];
			
			NSString *numberString = [formatter stringFromNumber:self.tripCalculation.fuelPrice];
			[formatter release];
			
			detailTextLabelString = [NSString stringWithFormat:@"%@ /gallon", numberString];
		} else {
			textLabelString = @"Distance";
			
			NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
			[formatter setNumberStyle:NSNumberFormatterDecimalStyle];
			[formatter setMaximumFractionDigits:0];
			
			NSString *numberString = [formatter stringFromNumber:self.tripCalculation.distance];
			[formatter release];
			
			detailTextLabelString = [NSString stringWithFormat:@"%@ miles", numberString];
		}
		
		infoCell.accessoryType = UITableViewCellAccessoryNone;
		infoCell.selectionStyle = UITableViewCellSelectionStyleNone;
		
		infoCell.textLabel.font = [UIFont boldSystemFontOfSize:15.0];
		infoCell.detailTextLabel.font = [UIFont systemFontOfSize:15.0];
		
		infoCell.textLabel.text = textLabelString;
		infoCell.detailTextLabel.text = detailTextLabelString;
		
		return infoCell;
	}
	
	static NSString *CellIdentifier = @"Cell";
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
	}
	
	UIView *backView = [[[UIView alloc] initWithFrame:CGRectZero] autorelease];
	cell.backgroundColor = [UIColor clearColor];
	cell.backgroundView = backView;
	cell.selectionStyle = UITableViewCellEditingStyleNone;
	
	UIButton *button = [[UIButton buttonWithType:UIButtonTypeRoundedRect] retain];
	CGFloat buttonWidth = [UIScreen mainScreen].bounds.size.width - 20.0;
	button.frame = CGRectMake(0.0, 0.0, buttonWidth, 44.0);
	
	if (indexPath.section == 2) {
		[button addTarget:self action:@selector(saveAction) forControlEvents:UIControlEventTouchDown];
		[button setTitle:@"Save Current As..." forState:UIControlStateNormal];
	}
	
	if (indexPath.section == 3) {
		[button addTarget:self action:@selector(deleteOptionsAction:) forControlEvents:UIControlEventTouchDown];
		[button setTitle:@"Delete Current" forState:UIControlStateNormal];
	}
	
	cell.accessoryView = button;
	
	[button release];
	
	return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	if (section == 0) {
		return @"Trip Cost";
	} else if (section == 1) {
		return @"Information";
	}
	return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
	return 34.0;
}

#pragma mark - UIActionSheet Delegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	if (actionSheet.tag == TRIP_NEW_TAG) {
		if (buttonIndex == 0) {
			[self performSelector:@selector(newAction)];
		} else if (buttonIndex == 1) {
			isNewTrip_ = YES;
			[self performSelector:@selector(saveAction)];
		}
	} else {
		if (buttonIndex == 0) {
			[self performSelector:@selector(deleteAction)];
		}
	}
}

@end
