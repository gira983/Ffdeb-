#include "LoadView/Includes.h"
#import "LoadView/DTTJailbreakDetection.h"
#import "imgui/Il2cpp.h"
#import "Utils/Macros.h"
#import "Utils/hack/Function.h"
#import "Utils/Mem.h"
#include "font.h"
#include "hook/hook.h"
#import "Other/Vector/Vector3.h"
#import "Other/Vector/Vector2.h"
#import "Other/Vector/Quaternion.h"
#import "Other/Vector/Monostring.h"
#include "Other/Icon.h"
#include "Other/iconcpp.h"
ImFont *_espFont;
#import "Esp.h"
#include "Other/AimKill.cpp"
#include "hook/hook.h"

#define UIColorFromHex(hexColor) [UIColor colorWithRed:((float)((hexColor & 0xFF0000) >> 16))/255.0 green:((float)((hexColor & 0xFF00) >> 8))/255.0 blue:((float)(hexColor & 0xFF))/255.0 alpha:1.0]




using namespace IL2Cpp;
@interface ImGuiDrawView () <MTKViewDelegate>
@property (nonatomic, strong) id <MTLDevice> device;
@property (nonatomic, strong) id <MTLCommandQueue> commandQueue;
@end

UIView *view;
NSString *jail;
NSString *namedv;
NSString *deviceType;
NSString *bundle;
NSString *ver;


UILabel *menuTitle;   

@implementation ImGuiDrawView
bool Guest;
bool Telecar, Telekill;
bool ResetGuest(void *instance){
    if (Guest) return true; Guest = false;
}

bool isFov(Vector3 vec1, Vector3 vec2, int radius) {
    int x = vec1.x;
    int y = vec1.y;

    int x0 = vec2.x;
    int y0 = vec2.y;
    if ((pow(x - x0, 2) + pow(y - y0, 2) ) <= pow(radius, 2)) {
        return true;
    } else {
        return false;
    }
}

void *GetClosestEnemy(void *match) {
    if (!match) {
        return nullptr;
    }
    float shortestDistance = 99999.0f;
    float maxAngle = AimFov;
    void *ClosestEnemy = NULL;
    void *LocalPlayer = GetLocalPlayer(match);
    if (LocalPlayer != nullptr) {
        Dictionary<uint8_t *, void **> *players = *(Dictionary<uint8_t*, void **> **)((long)match + 0x90);
        for(int u = 0; u < players->getNumValues(); u++) {
            void *Player = players->getValues()[u];
            if (Player != NULL && !get_isLocalTeam(Player) && !get_IsDieing(Player) && get_isVisible(Player) && get_MaxHP(Player) && !IsPlayerDead(Player)) {
                Vector3 PlayerPos = GetHipPosition(Player);
                Vector3 LocalPlayerPos = GetHeadPosition(LocalPlayer);
				if (aimStart) {
				if (AimWhen == 1) {
                    Vector3 targetDir = Vector3::Normalized(PlayerPos - LocalPlayerPos);
                    float angle = Vector3::Angle(targetDir, GetForward(Component_GetTransform(Camera_main())))  *100.0;
                    if (angle <= maxAngle) {
						if (IsVisible(Player)) {
                        if (angle < shortestDistance) {
                            shortestDistance = angle;
                            ClosestEnemy = Player;
                            }
                        }
                    }
                } else if (AimWhen == 0) {
                    Vector3 targetDir = Vector3::Normalized(PlayerPos - LocalPlayerPos);
                    float angle = Vector3::Angle(targetDir, GetForward(Component_GetTransform(Camera_main())))  *100.0;
                    if (angle <= maxAngle) {
if (IsVisible(Player)) {
                        if (angle < shortestDistance) {
                            shortestDistance = angle;
                            ClosestEnemy = Player;
						      }
}
							}
							
							}
                        }
                    }
                }
            }
    return ClosestEnemy;
}
void _LateUpdate(void *player) {
  if (player != NULL) {
      void *Match = CurentMatch();
      if (Match != NULL) {
         void *LocalPlayer = GetLocalPlayer(Match);                        
         if (LocalPlayer != NULL) {
             void *ClosestEnemy = GetClosestEnemy(Match);
             if (ClosestEnemy != NULL) {
                                              
tS++;
       if (tS > 1 && autotroca) {
         sID = !sID;
         SwapWeapon(LocalPlayer, sID, true);
           tS = 0;
            }
                 Vector3 EnemyLocation = GetHeadPosition(ClosestEnemy);
                 Vector3 PlayerLocation = CameraMain(LocalPlayer);
                 Quaternion PlayerLook = GetRotationToLocation(EnemyLocation, 0.1f, PlayerLocation);                  
                 
                 Vector3 LocalPlayerPos = GetHeadPosition(LocalPlayer);
                 Vector3 PlayerHeadPos = GetHeadPosition(ClosestEnemy);
                 float distance = Vector3::Distance(LocalPlayerPos, PlayerHeadPos);
            
                 if (AimScope && get_IsSighting(LocalPlayer)) {
                     set_aim(LocalPlayer, PlayerLook);
                 }
                 if (AimFire && get_IsFiring(LocalPlayer)) {
                     set_aim(LocalPlayer, PlayerLook);
                 }
				 
                 if (AimKill) {
                     PlayerTakeDamage(ClosestEnemy);
                 }	
if (Telekill) {
                    void *_MountTF = Component_GetTransform(ClosestEnemy);
                    if (_MountTF != NULL) {
                        Vector3 MountTF =Transform_INTERNAL_GetPosition(_MountTF) -(GetForward(_MountTF) * 0.0f);
                        Transform_INTERNAL_SetPosition(Component_GetTransform(LocalPlayer),Vvector3(MountTF.x+1.4f, MountTF.y + 1.4f, MountTF.z+1.4f));
                    }
                }
             }
         } 
      }
  }
}


void (*Update)(void* gamestartup);
void _Update(void* gamestartup) {
if(Update) {
void* Match = CurentMatch();
if((AimFire || AimScope || AimKill) && Match) {
}
}
}

ImFont *_iconFont;

static bool MenDeal = false;
static bool StreamerMode = false;
static bool hidetoplabel = false;

- (instancetype)initWithNibName:(nullable NSString *)nibNameOrNil bundle:(nullable NSBundle *)nibBundleOrNil
{

    [self cc];

    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];

    _device = MTLCreateSystemDefaultDevice();
    _commandQueue = [_device newCommandQueue];
menuTitle = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 200, 50)];
	menuTitle.text = [NSString stringWithUTF8String:oxorany("")];
	menuTitle.textColor = UIColorFromHex(0x72FF13);
	menuTitle.font = [UIFont fontWithName:[NSString stringWithUTF8String:oxorany("AppleSDGothicNeo-Light")] size:19.0f];
	menuTitle.textAlignment = NSTextAlignmentCenter;
	[menuTitle sizeToFit]; //make container the same size as the resulting text
    UIWindow *mainWindow = [UIApplication sharedApplication].keyWindow;
	menuTitle.center = CGPointMake(CGRectGetMidX(mainWindow.bounds), 20);
	menuTitle.adjustsFontSizeToFitWidth = true;
    [mainWindow addSubview: menuTitle];


    if (!self.device) abort();

    IMGUI_CHECKVERSION();
    ImGui::CreateContext();
    ImGuiIO& io = ImGui::GetIO();

    ImGui::StyleColorsDark();
    NSString *FontPath = @"/System/Library/Fonts/AppFonts/AppleGothic.otf";
    static const ImWchar icons_ranges[] = { 0xf000, 0xf3ff, 0 };
    ImFontConfig icons_config;

    ImFontConfig CustomFont;
    CustomFont.FontDataOwnedByAtlas = false;

 
    icons_config.MergeMode = true;
    icons_config.PixelSnapH = true;

    io.Fonts->AddFontFromMemoryTTF(const_cast<std::uint8_t*>(Custom), sizeof(Custom), 21.f, &CustomFont);
    _espFont=io.Fonts->AddFontFromMemoryCompressedTTF(font_awesome_data, font_awesome_size, 19.0f, &icons_config, icons_ranges);
    io.Fonts->AddFontDefault();
    ImGui_ImplMetal_Init(_device);
    return self;
}

+ (void)showChange:(BOOL)open
{
    MenDeal = open;
}

+ (BOOL)isMenuShowing {
    return MenDeal;
}

- (MTKView *)mtkView
{
    return (MTKView *)self.view;
}

-(void)cc
{

ver = [[[NSBundle mainBundle] infoDictionary] objectForKey:nssoxorany("CFBundleShortVersionString")];

bundle = [[NSBundle mainBundle] bundleIdentifier];

namedv = [[UIDevice currentDevice] name];
deviceType = [[UIDevice currentDevice] model];

if ([DTTJailbreakDetection isJailbroken]) {
jail = nssoxorany("Jailbroken");

}else{
jail = nssoxorany("Not Jailbroken Or Hidden Jailbreak");

}
}

- (void)loadView
{
    CGFloat w = [UIApplication sharedApplication].windows[0].rootViewController.view.frame.size.width;
    CGFloat h = [UIApplication sharedApplication].windows[0].rootViewController.view.frame.size.height;
    self.view = [[MTKView alloc] initWithFrame:CGRectMake(0, 0, w, h)];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.mtkView.device = self.device;
    if (!self.mtkView.device) {
        return;
    }
    self.mtkView.delegate = self;
    self.mtkView.clearColor = MTLClearColorMake(0, 0, 0, 0);
    self.mtkView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    self.mtkView.clipsToBounds = YES;



}

- (void)drawInMTKView:(MTKView*)view
{

    hideRecordTextfield.secureTextEntry = StreamerMode;

    ImGuiIO& io = ImGui::GetIO();
    io.DisplaySize.x = view.bounds.size.width;
    io.DisplaySize.y = view.bounds.size.height;

    CGFloat framebufferScale = view.window.screen.nativeScale ?: UIScreen.mainScreen.nativeScale;
    io.DisplayFramebufferScale = ImVec2(framebufferScale, framebufferScale);
    io.DeltaTime = 1 / float(view.preferredFramesPerSecond ?: 60);
    
    id<MTLCommandBuffer> commandBuffer = [self.commandQueue commandBuffer];
        
        if (MenDeal == true) 
        {
            [self.view setUserInteractionEnabled:YES];
            [self.view.superview setUserInteractionEnabled:YES];
            [menuTouchView setUserInteractionEnabled:YES];
        } 
        else if (MenDeal == false) 
        {
           
            [self.view setUserInteractionEnabled:NO];
            [self.view.superview setUserInteractionEnabled:NO];
            [menuTouchView setUserInteractionEnabled:NO];

        }

Attach();

        MTLRenderPassDescriptor* renderPassDescriptor = view.currentRenderPassDescriptor;
        if (renderPassDescriptor != nil)
        {
            id <MTLRenderCommandEncoder> renderEncoder = [commandBuffer renderCommandEncoderWithDescriptor:renderPassDescriptor];
            [renderEncoder pushDebugGroup:nssoxorany("ImGui Jane")];

            ImGui_ImplMetal_NewFrame(renderPassDescriptor);
            ImGui::NewFrame();

            ImFont* font = ImGui::GetFont();
    font->Scale = 16.f / font->FontSize;
    CGFloat x = (([UIApplication sharedApplication].windows[0].rootViewController.view.frame.size.width) - 380) / 2;
    CGFloat y = (([UIApplication sharedApplication].windows[0].rootViewController.view.frame.size.height) - 260) / 2;
    ImGui::SetNextWindowPos(ImVec2(x, y), ImGuiCond_FirstUseEver);



            
   if (MenDeal == true) {

   char* Gnam = (char*) [[NSString stringWithFormat:nssoxorany("Fryzz IOS PANEL 1.118.X "), ver] cStringUsingEncoding:NSUTF8StringEncoding];

   ImGui::SetNextWindowPos(ImVec2(x, y), ImGuiCond_FirstUseEver);
   ImGui::SetNextWindowSize(ImVec2(780.0f, 500.0f), ImGuiCond_FirstUseEver);

   ImGui::PushStyleVar(ImGuiStyleVar_WindowPadding, ImVec2(14.0f, 12.0f));
   ImGui::PushStyleVar(ImGuiStyleVar_WindowRounding, 10.0f);
   ImGui::PushStyleVar(ImGuiStyleVar_FramePadding, ImVec2(8.0f, 6.0f));
   ImGui::PushStyleVar(ImGuiStyleVar_FrameRounding, 5.0f);
   ImGui::PushStyleVar(ImGuiStyleVar_ChildRounding, 8.0f);
   ImGui::PushStyleVar(ImGuiStyleVar_ItemSpacing, ImVec2(10.0f, 7.0f));

   ImGui::Begin(Gnam, &MenDeal, ImGuiWindowFlags_NoCollapse | ImGuiWindowFlags_NoResize | ImGuiWindowFlags_NoScrollbar);
        ImGui::PushItemWidth(ImGui::GetWindowWidth() * 0.55f);

        ImGui::PushStyleColor(ImGuiCol_WindowBg, ImVec4(0.06f, 0.08f, 0.11f, 1.00f));
        ImGui::PushStyleColor(ImGuiCol_FrameBg, ImVec4(0.15f, 0.19f, 0.24f, 1.00f));
        ImGui::PushStyleColor(ImGuiCol_FrameBgHovered, ImVec4(0.23f, 0.33f, 0.41f, 1.00f));
        ImGui::PushStyleColor(ImGuiCol_FrameBgActive, ImVec4(0.18f, 0.35f, 0.50f, 1.00f));
        ImGui::PushStyleColor(ImGuiCol_TitleBgActive, ImVec4(0.11f, 0.76f, 0.70f, 1.00f));
        ImGui::PushStyleColor(ImGuiCol_Border, ImVec4(0.22f, 0.90f, 0.84f, 0.45f));
        ImGui::PushStyleColor(ImGuiCol_Text, ImVec4(0.90f, 0.94f, 0.96f, 1.00f));
        ImGui::PushStyleColor(ImGuiCol_TextDisabled, ImVec4(0.62f, 0.69f, 0.74f, 1.00f));
        ImGui::PushStyleColor(ImGuiCol_Separator, ImVec4(0.23f, 0.90f, 0.83f, 0.45f));
        ImGui::PushStyleColor(ImGuiCol_Button, ImVec4(0.10f, 0.56f, 0.53f, 0.75f));
        ImGui::PushStyleColor(ImGuiCol_ButtonHovered, ImVec4(0.18f, 0.76f, 0.71f, 0.95f));
        ImGui::PushStyleColor(ImGuiCol_ButtonActive, ImVec4(0.30f, 0.88f, 0.78f, 1.00f));
        ImGui::PushStyleColor(ImGuiCol_Tab, ImVec4(0.12f, 0.14f, 0.20f, 1.00f));
        ImGui::PushStyleColor(ImGuiCol_TabHovered, ImVec4(0.12f, 0.76f, 0.71f, 0.72f));
        ImGui::PushStyleColor(ImGuiCol_TabActive, ImVec4(0.11f, 0.76f, 0.70f, 1.00f));
        ImGui::PushStyleColor(ImGuiCol_TabUnfocused, ImVec4(0.12f, 0.13f, 0.19f, 1.00f));
        ImGui::PushStyleColor(ImGuiCol_TabUnfocusedActive, ImVec4(0.12f, 0.67f, 0.63f, 1.00f));
        ImGui::PushStyleColor(ImGuiCol_ChildBg, ImVec4(0.10f, 0.12f, 0.15f, 0.88f));
        ImGui::PushStyleColor(ImGuiCol_Header, ImVec4(0.13f, 0.76f, 0.70f, 0.65f));
        ImGui::PushStyleColor(ImGuiCol_HeaderHovered, ImVec4(0.14f, 0.86f, 0.79f, 0.95f));
        ImGui::PushStyleColor(ImGuiCol_HeaderActive, ImVec4(0.30f, 0.88f, 0.78f, 1.00f));

        ImGui::Spacing();
        ImGui::TextColored(ImVec4(0.34f, 0.95f, 0.80f, 1.00f), oxorany("// FRYZZ CONTROL"));
        ImGui::SameLine(ImGui::GetWindowWidth() - 210.0f);
        ImGui::TextDisabled(oxorany("ONLINE"));
        ImGui::Separator();

        ImGui::BeginTabBar(oxorany("Bar"), ImGuiTabBarFlags_NoTooltip);

        if (ImGui::BeginTabItem(oxorany(ICON_FA_CROSSHAIRS " Aimbot"))) {
            ImGui::BeginChild(oxorany("AimbotCard"), ImVec2(0.0f, 0.0f), true, ImGuiWindowFlags_NoScrollbar);

            ImGui::TextColored(ImVec4(0.34f, 0.95f, 0.80f, 1.00f), oxorany("Combat Systems"));
            ImGui::Separator();
            ImGui::Spacing();

            ImGui::Checkbox(oxorany("Enable Aimbot"), &aimStart);
            ImGui::Indent();
            ImGui::Checkbox(oxorany("AimFire"), &AimFire);
            ImGui::Checkbox(oxorany("AimScope"), &AimScope);
            ImGui::Unindent();

            ImGui::Spacing();
            ImGui::Separator();
            ImGui::Text(oxorany("Aim Fov"));
            ImGui::SliderFloat(oxorany("##circle"), &AimFov, 0.0f, 360.0f);

            ImGui::Combo(oxorany("Aim Trigger"), &AimWhen, "Always\0Firing\0Aiming\0");
            ImGui::Spacing();
            ImGui::EndChild();
            ImGui::EndTabItem();
        }

        if (ImGui::BeginTabItem(oxorany(ICON_FA_EYE " Visuals"))){
            ImGui::BeginChild(oxorany("VisualsCard"), ImVec2(0.0f, 0.0f), true, ImGuiWindowFlags_NoScrollbar);
            ImGui::TextColored(ImVec4(0.34f, 0.95f, 0.80f, 1.00f), oxorany("ESP Systems"));
            ImGui::Separator();
            ImGui::Spacing();
            ImGui::Checkbox(oxorany("Enable Esp"), &ESPEnable);
            ImGui::Separator();
            ImGui::Checkbox(oxorany("Esp - Lines"), &ESPLine);
            ImGui::Checkbox(oxorany("Esp - Boxes"), &ESPBox);
            ImGui::Checkbox(oxorany("Esp - Name"), &ESPName);
            ImGui::Checkbox(oxorany("Esp - Health"), &ESPHealth);
            ImGui::Spacing();
            ImGui::EndChild();
            ImGui::EndTabItem();
        }

        if (ImGui::BeginTabItem(oxorany(ICON_FA_COGS " Settings"))){
            ImGui::BeginChild(oxorany("SettingsCard"), ImVec2(0.0f, 0.0f), true, ImGuiWindowFlags_NoScrollbar);
            ImGui::TextColored(ImVec4(0.34f, 0.95f, 0.80f, 1.00f), oxorany("Control Room"));
            ImGui::Separator();
            ImGui::Spacing();
            ImGui::Checkbox(oxorany("Stream Mode"), &StreamerMode);
            ImGui::Checkbox(oxorany("Hide Top Label"), &hidetoplabel);

            ImGui::Spacing();
            ImGui::ColorEdit3(oxorany("Color Esp"), &*(float*)colorEsp, ImGuiColorEditFlags_NoInputs);
            ImGui::Spacing();
            if (ImGui::Combo(oxorany("Color Menu"), &style_idx, "Dark\0Light\0Classic\0")) {
                switch (style_idx)
                {
                    case 0: ImGui::StyleColorsDark(); break;
                    case 1: ImGui::StyleColorsLight(); break;
                    case 2: ImGui::StyleColorsClassic(); break;
                }
            }
            ImGui::Spacing();
            ImGui::EndChild();
            ImGui::EndTabItem();
        }

        if (ImGui::BeginTabItem(oxorany(" More"))) {
            ImGui::BeginChild(oxorany("MoreCard"), ImVec2(0.0f, 0.0f), true, ImGuiWindowFlags_NoScrollbar);
            ImGui::TextColored(ImVec4(0.34f, 0.95f, 0.80f, 1.00f), oxorany("Advanced Ops"));
            ImGui::Separator();
            ImGui::Spacing();
            if(ImGui::Button(oxorany("Reset Guest"))) { Guest = true; }
            ImGui::SameLine();
            ImGui::Checkbox(oxorany("Telekill Enemy"), &Telekill);
            ImGui::Spacing();
            ImGui::EndChild();
            ImGui::EndTabItem();
        }

        if (ImGui::BeginTabItem(oxorany(ICON_FA_ADDRESS_CARD " Info"))) {
            ImGui::BeginChild(oxorany("InfoCard"), ImVec2(0.0f, 0.0f), true, ImGuiWindowFlags_NoScrollbar);
            ImGui::SeparatorText(oxorany("Contact US"));
            ImGui::TextDisabled(oxorany("Developer:"));
            ImGui::SameLine();
            ImGui::TextLinkOpenURL(oxorany("Fryzz"), oxorany("https://t.me/g1reev7"));
            ImGui::TextDisabled(oxorany("CHANNEL:"));
            ImGui::SameLine();
            ImGui::TextLinkOpenURL(oxorany("MY CHANNEL"), oxorany("Channel Deleted"));
            ImGui::SameLine();
            ImGui::TextLinkOpenURL(oxorany("MY Chat"), oxorany("Chat Deleted"));
            ImGui::Spacing();
            ImGui::EndChild();
            ImGui::EndTabItem();
        }

        ImGui::EndTabBar();

        ImGui::Spacing();
        ImGui::Separator();
        ImGui::Spacing();

        ImGui::PopStyleColor(11);
        ImGui::PopStyleVar(6);
        ImGui::End();
}
DrawEsp();
if(hidetoplabel) {
        menuTitle.hidden = YES;
    } else {
         menuTitle.hidden = NO;
    }

auto Draw = ImGui::GetBackgroundDrawList();
    if (enable_circleFov)
    {
         Draw->AddCircle(ImVec2(kWidth/2, kHeight/2), circleSizeValue, IM_COL32(255, 0, 0, 255), 100, 1.0f);
    }
            ImGui::Render();
            ImDrawData* draw_data = ImGui::GetDrawData();
            ImGui_ImplMetal_RenderDrawData(draw_data, commandBuffer, renderEncoder);

            [renderEncoder popDebugGroup];
            [renderEncoder endEncoding];

            [commandBuffer presentDrawable:view.currentDrawable];
            
        }
        [commandBuffer commit];
}

- (void)mtkView:(MTKView*)view drawableSizeWillChange:(CGSize)size
{
    
}

- (void)updateIOWithTouchEvent:(UIEvent *)event
{
    UITouch *anyTouch = event.allTouches.anyObject;
    CGPoint touchLocation = [anyTouch locationInView:self.view];
    ImGuiIO &io = ImGui::GetIO();
    io.MousePos = ImVec2(touchLocation.x, touchLocation.y);

    BOOL hasActiveTouch = NO;
    for (UITouch *touch in event.allTouches)
    {
        if (touch.phase != UITouchPhaseEnded && touch.phase != UITouchPhaseCancelled)
        {
            hasActiveTouch = YES;
            break;
        }
    }
    io.MouseDown[0] = hasActiveTouch;
}

ImDrawList* getDrawList(){
    ImDrawList *drawList;
    drawList = ImGui::GetBackgroundDrawList();
    return drawList;
};
void hooking() {
void* address[] = {
        (void*)getRealOffset(ENCRYPTOFFSET("0x19E894")), 
                (void*)getRealOffset(ENCRYPTOFFSET("0x3E212F8")),

(void*)getRealOffset(ENCRYPTOFFSET("0x157FDCC")),

(void*)getRealOffset(ENCRYPTOFFSET("0x5ADBE00")),


    };
    void* function[] = {
        (void*)_LateUpdate,
        (void*)ResetGuest,
        (void*)DamageInfoHook,
        (void*)_Update
       
    };
    hook(address, function, 4);


get_transform = (void *(*)(void *))getRealOffset(ENCRYPTOFFSET("0x5850A8C")); 
  
get_transformFF = (void *(*)(void *)) getRealOffset(ENCRYPTOFFSET("0x5850A8C"));

get_position = (Vector3 (*)(void*)) getRealOffset(ENCRYPTOFFSET("0x5899A80"));

get_camera = (void *(*)()) getRealOffset(ENCRYPTOFFSET("0x584E620"));

worldToScreen = (Vector3 (*)(void *, Vector3)) getRealOffset(ENCRYPTOFFSET("0x584DF28"));

WorldToViewpoint = (Vector3 (*)(void *, Vector3, int ))getRealOffset(ENCRYPTOFFSET("0x584DF68"));


}

void *hack_thread(void *) {

    sleep(5);
    hooking();
    pthread_exit(nullptr);
    return nullptr;
}

void __attribute__((constructor)) initialize() {
    pthread_t hacks;
    pthread_create(&hacks, NULL, hack_thread, NULL); 
}

@end