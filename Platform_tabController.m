
#import "Platform_tabController.h"
#import "CardViewController.h"

@implementation Platform_tabController

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
	
	if(YES == [viewController.title isEqualToString:@"cards"]) {
		printf("tabBarController : cards refresh\n");
		CardViewController* tt = (CardViewController*) viewController;
		[tt refresh];
		
	}
}

- (void)tabBarController:(UITabBarController *)tabBarController didEndCustomizingViewControllers: (NSArray*)viewControllers changed:(BOOL)changed {
}

@end
