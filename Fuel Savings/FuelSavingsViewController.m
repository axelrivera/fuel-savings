//
//  FuelSavingsViewController.m
//  Fuel Savings
//
//  Created by arn on 6/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "FuelSavingsViewController.h"
#import "TotalView.h"
#import "TotalViewCell.h"
#import "TotalDetailViewCell.h"
#import "DetailView.h"
#import "DetailSummaryViewCell.h"
#import "Settings.h"
#import "UIViewController+iAd.h"
#import "Fuel_SavingsAppDelegate.h"

#define SAVINGS_NEW_TAG 1
#define SAVINGS_ACTION_TAG 2

@interface FuelSavingsViewController (Private)

- (NSArray *)infoDetails;
- (NSArray *)carDetailsForVehicle:(Vehicle *)vehicle;

@end

@implementation FuelSavingsViewController

@synthesize contentView = contentView_;
@synthesize savingsTable = savingsTable_;
@synthesize instructionsLabel = instructionsLabel_;
@synthesize currentSavings = currentSavings_;
@synthesize infoSummary = infoSummary_;
@synthesize car1Summary = car1Summary_;
@synthesize car2Summary = car2Summary_;
@synthesize currentCountry = currentCountry_;

- (id)init
{
	self = [super initWithNibName:@"FuelSavingsViewController" bundle:nil];
	if (self) {
		savingsData_ = [SavingsData sharedSavingsData];
		isNewSavings_ = NO;
		showNewAction_ = NO;
		hasButtons_ = NO;
		self.currentSavings = [Savings emptySavings];
		adBanner_ = SharedAdBannerView;
	}
	return self;
}

- (id)initWithTabBar:(BOOL)tab buttons:(BOOL)buttons
{
	self = [self init];
	if (self) {
		if (tab) {
			self.title = @"Savings";
			self.tabBarItem.image = [UIImage imageNamed:@"piggy_tab.png"];
		}
		hasButtons_ = buttons; 
	}
	return self;
}

- (void)dealloc
{	
	[contentView_ release];
	[savingsTable_ release];
	[instructionsLabel_ release];
	[currentSavings_ release];
	[infoSummary_ release];
	[car1Summary_ release];
	[car2Summary_ release];
	[currentCountry_ release];
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
		
		if (![savingsData_.currentSavings isSavingsEmpty]) {
			self.currentSavings = savingsData_.currentSavings;
		}
		
		self.instructionsLabel.font = [UIFont systemFontOfSize:18.0];
		self.instructionsLabel.text = @"Tap the New button to create a New Savings. You have the option to calculate "
		@"fuel savings for one or two cars.";
	}
}

- (void)viewDidUnload
{
	[super viewDidUnload];
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
	self.contentView = nil;
	self.savingsTable = nil;
	self.instructionsLabel = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	
	adBanner_.delegate = self;
	[self.view addSubview:adBanner_];
	[self layoutContentViewForCurrentOrientation:contentView_ animated:NO];
	
	self.savingsTable.hidden = YES;
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

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
	adBanner_.delegate = nil;
	//[adBanner_ removeFromSuperview];
}

#pragma mark - Custom Actions

- (void)newCheckAction
{
	if ([self.currentSavings isSavingsEmpty]) {
		[self performSelector:@selector(newAction)];
	} else {
		[self performSelector:@selector(newOptionsAction:)];
	}
}

- (void)newAction
{
	Savings *newSavings = [[Savings calculation] retain];
	newSavings.country = [Settings sharedSettings].defaultCountry;
	[newSavings setDefaultValues];
	
	CurrentSavingsViewController *currentSavingsViewController = [[CurrentSavingsViewController alloc] initWithSavings:newSavings];
	currentSavingsViewController.delegate = self;
	
	[newSavings release];
	
	UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:currentSavingsViewController];
	[currentSavingsViewController release];
	
	[self presentModalViewController:navController animated:YES];
	[navController release];
}

- (void)editAction
{
	Savings *editSavings = [self.currentSavings retain];
	
	CurrentSavingsViewController *currentSavingsViewController = [[CurrentSavingsViewController alloc] initWithSavings:editSavings];
	currentSavingsViewController.delegate = self;
	currentSavingsViewController.isEditingSavings = YES;
	
	[editSavings release];
	
	UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:currentSavingsViewController];
	[currentSavingsViewController release];
	
	[self presentModalViewController:navController animated:YES];
	[navController release];
}

- (void)saveAction
{
	[self performSelector:@selector(displayNameAction)];
}

- (void)deleteAction
{
	[self saveCurrentSavings:[Savings emptySavings]];
	[self reloadTable];
}

- (void)displayNameAction
{
	NameInputViewController *inputViewController = [[NameInputViewController alloc] init];
	inputViewController.footerText = @"Enter a name for the Current Savings.";
	inputViewController.delegate = self;
	
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
	[dateFormatter setDateStyle:NSDateFormatterShortStyle];
	[dateFormatter setTimeStyle:NSDateFormatterMediumStyle];
	
	inputViewController.currentName = [NSString stringWithFormat:@"Savings %@", [dateFormatter stringFromDate:[NSDate date]]];
	
	[dateFormatter release];
	
	UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:inputViewController];
	
	[inputViewController release];
	
	[self presentModalViewController:navController animated:YES];
	
	[navController release];
}

- (void)newOptionsAction:(id)sender {	
	UIActionSheet *actionSheet = [[UIActionSheet alloc]
								  initWithTitle:@"You have a Current Savings. What would you like to do before creating a New Savings?"
								  delegate:self
								  cancelButtonTitle:@"Cancel"
								  destructiveButtonTitle:nil
								  otherButtonTitles:@"Save Current As...", @"Delete Current", nil];
	
	actionSheet.destructiveButtonIndex = 1;
	
	actionSheet.tag = SAVINGS_NEW_TAG;
	
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
	
	actionSheet.tag = SAVINGS_ACTION_TAG;
	
	UIView *view = self.view;
	if (hasButtons_) {
		view = self.tabBarController.view;
	}
	[actionSheet showInView:view];
	[actionSheet release];	
}

#pragma mark - Custom Methods

- (void)saveCurrentSavings:(Savings *)savings
{
	self.currentSavings = savings;
	if (hasButtons_) {
		savingsData_.currentSavings = savings;
	}
}

- (void)reloadTable
{
	if (hasButtons_ && [self.currentSavings isSavingsEmpty]) {
		self.currentCountry = [Settings sharedSettings].defaultCountry;
	} else {
		self.currentCountry = self.currentSavings.country;
	}
	
	if ([self.currentSavings isSavingsEmpty]) {
		self.savingsTable.hidden = YES;
		self.navigationItem.rightBarButtonItem.enabled = NO;
	} else {
		self.savingsTable.hidden = NO;
		self.navigationItem.rightBarButtonItem.enabled = YES;
		
		DetailSummaryView *infoView = [[DetailSummaryView alloc] initWithDetails:[self infoDetails]];
		infoView.titleLabel.text = @"Details";
		infoView.imageView.image = [UIImage imageNamed:@"details.png"];
		[self setInfoSummary:infoView];
		[infoView release];
		
		DetailSummaryView *car1View = [[DetailSummaryView alloc] initWithDetails:[self carDetailsForVehicle:self.currentSavings.vehicle1]];
		car1View.titleLabel.text = @"Car 1";
		car1View.imageView.image = [UIImage imageNamed:@"car.png"];
		[self setCar1Summary:car1View];
		[car1View release];
		
		if ([self.currentSavings.vehicle2 hasDataReady]) {
			DetailSummaryView *car2View = [[DetailSummaryView alloc] initWithDetails:[self carDetailsForVehicle:self.currentSavings.vehicle2]];
			car2View.titleLabel.text = @"Car 2";
			car2View.imageView.image = [UIImage imageNamed:@"car.png"];
			[self setCar2Summary:car2View];
			[car2View release];
		}
	}
	[self.savingsTable reloadData];
}

#pragma mark - Private Methods

- (NSArray *)infoDetails
{
	NSMutableArray *details = [[[NSMutableArray alloc] initWithCapacity:0] autorelease];
	
	[details addObject:[DetailView detailDictionaryWithText:@"Using" detail:[self.currentSavings stringForCurrentType]]];
	[details addObject:[DetailView detailDictionaryWithText:@"Fuel Price" detail:[self.currentSavings stringForFuelPrice]]];
	[details addObject:[DetailView detailDictionaryWithText:@"Distance" detail:[self.currentSavings stringForDistance]]];
	
	if (self.currentSavings.type == EfficiencyTypeCombined) {
		[details addObject:[DetailView detailDictionaryWithText:@"City Drive Ratio" detail:[self.currentSavings stringForCityRatio]]];
		[details addObject:[DetailView detailDictionaryWithText:@"Highway Drive Ratio" detail:[self.currentSavings stringForHighwayRatio]]];
	}
	
	[details addObject:[DetailView detailDictionaryWithText:@"Ownership" detail:[self.currentSavings stringForCarOwnership]]];
	
	return details;
}

- (NSArray *)carDetailsForVehicle:(Vehicle *)vehicle
{	
	NSMutableArray *details = [[[NSMutableArray alloc] initWithCapacity:0] autorelease];
	
	[details addObject:[DetailView detailDictionaryWithText:@"Name" detail:[vehicle stringForName]]];
	
	if (self.currentSavings.type == EfficiencyTypeAverage) {
		[details addObject:[DetailView detailDictionaryWithText:@"Average MPG" detail:[vehicle stringForAvgEfficiency]]];
	} else {
		[details addObject:[DetailView detailDictionaryWithText:@"City MPG" detail:[vehicle stringForCityEfficiency]]];
		[details addObject:[DetailView detailDictionaryWithText:@"Highway MPG" detail:[vehicle stringForHighwayEfficiency]]];
	}
	
	return details;
}

#pragma mark - View Controller Delegates

- (void)currentSavingsViewControllerDelegateDidFinish:(CurrentSavingsViewController *)controller save:(BOOL)save
{
	if (save) {
		[self saveCurrentSavings:controller.currentSavings];
	}
	[self dismissModalViewControllerAnimated:YES];
}

- (void)nameInputViewControllerDidFinish:(NameInputViewController *)controller save:(BOOL)save
{
	if (save) {
		self.currentSavings.name = controller.currentName;
		Savings *savings = [self.currentSavings copy];
		[savingsData_.savingsArray addObject:savings];
		[savings release];
		if (isNewSavings_) {
			isNewSavings_ = NO;
			showNewAction_ = YES;
		}
	}
	[self dismissModalViewControllerAnimated:YES];
}

#pragma mark - UITableView Data Source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	if ([self.currentSavings isSavingsEmpty]) {
		return 0;
	}
	return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	NSInteger rows = 1;
	if (section <= 1 && [self.currentSavings.vehicle2 hasDataReady]) {
		rows = 2;
	} else if (section == 2 && [self.currentSavings.vehicle2 hasDataReady]) {
		rows = 3;
	} else if (section == 2 && ![self.currentSavings.vehicle2 hasDataReady]) {
		rows = 2;
	}
	return rows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{	
	if (indexPath.section <= 1) {
		if (indexPath.row < 1) {
			TotalViewType type = TotalViewTypeSingle;
			if ([self.currentSavings.vehicle2 hasDataReady]) {
				type = TotalViewTypeDouble;
			}
			TotalViewCell *totalCell = [[[TotalViewCell alloc] initWithTotalType:type reuseIdentifier:nil] autorelease];
			
			totalCell.selectionStyle = UITableViewCellSelectionStyleNone;
			
			NSString *imageStr = nil;;
			NSString *titleStr = nil;
			NSString *text1LabelStr = nil;
			NSString *text2LabelStr = nil;
			NSString *detail1LabelStr = nil;
			NSString *detail2LabelStr = nil;
			
			text1LabelStr = self.currentSavings.vehicle1.name;
			text2LabelStr = self.currentSavings.vehicle2.name;
			
			if (indexPath.section == 0) {
				imageStr = @"money.png";
				titleStr = @"Annual Fuel Cost";
				detail1LabelStr = [self.currentSavings stringForAnnualCostForVehicle1];
				detail2LabelStr = [self.currentSavings stringForAnnualCostForVehicle2];
			} else {
				imageStr = @"chart.png";
				titleStr = @"Total Fuel Cost";
				detail1LabelStr = [self.currentSavings stringForTotalCostForVehicle1];
				detail2LabelStr = [self.currentSavings stringForTotalCostForVehicle2];
			}
			
			totalCell.totalView.imageView.image = [UIImage imageNamed:imageStr];
			totalCell.totalView.titleLabel.text = titleStr;
			totalCell.totalView.text1Label.text = text1LabelStr;
			totalCell.totalView.detail1Label.text = detail1LabelStr;
			
			if ([self.currentSavings.vehicle2 hasDataReady]) {
				totalCell.totalView.text2Label.text = text2LabelStr;
				totalCell.totalView.detail2Label.text = detail2LabelStr;
				
				NSComparisonResult compareCost;
				
				if (indexPath.section == 0) {
					compareCost = [[self.currentSavings annualCostForVehicle1] compare:[self.currentSavings annualCostForVehicle2]];
				} else {
					compareCost = [[self.currentSavings totalCostForVehicle1] compare:[self.currentSavings totalCostForVehicle2]];
				}
				
				UIColor *highlightColor = [UIColor colorWithRed:245.0/255.0 green:121.0/255.0 blue:0.0 alpha:1.0];
				
				if (compareCost == NSOrderedAscending) {
					totalCell.totalView.text1Label.textColor = highlightColor;
					totalCell.totalView.detail1Label.textColor = highlightColor;
				} else if (compareCost == NSOrderedDescending) {
					totalCell.totalView.text2Label.textColor = highlightColor;
					totalCell.totalView.detail2Label.textColor = highlightColor;
				}
			}
			
			return totalCell;
		} else {
			static NSString *DetailCellIdentifier = @"DetailCell";
			
			TotalDetailViewCell *detailCell = (TotalDetailViewCell *)[tableView dequeueReusableCellWithIdentifier:DetailCellIdentifier];
			
			if (detailCell == nil) {
				detailCell = [[[TotalDetailViewCell alloc] initWithReuseIdentifier:DetailCellIdentifier] autorelease];
			}
			
			detailCell.selectionStyle = UITableViewCellSelectionStyleNone;
			
			NSString *textLabelStr = nil;
			
			if (indexPath.section == 0) {
				textLabelStr = [self.currentSavings annualCostCompareString];
			} else {
				textLabelStr = [self.currentSavings totalCostCompareString];
			}
			
			detailCell.textLabel.text = textLabelStr;
			
			return detailCell;
		}
	}
	
	DetailSummaryView *summary = nil;
	
	if (indexPath.row == 0) {
		summary = infoSummary_;
	} else if (indexPath.row == 1) {
		summary = car1Summary_;
	} else {
		summary = car2Summary_;
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
	CGFloat height = 44.0;
	if (indexPath.section <= 1) {
		if (indexPath.row < 1) {
			height = 66.0;
			if ([self.currentSavings.vehicle2 hasDataReady]) {
				height = 88.0;
			}
		} else {
			height = 46.0;
		}
	} else if (indexPath.section == 2) {
		if (indexPath.row == 0) {
			if (self.currentSavings.type == EfficiencyTypeAverage) {
				height = 117.0;
			} else {
				height = 151.0;
			}
		} else {
			if (self.currentSavings.type == EfficiencyTypeAverage) {
				height = 83.0;
			} else {
				height = 100.0;
			}
		}
	}
	return height;
}

#pragma mark - UIActionSheet Delegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	if (actionSheet.tag == SAVINGS_NEW_TAG) {
		if (buttonIndex == 0) {
			isNewSavings_ = YES;
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
	[self layoutContentViewForCurrentOrientation:contentView_ animated:YES];
}

- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error
{
	[self layoutContentViewForCurrentOrientation:contentView_ animated:YES];
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
