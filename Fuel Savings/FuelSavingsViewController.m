//
//  FuelSavingsViewController.m
//  Fuel Savings
//
//  Created by Axel Rivera on 6/27/11.
//  Copyright 2011 Axel Rivera. All rights reserved.
//

#import "FuelSavingsViewController.h"
#import "FuelSavingsViewController+Details.h"
#import "TotalView.h"
#import "TotalViewCell.h"
#import "TotalDetailViewCell.h"
#import "DetailView.h"
#import "DetailSummaryViewCell.h"
#import "Settings.h"

#define SAVINGS_NEW_TAG 1
#define SAVINGS_ACTION_TAG 2

@implementation FuelSavingsViewController

@synthesize savingsTable = savingsTable_;
@synthesize instructionsLabel = instructionsLabel_;
@synthesize currentSavings = currentSavings_;

- (id)init
{
	self = [super initWithNibName:@"FuelSavingsViewController" bundle:nil];
	if (self) {
		savingsData_ = [SavingsData sharedSavingsData];
		isNewSavings_ = NO;
		showNewAction_ = NO;
		hasButtons_ = NO;
		self.currentSavings = [Savings emptySavings];
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
	[savingsTable_ release];
	[instructionsLabel_ release];
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
		
	if (hasButtons_) {
		UIBarButtonItem *myNewButton = [[UIBarButtonItem alloc] initWithTitle:@"New"
																	  style:UIBarButtonItemStyleBordered
																	 target:self
																	 action:@selector(myNewCheckAction)];
		self.navigationItem.leftBarButtonItem = myNewButton;
		[myNewButton release];
		
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
	self.savingsTable = nil;
	self.instructionsLabel = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	
	self.savingsTable.hidden = YES;
	[self reloadTable];
}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
	
	if (showNewAction_ == YES) {
		showNewAction_ = NO;
		[self performSelector:@selector(myNewAction)];
	}
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

#pragma mark - Custom Actions

- (void)myNewCheckAction
{
	if ([self.currentSavings isSavingsEmpty]) {
		[self performSelector:@selector(myNewAction)];
	} else {
		[self performSelector:@selector(myNewOptionsAction:)];
	}
}

- (void)myNewAction
{
	Savings *myNewSavings = [[Savings calculation] retain];
	CurrentSavingsViewController *currentSavingsViewController = [[CurrentSavingsViewController alloc] initWithSavings:myNewSavings];
	currentSavingsViewController.delegate = self;
	[myNewSavings release];
	
	UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:currentSavingsViewController];
	[currentSavingsViewController release];
	[self presentModalViewController:navController animated:YES];
	[navController release];
}

- (void)editAction
{
	Savings *editSavings = [currentSavings_ retain];
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

- (void)myNewOptionsAction:(id)sender {	
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
	Savings *savingsCopy = [savings copy];
	self.currentSavings = savingsCopy;
	[savingsCopy release];
	if (hasButtons_) {
		savingsData_.currentSavings = savings;
	}
}

- (void)reloadTable
{
	if ([currentSavings_ isSavingsEmpty]) {
		self.savingsTable.hidden = YES;
		self.navigationItem.rightBarButtonItem.enabled = NO;
	} else {
		self.savingsTable.hidden = NO;
		self.navigationItem.rightBarButtonItem.enabled = YES;
	}
	[self.savingsTable reloadData];
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
		currentSavings_.name = controller.currentName;
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
	if ([currentSavings_ isSavingsEmpty]) {
		return 0;
	}
	return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	NSInteger rows = 1;
	if (section <= 1 && [currentSavings_.vehicle2 hasDataReady]) {
		rows = 2;
	} else if (section == 2 && [currentSavings_.vehicle2 hasDataReady]) {
		rows = 3;
	} else if (section == 2 && ![currentSavings_.vehicle2 hasDataReady]) {
		rows = 2;
	}
	return rows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{	
	if (indexPath.section <= 1) {
		if (indexPath.row < 1) {
			static NSString *CellIdentifier = @"TotalCell";
			TotalViewCell *totalCell = (TotalViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
			if (totalCell == nil) {
				totalCell = [[[TotalViewCell alloc] initWithReuseIdentifier:CellIdentifier] autorelease];
			}
			
			TotalView *totalView = nil;
			if (indexPath.section == 0) {
				totalView = [self annualFuelCostView];
			} else {
				totalView = [self totalFuelCostView];
			}
			
			[totalCell setTotalView:totalView];
			
			totalCell.selectionStyle = UITableViewCellSelectionStyleNone;
			
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
				textLabelStr = [currentSavings_ annualCostCompareString];
			} else {
				textLabelStr = [currentSavings_ totalCostCompareString];
			}
			
			detailCell.textLabel.text = textLabelStr;
			
			return detailCell;
		}
	}
		
	static NSString *SummaryCellIdentifier = @"SummaryCell";
	
	DetailSummaryViewCell *summaryCell = (DetailSummaryViewCell *)[tableView dequeueReusableCellWithIdentifier:SummaryCellIdentifier];
	if (summaryCell == nil) {
		summaryCell = [[[DetailSummaryViewCell alloc] initWithReuseIdentifier:SummaryCellIdentifier] autorelease];
	}
	
	DetailSummaryView *summaryView = nil;
	if (indexPath.row == 0) {
		summaryView = [self infoSummaryView];
	} else if (indexPath.row == 1) {
		summaryView = [self car1SummaryView];
	} else {
		summaryView = [self car2SummaryView];
	}
	
	[summaryCell setSummaryView:summaryView];
	
	summaryCell.selectionStyle = UITableViewCellSelectionStyleNone;
	
	return summaryCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	CGFloat height = 44.0;
	if (indexPath.section <= 1) {
		if (indexPath.row < 1) {
			height = 66.0;
			if ([currentSavings_.vehicle2 hasDataReady]) {
				height = 88.0;
			}
		} else {
			height = 46.0;
		}
	} else if (indexPath.section == 2) {
		if (indexPath.row == 0) {
			if (currentSavings_.type == EfficiencyTypeAverage) {
				height = 100.0;
			} else {
				height = 134.0;
			}
		} else {
			if (currentSavings_.type == EfficiencyTypeAverage) {
				height = 100.0;
			} else {
				height = 117.0;
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
			[self performSelector:@selector(myNewAction)];
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

@end
