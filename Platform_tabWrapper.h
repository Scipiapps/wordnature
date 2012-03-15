
/*
 탭은 없애버릴 수 없는 듯 하다. 다음부터는 쓰지 말아야지 ㅡ.ㅡ;
 애들이 일부러 커스텀하게 탭 바 같은 걸 만드는 이유가 있구만.
 */

#import "Platform_tabController.h"

@interface Platform_tabWrapper : NSObject {
	Platform_tabController* tabController;
}

@property (nonatomic, retain) UITabBarController* tabController;
+(Platform_tabWrapper*) sharedInstance;

@end
