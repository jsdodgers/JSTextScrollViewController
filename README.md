JSTextScrollViewController
==========================

View controller with a UIScrollView that automatically scrolls to display selected text field.


___Information___

This is a simple class that will automatically scroll the main scrollView such that any UITextField or UITextView that you add to it will be visible when the keyboard shows up (or any other input view).

In addition, there is implementation of a toolbar that can go above the inputView with buttons to resignFirstResponder (done) and to go to the next or previous text field based on tag.

The JSTextScrollViewController automatically does the following when the _viewDidLoad_ is called:

* Calls _[super viewDidLoad]_
* Sets the background color to white.
* Adds notificationCenter observers to handle keyboard actions.
* Calls the _-(void)addNotificationObservers_ method, which you can override to add any notification center obervers, if neccessary.
* Calls the _-(void)createScrollView_ method, which creates a UIScrollView which takes up the whole frame of the view.
		* This can be overridden to create a scrollView that takes up less than the whole screen, or a UIScrollView subclass.
* Calls the _-(void)draw_ method, which can be overridden to add subviews the the scrollView or to the view.

_Interface Builder_

If using Interface Builder, make sure to create a UIScrollView or UIScrollView subclass and link it to _scrollView_ instance variable.
Also, be sure to override _-(void)createScrollView_ so that the default scrollView is not created.

__Getting Started__

1. Make your viewController a subclass of JSTextScrollViewController.
2. If your viewController will observe any notifications, override the _-(void)addNotificationObservers_ method and add them all there.
3. If creating a custom scrollView or _UIScrollView_ subclass (_ie. UITableView_), override _-(void)createScrollView_ and create your scrollView there, setting self.scrollView.
4. If adding custom views to the scrollView through code, override _-(void)draw_.

Now, any UITextField or UITextView that has your viewController as its delegate will automatically be scrolled to a visible point on the screen when the keyboard shows up.

__Adding Next, Prev, and Done Buttons__

There are three ways to add a UIToolBar with next, prev, and done buttons to easily navigate through controls.

* _initWithToolbarDelegate:..._: Constructors have been added for each of UITextField and UITextView's constructors wich take an extra parameter of a _JSKeyboardToolBarDelegate_. The delegate will be whichever viewController contains the scrollView you are adding the field to, which will usually be _self_.
		* Ex: UITextField *field = [[UITextField alloc] initWithToolBarDelegate:self frame:CGRectMake(0, 0, 320, 40)];
* _-createKeyboardToolBar_: Calling this method in your viewController will automatically return a newly created UIToolBar with the buttons and _self_ as the delegate. You can then set the returned UIToolBar as the _inputAccessoryView_ of any textView or textField.
* _+createKeyboardToolBarWithDelegate:_: This is the last way to create the UIToolBar. If you are creating it outside of a JSTextScrollViewController subclass, calling this method on any subclass or the main class with your delegate as the parameter will create the UIToolBar. The previous method calls this with _self_ as the delegate. Like the previous method, just set the _inputAccessoryView_ to the returned UIToolBar.


