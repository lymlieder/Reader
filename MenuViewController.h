//
//  MenuViewController.h
//  Reader
//
//  Created by FairyAnnie on 2017/5/26.
//
//

#import <UIKit/UIKit.h>
#import "ReaderThumbsView.h"
#import "ReaderDocument.h"
#import "ReaderViewController.h"

@interface MenuViewController : UIViewController<UIScrollViewDelegate,UIGestureRecognizerDelegate>

//@property (nonatomic, strong) UIView *view;
@property (nonatomic, strong) UIView *thumbsView;
@property (nonatomic, strong) ReaderThumbsView *theThumbsView;//小方视图
@property (nonatomic, strong) ReaderThumbsView *theBigThumbsView;//有效视图
@property (nonatomic) NSInteger thumbsXCount, thumbsYCount, thumbXLeft,thumbYTop;
@property (nonatomic) CGSize size;//
@property (nonatomic) CGSize theBigViewSize;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic) NSUInteger pdfsCount;
@property (nonatomic, strong) NSMutableArray *pdfs;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) ReaderDocument *document;
@property (nonatomic, strong) UIView *blackView;
@property (nonatomic) CGRect imageR;
@property (nonatomic, strong) NSMutableString *phrase;
@property (nonatomic) BOOL quit;
@property (nonatomic) NSInteger theChosenNumber;
@property (nonatomic) NSMutableString *theDocumentName;
@property (nonatomic) CGRect scrollViewRect;
@property (nonatomic, strong) UILabel *blankLabel;
@property (nonatomic, strong) UISwipeGestureRecognizer *blankDown;
@property (nonatomic) BOOL freshTip;

-(void)load;
-(void)transTheDocumentIndex:(NSString *)indexName;

@end




@interface Tap : UITapGestureRecognizer

@property (nonatomic) NSInteger chosenNumber;

@end
