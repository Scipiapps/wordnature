

#import <UIKit/UIKit.h>

@class Recipe;
@class CardView;

@interface CardViewController : UIViewController {
	NSInteger section;
	NSInteger row;
	
	UIImageView *reflectionView;
	UIView *containerView;	
	UIButton *flipIndicatorButton;
}

@property (nonatomic) NSInteger section;
@property (nonatomic) NSInteger row;

@property (nonatomic,retain) UIView *containerView;
@property (nonatomic,retain) UIImageView *reflectionView;
@property (nonatomic,retain) UIButton *flipIndicatorButton;

-(void) refresh;
-(void) flip;

@end
