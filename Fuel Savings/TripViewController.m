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
	}
	[self.tableView reloadData];
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *CellIdentifier = @"Cell";
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
	}
	return cell;
}

@end
