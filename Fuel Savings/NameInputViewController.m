//
//  SingleInputViewController.m
//  Fuel Savings
//
//  Created by arn on 6/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "NameInputViewController.h"

@implementation NameInputViewController

@synthesize delegate = delegate_;
@synthesize key = key_;
@synthesize currentName = currentName_;

- (id)init
{
	self = [super initWithNibName:@"NameInputViewController" bundle:nil];
	if (self) {
		self.title = @"Enter Name";
		self.key = @"";
		self.currentName = @"";
	}
	return self;
}

- (id)initWithNavigationButtons {
	self = [self init];
	if (self) {
		UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave
																					target:self
																					action:@selector(saveAction)];
		self.navigationItem.rightBarButtonItem = saveButton;
		[saveButton release];
		
		UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
																					  target:self
																					  action:@selector(cancelAction)];
		self.navigationItem.leftBarButtonItem = cancelButton;
		[cancelButton release];
	}
	return self;
}

- (void)dealloc
{
	[key_ release];
	[currentName_ release];
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

	nameTextField_ = [[UITextField alloc] initWithFrame:CGRectMake(0.0, 7.0, 280.0, 30.0)];
	nameTextField_.font = [UIFont systemFontOfSize:16.0];
	nameTextField_.adjustsFontSizeToFitWidth = YES;
	nameTextField_.placeholder = @"Name";
	nameTextField_.keyboardType = UIKeyboardTypeDefault;
	nameTextField_.returnKeyType = UIReturnKeyDone;
	nameTextField_.autocorrectionType = UITextAutocorrectionTypeNo;
	nameTextField_.autocapitalizationType = UITextAutocapitalizationTypeWords;
	nameTextField_.textAlignment = UITextAlignmentLeft;
	nameTextField_.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
	nameTextField_.clearButtonMode = YES;
	nameTextField_.delegate = self;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
	[nameTextField_ release];
	nameTextField_ = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
	nameTextField_.text = self.currentName;
	[nameTextField_ becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
	if (self.navigationItem.rightBarButtonItem == nil) {
		[self performSelector:@selector(saveAction)];
	}
}

#pragma mark - Custom Actions

- (void)saveAction
{
	self.currentName = nameTextField_.text;
	[self.delegate nameInputViewControllerDidFinish:self save:YES];
}

- (void)cancelAction
{
	[self.delegate nameInputViewControllerDidFinish:self save:NO];
}

#pragma mark - Textfield Delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	[textField resignFirstResponder];
	return NO;
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
    cell.accessoryView = nameTextField_;
	
    return cell;
}

@end
