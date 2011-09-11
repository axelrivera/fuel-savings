//
//  TripViewController.m
//  Fuel Savings
//
//  Created by arn on 7/1/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "TripViewController.h"
#import "TripViewController+Details.h"
#import "TotalView.h"
#import "TotalViewCell.h"
#import "TotalDetailViewCell.h"
#import "DetailView.h"
#import "DetailSummaryViewCell.h"
#import "Settings.h"
#import "UIViewController+iAd.h"
#import "Fuel_SavingsAppDelegate.h"

#define TRIP_NEW_TAG 1
#define TRIP_ACTION_TAG 2

@implementation TripViewController

@synthesize contentView = contentView_;
@synthesize tripTable = tripTable_;
@synthesize instructionsLabel = instructionsLabel_;
@synthesize currentTrip = currentTrip_;

- (id)init
{
	self = [super initWithNibName:@"TripViewController" bundle:nil];
	if (self) {
		savingsData_ = [SavingsData sharedSavingsData];
		isNewTrip_ = NO;
		showNewAction_ = NO;
		hasButtons_ = NO;
		self.currentTrip = [Trip emptyTrip];
	}
	return self;
}

- (id)initWithTabBar:(BOOL)tab buttons:(BOOL)buttons
{
	self = [self init];
	if (self) {
		if (tab) {
			self.title = @"Trip";
			self.navigationItem.title = @"Analyze Trip";
			self.tabBarItem.image = [UIImage imageNamed:@"trip_tab.png"];
		}
		hasButtons_ = buttons;
	}
	return self;
}

- (void)dealloc
{	
	[contentView_ release];
	[tripTable_ release];
	[instructionsLabel_ release];
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
	
	self.contentView.tag = kAdContentViewTag;
	
	if (hasButtons_) {
		UIBarButtonItem *newButton = [[UIBarButtonItem alloc] initWithTitle:@"New"
																	  style:UIBarButtonItemStyleBordered
																	 target:self
																	 action:@selector(newCheckAction)];
		self.navigationItem.leftBarButtonItem = newButton;
		[newButton release];
		
		UIBarButtonItem *actionButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction
																					  target:self
																					  action:@selector(actionOptionsAction:)];
		self.navigationItem.rightBarButtonItem = actionButton;
		[actionButton release];
		
		if (![savingsData_.currentTrip isTripEmpty]) {
			self.currentTrip = savingsData_.currentTrip;
		}
		
		self.instructionsLabel.font = [UIFont systemFontOfSize:18.0];
		self.instructionsLabel.text = @"Tap the New button to create a New Trip. "
		@"You can calculate the cost of a trip based on distance.";
	}
}

- (void)viewDidUnload
{
	[super viewDidUnload];
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
	self.contentView = nil;
	self.tripTable = nil;
	self.instructionsLabel = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	
	ADBannerView *adBanner = SharedAdBannerView;
	adBanner.delegate = self;
	[self layoutCurrentOrientation:NO];
	
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

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
	ADBannerView *adBanner = SharedAdBannerView;
	adBanner.delegate = nil;
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
	Trip *newTrip = [[Trip calculation] retain];
	[newTrip setDefaultValues];
	
	CurrentTripViewController *currentTripViewController = [[CurrentTripViewController alloc] initWithTrip:newTrip];
	currentTripViewController.delegate = self;
	
	[newTrip release];
	
	UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:currentTripViewController];
	[currentTripViewController release];
	
	[self presentModalViewController:navController animated:YES];	
	[navController release];
}

- (void)editAction
{
	Trip *editTrip = [self.currentTrip retain];
	
	CurrentTripViewController *currentTripViewController = [[CurrentTripViewController alloc] initWithTrip:editTrip];
	currentTripViewController.delegate = self;
	currentTripViewController.isEditingTrip = YES;
	
	[editTrip release];
	
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
	[self saveCurrentTrip:[Trip emptyTrip]];
	self.navigationItem.rightBarButtonItem.enabled = NO;
	[self reloadTable];
}

- (void)displayNameAction
{
	NameInputViewController *inputViewController = [[NameInputViewController alloc] init];
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
								  destructiveButtonTitle:nil
								  otherButtonTitles:@"Save Current As...", @"Delete Current", nil];
	
	actionSheet.destructiveButtonIndex = 1;
	
	actionSheet.tag = TRIP_NEW_TAG;
	
	UIView *view = self.view;
	if (hasButtons_) {
		view = self.tabBarController.view;
	}
	[actionSheet showInView:view];
	[actionSheet release];	
}

- (void)actionOptionsAction:(id)sender {
	// open a dialog with two custom buttons	
	
	UIActionSheet *actionSheet = [[UIActionSheet alloc]
								  initWithTitle:nil
								  delegate:self
								  cancelButtonTitle:@"Cancel"
								  destructiveButtonTitle:nil
								  otherButtonTitles:@"Edit Current", @"Save Current As...", @"Delete Current", nil];
	
	actionSheet.destructiveButtonIndex = 2;
	
	actionSheet.tag = TRIP_ACTION_TAG;
	
	UIView *view = self.view;
	if (hasButtons_) {
		view = self.tabBarController.view;
	}
	[actionSheet showInView:view];
	[actionSheet release];	
}

#pragma mark - Custom Methods

- (void)saveCurrentTrip:(Trip *)trip
{
	Trip *tripCopy = [trip copy];
	self.currentTrip = tripCopy;
	[tripCopy release];
	if (hasButtons_) {
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
	}
	[self.tripTable reloadData];
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
			totalCell = [[[TotalViewCell alloc] initWithReuseIdentifier:TotalCellIdentifier] autorelease];
		}
		
		TotalView *totalView = [self tripCostView];
		[totalCell setTotalView:totalView];
		
		totalCell.selectionStyle = UITableViewCellSelectionStyleNone;
		
		return totalCell;
	} 
		
	static NSString *SummaryCellIdentifier = @"SummaryCell";
	
	DetailSummaryViewCell *summaryCell = (DetailSummaryViewCell *)[tableView dequeueReusableCellWithIdentifier:SummaryCellIdentifier];
	if (summaryCell == nil) {
		summaryCell = [[[DetailSummaryViewCell alloc] initWithReuseIdentifier:SummaryCellIdentifier] autorelease];
	}
	
	DetailSummaryView *summaryView = nil;
	
	if (indexPath.row == 0) {
		summaryView = [self infoSummaryView];
	} else {
		summaryView = [self carSummaryView];
	}

	[summaryCell setSummaryView:summaryView];
	
	summaryCell.selectionStyle = UITableViewCellSelectionStyleNone;
	
	return summaryCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSInteger height = 0.0;
	if (indexPath.section == 0) {
		height = 66.0;
	} else {
		if (indexPath.row == 0) {
			height = 83.0;
		} else {
			height = 100.0;
		}
	}
	return height;
}

#pragma mark - UIActionSheet Delegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	if (actionSheet.tag == TRIP_NEW_TAG) {
		if (buttonIndex == 0) {
			isNewTrip_ = YES;
			[self performSelector:@selector(saveAction)];
		} else if (buttonIndex == 1) {
			[self performSelector:@selector(newAction)];
		}
	} else {
		if (buttonIndex == 0) {
			[self performSelector:@selector(editAction)];
		} else if (buttonIndex == 1) {
			[self performSelector:@selector(saveAction)];
		} else if (buttonIndex == 2) {
			[self performSelector:@selector(deleteAction)];
		}
	}
}

#pragma mark - ADBannerViewDelegate

- (void)bannerViewDidLoadAd:(ADBannerView *)banner
{
	[self layoutCurrentOrientation:YES];
}

- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error
{
	[self layoutCurrentOrientation:YES];
}

- (BOOL)bannerViewActionShouldBegin:(ADBannerView *)banner willLeaveApplication:(BOOL)willLeave
{
	// Stop or Pause Stuff Here
	return YES;
}

- (void)bannerViewActionDidFinish:(ADBannerView *)banner
{
	// Get things back up running again!
}

@end
