
#import "Platform_tabWrapper.h"


@implementation Platform_tabWrapper
static Platform_tabWrapper* InstanceofPlatform_tabWrapper= nil;
@synthesize tabController; 

+(Platform_tabWrapper*) sharedInstance{
	if( nil == InstanceofPlatform_tabWrapper){
		InstanceofPlatform_tabWrapper = [[Platform_tabWrapper alloc] init];
		InstanceofPlatform_tabWrapper.tabController = [[Platform_tabController alloc] init];
		[InstanceofPlatform_tabWrapper.tabController setDelegate:(Platform_tabController*)InstanceofPlatform_tabWrapper.tabController];
		//[InstanceofPlatform_tabWrapper.tabController setColor:[UIColor blueColor]];
	}
	return InstanceofPlatform_tabWrapper;
}

@end
