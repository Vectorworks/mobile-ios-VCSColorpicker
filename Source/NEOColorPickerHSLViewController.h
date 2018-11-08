#import <UIKit/UIKit.h>
#import "NEOColorPickerBaseViewController.h"


@class NEOColorPickerGradientView;


@interface NEOColorPickerHSLViewController : NEOColorPickerBaseViewController

@property (weak, nonatomic) IBOutlet UIImageView *hueImageView;
@property (weak, nonatomic) IBOutlet UIImageView *hueCrosshair;
@property (weak, nonatomic) IBOutlet NEOColorPickerGradientView *gradientViewSaturation;
@property (weak, nonatomic) IBOutlet NEOColorPickerGradientView *gradientViewLuminosity;
@property (weak, nonatomic) IBOutlet NEOColorPickerGradientView *gradientViewAlpha;
@property (weak, nonatomic) IBOutlet UIImageView *checkeredView;
@property (weak, nonatomic) IBOutlet UIButton *buttonSatMin;
@property (weak, nonatomic) IBOutlet UIButton *buttonSatMax;
@property (weak, nonatomic) IBOutlet UIButton *buttonLumMax;
@property (weak, nonatomic) IBOutlet UIButton *buttonLumMin;
@property (weak, nonatomic) IBOutlet UIButton *buttonAlphaMax;
@property (weak, nonatomic) IBOutlet UIButton *buttonAlphaMin;
@property (weak, nonatomic) IBOutlet UILabel *labelTransparency;
@property (weak, nonatomic) IBOutlet UILabel *labelPreview;
@property (weak, nonatomic) IBOutlet UILabel *saturationLabel;
@property (weak, nonatomic) IBOutlet UILabel *luminosityLabel;
@property (weak, nonatomic) IBOutlet UILabel *hueLabel;
@property (weak, nonatomic) IBOutlet UIButton *doneButton;

@property (weak, nonatomic) IBOutlet UIView *centeredView;


- (IBAction)buttonPressMaxMin:(id)sender;


@end
