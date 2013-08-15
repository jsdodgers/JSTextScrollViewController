//
//  JSTextScrollViewController.h
//
//  Created by Jsdodgers on 8/14/13.
//  Copyright (c) 2013 jsdodgers. All rights reserved.
//

#import <UIKit/UIKit.h>



@protocol JSKeyboardToolBarDelegate <NSObject>


@optional
- (UIResponder *)getNextResponder:(UIView *)field;
- (UIResponder *)getPrevResponder:(UIView *)field;
@required
-(void)next:(id)sender;
-(void)prev:(id)sender;
-(void)done:(id)sender;
@end



@protocol JSEnableButtonDelegate <NSObject>

@required
-(void)enableButtons;
-(void)disableButtons;
@end


@interface UIView (GetFirstResponder)
-(UIView *)getFirstResponder;
@end

@interface UITextField (KeyboardToolBar)
- (id)initWithToolbarDelegate:(id<JSKeyboardToolBarDelegate>)delegate;
- (id)initWithToolbarDelegate:(id<JSKeyboardToolBarDelegate>)delegate frame:(CGRect)frame;
- (id)initWithToolbarDelegate:(id<JSKeyboardToolBarDelegate>)delegate coder:(NSCoder *)aDecoder;
@end

@interface UITextView (KeyboardToolBar)
- (id)initWithToolbarDelegate:(id<JSKeyboardToolBarDelegate>)delegate;
- (id)initWithToolbarDelegate:(id<JSKeyboardToolBarDelegate>)delegate coder:(NSCoder *)aDecoder;
- (id)initWithToolbarDelegate:(id<JSKeyboardToolBarDelegate>)delegate frame:(CGRect)frame;
- (id)initWithToolbarDelegate:(id<JSKeyboardToolBarDelegate>)delegate frame:(CGRect)frame textContainer:(NSTextContainer *)textContainer;
@end


@interface JSTextScrollViewController : UIViewController<UITextFieldDelegate,UITextViewDelegate,JSKeyboardToolBarDelegate,JSEnableButtonDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;


- (UIToolbar *)createKeyboardToolBar;
+ (UIToolbar *)createKeyboardToolBarWithDelegate:(id<JSKeyboardToolBarDelegate>)delegate;

+ (int)getKeyboardHeight;

- (void)addNotificationObservers;
- (void)createScrollView;
- (void)draw;
- (void)startEdit:(id)sender;
- (void)setButtonsEnabled:(BOOL)enabled;
- (void)disableButtons;
- (void)enableButtons;
- (void)resignFirstResponder;

@end
