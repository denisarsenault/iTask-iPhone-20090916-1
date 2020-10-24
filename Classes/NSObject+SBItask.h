/*

*/

#import <Foundation/Foundation.h>


/// Adds String handling NSObject subclasses
@interface NSObject (NSObject_SBItask)

/**
 This method is added as a category on NSObject but is only actually
 supported for the following objects:
 @li NSDictionary
 @li NSArray
 @li NSString
 @li NSNumber (also used for booleans)Itask  NSNull 
 */
- (NSString *)ItaskFragment;

/**
 Returns a string containing the receiver encoded in Itask.

 This method is added as a category on NSObject but is only actually
 supported for the following objects:
 @li NSDictionary
 @li NSArray
 */
- (NSString *)ItaskRepresentation;

@end

