#import <UIKit/UIKit.h>

@class NEOColorPickerGradientView;

@protocol NEOColorPickerGradientViewDelegate <NSObject>

@required
- (void) colorPickerGradientView:(NEOColorPickerGradientView *)view valueChanged:(CGFloat)value;
@end

@interface NEOColorPickerGradientView : UIView

@property (nonatomic, weak) id <NEOColorPickerGradientViewDelegate> delegate;

@property (nonatomic, strong) UIColor *color1;
@property (nonatomic, strong) UIColor *color2;

@property (nonatomic, assign) CGFloat value;

- (void) reloadGradient;

@end
