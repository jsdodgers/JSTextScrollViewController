//
//  JSTextScrollViewController.m
//
//  Created by Jsdodgers on 8/14/13.
//  Copyright (c) 2013 jsdodgers. All rights reserved.
//

#import "JSTextScrollViewController.h"


static CGRect keyboardFrame;


@implementation UIView (GetFirstResponder)

- (UIView *)getFirstResponder {
	if (self.isFirstResponder) {
		return self;
	}
	else {
		for (UIView *subview in self.subviews) {
			UIView *first = [subview getFirstResponder];
			if (first) return first;
		}
	}
	return nil;	
}
@end


@implementation UITextField (KeyboardToolBar)

- (id)initWithToolbarDelegate:(id<JSKeyboardToolBarDelegate>)delegate {
	if ((self = [self init])) {
		self.inputAccessoryView = [JSTextScrollViewController createKeyboardToolBarWithDelegate:delegate];
	}
	return self;
}

- (id)initWithToolbarDelegate:(id<JSKeyboardToolBarDelegate>)delegate frame:(CGRect)frame {
	if ((self = [self initWithFrame:frame])) {
		self.inputAccessoryView = [JSTextScrollViewController createKeyboardToolBarWithDelegate:delegate];
	}
	return self;
}

- (id)initWithToolbarDelegate:(id<JSKeyboardToolBarDelegate>)delegate coder:(NSCoder *)aDecoder {
	if ((self = [self initWithCoder:aDecoder])) {
		self.inputAccessoryView = [JSTextScrollViewController createKeyboardToolBarWithDelegate:delegate];
	}
	return self;
}

@end

@implementation UITextView (KeyboardToolBar)


- (id)initWithToolbarDelegate:(id<JSKeyboardToolBarDelegate>)delegate {
	if ((self = [self init])) {
		self.inputAccessoryView = [JSTextScrollViewController createKeyboardToolBarWithDelegate:delegate];
	}
	return self;
}

- (id)initWithToolbarDelegate:(id<JSKeyboardToolBarDelegate>)delegate coder:(NSCoder *)aDecoder {
	if ((self = [self initWithCoder:aDecoder])) {
		self.inputAccessoryView = [JSTextScrollViewController createKeyboardToolBarWithDelegate:delegate];
	}
	return self;
}

- (id)initWithToolbarDelegate:(id<JSKeyboardToolBarDelegate>)delegate frame:(CGRect)frame {
	if ((self = [self initWithFrame:frame])) {
		self.inputAccessoryView = [JSTextScrollViewController createKeyboardToolBarWithDelegate:delegate];
	}
	return self;
}

- (id)initWithToolbarDelegate:(id<JSKeyboardToolBarDelegate>)delegate frame:(CGRect)frame textContainer:(NSTextContainer *)textContainer {
	if ((self = [self initWithFrame:frame textContainer:textContainer])) {
		self.inputAccessoryView = [JSTextScrollViewController createKeyboardToolBarWithDelegate:delegate];
	}
	return self;
}

@end


@interface JSTextScrollViewController ()


@end

@implementation JSTextScrollViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {

    }
    return self;
}

- (id)init {
	return [self initWithNibName:nil bundle:nil];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
	if ((self = [super initWithCoder:aDecoder])) {
	
	}
	return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	[self.view setBackgroundColor:[UIColor whiteColor]];
	UIView *vi = [[UIView alloc] initWithFrame:CGRectMake(-10, -10, 1, 1)];
	[vi setBackgroundColor:[UIColor clearColor]];
	[self.view addSubview:vi];
	[self addNotificationObservers2];
	[self addNotificationObservers];
	[self createScrollView];
	[self draw];
}

- (void)draw {}

- (void)createScrollView {
	
	self.scrollView = [self createFullScreenScrollView];
	[self.scrollView setBackgroundColor:[UIColor colorWithRed:239.0f/255.0f green:239.0f/255.0f blue:244.0f/255.0f alpha:1.0f]];
	[self.view addSubview:self.scrollView];
}


- (UIScrollView *)createFullScreenScrollView {
	UIScrollView *scrollView;
	CGRect frame = self.view.bounds;
	if (!(IOS_6)) {
		float top = 0.0f;
		if (![UIApplication sharedApplication].statusBarHidden) top += 20;
		if (self.navigationController) top+= self.navigationController.navigationBar.frame.size.height;
		frame.size.height-=top;
		frame.origin.y+=top;
	}
	else {
		float top = 0.0f;
		if (self.navigationController) top+= self.navigationController.navigationBar.frame.size.height;
		frame.size.height-=top;
	}
	scrollView = [[UIScrollView alloc] initWithFrame:frame];
	[scrollView setContentSize:frame.size];
	return scrollView;
}

- (UITableView *)createFullScreenTableView {
	UITableView *tableView;
	CGRect frame = self.view.bounds;
	if (!(IOS_6)) {
		float top = 0.0f;
		if (![UIApplication sharedApplication].statusBarHidden) top += 20;
		if (self.navigationController) top+= self.navigationController.navigationBar.frame.size.height;
		frame.size.height-=top;
		frame.origin.y+=top;
	}
	else {
		float top = 0.0f;
		if (self.navigationController) top+= self.navigationController.navigationBar.frame.size.height;
		frame.size.height-=top;
	}
	tableView = [[UITableView alloc] initWithFrame:frame];
	return tableView;
}





- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




#pragma mark - Move scrollView to display field


- (void)scrollLeaveEdit {
	int off = self.scrollView.contentOffset.y;
	if (self.scrollView.contentSize.height - self.scrollView.frame.size.height < off)
		off = self.scrollView.contentSize.height - self.scrollView.frame.size.height;
	if (off<0)
		off = 0;
//	[UIView animateKeyframesWithDuration:0.3f delay:0.0f options:UIViewKeyframeAnimationOptionBeginFromCurrentState animations:^(){
	[UIView animateWithDuration:0.25f delay:0.0f options:UIViewAnimationOptionBeginFromCurrentState animations:^() {
		[self.scrollView setContentOffset:CGPointMake(self.scrollView.contentOffset.x, off)];
	} completion:^(BOOL finished){
		[self.scrollView setContentInset:UIEdgeInsetsZero];
	}];
	[self.scrollView setScrollEnabled:YES];
	
}

- (void)scrollSetOffset:(int)y view:(UIView *)view {
	[self.scrollView setScrollEnabled:NO];
	
	int off = y;
	off -= ((self.view.frame.size.height - self.scrollView.frame.origin.y) - [[self class] getKeyboardHeight]);
	off += view.frame.size.height + 10;
	if (off<0) off = 0;
	
	UIEdgeInsets insets = UIEdgeInsetsZero;
	if (self.scrollView.contentSize.height - self.scrollView.frame.size.height < off) {
		insets.bottom = off - (self.scrollView.contentSize.height - self.scrollView.frame.size.height);
	}
	
	if (insets.bottom>self.scrollView.contentInset.bottom) {
		[self.scrollView setContentInset:insets];
	}
	[UIView animateWithDuration:0.25f delay:0.0f options:UIViewAnimationOptionBeginFromCurrentState animations:^() {
		[self.scrollView setContentOffset:CGPointMake(self.scrollView.contentOffset.x, off)];
		[self.scrollView setContentInset:insets];
		
	}completion:^(BOOL completed){
	}];
	[self disableButtons];
}


#pragma mark - NSNotificationCenter Methods

- (void)addNotificationObservers {
	
}

- (void)addNotificationObservers2 {
	NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
	[center addObserver:self selector:@selector(keyboardChangedFrame:) name:UIKeyboardDidChangeFrameNotification object:nil];
	[center addObserver:self selector:@selector(keyboardChangedFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
}


- (void)keyboardChangedFrame:(id)sender {
	NSNotification *notification = (NSNotification *)sender;
	CGRect rect = [[notification.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
	keyboardFrame = rect;
	
	UIView *view = [self.scrollView getFirstResponder];
	
	if (view) {
		if ([view isFirstResponder])
			[self startEdit:view];
	}
}

#pragma mark - UITextField Delegate Methods


//This method is called when text is edited. This way, if a form has a max length, it can
//be capped here.
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
	return [self textField:textField shouldChangeCharactersInRange:range replacementString:string maxLength:0];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string maxLength:(int)maxLength{
	
	BOOL returnKey = [string rangeOfString:@"\n"].location !=NSNotFound;
	if (maxLength==0) return YES;
	int oldLength = [textField.text length];
	int replacementLength = [string length];
	int rangeLength = range.length;
	int newLength = oldLength - rangeLength + replacementLength;
	return newLength <=maxLength || returnKey;
}


//This method is called when the "Next" or "Go" buttons are pressed. It will go to the next text
//field if there is one; otherwise, it will hide the keyboard and login if the "Go" button was
//pressed or if the enter key was pressed in the last text field.
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	UIResponder *nextResponder = [self getNextResponder:textField];
	[self textFieldReturned:textField];
	if (textField.returnKeyType==UIReturnKeyNext && nextResponder) {
		[nextResponder becomeFirstResponder];
	}
	else {
		[textField resignFirstResponder];
		[self scrollLeaveEdit];
		[self enableButtons];
	}
	return NO;
}

- (void)textFieldReturned:(UITextField *)textField {
	
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
	[self.scrollView setScrollEnabled:NO];
	[self setButtonsEnabled:textField forResponder:textField];
	[textField setTextColor:[UIColor blackColor]];
	CGPoint point = CGPointMake(0, 0);
	UIView *view = textField;
	while ([view superview]) {
		point = [view convertPoint:point toView:[view superview]];
		view = [view superview];
		if (view==self.scrollView) {
			[self scrollSetOffset:point.y view:textField];
			break;
		}
	}
	
}

#pragma mark - UITextViewDelegate Methods

- (void)textViewDidBeginEditing:(UITextView *)textView {
	[self.scrollView setScrollEnabled:NO];
	[self setButtonsEnabled:(UIControl *)textView forResponder:textView];
	[textView setTextColor:[UIColor blackColor]];
	CGPoint point = CGPointMake(0, 0);
	UIView *view = textView;
	while ([view superview]) {
		point = [view convertPoint:point toView:[view superview]];
		view = [view superview];
		if (view==self.scrollView) {
			[self scrollSetOffset:point.y view:textView];
			break;
		}
	}
	
}

- (void)textViewDidEndEditing:(UITextView *)textView {
	
}



#pragma mark - Additional Text Control Methods



- (void)startEdit:(id)sender {
	if ([sender isKindOfClass:[UITextField class]]) [self textFieldDidBeginEditing:sender];
	else if ([sender isKindOfClass:[UITextView class]]) [self textViewDidBeginEditing:sender];
}


- (void)endEdit:(id)sender {
	
}



#pragma mark - JSKeyboardToolbarDelegate Methods


//next button pressed. Go to next text field.
- (void)next:(id)sender {
	UIView *view = [self.view getFirstResponder];
	UIResponder *nextResponder = [self getNextResponder:view];
	if (nextResponder) {
		[nextResponder becomeFirstResponder];
		[self setButtonsEnabled:(UIControl *)nextResponder forResponder:nextResponder];
	}
}

//prev button pressed. Go to the previous text field
- (void)prev:(id)sender {
	UIView *view = [self.view getFirstResponder];
	UIResponder *prevResponder = [self getPrevResponder:view];
	if (prevResponder) {
		[prevResponder becomeFirstResponder];
		[self setButtonsEnabled:(UIControl *)prevResponder forResponder:prevResponder];
	}
}

//Done pressed. Hide keyboard and end editing.
- (void)done:(id)sender {
	[self resignFirstResponder];
	[self enableButtons];
	[self scrollLeaveEdit];
	[self.scrollView setScrollEnabled:YES];
}

#pragma mark JSKeyboardToolbarDelegate Helper Methods

//Sets which buttons on the keyboard toolbar are enabled. If there is another field, the next
//button will be enabled and if there is a previous field, the prev button will be enabled.
- (void)setButtonsEnabled:(UIView *)field forResponder:(UIResponder *)receiver {
	UIToolbar *tool = (UIToolbar *)[receiver inputAccessoryView];
	UIBarButtonItem *next = [[tool items] objectAtIndex:1];
	UIBarButtonItem *prev = [[tool items] objectAtIndex:0];
	
	UIResponder *prevResponder = [self getPrevResponder:field];
	UIResponder *nextResponder = [self getNextResponder:field];
	[next setEnabled:nextResponder!=nil];
	[prev setEnabled:prevResponder!=nil];
	
}

- (UIResponder *)getNextResponder:(UIView *)field {
	UIResponder *nextResponder;
	int nextTag = field.tag + 1;
	nextResponder = [self.scrollView viewWithTag:nextTag];
	while (nextResponder!=nil && ((UIControl *)nextResponder).hidden) {
		nextTag++;
		nextResponder = [self.scrollView viewWithTag:nextTag];
	}
	return nextResponder;
}

- (UIResponder *)getPrevResponder:(UIView *)field {
	UIResponder *prevResponder;
	int prevTag = field.tag - 1;
	prevResponder = [self.scrollView viewWithTag:prevTag];
	while (prevResponder!=nil && ((UIControl *)prevResponder).hidden) {
		prevTag--;
		prevResponder = [self.scrollView viewWithTag:prevTag];
	}
	return prevResponder;
}


#pragma mark - Resign First Responder



- (void)resignFirstResponder {
	UIView *view = [self.view getFirstResponder];
	[view resignFirstResponder];
	[self scrollLeaveEdit];
}

#pragma mark - Enable Buttons


//The method does not have implementation by default, but can be overwritten in subclasses to disable/enable UIControls.
- (void)enableButtons {
	[self setButtonsEnabled:YES];
}

- (void)disableButtons {
	[self setButtonsEnabled:NO];
}

- (void)setButtonsEnabled:(BOOL)enabled {
	
}



#pragma mark - Keyboard Methods



+ (int)getKeyboardHeight {
	return keyboardFrame.size.height;
}


- (UIToolbar *)createKeyboardToolBar {
	return [[self class] createKeyboardToolBarWithDelegate:self];
}

+ (UIToolbar *)createKeyboardToolBarWithDelegate:(id<JSKeyboardToolBarDelegate>)delegate {
	UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, ((UIViewController *)delegate).view.frame.size.width, 44)];
	[toolbar setBarStyle:UIBarStyleBlackTranslucent];
	UIBarButtonItem *prev = [[UIBarButtonItem alloc] initWithTitle:@"Prev" style:UIBarButtonItemStyleBordered target:delegate action:@selector(prev:)];
	UIBarButtonItem *next = [[UIBarButtonItem alloc] initWithTitle:@"Next" style:UIBarButtonItemStyleBordered target:delegate action:@selector(next:)];
	UIBarButtonItem *done = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:delegate action:@selector(done:)];
	UIBarButtonItem *flexibleSpaceMiddle = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
	[toolbar setItems:@[prev,next,flexibleSpaceMiddle,done]];
	return toolbar;
}


@end