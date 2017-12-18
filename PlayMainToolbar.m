//
//  PlayMainToolbar.m
//  Reader
//
//  Created by Lieder on 2017/8/6.
//
//

#import "ReaderConstants.h"
#import "PlayMainToolbar.h"
#import "ReaderDocument.h"

#import <MessageUI/MessageUI.h>


@implementation PlayMainToolbar
{
    UIButton *markButton;
    
    UIImage *markImageN;
    UIImage *markImageY;
    
}

#pragma mark - Constants

#define BUTTON_X 8.0f
#define BUTTON_Y 8.0f

#define BUTTON_SPACE 8.0f
#define BUTTON_HEIGHT 30.0f

#define BUTTON_FONT_SIZE 15.0f
#define TEXT_BUTTON_PADDING 24.0f

#define ICON_BUTTON_WIDTH 40.0f

#define TITLE_FONT_SIZE 19.0f
#define TITLE_HEIGHT 28.0f

#pragma mark - Properties

@synthesize delegate;

#pragma mark - ReaderMainToolbar instance methods

- (instancetype)initWithFrame:(CGRect)frame
{
    return [self initWithFrame:frame documentName:nil];
}

- (instancetype)initWithFrame:(CGRect)frame documentName:(NSString *)documentName
{
    assert(documentName != nil); // Must have a valid ReaderDocument
    NSLog(@"用到初始化");
    
    
    
    if ((self = [super initWithFrame:frame]))
    {
        
        CGFloat viewWidth = self.bounds.size.width; // Toolbar view width
        
        
        BOOL largeDevice = ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad);
        
        //BOOL showDoublePlay = (([UIDevice currentDevice].orientation == UIDeviceOrientationLandscapeLeft) || ([UIDevice currentDevice].orientation == UIDeviceOrientationLandscapeRight));
        
        const CGFloat buttonSpacing = BUTTON_SPACE; const CGFloat iconButtonWidth = ICON_BUTTON_WIDTH;
        
        CGFloat titleX = BUTTON_X; CGFloat titleWidth = (viewWidth - (titleX + titleX));
        
        CGFloat leftButtonX = BUTTON_X; // Left-side button start X position
       
        CGFloat rightButtonX = viewWidth  ; // Right-side buttons start X position
        
        CGFloat doubleButtonWidth;
        
        {
            UIFont *doubleButtonFont = [UIFont systemFontOfSize:BUTTON_FONT_SIZE];
            NSString *doubleButtonText = NSLocalizedString(@"Double", @"button text");
            CGSize doubleButtonSize = [doubleButtonText sizeWithAttributes:@{NSFontAttributeName : doubleButtonFont}];
            doubleButtonWidth = (ceil(doubleButtonSize.width) + TEXT_BUTTON_PADDING);
            
            UIButton *doubleButton = [UIButton buttonWithType:UIButtonTypeCustom];
            doubleButton.frame = CGRectMake(leftButtonX , BUTTON_Y, doubleButtonWidth, BUTTON_HEIGHT);
            [doubleButton setTitleColor:[UIColor colorWithWhite:0.0f alpha:1.0f] forState:UIControlStateNormal];
            [doubleButton setTitleColor:[UIColor colorWithWhite:1.0f alpha:1.0f] forState:UIControlStateHighlighted];
            [doubleButton setTitle:doubleButtonText forState:UIControlStateNormal]; doubleButton.titleLabel.font = doubleButtonFont;
            [doubleButton addTarget:self action:@selector(doubleButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
           // [doubleButton setBackgroundImage:buttonH_seleted forState:UIControlStateSelected];
            //[doubleButton setBackgroundImage:buttonN forState:UIControlStateNormal];
            doubleButton.autoresizingMask = UIViewAutoresizingNone;
            //doneButton.backgroundColor = [UIColor grayColor];
            doubleButton.exclusiveTouch = YES;
            //doubleButton.tag = 48;
            
            [self addSubview:doubleButton]; //leftButtonX += (menuButtonWidth + buttonSpacing);

            
            UIImage *buttonH_seleted = [[UIImage imageNamed:@"ble-H"] stretchableImageWithLeftCapWidth:5 topCapHeight:0];
            UIImage *buttonN = [[UIImage imageNamed:@"ble"] stretchableImageWithLeftCapWidth:5 topCapHeight:0];
            
            UIButton *blueButton = [UIButton buttonWithType:UIButtonTypeCustom];
            blueButton.frame = CGRectMake(rightButtonX-doubleButtonWidth, BUTTON_Y, doubleButtonWidth, BUTTON_HEIGHT);
            //[blueButton setTitleColor:[UIColor colorWithWhite:0.0f alpha:1.0f] forState:UIControlStateNormal];
            //[blueButton setTitleColor:[UIColor colorWithWhite:1.0f alpha:1.0f] forState:UIControlStateHighlighted];
            //[doubleButton setTitle:doubleButtonText forState:UIControlStateNormal]; doubleButton.titleLabel.font = doubleButtonFont;
            [blueButton setImage:buttonN forState:UIControlStateNormal];
            [blueButton setImage:buttonH_seleted forState:UIControlStateHighlighted];
            [blueButton addTarget:self action:@selector(blueButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
            blueButton.autoresizingMask = UIViewAutoresizingNone;
            //doneButton.backgroundColor = [UIColor grayColor];
            blueButton.exclusiveTouch = YES;
            //doubleButton.tag = 48;
            
            [self addSubview:blueButton]; //leftButtonX += (menuButtonWidth + buttonSpacing);
            
            titleX = (doubleButtonWidth + buttonSpacing); titleWidth -= (doubleButtonWidth + buttonSpacing);
        }
        
        
//#if (READER_BOOKMARKS == TRUE) // Option
        
        if (largeDevice == YES) {
            
            rightButtonX -= (iconButtonWidth + buttonSpacing); // Position
        }
        
        else
        {
            rightButtonX -= ((2*iconButtonWidth) + buttonSpacing); // Position
        }
        
        
        CGRect titleRect = CGRectMake(doubleButtonWidth+buttonSpacing, BUTTON_Y, titleWidth - doubleButtonWidth, TITLE_HEIGHT);
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:titleRect];
        
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.font = [UIFont systemFontOfSize:TITLE_FONT_SIZE];
        titleLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        titleLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
        titleLabel.textColor = [UIColor colorWithWhite:0.0f alpha:1.0f];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.adjustsFontSizeToFitWidth = YES;
        titleLabel.minimumScaleFactor = 0.75f;
        titleLabel.text = [documentName stringByDeletingPathExtension];
#if (READER_FLAT_UI == FALSE) // Option
        titleLabel.shadowColor = [UIColor colorWithWhite:0.75f alpha:1.0f];
        titleLabel.shadowOffset = CGSizeMake(0.0f, 1.0f);
#endif // end of READER_FLAT_UI Option
        
        [self addSubview:titleLabel];
    }
    
    return self;
}

- (void)setBookmarkState:(BOOL)state
{
#if (READER_BOOKMARKS == TRUE) // Option
    
    if (state != markButton.tag) // Only if different state
    {
        if (self.hidden == NO) // Only if toolbar is visible
        {
            UIImage *image = (state ? markImageY : markImageN);
            
            [markButton setImage:image forState:UIControlStateNormal];
        }
        
        markButton.tag = state; // Update bookmarked state tag
    }
    
    if (markButton.enabled == NO) markButton.enabled = YES;
    
#endif // end of READER_BOOKMARKS Option
}

- (void)updateBookmarkImage
{
#if (READER_BOOKMARKS == TRUE) // Option
    
    if (markButton.tag != NSIntegerMin) // Valid tag
    {
        BOOL state = markButton.tag; // Bookmarked state
        
        UIImage *image = (state ? markImageY : markImageN);
        
        [markButton setImage:image forState:UIControlStateNormal];
    }
    
    if (markButton.enabled == NO) markButton.enabled = YES;
    
#endif // end of READER_BOOKMARKS Option
}

- (void)hideToolbar
{
    if (self.hidden == NO)
    {
        [UIView animateWithDuration:0.25 delay:0.0
                            options:UIViewAnimationOptionCurveLinear | UIViewAnimationOptionAllowUserInteraction
                         animations:^(void)
         {
             self.alpha = 0.0f;
         }
                         completion:^(BOOL finished)
         {
             self.hidden = YES;
         }
         ];
    }
}

- (void)showToolbar
{
    if (self.hidden == YES)
    {
        [self updateBookmarkImage]; // First
        
        [UIView animateWithDuration:0.25 delay:0.0
                            options:UIViewAnimationOptionCurveLinear | UIViewAnimationOptionAllowUserInteraction
                         animations:^(void)
         {
             self.hidden = NO;
             self.alpha = 1.0f;
         }
                         completion:NULL
         ];
    }
}

#pragma mark - UIButton action methods


- (void)doubleButtonTapped:(UIButton *)button
{
    [delegate tappedInToolbar:self doubleButton:button];
}

- (void)blueButtonTapped:(UIButton *)button
{
    [delegate tappedInToolbar:self blueButton:button];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
