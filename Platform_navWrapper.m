
#import "Platform_navWrapper.h"


@implementation Platform_navWrapper
static Platform_navWrapper* InstanceofPlatform_navWrapper= nil;
//@synthesize navController; 
@synthesize navDictionary;

+(Platform_navWrapper*) sharedInstance {
	if( nil == InstanceofPlatform_navWrapper){
		InstanceofPlatform_navWrapper = [[Platform_navWrapper alloc] init]; //deprecated
		InstanceofPlatform_navWrapper.navDictionary = [[NSMutableDictionary alloc] init];
	}
	return InstanceofPlatform_navWrapper;
}

-(void) createWithRoot:(UIViewController*)root forKey:(NSString*)key{
	UINavigationController* ins = [InstanceofPlatform_navWrapper.navDictionary objectForKey:key];
	if(ins == nil){
		ins = [[UINavigationController alloc] initWithRootViewController:root];
		[navDictionary setObject:ins forKey:key];
	}
}

-(UINavigationController*) getAtKey:(NSString*)key{
	UINavigationController* ret = [navDictionary objectForKey:key];
	return ret;
}

@end
