#import <UIKit/UIKit.h>
#import "CardViewController.h"

@interface CardView : UIView {
	NSString *card_name;
	NSString *card_description;
	
	CardViewController* viewController;
}

@property (nonatomic, retain) NSString *card_name;
@property (nonatomic, retain) NSString *card_description;
@property (nonatomic, retain) CardViewController* viewController;
+ (CGSize)preferredViewSize;
- (UIImage *)reflectedImageRepresentationWithHeight:(NSUInteger)height;

@end
