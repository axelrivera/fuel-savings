//
//  DistanceInputViewController.m
//  Fuel Savings
//
//  Created by arn on 6/29/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DistanceInputViewController.h"

#define MIN_DISTANCE 0
#define MAX_DISTANCE 99999
#define SAVINGS_FACTOR 1000
#define TRIP_FACTOR 100

@interface DistanceInputViewController (Private)

- (void)saveDistance:(NSNumber *)distance updatePicker:(BOOL)updatePicker animated:(BOOL)animated;
- (void)resetPickerAnimated:(BOOL)animated;
- (void)setInputPickerWithNumber:(NSNumber *)number animated:(BOOL)animated;

@end

@implementation DistanceInputViewController

@synthesize delegate = delegate_;
@synthesize distanceTable = distanceTable_;
@synthesize inputPicker = inputPicker_;
@synthesize addButton = addButton_;
@synthesize subtractButton = subtractButton_;
@synthesize resetButton = resetButton_;
@synthesize currentDistance = currentDistance_;
@synthesize distanceSuffix = distanceSuffix_;
@synthesize footerText = footerText_;

- (id)init
{
	self = [super initWithNibName:@"DistanceInputViewController" bundle:nil];
	if (self) {
		NSMutableArray *input = [[NSMutableArray alloc] initWithCapacity:10];
		for (NSInteger i = 0; i < 10; i++) {
			[input addObject:[NSNumber numberWithInteger:i]];
		}
		
		inputData_ = [[NSArray alloc] initWithObjects:
									[NSArray arrayWithArray:input],
									[NSArray arrayWithArray:input],
									[NSArray arrayWithArray:input],
									[NSArray arrayWithArray:input],
									[NSArray arrayWithArray:input],
									nil];
		
		[input release];
		
		numberFormatter_ = [[NSNumberFormatter alloc] init];
		[numberFormatter_ setNumberStyle:NSNumberFormatterDecimalStyle];
		[numberFormatter_ setMaximumFractionDigits:0];
		
		type_ = DistanceInputTypeSavings;
		distanceFactor_ = SAVINGS_FACTOR;
		
		self.currentDistance = nil;
		self.distanceSuffix = nil;
		self.footerText = nil;
	}
	return self;
}

- (id)initWithType:(DistanceInputType)type
{
	self = [self init];
	if (self) {
		if (type == DistanceInputTypeTrip) {
			type_ = type;
			distanceFactor_ = TRIP_FACTOR;
		}
	}
	return self;
}

- (void)dealloc
{
	[inputData_ release];
	[numberFormatter_ release];
	[distanceTable_ release];
	[inputPicker_ release];
	[addButton_ release];
	[subtractButton_ release];
	[resetButton_ release];
	[currentDistance_ release];
	[distanceSuffix_ release];
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
	self.title = @"Change Distance";
	
	
	NSNumber *numberFactor = [NSNumber numberWithInteger:distanceFactor_];
	
	self.addButton.title = [NSString stringWithFormat:@"Add %@", [numberFormatter_ stringFromNumber:numberFactor]];
	self.subtractButton.title = [NSString stringWithFormat:@"Subtract %@", [numberFormatter_ stringFromNumber:numberFactor]];
	self.resetButton.title = @"Reset";
	
	self.distanceTable.sectionHeaderHeight = 35.0;
}

- (void)viewDidUnload
{
	[super viewDidUnload];
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
	self.distanceTable = nil;
	self.inputPicker = nil;
	self.addButton = nil;
	self.subtractButton = nil;
	self.resetButton = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	
	if (self.currentDistance) {
		[self setInputPickerWithNumber:self.currentDistance animated:NO];
	} else {
		[self resetPickerAnimated:NO];
	}
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
	BOOL save = YES;
	if ([self.currentDistance integerValue] == 0) {
		save = NO;
	}
	[self.delegate distanceInputViewControllerDidFinish:self save:save];
}

# pragma mark - Custom Actions

- (IBAction)addAction:(id)sender
{
	NSInteger result = [self.currentDistance integerValue] + distanceFactor_;
	
	if (result > MAX_DISTANCE) {
		result = MAX_DISTANCE;
	}
	[self saveDistance:[NSNumber numberWithInteger:result] updatePicker:YES animated:YES];
}

- (IBAction)subtractAction:(id)sender
{
	NSInteger result = [self.currentDistance integerValue] - distanceFactor_;
	
	if (result < MIN_DISTANCE) {
		result = MIN_DISTANCE;
	}
	[self saveDistance:[NSNumber numberWithInteger:result] updatePicker:YES animated:YES];
}

- (IBAction)resetAction:(id)sender
{
	[self resetPickerAnimated:YES];
}

#pragma mark - Custom Methods

- (void)saveDistance:(NSNumber *)distance updatePicker:(BOOL)updatePicker animated:(BOOL)animated
{
	if (updatePicker) {
		[self setInputPickerWithNumber:distance animated:animated];
	}
	self.currentDistance = distance;
	[self.distanceTable reloadData];
}

#pragma mark - Private Methods

- (void)setInputPickerWithNumber:(NSNumber *)number animated:(BOOL)animated
{
	NSNumberFormatter *stringFormatter = [[NSNumberFormatter alloc] init];
	[stringFormatter setNumberStyle:NSNumberFormatterNoStyle];
	[stringFormatter setMinimumFractionDigits:0];
	[stringFormatter setFormatWidth:5];
	[stringFormatter setPaddingCharacter:@"0"];
	
	NSString *numberString = [stringFormatter stringFromNumber:number];
	
	[stringFormatter release];
	
	for (NSInteger i = 0; i < [self.inputPicker numberOfComponents]; i++) {
		NSString *string = [numberString substringWithRange:NSMakeRange(i, 1)];
		NSNumber *tmpNumber = [numberFormatter_ numberFromString:string];
		NSInteger position =  [tmpNumber integerValue];
		[self.inputPicker selectRow:position inComponent:i animated:animated];
	}
}

- (void)resetPickerAnimated:(BOOL)animated
{
	NSNumber *number = nil;
	if (type_ == DistanceInputTypeSavings) {
		number = [NSNumber numberWithInteger:15000];
	} else {
		number = [NSNumber numberWithInteger:100];
	}
	[self saveDistance:number updatePicker:YES animated:animated];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	// Return the number of rows in the section.
	return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *CellIdentifier = @"Cell";
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
	}
	
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
	cell.textLabel.textAlignment = UITextAlignmentCenter;
	cell.textLabel.font = [UIFont systemFontOfSize:18.0];
	
	NSMutableString *textLabelStr = [NSMutableString stringWithFormat:@"%@", [numberFormatter_ stringFromNumber:self.currentDistance]];
	
	if (self.distanceSuffix) {
		[textLabelStr appendFormat:@" %@", self.distanceSuffix];
	}
	
	cell.textLabel.text = textLabelStr;
	
	return cell;
}

#pragma mark - Table view delegate methods

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
	return self.footerText;
}

# pragma mark - UIPickerView Data Source

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
	return 5;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
	return [[inputData_ objectAtIndex:component] count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
	NSArray *array = [inputData_ objectAtIndex:component];
	return [numberFormatter_ stringFromNumber:[array objectAtIndex:row]];
}

#pragma UIPickerView Delegate

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
	return 50.0;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
	NSString *distanceString = @"";
	
	for (NSInteger i = 0; i < [pickerView numberOfComponents]; i++) {
		NSArray *array = [inputData_ objectAtIndex:i];
		NSNumber *number = [array objectAtIndex:[pickerView selectedRowInComponent:i]];
		distanceString = [distanceString stringByAppendingFormat:@"%@", [number stringValue]];
	}
	[self saveDistance:[numberFormatter_ numberFromString:distanceString] updatePicker:NO animated:NO];
}

@end
