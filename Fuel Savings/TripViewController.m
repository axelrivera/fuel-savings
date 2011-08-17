//
//  TripViewController.m
//  Fuel Savings
//
//  Created by arn on 7/1/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "TripViewController.h"
#import "TotalView.h"
#import "TotalViewCell.h"
#import "TotalDetailViewCell.h"
#import "DetailView.h"
#import "DetailSummaryViewCell.h"

#define TRIP_NEW_TAG 1
#define TRIP_DELETE_TAG 2

@interface TripViewController (Private)

- (NSArray *)infoDetails;
- (NSArray *)carDetailsForVehicle:(Vehicle *)vehicle;

@end

@implementation TripViewController

@synthesize tripTable = tripTable_;
@synthesize instructionsLabel = instructionsLabel_;
@synthesize newTrip	= newTrip_;
@synthesize currentTrip = currentTrip_;
@synthesize infoSummary = infoSummary_;
@synthesize carSummary = carSummary_;

- (id)init
{
	self = [super initWithNibName:@"TripViewController" bundle:nil];
	if (self) {
		savingsData_ = [SavingsData sharedSavingsData];
		self.newTrip = nil;
		self.currentTrip = [Trip emptyTrip];
		isNewTrip_ = NO;
		showNewAction_ = NO;
		buttonView_ = nil;
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
		
		buttonView_ = [[DoubleButtonView alloc] initWithButtonType:UIButtonTypeRoundedRect frame:CGRectZero];
		
		[buttonView_.leftButton addTarget:self action:@selector(saveAction) forControlEvents:UIControlEventTouchDown];
		[buttonView_.leftButton setTitle:@"Save As..." forState:UIControlStateNormal];
		
		[buttonView_.rightButton addTarget:self action:@selector(deleteOptionsAction:) forControlEvents:UIControlEventTouchDown];
		[buttonView_.rightButton setTitle:@"Delete" forState:UIControlStateNormal];
	}
	return self;
}

- (void)dealloc
{
	[tripTable_ release];
	[instructionsLabel_ release];
	[newTrip_ release];
	[currentTrip_ release];
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
	
	if (buttonView_) {
		UIBarButtonItem *newButton = [[UIBarButtonItem alloc] initWithTitle:@"New"
																	  style:UIBarButtonItemStyleBordered
																	 target:self
																	 action:@selector(newCheckAction)];
		self.navigationItem.leftBarButtonItem = newButton;
		[newButton release];
		
		UIBarButtonItem *editButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit
																					target:self
																					action:@selector(editAction)];
		self.navigationItem.rightBarButtonItem = editButton;
		[editButton release];
		
		if (![savingsData_.currentTrip isTripEmpty]) {
			self.currentTrip = savingsData_.currentTrip;
		}
		
		self.instructionsLabel.font = [UIFont systemFontOfSize:14.0];
		self.instructionsLabel.text = @"Tap the New button to create a New Trip.";
	}
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
	self.tripTable = nil;
	self.instructionsLabel = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	[self reloadTable];
}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
	
	if (showNewAction_ == YES) {
		showNewAction_ = NO;
		[self performSelector:@selector(newAction)];
	}
}

#pragma mark - Custom Actions

- (void)newCheckAction
{
	if ([self.currentTrip isTripEmpty]) {
		[self performSelector:@selector(newAction)];
	} else {
		[self performSelector:@selector(newOptionsAction:)];
	}
}

- (void)newAction
{
	self.newTrip = [Trip calculation];
	CurrentTripViewController *currentTripViewController = [[CurrentTripViewController alloc] initWithTrip:newTrip_];
	currentTripViewController.delegate = self;
	
	UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:currentTripViewController];
	[self presentModalViewController:navController animated:YES];
	
	[currentTripViewController release];
	[navController release];
}

- (void)editAction
{
	self.newTrip = self.currentTrip;
	CurrentTripViewController *currentTripViewController = [[CurrentTripViewController alloc] initWithTrip:newTrip_];
	currentTripViewController.delegate = self;
	currentTripViewController.isEditingTrip = YES;
	
	UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:currentTripViewController];
	[self presentModalViewController:navController animated:YES];
	
	[currentTripViewController release];
	[navController release];
}

- (void)saveAction
{
	[self performSelector:@selector(displayNameAction)];
}


- (void)deleteAction
{
	[self saveCurrentTrip:[Trip emptyTrip]];
	self.navigationItem.rightBarButtonItem.enabled = NO;
	[self reloadTable];
}

- (void)displayNameAction
{
	NameInputViewController *inputViewController = [[NameInputViewController alloc] initWithNavigationButtons];
	inputViewController.footerText = @"Enter a name for the Current Trip.";
	inputViewController.delegate = self;
	
	if (![self.currentTrip.name isEqualToString:@""]) {
		inputViewController.currentName = self.currentTrip.name;
	} else {
		NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
		[dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
		[dateFormatter setDateStyle:NSDateFormatterShortStyle];
		[dateFormatter setTimeStyle:NSDateFormatterMediumStyle];
		
		inputViewController.currentName = [NSString stringWithFormat:@"Trip %@", [dateFormatter stringFromDate:[NSDate date]]];
		
		[dateFormatter release];
	}
	
	UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:inputViewController];
	[self presentModalViewController:navController animated:YES];
	
	[inputViewController release];
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

#pragma mark - Custom Methods

- (void)saveCurrentTrip:(Trip *)trip
{
	self.currentTrip = trip;
	if (buttonView_) {
		savingsData_.currentTrip = trip;
	}
}

- (void)reloadTable
{
	if ([self.currentTrip isTripEmpty]) {
		self.tripTable.hidden = YES;
		self.navigationItem.rightBarButtonItem.enabled = NO;
	} else {
		self.tripTable.hidden = NO;
		self.navigationItem.rightBarButtonItem.enabled = YES;
		
		DetailSummaryView *infoView = [[DetailSummaryView alloc] initWithDetails:[self infoDetails]];
		infoView.titleLabel.text = @"Details";
		infoView.imageView.image = [UIImage imageNamed:@"details.png"];
		[self setInfoSummary:infoView];
		[infoView release];
		
		DetailSummaryView *carView = [[DetailSummaryView alloc] initWithDetails:[self carDetailsForVehicle:self.currentTrip.vehicle]];
		carView.titleLabel.text = @"My Car";
		carView.imageView.image = [UIImage imageNamed:@"car.png"];
		[self setCarSummary:carView];
		[carView release];
	}
	[self.tripTable reloadData];
}

#pragma mark - Private Methods

- (NSArray *)infoDetails
{
	NSMutableArray *details = [[[NSMutableArray alloc] initWithCapacity:0] autorelease];
	
	[details addObject:[DetailView detailDictionaryWithText:@"Trip Name" detail:[self.currentTrip stringForName]]];
	[details addObject:[DetailView detailDictionaryWithText:@"Fuel Price" detail:[self.currentTrip stringForFuelPrice]]];
	[details addObject:[DetailView detailDictionaryWithText:@"Distance" detail:[self.currentTrip stringForDistance]]];
	
	return details;
}

- (NSArray *)carDetailsForVehicle:(Vehicle *)vehicle
{	
	NSMutableArray *details = [[[NSMutableArray alloc] initWithCapacity:0] autorelease];
	
	[details addObject:[DetailView detailDictionaryWithText:@"Name" detail:[vehicle stringForName]]];
	[details addObject:[DetailView detailDictionaryWithText:@"Fuel Efficiency" detail:[vehicle stringForAvgEfficiency]]];
	
	return details;
}

#pragma mark - View Controller Delegates

- (void)currentTripViewControllerDelegateDidFinish:(CurrentTripViewController *)controller save:(BOOL)save
{
	if (save) {
		[self saveCurrentTrip:controller.currentTrip];
	}
	[self dismissModalViewControllerAnimated:YES];
}

- (void)nameInputViewControllerDidFinish:(NameInputViewController *)controller save:(BOOL)save
{
	if (save) {
		self.currentTrip.name = controller.currentName;
		Trip *trip = [self.currentTrip copy];
		[savingsData_.tripArray addObject:trip];
		[trip release];
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
	if ([self.currentTrip isTripEmpty]) {
		return 0;
	}
	return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	if (section == 0) {
		return 1;
	}
	return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (indexPath.section == 0) {
		static NSString *TotalCellIdentifier = @"TotalCell";
		
		TotalViewCell *totalCell = (TotalViewCell *)[tableView dequeueReusableCellWithIdentifier:TotalCellIdentifier];
		
		if (totalCell == nil) {
			totalCell = [[[TotalViewCell alloc] initWithTotalType:TotalViewTypeSingle reuseIdentifier:TotalCellIdentifier] autorelease];
		}
		
		totalCell.selectionStyle = UITableViewCellSelectionStyleNone;
		
		NSString *imageStr = @"money.png";
		NSString *titleStr = @"Trip Cost";
		NSString *text1LabelStr = [self.currentTrip stringForName];
		
		NSString *detail1LabelStr = [self.currentTrip stringForTripCost];
		
		totalCell.totalView.imageView.image = [UIImage imageNamed:imageStr];
		totalCell.totalView.titleLabel.text = titleStr;
		totalCell.totalView.text1Label.text = text1LabelStr;
		totalCell.totalView.detail1Label.text = detail1LabelStr;
		
		UIColor *textColor = [UIColor colorWithRed:0.0 green:128.0/255.0 blue:0.0 alpha:1.0];
		
		totalCell.totalView.text1Label.textColor = textColor;
		totalCell.totalView.detail1Label.textColor = textColor;
		
		return totalCell;
	} 
	
	DetailSummaryView *summary = nil;
	
	if (indexPath.row == 0) {
		summary = infoSummary_;
	} else {
		summary = carSummary_;
	}
	
	NSString *SummaryCellIdentifier = [NSString stringWithFormat:@"SummaryCell%i", [summary.detailViews count]];
	
	DetailSummaryViewCell *summaryCell = (DetailSummaryViewCell *)[tableView dequeueReusableCellWithIdentifier:SummaryCellIdentifier];
	
	if (summaryCell == nil) {
		summaryCell = [[[DetailSummaryViewCell alloc] initWithReuseIdentifier:SummaryCellIdentifier] autorelease];
	}
	
	summaryCell.selectionStyle = UITableViewCellSelectionStyleNone;
	
	[summaryCell setSummaryView:summary];
	
	return summaryCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSInteger height = 0.0;
	if (indexPath.section == 0) {
		height = 66.0;
	} else {
		if (indexPath.row == 0) {
			height = 100.0;
		} else {
			height = 83.0;
		}
	}
	return height;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
	if (section == 1 && buttonView_) {
		return buttonView_;
	}
	return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
	if (section == 1) {
		return 84.0;
	}
	return 10.0;
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
