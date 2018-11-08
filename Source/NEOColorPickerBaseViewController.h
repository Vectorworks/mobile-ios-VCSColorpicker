#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define DEGREES_TO_RADIANS(degrees) ((degrees) / ((180.0 / M_PI)))

@class NEOColorPickerBaseViewController;

@protocol NEOColorPickerViewControllerDelegate <NSObject>

@required
- (void) colorPickerViewController:(NEOColorPickerBaseViewController *) controller didSelectColor:(UIColor *)color;
- (void) colorPickerViewControllerDidCancel:(NEOColorPickerBaseViewController *)controller;
@optional
- (void) colorPickerViewController:(NEOColorPickerBaseViewController *) controller didChangeColor:(UIColor *)color;

@end


#define NEOColorPicker4InchDisplay()  [UIScreen mainScreen].bounds.size.height >= (568 -1)


@interface NEOColorPickerFavoritesManager : NSObject

@property (readonly, nonatomic, strong) NSOrderedSet *favoriteColors;

+ (NEOColorPickerFavoritesManager *) instance;

- (void) addFavorite:(UIColor *)color;


@end


@interface NEOColorPickerBaseViewController : UIViewController

@property (nonatomic, weak) id <NEOColorPickerViewControllerDelegate> delegate;

@property (nonatomic, strong) UIColor *selectedColor;
@property (nonatomic, assign) BOOL disallowOpacitySelection;
@property (nonatomic, strong) NSString* selectedColorText;
@property (nonatomic, strong) NSString* saturationText;
@property (nonatomic, strong) NSString* luminosityText;
@property (nonatomic, strong) NSString* hueText;
@property (nonatomic, strong) NSString* transparencyText;
@property (nonatomic, strong) NSString* doneButtonText;
@property (nonatomic, strong) NSString* selectedText;
@property (nonatomic, assign) CGRect selectedColoerFrame;

- (IBAction)buttonPressCancel:(id)sender;
- (IBAction)buttonPressDone:(id)sender;

- (void) setupShadow:(CALayer *)layer;
//rotation
-(void)updateForDeviceOrientation:(UIDeviceOrientation)orientation animated:(BOOL)animated;
-(void)repositionTheColorsPalette;
-(void)rotateView:(UIView*)rotatingView withDegrees:(CGFloat)degrees andOrientation:(UIDeviceOrientation)orientation;

-(CGRect)getFrameNextToLabel:(UILabel*)label;
@end
