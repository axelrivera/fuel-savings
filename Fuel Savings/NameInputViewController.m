//
//  SingleInputViewController.m
//  Fuel Savings
//
//  Created by arn on 6/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "NameInputViewController.h"

@interface NameInputViewController (Private)

- (void)displayErrorWithMessage:(NSString *)message;

@end

@implementation NameInputViewController

@synthesize delegate = delegate_;
@synthesize key = key_;
@synthesize currentName = currentName_;
@synthesize footerText = footerText_;

- (id)init
{
	self = [super initWithNibName:@"NameInputViewController" bundle:nil];
	if (self) {
		self.title = @"Name";
		self.key = @"";
		self.currentName = @"";
		self.footerText = nil;
	}
	return self;
}

- (void)dealloc
{
	[key_ release];
	[currentName_ release];
	[footerText_ release];
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

	nameTextField_ = [[UITextField alloc] initWithFrame:CGRectMake(0.0, 7.0, 280.0, 30.0)];
	nameTextField_.font = [UIFont systemFontOfSize:16.0];
	nameTextField_.adjustsFontSizeToFitWidth = YES;
	nameTextField_.placeholder = @"Name";
	nameTextField_.keyboardType = UIKeyboardTypeDefault;
	nameTextField_.returnKeyType = UIReturnKeyDefault;
	nameTextField_.autocorrectionType = UITextAutocorrectionTypeNo;
	nameTextField_.autocapitalizationType = UITextAutocapitalizationTypeWords;
	nameTextField_.textAlignment = UITextAlignmentLeft;
	nameTextField_.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
	nameTextField_.clearButtonMode = YES;
	nameTextField_.delegate = self;
	
	self.tableView.sectionHeaderHeight = 35.0;
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
}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
	[nameTextField_ becomeFirstResponder];
}

#pragma mark - Custom Actions

- (void)saveAction
{
	self.currentName = nameTextField_.text;
	
	self.currentName = [self.currentName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
	if ([self.currentName isEqualToString:@""]) {
		[self displayNameError];
		return;
	}
	
	[self.delegate nameInputViewControllerDidFinish:self save:YES];
}

- (void)cancelAction
{
	[self.delegate nameInputViewControllerDidFinish:self save:NO];
}

#pragma mark - Private Methods

- (void)displayNameError
{
	[self displayErrorWithMessage:@"The Name cannot be empty."];
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

#pragma mark - Table view delegate methods

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
	return self.footerText;
}

#pragma mark - Textfield Delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	[self performSelector:@selector(saveAction)];
	return NO;
}

@end
