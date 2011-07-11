//
//  CurrentSavingsViewController.m
//  Fuel Savings
//
//  Created by arn on 6/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CurrentSavingsViewController.h"
#import "NSMutableArray+Vehicle.h"

static NSString * const car1Key = @"Car1Key";
static NSString * const car2Key = @"Car2Key";

static NSString * const typeKey = @"TypeKey";
static NSString * const fuelPriceKey = @"PriceKey";
static NSString * const distanceKey = @"DistanceKey";
static NSString * const ratioKey = @"RatioKey";
static NSString * const carOwnershipKey = @"CarOwnershipKey";

static NSString * const vehicleNameKey = @"VehicleNameKey";
static NSString * const vehicleAvgEfficiencyKey = @"VehicleAvgEfficiencyKey";
static NSString * const vehicleCityEfficiencyKey = @"VehicleCityEfficiencyKey";
static NSString * const vehicleHighwayEfficiencyKey = @"VehicleHighwayEfficiencyKey";

@interface CurrentSavingsViewController (Private)

- (NSArray *)avgInformationKeys;
- (void)setAvgInformationKeys;

- (NSArray *)combinedInformationKeys;
- (void)setCombinedInformationKeys;

- (NSArray *)avgVehicleKeys;
- (void)setAvgVehicleKeys;

- (NSArray *)combinedVehicleKeys;
- (void)setCombinedVehicleKeys;

- (void)displayErrorWithMessage:(NSString *)message;

@end

@implementation CurrentSavingsViewController

@synthesize delegate = delegate_;
@synthesize newTable = newTable_;
@synthesize isEditingSavings = isEditingSavings_;

- (id)init
{
	self = [super initWithNibName:@"CurrentSavingsViewController" bundle:nil];
	if (self) {		
		savingsData_ = [SavingsData sharedSavingsData];
		[self setAvgInformationKeys];
		[self setCombinedInformationKeys];
		[self setAvgVehicleKeys];
		[self setCombinedVehicleKeys];
	}
	return self;
}

- (void)dealloc
{
	[newData_ release];
	[avgInformationKeys_ release];
	[combinedInformationKeys_ release];
	[avgVehicleKeys_ release];
	[combinedVehicleKeys_ release];
	[deleteHeaderView_ release];
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
	
	newData_ = [[NSMutableArray alloc] initWithObjects:
				[NSArray array],
				[NSArray array],
				[NSArray array],
				nil];
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
	
	if (self.isEditingSavings) {
		self.title = @"Edit Savings";
	} else {
		self.title = @"New Savings";
	}
	
	if (savingsData_.currentCalculation.type == EfficiencyTypeAverage) {
		[newData_ replaceObjectAtIndex:0 withObject:[self avgInformationKeys]];
		[newData_ replaceObjectAtIndex:1 withObject:[self avgVehicleKeys]];
		[newData_ replaceObjectAtIndex:2 withObject:[self avgVehicleKeys]];
	} else {
		[newData_ replaceObjectAtIndex:0 withObject:[self combinedInformationKeys]];
		[newData_ replaceObjectAtIndex:1 withObject:[self combinedVehicleKeys]];
		[newData_ replaceObjectAtIndex:2 withObject:[self combinedVehicleKeys]];
	}
	
	[self.newTable reloadData];	
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

#pragma mark - Custom Actions

- (void)saveAction
{
	[self.delegate currentSavingsViewControllerDelegateDidFinish:self save:YES];
}

- (void)dismissAction
{
	[self.delegate currentSavingsViewControllerDelegateDidFinish:self save:NO];
}

- (void)deleteAction
{
	[self.delegate currentSavingsViewControllerDelegateDidDelete:self];
	[self.delegate currentSavingsViewControllerDelegateDidFinish:self save:NO];
}

- (void)deleteOptionsAction:(id)sender {
	// open a dialog with two custom buttons	
	
	UIActionSheet *actionSheet = [[UIActionSheet alloc]
								  initWithTitle:nil
								  delegate:self
								  cancelButtonTitle:@"Cancel"
								  destructiveButtonTitle:@"Delete Calculation"
								  otherButtonTitles:nil];
	
	[actionSheet showInView:self.view]; // show from our table view (pops up in the middle of the table)
	[actionSheet release];	
}

#pragma mark - UITableView Data Source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return [newData_ count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [[newData_ objectAtIndex:section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{	
	static NSString *CellIdentifier = @"Cell";
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
	}
	
	NSString *textLabelString = nil;
	NSString *detailTextLabelString = nil;
	
	NSString *key = [[newData_ objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
	
	if (indexPath.section == 0) {
		if ([key isEqualToString:typeKey]) {
			textLabelString = @"Using";
			detailTextLabelString = [savingsData_.currentCalculation stringForCurrentType];
		} else if ([key isEqualToString:fuelPriceKey]) {
			textLabelString = @"Fuel Price";
			
			NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
			[formatter setNumberStyle:NSNumberFormatterCurrencyStyle];
			
			NSString *numberString = [formatter stringFromNumber:savingsData_.currentCalculation.fuelPrice];
			[formatter release];
			
			detailTextLabelString = [NSString stringWithFormat:@"%@ /gallon", numberString];
		} else if ([key isEqualToString:distanceKey]) {
			textLabelString = @"Distance";
			
			NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
			[formatter setNumberStyle:NSNumberFormatterDecimalStyle];
			[formatter setMaximumFractionDigits:0];
			
			NSString *numberString = [formatter stringFromNumber:savingsData_.currentCalculation.distance];
			[formatter release];
			
			detailTextLabelString = [NSString stringWithFormat:@"%@ miles/year", numberString];
		} else if ([key isEqualToString:ratioKey]) {
			textLabelString = @"Ratio";
			
			NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
			[formatter setNumberStyle:NSNumberFormatterPercentStyle];
			[formatter setMaximumFractionDigits:0];
			
			detailTextLabelString = [NSString stringWithFormat:@"%@ City / %@ Highway",
									 [formatter stringFromNumber:savingsData_.currentCalculation.cityRatio],
									 [formatter stringFromNumber:savingsData_.currentCalculation.highwayRatio]];
			[formatter release];
		} else {
			textLabelString = @"Ownership";
			detailTextLabelString = [NSString stringWithFormat:@"%@ years",
									 [savingsData_.currentCalculation.carOwnership stringValue]];
		}
	} else {
		Vehicle *vehicle = nil;
		if (indexPath.section == 1) {
			vehicle = savingsData_.currentCalculation.vehicle1;
		} else {
			vehicle = savingsData_.currentCalculation.vehicle2;
		}
		
		NSString *efficiencyFormatString = @"%@ MPG";
		
		if ([key isEqualToString:vehicleNameKey]) {
			textLabelString = @"Name";
			detailTextLabelString = vehicle.name;
		} else if ([key isEqualToString:vehicleAvgEfficiencyKey]) {
			textLabelString = @"Average MPG";
			detailTextLabelString = [NSString stringWithFormat:efficiencyFormatString, [vehicle.avgEfficiency stringValue]];
		} else if ([key isEqualToString:vehicleCityEfficiencyKey]) {
			textLabelString = @"City MPG";
			detailTextLabelString = [NSString stringWithFormat:efficiencyFormatString, [vehicle.cityEfficiency stringValue]];
		} else {
			textLabelString = @"Highway MPG";
			detailTextLabelString = [NSString stringWithFormat:efficiencyFormatString, [vehicle.highwayEfficiency stringValue]];
		}
	}
	
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	cell.selectionStyle = UITableViewCellSelectionStyleBlue;
	
	cell.textLabel.font = [UIFont boldSystemFontOfSize:15.0];
	cell.detailTextLabel.font = [UIFont systemFontOfSize:15.0];
	
	cell.detailTextLabel.lineBreakMode = UILineBreakModeWordWrap;
	
	cell.textLabel.text = textLabelString;
	cell.detailTextLabel.text = detailTextLabelString;
	
	return cell;
}

#pragma mark - UITableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	
	UIViewController *viewController = nil;
	
	NSString *key = [[newData_ objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
	
	if (indexPath.section == 0) {
		if ([key isEqualToString:typeKey]) {
			TypeInputViewController *inputViewController = [[TypeInputViewController alloc] init];
			inputViewController.delegate = self;
			inputViewController.currentType = savingsData_.currentCalculation.type;
			viewController = inputViewController;
		} else if ([key isEqualToString:fuelPriceKey]) {
			PriceInputViewController *inputViewController = [[PriceInputViewController alloc] init];
			inputViewController.delegate = self;
			inputViewController.currentPrice = savingsData_.currentCalculation.fuelPrice;
			viewController = inputViewController;
		} else if ([key isEqualToString:distanceKey]) {
			DistanceInputViewController *inputViewController = [[DistanceInputViewController alloc] init];
			inputViewController.delegate = self;
			inputViewController.currentDistance = savingsData_.currentCalculation.distance;
			viewController = inputViewController;
		} else if ([key isEqualToString:ratioKey]) {
			RatioInputViewController *inputViewcontroller = [[RatioInputViewController alloc] init];
			inputViewcontroller.delegate = self;
			inputViewcontroller.currentCityRatio = savingsData_.currentCalculation.cityRatio;
			inputViewcontroller.currentHighwayRatio = savingsData_.currentCalculation.highwayRatio;
			viewController = inputViewcontroller;
		} else {
			OwnerInputViewController *inputViewController = [[OwnerInputViewController alloc] init];
			inputViewController.delegate = self;
			inputViewController.currentOwnership = savingsData_.currentCalculation.carOwnership;
			viewController = inputViewController;
		}
	} else {
		Vehicle *vehicle = nil;
		NSString *vehicleKey = nil;
		if (indexPath.section == 1) {
			vehicle = savingsData_.currentCalculation.vehicle1;
			vehicleKey = car1Key;
		} else {
			vehicle = savingsData_.currentCalculation.vehicle2;
			vehicleKey = car2Key;
		}
		
		if ([key isEqualToString:vehicleNameKey]) {
			NameInputViewController *inputViewController = [[NameInputViewController alloc] init];
			inputViewController.delegate = self;
			inputViewController.key = vehicleKey;
			inputViewController.currentName = vehicle.name;
			viewController = inputViewController;
		} else {
			EfficiencyInputViewController *inputViewController = [[EfficiencyInputViewController alloc] init];
			inputViewController.delegate = self;
			inputViewController.key = vehicleKey;
			if ([key isEqualToString:vehicleAvgEfficiencyKey]) {
				inputViewController.currentEfficiency = vehicle.avgEfficiency;
				inputViewController.currentType = EfficiencyInputTypeAverage;
			} else if ([key isEqualToString:vehicleCityEfficiencyKey]) {
				inputViewController.currentEfficiency = vehicle.cityEfficiency;
				inputViewController.currentType = EfficiencyInputTypeCity;
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

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
	if (section == 0 && self.isEditingSavings == YES) {
		[deleteHeaderView_ autorelease];
		deleteHeaderView_ = [[UIView alloc] initWithFrame:CGRectZero];
		
		UIButton *button = [[UIButton buttonWithType:UIButtonTypeRoundedRect] retain];
		[button addTarget:self action:@selector(deleteOptionsAction:) forControlEvents:UIControlEventTouchDown];
		[button setTitle:@"Delete Calculation" forState:UIControlStateNormal];
		
		CGFloat buttonWidth = [UIScreen mainScreen].bounds.size.width - 20.0;
		button.frame = CGRectMake(10.0, 20.0, buttonWidth, 44.0);
		
		[deleteHeaderView_ addSubview:button];
		[button release];
		
		return deleteHeaderView_;
	}
	return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
	if (section == 0) {
		return 84.0;
	}
	return 30.0;
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

- (void)ratioInputViewControllerDidFinish:(RatioInputViewController *)controller save:(BOOL)save
{
	if (save) {
		savingsData_.currentCalculation.cityRatio = controller.currentCityRatio;
		savingsData_.currentCalculation.highwayRatio = controller.currentHighwayRatio;
	}
	[self.navigationController popViewControllerAnimated:YES];
}

- (void)ownerInputViewControllerDidFinish:(OwnerInputViewController *)controller save:(BOOL)save
{
	if (save) {
		savingsData_.currentCalculation.carOwnership = controller.currentOwnership;
	}
	[self.navigationController popViewControllerAnimated:YES];
}

- (void)nameInputViewControllerDidFinish:(NameInputViewController *)controller save:(BOOL)save
{
	if (save) {
		Vehicle *vehicle = nil;
		if ([controller.key isEqualToString:car1Key]) {
			vehicle = savingsData_.currentCalculation.vehicle1;
		} else {
			vehicle = savingsData_.currentCalculation.vehicle2;
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
			vehicle = savingsData_.currentCalculation.vehicle1;
		} else {
			vehicle = savingsData_.currentCalculation.vehicle2;
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

#pragma mark - Private Methods

- (NSArray *)avgInformationKeys
{
	return avgInformationKeys_;
}

- (void)setAvgInformationKeys
{
	if (avgInformationKeys_ != nil) {
		[avgInformationKeys_ release];
	}
	avgInformationKeys_ = [[NSArray alloc] initWithObjects:
						   typeKey,
						   fuelPriceKey,
						   distanceKey,
						   carOwnershipKey,
						   nil];
}

- (NSArray *)combinedInformationKeys
{
	return combinedInformationKeys_;
}

- (void)setCombinedInformationKeys
{
	if (combinedInformationKeys_ != nil) {
		[combinedVehicleKeys_ release];
	}
	combinedInformationKeys_ = [[NSArray alloc] initWithObjects:
								typeKey,
								fuelPriceKey,
								distanceKey,
								ratioKey,
								carOwnershipKey,
								nil];
}

- (NSArray *)avgVehicleKeys
{
	return avgVehicleKeys_;
}

- (void)setAvgVehicleKeys
{
	if (avgVehicleKeys_ != nil) {
		[avgVehicleKeys_ release];
	}
	avgVehicleKeys_ = [[NSArray alloc] initWithObjects:
					   vehicleNameKey,
					   vehicleAvgEfficiencyKey,
					   nil];
}

- (NSArray *)combinedVehicleKeys
{
	return combinedVehicleKeys_;
}

- (void)setCombinedVehicleKeys
{
	if (combinedVehicleKeys_ != nil) {
		[combinedVehicleKeys_ release];
	}
	combinedVehicleKeys_ = [[NSArray alloc] initWithObjects:
						   vehicleNameKey,
						   vehicleCityEfficiencyKey,
						   vehicleHighwayEfficiencyKey,
						   nil];
}

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

#pragma mark -
#pragma mark UIActionSheet Delegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	if (buttonIndex == 0) {
		[self performSelector:@selector(deleteAction)];
	}
}

@end