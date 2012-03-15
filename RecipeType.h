
#import <CoreData/CoreData.h>

@class Recipe;

@interface RecipeType :  NSManagedObject  
{
}

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet* recipes;

@end


@interface RecipeType (CoreDataGeneratedAccessors)
- (void)addRecipesObject:(Recipe *)value;
- (void)removeRecipesObject:(Recipe *)value;
- (void)addRecipes:(NSSet *)value;
- (void)removeRecipes:(NSSet *)value;

@end

