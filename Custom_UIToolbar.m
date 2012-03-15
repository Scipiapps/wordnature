
#import "Custom_UIToolbar.h"


@implementation Custom_UIToolbar


- (void)drawRect:(CGRect)rect {
	UIImage *image = [UIImage imageNamed: @"icon.png"];
	[image drawInRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
}


@end
