#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class NEOColorPickerBaseViewController;

@protocol NEOColorPickerViewControllerDelegate <NSObject>

@required
- (void) colorPickerViewController:(NEOColorPickerBaseViewController *) controller didSelectColor:(UIColor *)color;
- (void) colorPickerViewControllerDidCancel:(NEOColorPickerBaseViewController *)controller;
@optional
- (void) colorPickerViewController:(NEOColorPickerBaseViewController *) controller didChangeColor:(UIColor *)color;

@end


#define NEOColorPicker4InchDisplay()  [UIScreen mainScreen].bounds.size.height == 568


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

- (IBAction)buttonPressCancel:(id)sender;
- (IBAction)buttonPressDone:(id)sender;

- (void) setupShadow:(CALayer *)layer;
@end
