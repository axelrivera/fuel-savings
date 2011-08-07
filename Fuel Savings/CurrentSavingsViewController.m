//
//  CurrentSavingsViewController.m
//  Fuel Savings
//
//  Created by arn on 6/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CurrentSavingsViewController.h"
#import "NSMutableArray+Vehicle.h"
#import "Fuel_SavingsAppDelegate.h"

static NSString * const dictionaryKey = @"DictionaryKey";
static NSString * const dictionaryTextKey = @"DictionaryTextKey";
static NSString * const dictionaryDetailKey = @"DictionaryDetailKey";
static NSString * const dictionaryButtonKey = @"DictionaryButtonKey";

static NSString * const typeKey = @"TypeKey";
static NSString * const fuelPriceKey = @"PriceKey";
static NSString * const distanceKey = @"DistanceKey";
static NSString * const ratioKey = @"RatioKey";
static NSString * const carOwnershipKey = @"CarOwnershipKey";

static NSString * const vehicle1Key = @"Vehicle1Key";
static NSString * const vehicle2Key = @"Vehicle2Key";

static NSString * const vehicleNameKey = @"VehicleNameKey";
static NSString * const vehicleAvgEfficiencyKey = @"VehicleAvgEfficiencyKey";
static NSString * const vehicleCityEfficiencyKey = @"VehicleCityEfficiencyKey";
static NSString * const vehicleHighwayEfficiencyKey = @"VehicleHighwayEfficiencyKey";

@interface CurrentSavingsViewController (Private)

- (NSArray *)informationArray;
- (NSArray *)vehicleArrayWithKey:(NSString *)key;
- (NSDictionary *)textDictionaryWithKey:(NSString *)key text:(NSString *)text detail:(NSString *)detail;
- (NSDictionary *)buttonDictionaryWithKey:(NSString *)key text:(NSString *)text selector:(SEL)selector;

- (void)displayErrorWithMessage:(NSString *)message;

@end

@implementation CurrentSavingsViewController

@synthesize delegate = delegate_;
@synthesize newTable = newTable_;
@synthesize newData = newData_;
@synthesize isEditingSavings = isEditingSavings_;

- (id)init
{
	self = [super initWithNibName:@"CurrentSavingsViewController" bundle:nil];
	if (self) {		
		savingsData_ = [SavingsData sharedSavingsData];
		isCar1Selected_ = NO;
		isCar2Selected_ = NO;
	}
	return self;
}

- (void)dealloc
{
	[newData_ release];
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
	self.newData = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	
	if (self.isEditingSavings) {
		self.title = @"Edit Savings";
	} else {
		self.title = @"New Savings";
	}
	
	self.newData = [NSMutableArray arrayWithCapacity:0];
	
	[self.newData addObject:[self informationArray]];
	[self.newData addObject:[self vehicleArrayWithKey:vehicle1Key]];
	//[self.newData addObject:[self vehicleArrayWithKey:vehicle2Key]];
	
	if ([savingsData_.currentCalculation.vehicle2 hasDataReady]) {
		[self.newData addObject:[self vehicleArrayWithKey:vehicle2Key]];
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

- (void)selectCar1Action
{
	isCar1Selected_ = YES;
	isCar2Selected_ = NO;
	[self performSelector:@selector(selectCarAction)];
}

- (void)selectCar2Action
{
	isCar1Selected_ = NO;
	isCar2Selected_ = YES;
	[self performSelector:@selector(selectCarAction)];
}

- (void)selectCarAction
{
	VehicleSelectViewController *inputViewController = [[VehicleSelectViewController alloc] init];
	Fuel_SavingsAppDelegate *appDelegate = (Fuel_SavingsAppDelegate *)[[UIApplication sharedApplication] delegate];
	inputViewController.context = [appDelegate.coreDataObject managedObjectContext];
	inputViewController.currentSavingsViewController = self;
	
	UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:inputViewController];
	
	[self presentModalViewController:navController animated:YES];
	
	[inputViewController release];
	[navController release];
}

#pragma mark - UITableView Data Source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	NSInteger sections = [self.newData count];
	if (sections == 2) {
		sections++;
	}
	return sections;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	NSInteger rows = 0;
	if (section == 2 && [self.newData count] == 2) {
		rows = 1;
	} else {
		rows = [[self.newData objectAtIndex:section] count];
	}
	return rows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (indexPath.section == 2 && [self.newData count] == 2) {
		static NSString *AddCellIdentifier = @"AddCell";
		
		UITableViewCell *addCell = [tableView dequeueReusableCellWithIdentifier:AddCellIdentifier];
		
		if (addCell == nil) {
			addCell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:AddCellIdentifier] autorelease];
		}
	
		addCell.selectionStyle = UITableViewCellSelectionStyleBlue;
		addCell.imageView.image = [UIImage imageNamed:@"add.png"];
		addCell.textLabel.text = @"Add Car 2 (Optional)";
		
		return addCell;
	}
	
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

#pragma mark - UITableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	
	if (indexPath.section == 2 && [self.newData count] == 2) {
		[self.newData addObject:[self vehicleArrayWithKey:vehicle2Key]];
				
		[tableView beginUpdates];
		
		[tableView deleteSections:[NSIndexSet indexSetWithIndex:2] withRowAnimation:UITableViewRowAnimationNone];
		[tableView insertSections:[NSIndexSet indexSetWithIndex:2] withRowAnimation:UITableViewRowAnimationTop];
		
		[tableView endUpdates];
		
		NSIndexPath *lastCell = [NSIndexPath indexPathForRow:[[self.newData objectAtIndex:2] count] - 1
												   inSection:2];
		
		[tableView scrollToRowAtIndexPath:lastCell atScrollPosition:UITableViewScrollPositionBottom animated:YES];
		
		return;
	}
	
	UIViewController *viewController = nil;
	
	NSDictionary *dictionary = [[self.newData objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
	NSString *key = [dictionary objectForKey:dictionaryKey];
	
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
			vehicleKey = vehicle1Key;
		} else {
			vehicle = savingsData_.currentCalculation.vehicle2;
			vehicleKey = vehicle2Key;
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
		if ([controller.key isEqualToString:vehicle1Key]) {
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
		if ([controller.key isEqualToString:vehicle1Key]) {
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

- (void)vehicleDetailsViewControllerDidFinish:(VehicleDetailsViewController *)controller save:(BOOL)save
{
	if (save) {
		NSDictionary *info = controller.mpgDatabaseInfo;
		if (isCar1Selected_ == YES) {
			savingsData_.currentCalculation.vehicle1.name = [NSString stringWithFormat:@"%@ %@",
															 [info objectForKey:@"make"],
															 [info objectForKey:@"model"]];
			savingsData_.currentCalculation.vehicle1.avgEfficiency = [info objectForKey:@"mpgAverage"];
			savingsData_.currentCalculation.vehicle1.cityEfficiency = [info objectForKey:@"mpgCity"];
			savingsData_.currentCalculation.vehicle1.highwayEfficiency = [info	objectForKey:@"mpgHighway"];
		} else {
			savingsData_.currentCalculation.vehicle2.name = [NSString stringWithFormat:@"%@ %@",
															 [info objectForKey:@"make"],
															 [info objectForKey:@"model"]];
			savingsData_.currentCalculation.vehicle2.avgEfficiency = [info objectForKey:@"mpgAverage"];
			savingsData_.currentCalculation.vehicle2.cityEfficiency = [info objectForKey:@"mpgCity"];
			savingsData_.currentCalculation.vehicle2.highwayEfficiency = [info	objectForKey:@"mpgHighway"];
		}
	}
	isCar1Selected_ = NO;
	isCar2Selected_ = NO;
	[self dismissModalViewControllerAnimated:YES];
}

#pragma mark - Custom Methods

- (NSArray *)informationArray
{	
	NSMutableArray *array = [[[NSMutableArray alloc] initWithCapacity:0] autorelease];
	
	NSDictionary *dictionary = nil;
		
	dictionary = [self textDictionaryWithKey:typeKey
										text:@"Using"
									  detail:[savingsData_.currentCalculation stringForCurrentType]];
	[array addObject:dictionary];
	
	NSNumberFormatter *priceFormatter = [[NSNumberFormatter alloc] init];
	[priceFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
	
	NSString *priceStr = [priceFormatter stringFromNumber:savingsData_.currentCalculation.fuelPrice];
	[priceFormatter release];
	
	dictionary = [self textDictionaryWithKey:fuelPriceKey
										text:@"Fuel Price"
									  detail:[NSString stringWithFormat:@"%@ /gallon", priceStr]];
	[array addObject:dictionary];
	
	NSNumberFormatter *distanceFormatter = [[NSNumberFormatter alloc] init];
	[distanceFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
	[distanceFormatter setMaximumFractionDigits:0];
	
	NSString *distanceStr = [distanceFormatter stringFromNumber:savingsData_.currentCalculation.distance];
	[distanceFormatter release];
	
	dictionary = [self textDictionaryWithKey:distanceKey
										text:@"Distance"
									  detail:[NSString stringWithFormat:@"%@ miles/year", distanceStr]];
	[array addObject:dictionary];
	
	if (savingsData_.currentCalculation.type == EfficiencyTypeCombined) {
		NSNumberFormatter *ratioFormatter = [[NSNumberFormatter alloc] init];
		[ratioFormatter setNumberStyle:NSNumberFormatterPercentStyle];
		[ratioFormatter setMaximumFractionDigits:0];
		
		NSString *ratioStr = [NSString stringWithFormat:@"%@ City / %@ Highway",
								 [ratioFormatter stringFromNumber:savingsData_.currentCalculation.cityRatio],
								 [ratioFormatter stringFromNumber:savingsData_.currentCalculation.highwayRatio]];
		[ratioFormatter release];
		
		dictionary = [self textDictionaryWithKey:ratioKey
											text:@"Ratio"
										  detail:ratioStr];
		[array addObject:dictionary];
	}
	
	NSString *ownershipStr = nil;
	
	if ([savingsData_.currentCalculation.carOwnership integerValue] > 1) {
		ownershipStr = [NSString stringWithFormat:@"%@ years", [savingsData_.currentCalculation.carOwnership stringValue]];
	} else {
		ownershipStr = [NSString stringWithFormat:@"%@ year", [savingsData_.currentCalculation.carOwnership stringValue]];					
	}
	
	dictionary = [self textDictionaryWithKey:carOwnershipKey
										text:@"Ownership"
									  detail:ownershipStr];
	[array addObject:dictionary];
	
	return array;
}

- (NSArray *)vehicleArrayWithKey:(NSString *)key
{
	Vehicle *vehicle = nil;
	NSString *titleText = nil;
	SEL titleSelector;
	
	if ([key isEqualToString:vehicle1Key]) {
		vehicle = savingsData_.currentCalculation.vehicle1;
		titleText = @"Car 1";
		titleSelector = @selector(selectCar1Action);
	} else {
		vehicle = savingsData_.currentCalculation.vehicle2;
		titleText = @"Car 2";
		titleSelector = @selector(selectCar2Action);
	}
	
	NSMutableArray *array = [[[NSMutableArray alloc] initWithCapacity:0] autorelease];
	
	NSDictionary *dictionary = nil;
	
	dictionary = [self buttonDictionaryWithKey:key
										  text:titleText
									  selector:titleSelector];
	[array addObject:dictionary];
	
	dictionary = [self textDictionaryWithKey:vehicleNameKey
										text:@"Name"
									  detail:vehicle.name];
	[array addObject:dictionary];
	
	NSString *efficiencyFormatString = @"%@ MPG";
	
	if (savingsData_.currentCalculation.type == EfficiencyTypeAverage) {
		NSString *combinedStr = [NSString stringWithFormat:efficiencyFormatString, [vehicle.avgEfficiency stringValue]];
		dictionary = [self textDictionaryWithKey:vehicleAvgEfficiencyKey
											text:@"Combined MPG"
										  detail:combinedStr];
		[array addObject:dictionary];
	} else {
		NSString *cityStr = [NSString stringWithFormat:efficiencyFormatString, [vehicle.cityEfficiency stringValue]];
		dictionary = [self textDictionaryWithKey:vehicleCityEfficiencyKey
											text:@"City MPG"
										  detail:cityStr];
		[array addObject:dictionary];
		
		NSString *highwayStr = [NSString stringWithFormat:efficiencyFormatString, [vehicle.highwayEfficiency stringValue]];
		dictionary = [self textDictionaryWithKey:vehicleHighwayEfficiencyKey
											text:@"Highway MPG"
										  detail:highwayStr];
		[array addObject:dictionary];
	}

	return array;
}

- (NSDictionary *)textDictionaryWithKey:(NSString *)key text:(NSString *)text detail:(NSString *)detail
{
	NSDictionary *dictionary = [[[NSDictionary alloc] initWithObjectsAndKeys:
								 key, dictionaryKey,
								 text, dictionaryTextKey,
								 detail, dictionaryDetailKey,
								 nil] autorelease];
	return dictionary;
}

- (NSDictionary *)buttonDictionaryWithKey:(NSString *)key text:(NSString *)text selector:(SEL)selector;
{
	UIButton *button = [[UIButton buttonWithType:UIButtonTypeRoundedRect] retain];
	[button addTarget:self action:selector forControlEvents:UIControlEventTouchDown];
	[button setTitle:@"Select Car" forState:UIControlStateNormal];
	button.frame = CGRectMake(0.0, 0.0, 110.0, 28.0);
	
	NSDictionary *dictionary = [[[NSDictionary alloc] initWithObjectsAndKeys:
								 key, dictionaryKey,
								 text, dictionaryTextKey,
								 button, dictionaryButtonKey,
								 nil] autorelease];
	[button release];
	
	return dictionary;
}

#pragma mark - Private Methods

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
