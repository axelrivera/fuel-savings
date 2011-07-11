//
//  FuelSavingsViewController.m
//  Fuel Savings
//
//  Created by arn on 6/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "FuelSavingsViewController.h"
#import "CurrentSavingsViewController.h"
#import "SavingsCalculation.h"

@implementation FuelSavingsViewController

static CGSize annualLabelSize;
static CGSize totalLabelSize;

@synthesize savingsTable = savingsTable_;
@synthesize vehicle1AnnualCost = vehicle1AnnualCost_;
@synthesize vehicle1TotalCost = vehicle1TotalCost_;
@synthesize vehicle2AnnualCost = vehicle2AnnualCost_;
@synthesize vehicle2TotalCost = vehicle2TotalCost_;
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
		self.backupCopy = nil;
	}
	return self;
}

- (id)initWithTabBar
{
	self = [self init];
	if (self) {
		self.title = @"Compare";
		self.navigationItem.title = @"Compare Savings";
		self.tabBarItem.image = [UIImage imageNamed:@"compare_tab.png"];
	}
	return self;
}

- (void)dealloc
{
	[savingsTable_ release];
	[currencyFormatter_ release];
	[vehicle1AnnualCost_ release];
	[vehicle1TotalCost_ release];
	[vehicle2AnnualCost_ release];
	[vehicle2TotalCost_ release];
	[annualFooterView_ release];
	[totalFooterView_ release];
	[infoFooterView_ release];
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
	
	UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit
																				target:self
																				action:@selector(editAction)];
	self.navigationItem.leftBarButtonItem = leftButton;
	[leftButton release];
	
	UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"New"
																	style:UIBarButtonItemStyleBordered
																   target:self
																   action:@selector(newAction)];
	self.navigationItem.rightBarButtonItem = rightButton;
	[rightButton release];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
	self.savingsTable = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	
	self.navigationItem.leftBarButtonItem.enabled = NO;
	
	if (savingsData_.currentCalculation) {
		self.navigationItem.leftBarButtonItem.enabled = YES;
		EfficiencyType type = savingsData_.currentCalculation.type;
		if ([savingsData_.currentCalculation.vehicle1 hasDataReadyForType:type]) {
			self.vehicle1AnnualCost = [savingsData_.currentCalculation annualCostForVehicle1];
			self.vehicle1TotalCost = [savingsData_.currentCalculation totalCostForVehicle1];
		} else {
			self.vehicle1AnnualCost = [NSNumber numberWithFloat:0.0];
			self.vehicle1TotalCost = [NSNumber numberWithFloat:0.0];
		}
		
		if ([savingsData_.currentCalculation.vehicle2 hasDataReadyForType:type]) {
			self.vehicle2AnnualCost = [savingsData_.currentCalculation annualCostForVehicle2];
			self.vehicle2TotalCost = [savingsData_.currentCalculation totalCostForVehicle2];
		} else {
			self.vehicle2AnnualCost = [NSNumber numberWithFloat:0.0];
			self.vehicle2TotalCost = [NSNumber numberWithFloat:0.0];
		}
	}
	[self.savingsTable reloadData];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

#pragma mark - Custom Actions

- (void)newAction
{
	[savingsData_ setupCurrentCalculation];
	CurrentSavingsViewController *currentSavingsViewController = [[CurrentSavingsViewController alloc] init];
	currentSavingsViewController.delegate = self;
	
	UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:currentSavingsViewController];
	
	[currentSavingsViewController release];
	
	[self presentModalViewController:navController animated:YES];
	
	[navController release];
}

- (void)editAction
{
	self.backupCopy = savingsData_.currentCalculation;
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

#pragma mark - View Controller Delegates

- (void)currentSavingsViewControllerDelegateDidDelete:(CurrentSavingsViewController *)controller
{
	self.backupCopy = nil;
}

- (void)currentSavingsViewControllerDelegateDidFinish:(CurrentSavingsViewController *)controller save:(BOOL)save
{
	if (!save) {
		if (controller.isEditingSavings == YES) {
			savingsData_.currentCalculation = self.backupCopy;
		} else {
			savingsData_.currentCalculation = nil;
		}
	}
	[self dismissModalViewControllerAnimated:YES];
}

- (void)nameInputViewControllerDidFinish:(NameInputViewController *)controller save:(BOOL)save
{
	if (save) {
		
	}
	[self dismissModalViewControllerAnimated:YES];
}

#pragma mark - UITableView Data Source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	if (savingsData_.currentCalculation == nil) {
		return 0;
	}
	
	return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	NSInteger rows = 0;
	
	if (section == 0 || section == 1) {
		EfficiencyType type = savingsData_.currentCalculation.type;
		
		if ([savingsData_.currentCalculation.vehicle1 hasDataReadyForType:type]) {
			rows++;
		}
		
		if ([savingsData_.currentCalculation.vehicle2 hasDataReadyForType:type]) {
			rows++;
		}
	} else {
		rows = 3;
	}
	
	return rows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{	
	if (indexPath.section == 2) {
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
			
			NSString *numberString = [formatter stringFromNumber:savingsData_.currentCalculation.fuelPrice];
			[formatter release];
			
			detailTextLabelString = [NSString stringWithFormat:@"%@ /gallon", numberString];
		} else if (indexPath.row == 1) {
			textLabelString = @"Distance";
			
			NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
			[formatter setNumberStyle:NSNumberFormatterDecimalStyle];
			[formatter setMaximumFractionDigits:0];
			
			NSString *numberString = [formatter stringFromNumber:savingsData_.currentCalculation.distance];
			[formatter release];
			
			detailTextLabelString = [NSString stringWithFormat:@"%@ miles/year", numberString];
		} else {
			textLabelString = @"Ownership";
			detailTextLabelString = [NSString stringWithFormat:@"%@ years",
									 [savingsData_.currentCalculation.carOwnership stringValue]];
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
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
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
		textLabelString = savingsData_.currentCalculation.vehicle1.name;
		detailTextLabelString = [currencyFormatter_ stringFromNumber:number1];
	} else {
		textLabelString = savingsData_.currentCalculation.vehicle2.name;
		detailTextLabelString = [currencyFormatter_ stringFromNumber:number2];
	}
		
	cell.accessoryType = UITableViewCellAccessoryNone;
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
	
	cell.textLabel.font = [UIFont boldSystemFontOfSize:15.0];
	cell.detailTextLabel.font = [UIFont systemFontOfSize:15.0];
	
	cell.textLabel.text = textLabelString;
	cell.detailTextLabel.text = detailTextLabelString;
	
	return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	if (section == 0) {
		return @"Annual Cost";
	} else if (section == 1) {
		return @"Total Cost";
	}
	return @"Information";
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
	if (!savingsData_.currentCalculation) {
		return nil;
	}
	
	EfficiencyType type = savingsData_.currentCalculation.type;
	
	BOOL isVehicle1Ready = [savingsData_.currentCalculation.vehicle1 hasDataReadyForType:type];
	BOOL isVehicle2Ready = [savingsData_.currentCalculation.vehicle2 hasDataReadyForType:type];
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
							  savingsData_.currentCalculation.vehicle2.name,
							  [currencyFormatter_ stringFromNumber:savings]];
			} else {
				NSNumber *savings = [NSNumber numberWithFloat:[self.vehicle2AnnualCost floatValue] - [self.vehicle1AnnualCost floatValue]];
				label.text = [NSString stringWithFormat:@"%@ saves you %@ each year.",
							  savingsData_.currentCalculation.vehicle1.name,
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
			
			NSInteger years = [savingsData_.currentCalculation.carOwnership integerValue];
			
			if (result == NSOrderedSame) {
				label.text = [NSString stringWithFormat:@"The total fuel cost is the same over a period of %i years.", years];
			} else if (result == NSOrderedDescending) {
				NSNumber *savings = [NSNumber numberWithFloat:[self.vehicle1TotalCost floatValue] - [self.vehicle2TotalCost floatValue]];
				label.text = [NSString stringWithFormat:@"%@ saves you %@ over %i years.",
							  savingsData_.currentCalculation.vehicle2.name,
							  [currencyFormatter_ stringFromNumber:savings],
							  years];
			} else {
				NSNumber *savings = [NSNumber numberWithFloat:[self.vehicle2TotalCost floatValue] - [self.vehicle1TotalCost floatValue]];
				label.text = [NSString stringWithFormat:@"%@ saves you %@ over %i years.",
							  savingsData_.currentCalculation.vehicle1.name,
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
			
			NSLog(@"Width: %f, Height: %f", totalLabelSize.width, totalLabelSize.height);
			
			[totalFooterView_ addSubview:label];
			[label release];
			
			return totalFooterView_;
		}
	} else {
		[infoFooterView_ autorelease];
		infoFooterView_ = [[UIView alloc] initWithFrame:CGRectZero];
		
		UIButton *button = [[UIButton buttonWithType:UIButtonTypeRoundedRect] retain];
		[button addTarget:self action:@selector(saveAction) forControlEvents:UIControlEventTouchDown];
		[button setTitle:@"Save" forState:UIControlStateNormal];
		
		CGFloat buttonWidth = [UIScreen mainScreen].bounds.size.width - 20.0;
		button.frame = CGRectMake(10.0, 20.0, buttonWidth, 44.0);
		
		[infoFooterView_ addSubview:button];
		[button release];
		
		return infoFooterView_;
	}
	return nil;
}

@end
