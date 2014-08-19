unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, ExtCtrls, StdCtrls, ComCtrls, ExtDlgs, Buttons,
  ImgList, Spin;

type
  TForm1 = class(TForm)
    StatusBar1: TStatusBar;
    GroupBox1: TGroupBox;
    RadioGroup1: TRadioGroup;
    Plik1: TMenuItem;
    Zako1: TMenuItem;
    MainMenu1: TMainMenu;
    GroupBox2: TGroupBox;
    Label1: TLabel;
    Edit1: TEdit;
    SpeedButton1: TSpeedButton;
    OpenPictureDialog1: TOpenPictureDialog;
    PaintBox1: TPaintBox;
    Label2: TLabel;
    Shape1: TShape;
    Label3: TLabel;
    Shape2: TShape;
    SpeedButton2: TSpeedButton;
    SpeedButton3: TSpeedButton;
    ColorDialog1: TColorDialog;
    ImageList1: TImageList;
    SpinEdit1: TSpinEdit;
    Label4: TLabel;
    Button1: TButton;
    procedure Zako1Click(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure PaintBox1Paint(Sender: TObject);
    procedure PaintBox1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure SpeedButton2Click(Sender: TObject);
    procedure SpeedButton3Click(Sender: TObject);
    procedure SpinEdit1Change(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
  private
    { Private declarations }
    bitmap:TBitmap;
    simulation_speed:integer;
    end_simulation:boolean;
  public
    { Public declarations }
    procedure floodfill1(c:TCanvas; width:integer; height:integer; x:integer; y:integer; base_color:TColor; replace_with:TColor);
    procedure floodfill2(c:TCanvas; width:integer; height:integer; x:integer; y:integer; base_color:TColor; replace_with:TColor);
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.floodfill1(c:TCanvas; width:integer; height:integer; x:integer; y:integer; base_color:TColor; replace_with:TColor);
begin
  if end_simulation then exit;
  if c.Pixels[x, y] <> base_color then exit;
  if c.Pixels[x, y] = replace_with then exit;
  c.Pixels[x, y] := replace_with;
  bitmap.Canvas.Pixels[x, y] := replace_with;
  sleep(simulation_speed);
  Application.ProcessMessages;
  if x-1 >= 0 then
    floodfill1(c, width, height, x-1, y, base_color, replace_with);
  if width >= x+1 then
    floodfill1(c, width, height, x+1, y, base_color, replace_with);
  if y-1 >= 0 then
    floodfill1(c, width, height, x, y-1, base_color, replace_with);
  if height >= y+1 then
    floodfill1(c, width, height, x, y+1, base_color, replace_with);
end;

procedure TForm1.floodfill2(c:TCanvas; width:integer; height:integer; x:integer; y:integer; base_color:TColor; replace_with:TColor);
begin
  if end_simulation then exit;
  if c.Pixels[x, y] <> base_color then exit;
  if c.Pixels[x, y] = replace_with then exit;
  c.Pixels[x, y] := replace_with;
  bitmap.Canvas.Pixels[x, y] := replace_with;
  sleep(simulation_speed);
  Application.ProcessMessages;
  if x-1 >= 0 then
    floodfill2(c, width, height, x-1, y, base_color, replace_with);
  if (x-1 >= 0) and (y-1 >= 0) then
    floodfill2(c, width, height, x-1, y-1, base_color, replace_with);
  if y-1 >= 0 then
    floodfill2(c, width, height, x, y-1, base_color, replace_with);
  if (y-1 >= 0) and (x+1 <= width) then
    floodfill2(c, width, height, x+1, y-1, base_color, replace_with);
  if width >= x+1 then
    floodfill2(c, width, height, x+1, y, base_color, replace_with);
  if (width >= x+1) and (height >= y+1) then
    floodfill2(c, width, height, x+1, y+1, base_color, replace_with);
  if height >= y+1 then
    floodfill2(c, width, height, x, y+1, base_color, replace_with);
  if (height >= y+1) and (x-1 >= 0) then
    floodfill2(c, width, height, x-1, y+1, base_color, replace_with);
end;

procedure TForm1.Zako1Click(Sender: TObject);
begin
  Close();
end;

procedure TForm1.SpeedButton1Click(Sender: TObject);
var
  f:string;
begin
  if OpenPictureDialog1.Execute then
  begin
    f := OpenPictureDialog1.FileName;
    bitmap.LoadFromFile(f);
    bitmap.Width := PaintBox1.ClientWidth;
    bitmap.Height := PaintBox1.ClientHeight;
    Edit1.Text := f;
    PaintBox1.Invalidate;
  end;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  bitmap := TBitmap.Create;
  ImageList1.GetBitmap(0, bitmap);
  bitmap.Width := PaintBox1.ClientWidth;
  bitmap.Height := PaintBox1.ClientHeight;
  simulation_speed := SpinEdit1.Value;
  end_simulation := false;
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  bitmap.Free;
end;

procedure TForm1.PaintBox1Paint(Sender: TObject);
begin
  PaintBox1.Canvas.Brush.Color := clBlack;
  PaintBox1.Canvas.Rectangle(PaintBox1.ClientRect);
  PaintBox1.Canvas.Draw(0, 0, bitmap);
end;

procedure TForm1.PaintBox1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  //rozpocznij wypelnianie
  end_simulation := false;
  case RadioGroup1.ItemIndex of
    0:floodfill1(PaintBox1.Canvas, PaintBox1.ClientWidth, PaintBox1.ClientHeight, X, Y, Shape1.Brush.Color, Shape2.Brush.Color);
    1:floodfill2(PaintBox1.Canvas, PaintBox1.ClientWidth, PaintBox1.ClientHeight, X, Y, Shape1.Brush.Color, Shape2.Brush.Color);
  end;
end;

procedure TForm1.SpeedButton2Click(Sender: TObject);
begin
  if ColorDialog1.Execute then
  begin
    Shape1.Brush.Color := ColorDialog1.Color;
  end;
end;

procedure TForm1.SpeedButton3Click(Sender: TObject);
begin
  if ColorDialog1.Execute then
  begin
    Shape2.Brush.Color := ColorDialog1.Color;
  end;
end;

procedure TForm1.SpinEdit1Change(Sender: TObject);
begin
  simulation_speed := SpinEdit1.Value;
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  end_simulation := true;
end;

procedure TForm1.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  end_simulation := true;
end;

end.
