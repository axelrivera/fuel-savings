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
#import "DetailSummaryViewCell.h"

#define SAVINGS_NEW_TAG 1
#define SAVINGS_DELETE_TAG 2

@interface FuelSavingsViewController (Private)

- (void)setInfoSummary:(DetailSummaryView *)summary;
- (void)setCar1Summary:(DetailSummaryView *)summary;
- (void)setCar2Summary:(DetailSummaryView *)summary;

@end

@implementation FuelSavingsViewController

@synthesize showButtons = showButtons_;
@synthesize newSavings = newSavings_;
@synthesize currentSavings = currentSavings_;

- (id)init
{
	self = [super initWithNibName:@"FuelSavingsViewController" bundle:nil];
	if (self) {
		savingsData_ = [SavingsData sharedSavingsData];
		currencyFormatter_ = [[NSNumberFormatter alloc] init];
		[currencyFormatter_ setNumberStyle:NSNumberFormatterCurrencyStyle];
		[currencyFormatter_ setMaximumFractionDigits:0];
		self.showButtons = NO;
		self.newSavings = nil;
		self.currentSavings = [Savings emptySavings];
		isNewSavings_ = NO;
		showNewAction_ = NO;
	}
	return self;
}

- (id)initWithTabBar
{
	self = [self init];
	if (self) {
		self.title = @"Savings";
		self.navigationItem.title = @"Compare Savings";
		self.tabBarItem.image = [UIImage imageNamed:@"piggy_tab.png"];
		self.showButtons = YES;
	}
	return self;
}

- (void)dealloc
{
	[currencyFormatter_ release];
	[newSavings_ release];
	[currentSavings_ release];
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
	
	if (self.showButtons) {
		UIBarButtonItem *editButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit
																					target:self
																					action:@selector(editAction)];
		self.navigationItem.rightBarButtonItem = editButton;
		[editButton release];
		
		UIBarButtonItem *newButton = [[UIBarButtonItem alloc] initWithTitle:@"New"
																	  style:UIBarButtonItemStyleBordered
																	 target:self
																	 action:@selector(newCheckAction)];
		self.navigationItem.leftBarButtonItem = newButton;
		[newButton release];
		
		if (![savingsData_.currentSavings isSavingsEmpty]) {
			self.currentSavings = savingsData_.currentSavings;
		}
	}
	
	self.tableView.sectionHeaderHeight = 10.0;
	self.tableView.sectionFooterHeight = 10.0;
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
	if (![self.currentSavings isSavingsEmpty]) {
		self.navigationItem.rightBarButtonItem.enabled = YES;
		
		NSMutableArray *infoLabels = [[NSMutableArray alloc] initWithCapacity:0];
		NSMutableArray *infoDetails = [[NSMutableArray alloc] initWithCapacity:0];
		
		[infoLabels addObject:@"Using"];
		[infoDetails addObject:[self.currentSavings stringForCurrentType]];
		
		[infoLabels addObject:@"Fuel Price"];
		[infoDetails addObject:[self.currentSavings stringForFuelPrice]];
		
		[infoLabels addObject:@"Distance"];
		[infoDetails addObject:[self.currentSavings stringForDistance]];
		
		if (self.currentSavings.type == EfficiencyTypeCombined) {
			[infoLabels addObject:@"City Drive Ratio"];
			[infoDetails addObject:[self.currentSavings stringForCityRatio]];
			
			[infoLabels addObject:@"Highway Drive Ratio"];
			[infoDetails addObject:[self.currentSavings stringForHighwayRatio]];
		}
		
		[infoLabels addObject:@"Ownership"];
		[infoDetails addObject:[self.currentSavings stringForCarOwnership]];
		
		DetailSummaryView *infoView = [[DetailSummaryView alloc] initWithLabels:infoLabels details:infoDetails];
		infoView.titleLabel.text = @"Details";
		infoView.imageView.image = [UIImage imageNamed:@"details.png"];
		[self setInfoSummary:infoView];
		[infoView release];
		
		[infoLabels release];
		[infoDetails release];
		
		NSMutableArray *car1Labels = [[NSMutableArray alloc] initWithCapacity:0];
		NSMutableArray *car1Details = [[NSMutableArray alloc] initWithCapacity:0];
		
		[car1Labels addObject:@"Name"];
		[car1Details addObject:[self.currentSavings.vehicle1 stringForName]];
		
		if (self.currentSavings.type == EfficiencyTypeAverage) {
			[car1Labels addObject:@"Average MPG"];
			[car1Details addObject:[self.currentSavings.vehicle1 stringForAvgEfficiency]];
		} else {
			[car1Labels addObject:@"City MPG"];
			[car1Details addObject:[self.currentSavings.vehicle1 stringForCityEfficiency]];
			
			[car1Labels addObject:@"Highway MPG"];
			[car1Details addObject:[self.currentSavings.vehicle1 stringForHighwayEfficiency]];
		}
		
		DetailSummaryView *car1View = [[DetailSummaryView alloc] initWithLabels:car1Labels details:car1Details];
		car1View.titleLabel.text = @"Car 1";
		car1View.imageView.image = [UIImage imageNamed:@"car.png"];
		[self setCar1Summary:car1View];
		[car1View release];
		
		[car1Labels release];
		[car1Details release];
		
		if ([self.currentSavings.vehicle2 hasDataReady]) {
			NSMutableArray *car2Labels = [[NSMutableArray alloc] initWithCapacity:0];
			NSMutableArray *car2Details = [[NSMutableArray alloc] initWithCapacity:0];
			
			[car2Labels addObject:@"Name"];
			[car2Details addObject:[self.currentSavings.vehicle2 stringForName]];
			
			if (self.currentSavings.type == EfficiencyTypeAverage) {
				[car2Labels addObject:@"Average MPG"];
				[car2Details addObject:[self.currentSavings.vehicle2 stringForAvgEfficiency]];
			} else {
				[car2Labels addObject:@"City MPG"];
				[car2Details addObject:[self.currentSavings.vehicle2 stringForCityEfficiency]];
				
				[car2Labels addObject:@"Highway MPG"];
				[car2Details addObject:[self.currentSavings.vehicle2 stringForHighwayEfficiency]];
			}
			
			DetailSummaryView *car2View = [[DetailSummaryView alloc] initWithLabels:car2Labels details:car2Details];
			car2View.titleLabel.text = @"Car 2";
			car2View.imageView.image = [UIImage imageNamed:@"car.png"];
			[self setCar2Summary:car2View];
			[car2View release];
			
			[car2Labels release];
			[car2Details release];
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
	self.newSavings = [Savings calculation];
	CurrentSavingsViewController *currentSavingsViewController = [[CurrentSavingsViewController alloc] initWithSavings:newSavings_];
	currentSavingsViewController.delegate = self;
	
	UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:currentSavingsViewController];
	
	[self presentModalViewController:navController animated:YES];
	
	[currentSavingsViewController release];
	[navController release];
}

- (void)editAction
{
	self.newSavings = self.currentSavings;
	CurrentSavingsViewController *currentSavingsViewController = [[CurrentSavingsViewController alloc] initWithSavings:newSavings_];
	currentSavingsViewController.delegate = self;
	currentSavingsViewController.isEditingSavings = YES;
	
	UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:currentSavingsViewController];
	
	[self presentModalViewController:navController animated:YES];
	
	[currentSavingsViewController release];
	[navController release];
}

- (void)saveAction
{
	[self performSelector:@selector(displayNameAction)];
}

- (void)deleteAction
{
	[self saveCurrentSavings:[Savings emptySavings]];
	self.navigationItem.rightBarButtonItem.enabled = NO;
	[self.tableView reloadData];
}

- (void)displayNameAction
{
	NameInputViewController *inputViewController = [[NameInputViewController alloc] initWithNavigationButtons];
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
								  destructiveButtonTitle:@"Delete Current"
								  otherButtonTitles:@"Save Current As...", nil];
	
	actionSheet.tag = SAVINGS_NEW_TAG;
	
	[actionSheet showFromTabBar:self.tabBarController.tabBar];
	[actionSheet release];	
}

- (void)deleteOptionsAction:(id)sender {
	// open a dialog with two custom buttons	
	
	UIActionSheet *actionSheet = [[UIActionSheet alloc]
								  initWithTitle:@"Are you sure? The information on your Current Savings will be lost."
								  delegate:self
								  cancelButtonTitle:@"Cancel"
								  destructiveButtonTitle:@"Delete Current"
								  otherButtonTitles:nil];
	
	actionSheet.tag = SAVINGS_DELETE_TAG;
	
	[actionSheet showFromTabBar:self.tabBarController.tabBar];
	[actionSheet release];	
}

#pragma mark - Custom Methods

- (void)saveCurrentSavings:(Savings *)savings
{
	self.currentSavings = savings;
	if (self.showButtons) {
		savingsData_.currentSavings = savings;
	}
}

#pragma mark - Private Methods

- (void)setInfoSummary:(DetailSummaryView *)summary
{
	[infoSummary_ autorelease];
	infoSummary_ = [summary retain];
}

- (void)setCar1Summary:(DetailSummaryView *)summary
{
	[car1Summary_ autorelease];
	car1Summary_ = [summary retain];
}

- (void)setCar2Summary:(DetailSummaryView *)summary
{
	[car2Summary_ autorelease];
	car2Summary_ = [summary retain];
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
			
			NSNumber *cost1 = nil;
			NSNumber *cost2 = nil;
			
			if (indexPath.section == 0) {
				imageStr = @"money.png";
				titleStr = @"Annual Fuel Cost";
				cost1 = [self.currentSavings annualCostForVehicle1];
				cost2 = [self.currentSavings annualCostForVehicle2];
			} else {
				imageStr = @"chart.png";
				titleStr = @"Total Fuel Cost";
				cost1 = [self.currentSavings totalCostForVehicle1];
				cost2 = [self.currentSavings totalCostForVehicle2];
			}
			
			text1LabelStr = self.currentSavings.vehicle1.name;
			text2LabelStr = self.currentSavings.vehicle2.name;
			
			detail1LabelStr = [currencyFormatter_ stringFromNumber:cost1];
			detail2LabelStr = [currencyFormatter_ stringFromNumber:cost2];
			
			totalCell.totalView.imageView.image = [UIImage imageNamed:imageStr];
			totalCell.totalView.titleLabel.text = titleStr;
			totalCell.totalView.text1Label.text = text1LabelStr;
			totalCell.totalView.detail1Label.text = detail1LabelStr;
			
			if ([self.currentSavings.vehicle2 hasDataReady]) {
				totalCell.totalView.text2Label.text = text2LabelStr;
				totalCell.totalView.detail2Label.text = detail2LabelStr;
				
				UIColor *highlightColor = [UIColor colorWithRed:245.0/255.0 green:121.0/255.0 blue:0.0 alpha:1.0];
				
				NSComparisonResult compareCost = [cost1 compare:cost2];
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
				NSNumber *vehicle1AnnualCost = [self.currentSavings annualCostForVehicle1];
				NSNumber *vehicle2AnnualCost = [self.currentSavings annualCostForVehicle2];
				
				NSComparisonResult result = [vehicle1AnnualCost compare:vehicle2AnnualCost];
				
				if (result == NSOrderedSame) {
					textLabelStr = @"Fuel cost is the same.";
				} else if (result == NSOrderedDescending) {
					NSNumber *savings = [NSNumber numberWithFloat:[vehicle1AnnualCost floatValue] - [vehicle2AnnualCost floatValue]];
					textLabelStr = [NSString stringWithFormat:@"%@ saves you %@ each year.",
									self.currentSavings.vehicle2.name,
									[currencyFormatter_ stringFromNumber:savings]];
				} else {
					NSNumber *savings = [NSNumber numberWithFloat:[vehicle2AnnualCost floatValue] - [vehicle1AnnualCost floatValue]];
					textLabelStr = [NSString stringWithFormat:@"%@ saves you %@ each year.",
									self.currentSavings.vehicle1.name,
									[currencyFormatter_ stringFromNumber:savings]];
				}
			} else {
				NSNumber *vehicle1TotalCost = [self.currentSavings totalCostForVehicle1];
				NSNumber *vehicle2TotalCost = [self.currentSavings totalCostForVehicle2];
				
				NSComparisonResult result = [vehicle1TotalCost compare:vehicle2TotalCost];
				
				NSInteger years = [self.currentSavings.carOwnership integerValue];
				
				if (result == NSOrderedSame) {
					textLabelStr = [NSString stringWithFormat:@"Fuel cost is the same over %i years.", years];
				} else if (result == NSOrderedDescending) {
					NSNumber *savings = [NSNumber numberWithFloat:[vehicle1TotalCost floatValue] - [vehicle2TotalCost floatValue]];
					textLabelStr = [NSString stringWithFormat:@"%@ saves you %@ over %i years.",
									self.currentSavings.vehicle2.name,
									[currencyFormatter_ stringFromNumber:savings],
									years];
				} else {
					NSNumber *savings = [NSNumber numberWithFloat:[vehicle2TotalCost floatValue] - [vehicle1TotalCost floatValue]];
					textLabelStr = [NSString stringWithFormat:@"%@ saves you %@ over %i years.",
									self.currentSavings.vehicle1.name,
									[currencyFormatter_ stringFromNumber:savings],
									years];
				}
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

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
	if (section == 2 && self.navigationItem.rightBarButtonItem != nil) {
		CGFloat contentWidth = [UIScreen mainScreen].bounds.size.width;
		
		UIButton *leftButton = [[UIButton buttonWithType:UIButtonTypeRoundedRect] retain];
		[leftButton addTarget:self action:@selector(saveAction) forControlEvents:UIControlEventTouchDown];
		[leftButton setTitle:@"Save As..." forState:UIControlStateNormal];
		
		UIButton *rightButton = [[UIButton buttonWithType:UIButtonTypeRoundedRect] retain];
		[rightButton addTarget:self action:@selector(deleteOptionsAction:) forControlEvents:UIControlEventTouchDown];
		[rightButton setTitle:@"Delete" forState:UIControlStateNormal];
		
		UIView *buttonView = [[[UIView alloc] initWithFrame:CGRectZero] autorelease];
		//buttonView.frame = CGRectMake(0.0, 0.0, contentWidth, 84.0);
		
		leftButton.frame = CGRectMake(10.0,
									  20.0,
									  (contentWidth / 2.0) - (10.0 + 5.0),
									  44.0);
		
		rightButton.frame = CGRectMake((contentWidth / 2.0) + 5.0,
									   20.0,
									   (contentWidth / 2.0) - (10.0 + 5.0),
									   44.0);
		
		[buttonView addSubview:leftButton];
		[buttonView addSubview:rightButton];
		
		
		[leftButton release];
		[rightButton release];
		
		return buttonView;
	}
	return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
	if (section == 2) {
		return 84.0;
	}
	return 10.0;
}

#pragma mark - UIActionSheet Delegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	if (actionSheet.tag == SAVINGS_NEW_TAG) {
		if (buttonIndex == 0) {
			[self performSelector:@selector(newAction)];
		} else if (buttonIndex == 1) {
			isNewSavings_ = YES;
			[self performSelector:@selector(saveAction)];
		}
	} else {
		if (buttonIndex == 0) {
			[self performSelector:@selector(deleteAction)];
		}
	}
}

@end
