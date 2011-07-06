//
//  CurrentSavingsViewController.m
//  Fuel Savings
//
//  Created by arn on 6/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "NewSavingsViewController.h"
#import "NSMutableArray+Vehicle.h"

NSString * const car1Key = @"Car1Key";
NSString * const car2Key = @"Car2Key";

@interface NewSavingsViewController (Private)

- (void)displayErrorWithMessage:(NSString *)message;

@end

@implementation NewSavingsViewController

@synthesize delegate = delegate_;
@synthesize newTable = newTable_;

- (id)init
{
	self = [super initWithNibName:@"NewSavingsViewController" bundle:nil];
	if (self) {		
		savingsData_ = [SavingsData sharedSavingsData];
	}
	return self;
}

- (void)dealloc
{
	[newTable_ release];
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
	
	UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
																				  target:self
																				  action:@selector(dismissAction)];
	self.navigationItem.leftBarButtonItem = cancelButton;
	[cancelButton release];
	
	UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave
																				target:self
																				action:@selector(saveAction)];
	self.navigationItem.rightBarButtonItem = saveButton;
	[saveButton release];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
	self.newTable = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	
	self.title = @"New Calculation";
	[self.newTable reloadData];	
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

#pragma mark - Custom Actions

- (void)saveAction
{
	[self.delegate newSavingsViewControllerDelegateDidFinish:self save:YES];
}

- (void)dismissAction
{
	[self.delegate newSavingsViewControllerDelegateDidFinish:self save:NO];
}

#pragma mark - UITableView Data Source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	NSInteger rows;
	if (section == 0) {
		rows = 4;
	} else {
		if (savingsData_.newCalculation.type == SavingsCalculationTypeAverage) {
			rows = 2;
		} else {
			rows = 3;
		}
	}
	return rows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (indexPath.section == 0) {
		static NSString *InfoCellIdentifier = @"InfoCell";
		
		UITableViewCell *infoCell = [tableView dequeueReusableCellWithIdentifier:InfoCellIdentifier];
		
		if (infoCell == nil) {
			infoCell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:InfoCellIdentifier] autorelease];
		}
		
		infoCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		infoCell.selectionStyle = UITableViewCellSelectionStyleBlue;
		
		if (indexPath.row == 0) {
			infoCell.textLabel.text = @"Use";
			infoCell.detailTextLabel.text = [savingsData_.newCalculation stringForCurrentType];
		} else if (indexPath.row == 1) {
			infoCell.textLabel.text = @"Fuel Price";
			NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
			[formatter setNumberStyle:NSNumberFormatterCurrencyStyle];
			NSString *numberString = [formatter stringFromNumber:savingsData_.newCalculation.fuelPrice];
			[formatter release];
			infoCell.detailTextLabel.text = [NSString stringWithFormat:@"%@ /gallon", numberString];
		} else if (indexPath.row == 2) {
			infoCell.textLabel.text = @"Distance";
			NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
			[formatter setNumberStyle:NSNumberFormatterDecimalStyle];
			[formatter setMaximumFractionDigits:0];
			NSString *numberString = [formatter stringFromNumber:savingsData_.newCalculation.distance];
			[formatter release];
			infoCell.detailTextLabel.text = [NSString stringWithFormat:@"%@ miles/year", numberString];
		} else {
			infoCell.textLabel.text = @"Car Ownership";
			infoCell.detailTextLabel.text = [NSString stringWithFormat:@"%@ years",
											 [savingsData_.newCalculation.carOwnership stringValue]];
		}
		
		return infoCell;
	}
	
	static NSString *CellIdentifier = @"Cell";
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
	}
	
	Vehicle *vehicle = nil;
	if (indexPath.section == 1) {
		vehicle = savingsData_.newCalculation.vehicle1;
	} else {
		vehicle = savingsData_.newCalculation.vehicle2;
	}
	
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	cell.selectionStyle = UITableViewCellSelectionStyleBlue;
	
	NSString *textLabelString = nil;
	NSString *detailTextLabelString = nil;
	
	if (indexPath.row == 0) {
		textLabelString = @"Name";
		detailTextLabelString = vehicle.name;
	} else if (indexPath.row == 1) {
		if (savingsData_.newCalculation.type == SavingsCalculationTypeAverage) {
			textLabelString = @"Average MPG";
			detailTextLabelString = [NSString stringWithFormat:@"%@ MPG", [vehicle.avgEfficiency stringValue]];
		} else {
			textLabelString = @"City MPG";
			detailTextLabelString = [NSString stringWithFormat:@"%@ MPG", [vehicle.cityEfficiency stringValue]];
		}
	} else {
		textLabelString = @"Highway MPG";
		detailTextLabelString = [NSString stringWithFormat:@"%@ MPG", [vehicle.highwayEfficiency stringValue]];
	}
	
	cell.textLabel.text = textLabelString;
	cell.detailTextLabel.text = detailTextLabelString;
	
	return cell;
}

#pragma mark - UITableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	
	UIViewController *viewController = nil;
	
	if (indexPath.section == 0) {
		if (indexPath.row == 0) {
			TypeInputViewController *inputViewController = [[TypeInputViewController alloc] init];
			inputViewController.delegate = self;
			inputViewController.currentType = savingsData_.newCalculation.type;
			viewController = inputViewController;
		} else if (indexPath.row == 1) {
			PriceInputViewController *inputViewController = [[PriceInputViewController alloc] init];
			inputViewController.delegate = self;
			inputViewController.currentPrice = savingsData_.newCalculation.fuelPrice;
			viewController = inputViewController;
		} else if (indexPath.row == 2) {
			DistanceInputViewController *inputViewController = [[DistanceInputViewController alloc] init];
			inputViewController.delegate = self;
			inputViewController.currentDistance = savingsData_.newCalculation.distance;
			viewController = inputViewController;
		} else {
			OwnerInputViewController *inputViewController = [[OwnerInputViewController alloc] init];
			inputViewController.delegate = self;
			inputViewController.currentOwnership = savingsData_.newCalculation.carOwnership;
			viewController = inputViewController;
		}
	} else {
		Vehicle *vehicle = nil;
		NSString *key = nil;
		if (indexPath.section == 1) {
			vehicle = savingsData_.newCalculation.vehicle1;
			key = car1Key;
		} else {
			vehicle = savingsData_.newCalculation.vehicle2;
			key = car2Key;
		}
		
		if (indexPath.row == 0) {
			NameInputViewController *inputViewController = [[NameInputViewController alloc] init];
			inputViewController.delegate = self;
			inputViewController.key = key;
			inputViewController.currentName = vehicle.name;
			viewController = inputViewController;
		} else {
			EfficiencyInputViewController *inputViewController = [[EfficiencyInputViewController alloc] init];
			inputViewController.delegate = self;
			inputViewController.key = key;
			if (indexPath.row == 1) {
				if (savingsData_.newCalculation.type == SavingsCalculationTypeAverage) {
					inputViewController.currentEfficiency = vehicle.avgEfficiency;
					inputViewController.currentType = EfficiencyInputTypeAverage;
				} else {
					inputViewController.currentEfficiency = vehicle.cityEfficiency;
					inputViewController.currentType = EfficiencyInputTypeCity;
				}
			} else {
				inputViewController.currentEfficiency = vehicle.highwayEfficiency;
				inputViewController.currentType = EfficiencyInputTypeHighway;
			}
			viewController = inputViewController;
		}
	}
	
	if (viewController) {
		[self.navigationController pushViewController:viewController animated:YES];
		[viewController release];
	}
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	NSString *titleString = nil;
	if (section == 0) {
		titleString = nil;
	} else if (section == 1) {
		titleString = @"Car 1";
	} else {
		titleString = @"Car 2 (Optional)";
	}
	return titleString;
}

#pragma mark - View Controller Delegates

- (void)typeInputViewControllerDidFinish:(TypeInputViewController *)controller save:(BOOL)save
{
	if (save) {
		savingsData_.newCalculation.type = controller.currentType;
	}
	[self.navigationController popViewControllerAnimated:YES];
}

- (void)priceInputViewControllerDidFinish:(PriceInputViewController *)controller save:(BOOL)save
{
	if (save) {
		savingsData_.newCalculation.fuelPrice = controller.currentPrice;
	}
	[self.navigationController popViewControllerAnimated:YES];
}

- (void)distanceInputViewControllerDidFinish:(DistanceInputViewController *)controller save:(BOOL)save
{
	if (save) {
		savingsData_.newCalculation.distance = controller.currentDistance;
	}
	[self.navigationController popViewControllerAnimated:YES];
}

- (void)ownerInputViewControllerDelegate:(OwnerInputViewController *)controller save:(BOOL)save
{
	if (save) {
		savingsData_.newCalculation.carOwnership = controller.currentOwnership;
	}
	[self.navigationController popViewControllerAnimated:YES];
}

- (void)nameInputViewControllerDidFinish:(NameInputViewController *)controller save:(BOOL)save
{
	if (save) {
		Vehicle *vehicle = nil;
		if ([controller.key isEqualToString:car1Key]) {
			vehicle = savingsData_.newCalculation.vehicle1;
		} else {
			vehicle = savingsData_.newCalculation.vehicle2;
		}
		vehicle.name = controller.currentName;
	}
	[self.navigationController popViewControllerAnimated:YES];
}

- (void)efficiencyInputViewControllerDidFinish:(EfficiencyInputViewController *)controller save:(BOOL)save
{
	if (save) {
		Vehicle *vehicle = nil;
		if ([controller.key isEqualToString:car1Key]) {
			vehicle = savingsData_.newCalculation.vehicle1;
		} else {
			vehicle = savingsData_.newCalculation.vehicle2;
		}
		
		if (controller.currentType == EfficiencyInputTypeAverage) {
			vehicle.avgEfficiency = controller.currentEfficiency;
			vehicle.cityEfficiency = vehicle.avgEfficiency;
			vehicle.highwayEfficiency = vehicle.avgEfficiency;
		} else {
			if (controller.currentType == EfficiencyInputTypeCity) {
				vehicle.cityEfficiency = controller.currentEfficiency;
			} else {
				vehicle.highwayEfficiency = controller.currentEfficiency;
			}
			NSInteger average = ([vehicle.cityEfficiency integerValue] + [vehicle.highwayEfficiency integerValue]) / 2;
			vehicle.avgEfficiency = [NSNumber numberWithInteger:average];
		}
	}
	[self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UIAlert Views

- (void)displayErrorWithMessage:(NSString *)message
{
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"]
													message:message
												   delegate:self
										  cancelButtonTitle:@"OK"
										  otherButtonTitles: nil];
	[alert show];	
	[alert release];
}

@end
