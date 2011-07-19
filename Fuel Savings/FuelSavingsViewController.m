//
//  FuelSavingsViewController.m
//  Fuel Savings
//
//  Created by arn on 6/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "FuelSavingsViewController.h"
#import "CurrentSavingsViewController.h"

#define SAVINGS_NEW_TAG 1
#define SAVINGS_DELETE_TAG 2

@implementation FuelSavingsViewController

static CGSize annualLabelSize;
static CGSize totalLabelSize;

@synthesize vehicle1AnnualCost = vehicle1AnnualCost_;
@synthesize vehicle1TotalCost = vehicle1TotalCost_;
@synthesize vehicle2AnnualCost = vehicle2AnnualCost_;
@synthesize vehicle2TotalCost = vehicle2TotalCost_;
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
		annualLabelSize = CGSizeZero;
		totalLabelSize = CGSizeZero;
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
	[vehicle1AnnualCost_ release];
	[vehicle1TotalCost_ release];
	[vehicle2AnnualCost_ release];
	[vehicle2TotalCost_ release];
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
		EfficiencyType type = self.savingsCalculation.type;
		if ([self.savingsCalculation.vehicle1 hasDataReadyForType:type]) {
			self.vehicle1AnnualCost = [self.savingsCalculation annualCostForVehicle1];
			self.vehicle1TotalCost = [self.savingsCalculation totalCostForVehicle1];
		} else {
			self.vehicle1AnnualCost = [NSNumber numberWithFloat:0.0];
			self.vehicle1TotalCost = [NSNumber numberWithFloat:0.0];
		}
		
		if ([self.savingsCalculation.vehicle2 hasDataReadyForType:type]) {
			self.vehicle2AnnualCost = [self.savingsCalculation annualCostForVehicle2];
			self.vehicle2TotalCost = [self.savingsCalculation totalCostForVehicle2];
		} else {
			self.vehicle2AnnualCost = [NSNumber numberWithFloat:0.0];
			self.vehicle2TotalCost = [NSNumber numberWithFloat:0.0];
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
		sections = sections + 2;
	}
	
	return sections;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	NSInteger rows = 0;
	
	if (section == 0 || section == 1) {
		EfficiencyType type = self.savingsCalculation.type;
		
		if ([self.savingsCalculation.vehicle1 hasDataReadyForType:type]) {
			rows++;
		}
		
		if ([self.savingsCalculation.vehicle2 hasDataReadyForType:type]) {
			rows++;
		}
	} else if (section == 2) {
		rows = 3;
	} else {
		rows = 1;
	}
	
	return rows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{	
	if (indexPath.section == 0 || indexPath.section == 1) {
		static NSString *VehicleCellIdentifier = @"VehicleCell";
		
		UITableViewCell *vehicleCell = [tableView dequeueReusableCellWithIdentifier:VehicleCellIdentifier];
		
		if (vehicleCell == nil) {
			vehicleCell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:VehicleCellIdentifier] autorelease];
		}
		
		NSNumber *number1 = nil;
		NSNumber *number2 = nil;
		if (indexPath.section == 0) {
			number1 = self.vehicle1AnnualCost;
			number2 = self.vehicle2AnnualCost;
		} else {
			number1 = self.vehicle1TotalCost;
			number2 = self.vehicle2TotalCost;
		}
		
		NSString *textLabelString = nil;
		NSString *detailTextLabelString = nil;
		
		if (indexPath.row == 0) {
			textLabelString = self.savingsCalculation.vehicle1.name;
			detailTextLabelString = [currencyFormatter_ stringFromNumber:number1];
		} else {
			textLabelString = self.savingsCalculation.vehicle2.name;
			detailTextLabelString = [currencyFormatter_ stringFromNumber:number2];
		}
		
		vehicleCell.accessoryType = UITableViewCellAccessoryNone;
		vehicleCell.selectionStyle = UITableViewCellSelectionStyleNone;
		
		vehicleCell.textLabel.font = [UIFont boldSystemFontOfSize:15.0];
		vehicleCell.detailTextLabel.font = [UIFont systemFontOfSize:15.0];
		
		vehicleCell.textLabel.text = textLabelString;
		vehicleCell.detailTextLabel.text = detailTextLabelString;
		
		return vehicleCell;
	} else if (indexPath.section == 2) {
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
			
			NSString *numberString = [formatter stringFromNumber:self.savingsCalculation.fuelPrice];
			[formatter release];
			
			detailTextLabelString = [NSString stringWithFormat:@"%@ /gallon", numberString];
		} else if (indexPath.row == 1) {
			textLabelString = @"Distance";
			
			NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
			[formatter setNumberStyle:NSNumberFormatterDecimalStyle];
			[formatter setMaximumFractionDigits:0];
			
			NSString *numberString = [formatter stringFromNumber:self.savingsCalculation.distance];
			[formatter release];
			
			detailTextLabelString = [NSString stringWithFormat:@"%@ miles/year", numberString];
		} else {
			textLabelString = @"Ownership";
			detailTextLabelString = [NSString stringWithFormat:@"%@ years",
									 [self.savingsCalculation.carOwnership stringValue]];
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
	
	if (indexPath.section == 3) {
		[button addTarget:self action:@selector(saveAction) forControlEvents:UIControlEventTouchDown];
		[button setTitle:@"Save Current As..." forState:UIControlStateNormal];
	}
	
	if (indexPath.section == 4) {
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
		return @"Annual Cost";
	} else if (section == 1) {
		return @"Total Cost";
	} else if (section == 2) {
		return @"Information";
	}
	return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
	return 34.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
	if (section == 0) {
		return annualLabelSize.height + 10.0;
	} else if (section == 1) {
		return totalLabelSize.height + 10.0;
	}
	return 84.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
	if (!self.savingsCalculation) {
		return nil;
	}
	
	EfficiencyType type = self.savingsCalculation.type;
	
	BOOL isVehicle1Ready = [self.savingsCalculation.vehicle1 hasDataReadyForType:type];
	BOOL isVehicle2Ready = [self.savingsCalculation.vehicle2 hasDataReadyForType:type];
	if (section == 0) {
		if (isVehicle1Ready && isVehicle2Ready) {
			[annualFooterView_ autorelease];
			annualFooterView_ = [[UIView alloc] initWithFrame:CGRectZero];
			
			UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
			label.lineBreakMode = UILineBreakModeWordWrap;
			label.numberOfLines = 2;
			label.textAlignment = UITextAlignmentCenter;
			label.font = [UIFont systemFontOfSize:15.0];
			label.textColor = [UIColor colorWithRed:0.0 green:128.0/255.0 blue:0.0 alpha:1.0];
			label.backgroundColor = [UIColor clearColor];
			
			label.shadowColor = [UIColor whiteColor];
			label.shadowOffset = CGSizeMake(0.0, 1.0);
			
			
			NSComparisonResult result = [self.vehicle1AnnualCost compare:self.vehicle2AnnualCost];
			
			if (result == NSOrderedSame) {
				label.text = @"Annual fuel cost is the same.";
			} else if (result == NSOrderedDescending) {
				NSNumber *savings = [NSNumber numberWithFloat:[self.vehicle1AnnualCost floatValue] - [self.vehicle2AnnualCost floatValue]];
				label.text = [NSString stringWithFormat:@"%@ saves you %@ each year.",
							  self.savingsCalculation.vehicle2.name,
							  [currencyFormatter_ stringFromNumber:savings]];
			} else {
				NSNumber *savings = [NSNumber numberWithFloat:[self.vehicle2AnnualCost floatValue] - [self.vehicle1AnnualCost floatValue]];
				label.text = [NSString stringWithFormat:@"%@ saves you %@ each year.",
							  self.savingsCalculation.vehicle1.name,
							  [currencyFormatter_ stringFromNumber:savings]];
			}
			
			annualLabelSize = [label.text sizeWithFont:[UIFont systemFontOfSize:15.0]
									 constrainedToSize:CGSizeMake(280.0, 50.0)
										 lineBreakMode:UILineBreakModeWordWrap];
			
			label.frame = CGRectMake(20.0,
									 5.0,
									 280.0,
									 annualLabelSize.height);
			
			
			[annualFooterView_ addSubview:label];
			[label release];
			
			return annualFooterView_;
		}
	} else if (section == 1) {
		if (isVehicle1Ready && isVehicle2Ready) {
			[totalFooterView_ autorelease];
			totalFooterView_ = [[UIView alloc] initWithFrame:CGRectZero];
			
			UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
			label.lineBreakMode = UILineBreakModeWordWrap;
			label.numberOfLines = 2;
			label.textAlignment = UITextAlignmentCenter;
			label.font = [UIFont systemFontOfSize:15.0];
			label.textColor = [UIColor colorWithRed:0.0 green:128.0/255.0 blue:0.0 alpha:1.0];
			label.backgroundColor = [UIColor clearColor];
			
			label.shadowColor = [UIColor whiteColor];
			label.shadowOffset = CGSizeMake(0.0, 1.0);
			
			
			NSComparisonResult result = [self.vehicle1TotalCost compare:self.vehicle2TotalCost];
			
			NSInteger years = [self.savingsCalculation.carOwnership integerValue];
			
			if (result == NSOrderedSame) {
				label.text = [NSString stringWithFormat:@"The total fuel cost is the same over a period of %i years.", years];
			} else if (result == NSOrderedDescending) {
				NSNumber *savings = [NSNumber numberWithFloat:[self.vehicle1TotalCost floatValue] - [self.vehicle2TotalCost floatValue]];
				label.text = [NSString stringWithFormat:@"%@ saves you %@ over %i years.",
							  self.savingsCalculation.vehicle2.name,
							  [currencyFormatter_ stringFromNumber:savings],
							  years];
			} else {
				NSNumber *savings = [NSNumber numberWithFloat:[self.vehicle2TotalCost floatValue] - [self.vehicle1TotalCost floatValue]];
				label.text = [NSString stringWithFormat:@"%@ saves you %@ over %i years.",
							  self.savingsCalculation.vehicle1.name,
							  [currencyFormatter_ stringFromNumber:savings],
							  years];
			}
			
			totalLabelSize = [label.text sizeWithFont:[UIFont systemFontOfSize:15.0]
									 constrainedToSize:CGSizeMake(280.0, 50.0)
										 lineBreakMode:UILineBreakModeWordWrap];
			
			label.frame = CGRectMake(20.0,
									 5.0,
									 280.0,
									 totalLabelSize.height);
			
			[totalFooterView_ addSubview:label];
			[label release];
			
			return totalFooterView_;
		}
	}
	return nil;
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
