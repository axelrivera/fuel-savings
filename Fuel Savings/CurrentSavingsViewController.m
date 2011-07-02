//
//  CurrentSavingsViewController.m
//  Fuel Savings
//
//  Created by arn on 6/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CurrentSavingsViewController.h"
#import "NSMutableArray+Vehicle.h"

#define MAX_VEHICLES 5

@implementation CurrentSavingsViewController

@synthesize currentTable = currentTable_;

- (id)init
{
	self = [super initWithNibName:@"CurrentSavingsViewController" bundle:nil];
	if (self) {
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
		
		savingsData_ = [SavingsData sharedSavingsData];
	}
	return self;
}

- (void)dealloc
{
	[currentTable_ release];
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
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
	self.currentTable = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	
	self.title = @"New Calculation";
	[self.currentTable reloadData];	
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

#pragma mark - Custom Actions

- (void)saveAction
{
	[self performSelector:@selector(dismissAction)];
}

- (void)dismissAction
{
	[self dismissModalViewControllerAnimated:YES];
}

#pragma mark - UITableView Data Source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	NSInteger rows;
	if (section == 0) {
		rows = 4;
	} else {
		rows = 1 + [savingsData_.currentCalculation.vehicles count];
	}
	return rows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *CellIdentifier = @"Cell";
	
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
	}
	
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	cell.selectionStyle = UITableViewCellSelectionStyleBlue;
	
	if (indexPath.section == 0) {
		if (indexPath.row == 0) {
			cell.textLabel.text = @"Use";
			cell.detailTextLabel.text = [savingsData_.currentCalculation stringForCurrentType];
		} else if (indexPath.row == 1) {
			cell.textLabel.text = @"Fuel Price";
			NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
			[formatter setNumberStyle:NSNumberFormatterCurrencyStyle];
			NSString *numberString = [formatter stringFromNumber:savingsData_.currentCalculation.fuelPrice];
			[formatter release];
			cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ /gallon", numberString];
		} else if (indexPath.row == 2) {
			cell.textLabel.text = @"Distance";
			NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
			[formatter setNumberStyle:NSNumberFormatterDecimalStyle];
			[formatter setMaximumFractionDigits:0];
			NSString *numberString = [formatter stringFromNumber:savingsData_.currentCalculation.distance];
			[formatter release];
			cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ miles/year", numberString];
		} else {
			cell.textLabel.text = @"Car Ownership";
			cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ years",
										 [savingsData_.currentCalculation.carOwnership stringValue]];
		}
	} else {
		if (indexPath.row == 0) {
			cell.textLabel.text = @"Add New Vehicle";
		} else {
			Vehicle *vehicle = [savingsData_.currentCalculation.vehicles objectAtIndex:indexPath.row - 1];
			cell.textLabel.text = vehicle.name;
		}
	}
	
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
			inputViewController.currentType = savingsData_.currentCalculation.type;
			viewController = inputViewController;
		} else if (indexPath.row == 1) {
			PriceInputViewController *inputViewController = [[PriceInputViewController alloc] init];
			inputViewController.delegate = self;
			inputViewController.currentPrice = savingsData_.currentCalculation.fuelPrice;
			viewController = inputViewController;
		} else if (indexPath.row == 2) {
			DistanceInputViewController *inputViewController = [[DistanceInputViewController alloc] init];
			inputViewController.delegate = self;
			inputViewController.currentDistance = savingsData_.currentCalculation.distance;
			viewController = inputViewController;
		} else {
			OwnerInputViewController *inputViewController = [[OwnerInputViewController alloc] init];
			inputViewController.delegate = self;
			inputViewController.currentOwnership = savingsData_.currentCalculation.carOwnership;
			viewController = inputViewController;
		}
	} else {
		NSInteger totalVehicles = [savingsData_.currentCalculation.vehicles count];
		if (indexPath.row == 0 && totalVehicles >= MAX_VEHICLES) {
			NSString *errorString = [NSString stringWithFormat:@"You can only add a maximum of %i vehicles. Please"
									 @" remove one of your current vehicles before continuing.",
									 MAX_VEHICLES];
			[self performSelector:@selector(displayErrorWithMessage:) withObject:errorString];
			return;
		}
		
		VehicleInputViewController *inputViewController = [[VehicleInputViewController alloc] init];
		inputViewController.delegate = self;
		
		if (indexPath.row == 0) {
			inputViewController.currentName = [NSString stringWithFormat:@"Car %i", totalVehicles + 1];
			viewController = inputViewController;
		} else {
			inputViewController.isEditingVehicle = YES;
			Vehicle *vehicle = [savingsData_.currentCalculation.vehicles objectAtIndex:indexPath.row - 1];
			inputViewController.currentName = vehicle.name;
			inputViewController.currentAvgEfficiency = vehicle.avgEfficiency;
			inputViewController.currentCityEfficiency = vehicle.cityEfficiency;
			inputViewController.currentHighwayEfficiency = vehicle.highwayEfficiency;
			viewController = inputViewController;
		}
	}
	
	if (viewController) {
		[self.navigationController pushViewController:viewController animated:YES];
		[viewController release];
	}
}

#pragma mark - View Controller Delegates

- (void)typeInputViewControllerDidFinish:(TypeInputViewController *)controller save:(BOOL)save
{
	if (save) {
		savingsData_.currentCalculation.type = controller.currentType;
	}
	[self.navigationController popViewControllerAnimated:YES];
}

- (void)priceInputViewControllerDidFinish:(PriceInputViewController *)controller save:(BOOL)save
{
	if (save) {
		savingsData_.currentCalculation.fuelPrice = controller.currentPrice;
	}
	[self.navigationController popViewControllerAnimated:YES];
}

- (void)distanceInputViewControllerDidFinish:(DistanceInputViewController *)controller save:(BOOL)save
{
	if (save) {
		savingsData_.currentCalculation.distance = controller.currentDistance;
	}
	[self.navigationController popViewControllerAnimated:YES];
}

- (void)ownerInputViewControllerDelegate:(OwnerInputViewController *)controller save:(BOOL)save
{
	if (save) {
		savingsData_.currentCalculation.carOwnership = controller.currentOwnership;
	}
	[self.navigationController popViewControllerAnimated:YES];
}

- (void)vehicleInputViewControllerDidFinish:(VehicleInputViewController *)controller save:(BOOL)save
{
	if (save) {
		if (!controller.isEditingVehicle) {
			Vehicle *vehicle = [[Vehicle alloc] init];
			vehicle.name = controller.currentName;
			if (savingsData_.currentCalculation.type == SavingsCalculationTypeAverage) {
				vehicle.avgEfficiency = controller.currentAvgEfficiency;
				vehicle.cityEfficiency = vehicle.avgEfficiency;
				vehicle.highwayEfficiency = vehicle.avgEfficiency;
			} else {
				vehicle.cityEfficiency = controller.currentCityEfficiency;
				vehicle.highwayEfficiency = controller.currentHighwayEfficiency;
				
				NSInteger average = ([vehicle.cityEfficiency integerValue] + [vehicle.highwayEfficiency integerValue]) / 2;
				
				vehicle.avgEfficiency = [NSNumber numberWithInteger:average];
			}
			
			[savingsData_.currentCalculation.vehicles addVehicle:vehicle];
			
			[vehicle release];
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
