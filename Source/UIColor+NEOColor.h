#import <UIKit/UIKit.h>

@interface UIColor (NEOColor)

+ (UIColor *) neoRandomColor;

- (CGFloat) neoLuminosity;

- (CGFloat) neoAlpha;

- (UIColor *) neoColorWithAlpha:(CGFloat) alpha;

- (UIColor *) neoToHSL;

- (UIColor *) neoComplementary;
- (UIColor *)neoContrastingBW;

- (BOOL) neoIsEqual:(UIColor *)color;
@end
