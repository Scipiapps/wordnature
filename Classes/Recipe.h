//#import "RecipeType.h"

@interface Recipe : NSManagedObject {
}

@property (nonatomic, retain) NSString *instructions; /* overview saver */
@property (nonatomic, retain) NSString *name; /* word name */
@property (nonatomic, retain) NSString *noteName; /* note name */
@property (nonatomic, retain) NSString *overview; /* description */
@property (nonatomic, retain) NSString *prepTime; /* word count */
@property (nonatomic, retain) NSSet *ingredients; /* reserved */
@property (nonatomic, retain) UIImage *thumbnailImage; /* reserved */
@property (nonatomic, retain) NSManagedObject *image; /* reserved */
@property (nonatomic, retain) NSManagedObject *type; /* reserved */

@end


@interface Recipe (CoreDataGeneratedAccessors)
- (void)addIngredientsObject:(NSManagedObject *)value;
- (void)removeIngredientsObject:(NSManagedObject *)value;
- (void)addIngredients:(NSSet *)value;
- (void)removeIngredients:(NSSet *)value;
@end

