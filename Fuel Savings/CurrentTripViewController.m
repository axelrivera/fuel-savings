//
//  CurrentTripViewController.m
//  Fuel Savings
//
//  Created by arn on 7/15/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CurrentTripViewController.h"
#import "NSDictionary+Section.h"
#import "VehicleSelectViewController.h"
#import "Fuel_SavingsAppDelegate.h"

static NSString * const fuelPriceKey = @"PriceKey";
static NSString * const distanceKey = @"DistanceKey";

static NSString * const vehicleKey = @"VehicleKey";
static NSString * const vehicleNameKey = @"VehicleNameKey";
static NSString * const vehicleAvgEfficiencyKey = @"VehicleAvgEfficiencyKey";

@interface CurrentTripViewController (Private)

- (NSArray *)informationArray;
- (NSArray *)vehicleArray;

@end

@implementation CurrentTripViewController

@synthesize delegate = delegate_;
@synthesize newData = newData_;
@synthesize isEditingTrip = isEditingTrip_;

- (id)init
{
	self = [super initWithNibName:@"CurrentTripViewController" bundle:nil];
	if (self) {
		tripData_ = [TripData sharedTripData];
	}
	return self;
}

- (void)dealloc
{
	[newData_ release];
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
	self.newData = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
	
	if (self.isEditingTrip) {
		self.title = @"Edit Trip";
	} else {
		self.title = @"New Trip";
	}
	
	self.newData = [NSMutableArray arrayWithCapacity:0];
	
	[self.newData addObject:[self informationArray]];
	[self.newData addObject:[self vehicleArray]];

	[self.tableView reloadData];
}

#pragma mark - Custom Actions

- (void)saveAction
{
	[self.delegate currentTripViewControllerDelegateDidFinish:self save:YES];
}

- (void)dismissAction
{
	[self.delegate currentTripViewControllerDelegateDidFinish:self save:NO];
}

- (void)selectCarAction
{
	VehicleSelectViewController *inputViewController = [[VehicleSelectViewController alloc] init];
	Fuel_SavingsAppDelegate *appDelegate = (Fuel_SavingsAppDelegate *)[[UIApplication sharedApplication] delegate];
	inputViewController.context = [appDelegate.coreDataObject managedObjectContext];
	inputViewController.currentTripViewController = self;
	
	UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:inputViewController];
	
	[self presentModalViewController:navController animated:YES];
	
	[inputViewController release];
	[navController release];
}

#pragma mark - UIViewController Delegates

- (void)priceInputViewControllerDidFinish:(PriceInputViewController *)controller save:(BOOL)save
{
	if (save) {
		tripData_.currentCalculation.fuelPrice = controller.currentPrice;
	}
	[self.navigationController popViewControllerAnimated:YES];
}

- (void)distanceInputViewControllerDidFinish:(DistanceInputViewController *)controller save:(BOOL)save
{
	if (save) {
		tripData_.currentCalculation.distance = controller.currentDistance;
	}
	[self.navigationController popViewControllerAnimated:YES];
}

- (void)nameInputViewControllerDidFinish:(NameInputViewController *)controller save:(BOOL)save
{
	if (save) {
		tripData_.currentCalculation.vehicle.name = controller.currentName;
	}
	[self.navigationController popViewControllerAnimated:YES];
}

- (void)efficiencyInputViewControllerDidFinish:(EfficiencyInputViewController *)controller save:(BOOL)save
{
	if (save) {
		tripData_.currentCalculation.vehicle.avgEfficiency = controller.currentEfficiency;
		tripData_.currentCalculation.vehicle.cityEfficiency = controller.currentEfficiency;
		tripData_.currentCalculation.vehicle.highwayEfficiency = controller.currentEfficiency;
	}
	[self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.newData count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [[self.newData objectAtIndex:section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSDictionary *dictionary = [[self.newData objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
	
	if (indexPath.section > 0 && indexPath.row == 0) {
		static NSString *TitleCellIdentifier = @"TitleCell";
		
		UITableViewCell *titleCell = [tableView dequeueReusableCellWithIdentifier:TitleCellIdentifier];
		
		if (titleCell == nil) {
			titleCell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:TitleCellIdentifier] autorelease];
		}
		
		titleCell.accessoryView = [dictionary objectForKey:dictionaryButtonKey];
		titleCell.selectionStyle = UITableViewCellSelectionStyleNone;
		
		titleCell.textLabel.textColor = [UIColor colorWithRed:57.0/255.0 green:85.0/255.0 blue:135.0/255.0 alpha:1.0];
		
		titleCell.textLabel.text = [dictionary objectForKey:dictionaryTextKey];
		
		return titleCell;
	}
	
	static NSString *CellIdentifier = @"Cell";
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
	}
	
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	cell.selectionStyle = UITableViewCellSelectionStyleBlue;
	
	cell.textLabel.font = [UIFont boldSystemFontOfSize:15.0];
	cell.detailTextLabel.font = [UIFont systemFontOfSize:15.0];
	
	cell.textLabel.text = [dictionary objectForKey:dictionaryTextKey];
	cell.detailTextLabel.text = [dictionary objectForKey:dictionaryDetailKey];
	
	return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	
	UIViewController *viewController = nil;
	
	NSDictionary *dictionary = [[self.newData objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
	NSString *key = [dictionary objectForKey:dictionaryKey];
    
	if (indexPath.section == 0) {
		if ([key isEqualToString:fuelPriceKey]) {
			PriceInputViewController *inputViewController = [[PriceInputViewController alloc] init];
			inputViewController.delegate = self;
			inputViewController.currentPrice = tripData_.currentCalculation.fuelPrice;
			viewController = inputViewController;
		} else {
			DistanceInputViewController *inputViewController = [[DistanceInputViewController alloc] initWithType:DistanceInputTypeTrip];
			inputViewController.delegate = self;
			inputViewController.currentDistance = tripData_.currentCalculation.distance;
			viewController = inputViewController;
		}
	} else {
		if ([key isEqualToString:vehicleNameKey]) {
			NameInputViewController *inputViewController = [[NameInputViewController alloc] init];
			inputViewController.delegate = self;
			inputViewController.currentName = tripData_.currentCalculation.vehicle.name;
			viewController = inputViewController;
		} else if ([key isEqualToString:vehicleAvgEfficiencyKey]) {
			EfficiencyInputViewController *inputViewController = [[EfficiencyInputViewController alloc] init];
			inputViewController.delegate = self;
			inputViewController.currentEfficiency = tripData_.currentCalculation.vehicle.avgEfficiency;
			inputViewController.currentType	= EfficiencyInputTypeAverage;
			viewController = inputViewController;
		}
	}
	
	if (viewController) {
		[self.navigationController pushViewController:viewController animated:YES];
		[viewController release];
	}
}

- (void)vehicleDetailsViewControllerDidFinish:(VehicleDetailsViewController *)controller save:(BOOL)save
{
	if (save) {
		NSDictionary *info = controller.mpgDatabaseInfo;
		tripData_.currentCalculation.vehicle.name = [NSString stringWithFormat:@"%@ %@",
														 [info objectForKey:@"make"],
														 [info objectForKey:@"model"]];
		tripData_.currentCalculation.vehicle.avgEfficiency = [info objectForKey:@"mpgAverage"];
		tripData_.currentCalculation.vehicle.cityEfficiency = [info objectForKey:@"mpgAverage"];
		tripData_.currentCalculation.vehicle.highwayEfficiency = [info objectForKey:@"mpgAverage"];
	}
	[self dismissModalViewControllerAnimated:YES];
}


#pragma mark - Private Methods

- (NSArray *)informationArray
{	
	NSMutableArray *array = [NSMutableArray arrayWithCapacity:0];
	
	NSDictionary *dictionary = nil;
	
	NSNumberFormatter *priceFormatter = [[NSNumberFormatter alloc] init];
	[priceFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
	
	NSString *priceStr = [priceFormatter stringFromNumber:tripData_.currentCalculation.fuelPrice];
	[priceFormatter release];
	
	dictionary = [NSDictionary textDictionaryWithKey:fuelPriceKey
												text:@"Fuel Price"
											  detail:[NSString stringWithFormat:@"%@ /gallon", priceStr]];
	[array addObject:dictionary];
	
	NSNumberFormatter *distanceFormatter = [[NSNumberFormatter alloc] init];
	[distanceFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
	[distanceFormatter setMaximumFractionDigits:0];
	
	NSString *distanceStr = [distanceFormatter stringFromNumber:tripData_.currentCalculation.distance];
	[distanceFormatter release];
	
	dictionary = [NSDictionary textDictionaryWithKey:distanceKey
												text:@"Distance"
											  detail:[NSString stringWithFormat:@"%@ miles", distanceStr]];
	[array addObject:dictionary];
	
	return array;
}

- (NSArray *)vehicleArray
{	
	NSMutableArray *array = [NSMutableArray arrayWithCapacity:0];
	
	NSDictionary *dictionary = nil;
	
	dictionary = [NSDictionary buttonDictionaryWithKey:vehicleKey
												  text:@"Your Car"];
	
	UIButton *button = [dictionary objectForKey:dictionaryButtonKey];
	[button addTarget:self action:@selector(selectCarAction) forControlEvents:UIControlEventTouchDown];
	
	[array addObject:dictionary];
	
	dictionary = [NSDictionary textDictionaryWithKey:vehicleNameKey
												text:@"Name"
											  detail:tripData_.currentCalculation.vehicle.name];
	[array addObject:dictionary];
	
	NSString *combinedStr = [NSString stringWithFormat:@"%@ MPG", [tripData_.currentCalculation.vehicle.avgEfficiency stringValue]];
	dictionary = [NSDictionary textDictionaryWithKey:vehicleAvgEfficiencyKey
												text:@"Fuel Efficiency"
											  detail:combinedStr];
	[array addObject:dictionary];
	
	return array;
}

@end
