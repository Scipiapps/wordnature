#import "CardDetailView.h"

@implementation CardDetailView

@synthesize viewController;

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	[viewController flip];
} 

@end
