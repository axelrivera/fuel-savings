//
//  FuelSavingsViewController.m
//  Fuel Savings
//
//  Created by arn on 6/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "FuelSavingsViewController.h"
#import "CurrentSavingsViewController.h"
#import "TotalView.h"
#import "TotalViewCell.h"
#import "TotalDetailViewCell.h"

#define SAVINGS_NEW_TAG 1
#define SAVINGS_DELETE_TAG 2

@implementation FuelSavingsViewController

@synthesize savingsCalculation = savingsCalculation_;
@synthesize backupCopy = backupCopy_;

- (id)init
{
	self = [super initWithNibName:@"FuelSavingsViewController" bundle:nil];
	if (self) {
		savingsData_ = [SavingsData sharedSavingsData];
		currencyFormatter_ = [[NSNumberFormatter alloc] init];
		[currencyFormatter_ setNumberStyle:NSNumberFormatterCurrencyStyle];
		[currencyFormatter_ setMaximumFractionDigits:0];
		self.savingsCalculation = nil;
		self.backupCopy = nil;
		isNewSavings_ = NO;
		showNewAction_ = NO;
		hasTabBar_ = NO;
	}
	return self;
}

- (id)initWithTabBar
{
	self = [self init];
	if (self) {
		self.title = @"Savings";
		self.navigationItem.title = @"Compare Savings";
		self.tabBarItem.image = [UIImage imageNamed:@"savings_tab.png"];
		hasTabBar_ = YES;
	}
	return self;
}

- (void)dealloc
{
	[currencyFormatter_ release];
	[annualFooterView_ release];
	[totalFooterView_ release];
	[infoFooterView_ release];
	[savingsCalculation_ release];
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
		self.savingsCalculation = savingsData_.savingsCalculation;
	} else {
		if (self.savingsCalculation == nil) {
			[self.navigationController popToRootViewControllerAnimated:YES];
		}
	}
	
	if (self.savingsCalculation) {
		self.navigationItem.rightBarButtonItem.enabled = YES;
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
		savingsData_.savingsCalculation = self.savingsCalculation;
	}
}

#pragma mark - Custom Actions

- (void)newCheckAction
{
	if (self.savingsCalculation == nil) {
		[self performSelector:@selector(newAction)];
	} else {
		[self performSelector:@selector(newOptionsAction:)];
	}
}

- (void)newAction
{
	self.savingsCalculation = [Savings calculation];
	savingsData_.currentCalculation = self.savingsCalculation;
	CurrentSavingsViewController *currentSavingsViewController = [[CurrentSavingsViewController alloc] init];
	currentSavingsViewController.delegate = self;
	
	UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:currentSavingsViewController];
	
	[currentSavingsViewController release];
	
	[self presentModalViewController:navController animated:YES];
	
	[navController release];
}

- (void)editAction
{
	self.backupCopy = self.savingsCalculation;
	savingsData_.currentCalculation = self.savingsCalculation;
	CurrentSavingsViewController *currentSavingsViewController = [[CurrentSavingsViewController alloc] init];
	currentSavingsViewController.delegate = self;
	currentSavingsViewController.isEditingSavings = YES;
	
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
	self.savingsCalculation = nil;
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

#pragma mark - View Controller Delegates

- (void)currentSavingsViewControllerDelegateDidFinish:(CurrentSavingsViewController *)controller save:(BOOL)save
{
	if (!save) {
		if (controller.isEditingSavings == YES) {
			self.savingsCalculation = self.backupCopy;
		} else {
			self.savingsCalculation = nil;
		}
	}
	savingsData_.currentCalculation = nil;
	[self dismissModalViewControllerAnimated:YES];
}

- (void)nameInputViewControllerDidFinish:(NameInputViewController *)controller save:(BOOL)save
{
	if (save) {
		self.savingsCalculation.name = controller.currentName;
		[savingsData_.savedCalculations addObject:[self.savingsCalculation copy]];
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
	if (self.savingsCalculation == nil) {
		return 0;
	}
	
	NSInteger sections = 3;
	
	if (hasTabBar_) {
		sections = sections + 1;
	}
	
	return sections;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	NSInteger rows = 1;
	if (section <= 1 && [self.savingsCalculation.vehicle2 hasDataReady]) {
		rows = 2;
	}
	return rows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{	
	if (indexPath.section <= 1) {
		if (indexPath.row < 1) {
			TotalViewType type = TotalViewTypeSingle;
			if ([self.savingsCalculation.vehicle2 hasDataReady]) {
				type = TotalViewTypeDouble;
			}
			TotalViewCell *totalCell = [[[TotalViewCell alloc] initWithTotalType:type] autorelease];
			
			totalCell.selectionStyle = UITableViewCellSelectionStyleNone;
			
			NSString *imageStr = nil;;
			NSString *titleStr = nil;
			NSString *text1LabelStr = nil;
			NSString *text2LabelStr = nil;
			NSString *detail1LabelStr = nil;
			NSString *detail2LabelStr = nil;
			
			if (indexPath.section == 0) {
				imageStr = @"money.png";
				titleStr = @"Annual Fuel Cost";
				detail1LabelStr = [currencyFormatter_ stringFromNumber:[self.savingsCalculation annualCostForVehicle1]];
				detail2LabelStr = [currencyFormatter_ stringFromNumber:[self.savingsCalculation annualCostForVehicle2]];
			} else {
				imageStr = @"chart.png";
				titleStr = @"Total Fuel Cost";
				detail1LabelStr = [currencyFormatter_ stringFromNumber:[self.savingsCalculation totalCostForVehicle1]];
				detail2LabelStr = [currencyFormatter_ stringFromNumber:[self.savingsCalculation totalCostForVehicle2]];
			}
			
			text1LabelStr = self.savingsCalculation.vehicle1.name;
			text2LabelStr = self.savingsCalculation.vehicle2.name;
			
			totalCell.totalView.imageView.image = [UIImage imageNamed:imageStr];
			totalCell.totalView.titleLabel.text = titleStr;
			totalCell.totalView.text1Label.text = text1LabelStr;
			totalCell.totalView.detail1Label.text = detail1LabelStr;
			
			if ([self.savingsCalculation.vehicle2 hasDataReady]) {
				totalCell.totalView.text2Label.text = text2LabelStr;
				totalCell.totalView.detail2Label.text = detail2LabelStr;
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
				NSNumber *vehicle1AnnualCost = [self.savingsCalculation annualCostForVehicle1];
				NSNumber *vehicle2AnnualCost = [self.savingsCalculation annualCostForVehicle2];
				
				NSComparisonResult result = [vehicle1AnnualCost compare:vehicle2AnnualCost];
				
				if (result == NSOrderedSame) {
					textLabelStr = @"Fuel cost is the same.";
				} else if (result == NSOrderedDescending) {
					NSNumber *savings = [NSNumber numberWithFloat:[vehicle1AnnualCost floatValue] - [vehicle2AnnualCost floatValue]];
					textLabelStr = [NSString stringWithFormat:@"%@ saves you %@ each year.",
									self.savingsCalculation.vehicle2.name,
									[currencyFormatter_ stringFromNumber:savings]];
				} else {
					NSNumber *savings = [NSNumber numberWithFloat:[vehicle2AnnualCost floatValue] - [vehicle1AnnualCost floatValue]];
					textLabelStr = [NSString stringWithFormat:@"%@ saves you %@ each year.",
									self.savingsCalculation.vehicle1.name,
									[currencyFormatter_ stringFromNumber:savings]];
				}
			} else {
				NSNumber *vehicle1TotalCost = [self.savingsCalculation totalCostForVehicle1];
				NSNumber *vehicle2TotalCost = [self.savingsCalculation totalCostForVehicle2];
				
				NSComparisonResult result = [vehicle1TotalCost compare:vehicle2TotalCost];
				
				NSInteger years = [self.savingsCalculation.carOwnership integerValue];
				
				if (result == NSOrderedSame) {
					textLabelStr = [NSString stringWithFormat:@"Fuel cost is the same over %i years.", years];
				} else if (result == NSOrderedDescending) {
					NSNumber *savings = [NSNumber numberWithFloat:[vehicle1TotalCost floatValue] - [vehicle2TotalCost floatValue]];
					textLabelStr = [NSString stringWithFormat:@"%@ saves you %@ over %i years.",
									self.savingsCalculation.vehicle2.name,
									[currencyFormatter_ stringFromNumber:savings],
									years];
				} else {
					NSNumber *savings = [NSNumber numberWithFloat:[vehicle2TotalCost floatValue] - [vehicle1TotalCost floatValue]];
					textLabelStr = [NSString stringWithFormat:@"%@ saves you %@ over %i years.",
									self.savingsCalculation.vehicle1.name,
									[currencyFormatter_ stringFromNumber:savings],
									years];
				}
			}
			
			detailCell.textLabel.text = textLabelStr;
			
			return detailCell;
		}
	}
	
	static NSString *CellIdentifier = @"ButtonCell";
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
	}
	
	UIView *backView = [[[UIView alloc] initWithFrame:CGRectZero] autorelease];
	cell.backgroundColor = [UIColor clearColor];
	cell.backgroundView = backView;
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
	
	CGFloat contentWidth = [UIScreen mainScreen].bounds.size.width - 20.0;
	
	if (indexPath.section == 2) {
		UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectZero];
		textLabel.lineBreakMode = UILineBreakModeWordWrap;
		textLabel.numberOfLines = 3;
		textLabel.textAlignment = UITextAlignmentCenter;
		textLabel.backgroundColor = [UIColor clearColor];
		textLabel.textColor = [UIColor darkGrayColor];
		textLabel.font = [UIFont systemFontOfSize:14.0];
		textLabel.shadowColor = [UIColor whiteColor];
		textLabel.shadowOffset = CGSizeMake(0.0, 1.0);
		
		NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
		
		[formatter setNumberStyle:NSNumberFormatterCurrencyStyle];
		
		NSString *fuelStr = [formatter stringFromNumber:self.savingsCalculation.fuelPrice];
		
		[formatter setNumberStyle:NSNumberFormatterDecimalStyle];
		[formatter setMaximumFractionDigits:0];
		
		NSString *distanceStr = [formatter stringFromNumber:self.savingsCalculation.distance];
		
		NSInteger years = [self.savingsCalculation.carOwnership integerValue];
		
		NSString *yearsStr = nil;
		
		if (years == 1) {
			yearsStr = [NSString stringWithFormat:@"%i year", years];
		} else {
			yearsStr = [NSString stringWithFormat:@"%i years", years];
		}
		
		textLabel.text = [NSString stringWithFormat:
						  @"Fuel Price - %@ /gallon\n"
						  @"Distance - %@ miles/year\n"
						  @"Ownership - %@",
						  fuelStr,
						  distanceStr,
						  yearsStr];
		
		textLabel.frame = CGRectMake(10.0, 0.0, contentWidth, 66.0);
		
		cell.accessoryView = textLabel;
		
		[textLabel release];
		[formatter release];
	} else {
		UIButton *leftButton = [[UIButton buttonWithType:UIButtonTypeRoundedRect] retain];
		[leftButton addTarget:self action:@selector(saveAction) forControlEvents:UIControlEventTouchDown];
		[leftButton setTitle:@"Save As..." forState:UIControlStateNormal];
		
		UIButton *rightButton = [[UIButton buttonWithType:UIButtonTypeRoundedRect] retain];
		[rightButton addTarget:self action:@selector(deleteOptionsAction:) forControlEvents:UIControlEventTouchDown];
		[rightButton setTitle:@"Delete" forState:UIControlStateNormal];
		
		UIView *buttonView = [[UIView alloc] initWithFrame:CGRectZero];
		buttonView.frame = CGRectMake(20.0, 0.0, contentWidth, 44.0);
		
		leftButton.frame = CGRectMake(0.0,
									  0.0,
									  (contentWidth / 2.0) - 10.0,
									  44.0);
		
		rightButton.frame = CGRectMake((contentWidth / 2.0) + 5.0,
									  0.0,
									  (contentWidth / 2.0) - 10.0,
									  44.0);
		
		[buttonView addSubview:leftButton];
		[buttonView addSubview:rightButton];
		
		cell.accessoryView = buttonView;
		
		[leftButton release];
		[rightButton release];
		[buttonView release];
	}
	
	return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSInteger height = 44.0;
	if (indexPath.section <= 1) {
		if (indexPath.row < 1) {
			height = 66.0;
			if ([self.savingsCalculation.vehicle2 hasDataReady]) {
				height = 88.0;
			}
		} else {
			height = 46.0;
		}
	} else if (indexPath.section == 2) {
		height = 66.0;
	}
	return height;
}

-(CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
		return 13.0;
	}
    return 1.0;
}


-(CGFloat)tableView:(UITableView*)tableView heightForFooterInSection:(NSInteger)section
{
	NSInteger height = 13.0;
	if (section == 1 || section == 2) {
		height = 1.0;
	}
    return height;
}

-(UIView*)tableView:(UITableView*)tableView viewForHeaderInSection:(NSInteger)section
{
    return [[[UIView alloc] initWithFrame:CGRectZero] autorelease];
}

-(UIView*)tableView:(UITableView*)tableView viewForFooterInSection:(NSInteger)section
{
    return [[[UIView alloc] initWithFrame:CGRectZero] autorelease];
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
