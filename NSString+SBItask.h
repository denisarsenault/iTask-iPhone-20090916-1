/*

*/

#import <Foundation/Foundation.h>

/// Adds Itask parsing to NSString
@interface NSString (NSString_SBItask)

/// Returns the object represented in the receiver, or nil on error. 
- (id)ItaskFragmentValue;

/// Returns the dictionary or array represented in the receiver, or nil on error.
- (id)ItaskValue;

@end
