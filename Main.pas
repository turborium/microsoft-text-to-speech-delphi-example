// CrazzzyPeter aka TurboPeter
// MIT LICENSE
unit Main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.UITypes, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, Bass;

type
  TFormMain = class(TForm)
    MemoText: TMemo;
    LabelMemoTitle: TLabel;
    ButtonPlaySpeech: TButton;
    ButtonSaveSpeech: TButton;
    LabelTokenTitle: TLabel;
    EditKey: TEdit;
    LabelKeyTitle: TLabel;
    EditToken: TEdit;
    EditRegion: TEdit;
    LabelRegionTitle: TLabel;
    PanelBottom: TGridPanel;
    PanelButtons: TPanel;
    FileSaveDialog: TFileSaveDialog;
    procedure ButtonSaveSpeechClick(Sender: TObject);
    procedure ButtonPlaySpeechClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    BassStream: HSTREAM;
    MemoryMP3Stream: TMemoryStream;
    function MakeMP3Stream(): TMemoryStream;
    procedure BeginPlay(const Stream: TMemoryStream);
    procedure EndPlay();
    function IsPlay(): Boolean;
  public
  end;

var
  FormMain: TFormMain;

implementation

{$R *.dfm}

uses
  System.Net.HttpClient, System.Net.URLClient, System.NetEncoding;

// normal code below

function GetToken(const Region, Key: string): string;
var
  Client: THTTPClient;
  Response: IHTTPResponse;
begin
  Client :=  THTTPClient.Create();
  try
    Client.CustomHeaders['Ocp-Apim-Subscription-Key'] := Key;
    Response := Client.Post('https://'+ Region +'.api.cognitive.microsoft.com/sts/v1.0/issueToken', TStream(nil));
    if Response.StatusCode <> 200 then
      raise Exception.Create(Format('Can''t get token: %d: "%s"', [Response.StatusCode, Response.StatusText]));
    Exit(Response.ContentAsString());
  finally
    Client.Free();
  end;
end;

function MakeSpeechMP3Stream(const Region, SubsriptionKey, Token: string; const Text: string): TMemoryStream;
var
  Client: THTTPClient;
  Stream: TStringStream;
  Response: IHTTPResponse;
begin
  Client :=  THTTPClient.Create();
  try
    if Token <> '' then
      Client.CustomHeaders['Authorization'] := 'Bearer ' + Token
    else
      Client.CustomHeaders['Ocp-Apim-Subscription-Key'] := SubsriptionKey;
    Client.CustomHeaders['Content-Type'] := 'application/ssml+xml';
    Client.CustomHeaders['X-Microsoft-OutputFormat'] := 'audio-16khz-128kbitrate-mono-mp3';
    Client.CustomHeaders['User-Agent'] := 'DelphiClient';

    Stream := TStringStream.Create(
      '<speak version=''1.0'' xml:lang=''en-US''>' +
        '<voice xml:lang=''ru-RU'' name=''ru-RU-SvetlanaNeural''>' +
          TNetEncoding.HTML.Encode(Text) +
        '</voice>' +
      '</speak>',
      TEncoding.UTF8,
      False
    );
    try
      Response := Client.Post('https://'+ Region +'.tts.speech.microsoft.com/cognitiveservices/v1', Stream);

      if Response.StatusCode <> 200 then
        raise Exception.Create(Format('TextToSpeechMP3 error: %d: "%s"', [Response.StatusCode, Response.StatusText]));

      Result := TMemoryStream.Create();
      Result.CopyFrom(Response.ContentStream);
    finally
      Stream.Free();
    end;
  finally
    Client.Free();
  end;
end;

// bad code below

procedure BassEnd(handle: HDSP; channel: DWORD; buffer: Pointer; user: Pointer); stdcall;
begin
  TFormMain(user).EndPlay();
end;

procedure TFormMain.BeginPlay(const Stream: TMemoryStream);
begin
  EndPlay();

  try
    MemoryMP3Stream := Stream;
    BassStream := BASS_StreamCreateFile(True, Stream.Memory, 0, Stream.Size, 0);

    if BassStream = 0 then
      raise Exception.Create('Error: BASS_StreamCreateFile');

    if BASS_ChannelSetSync(BassStream, BASS_SYNC_END, 0, @BassEnd, Self) = 0 then
      raise Exception.Create('Error: BASS_ChannelSetSync');

    if not BASS_ChannelPlay(BassStream, False) then
      raise Exception.Create('Error: BASS_ChannelPlay');

    ButtonPlaySpeech.Caption := 'Stop';
    ButtonSaveSpeech.Enabled := False;
    EditKey.Enabled := False;
    EditToken.Enabled := False;
    EditRegion.Enabled := False;
    MemoText.Enabled := False;
  except
    EndPlay();
    raise;
  end;
end;

procedure TFormMain.EndPlay();
begin
  if BassStream <> 0 then
  begin
    BASS_ChannelFree(BassStream);
    BassStream := 0;
  end;

  if MemoryMP3Stream <> nil then
  begin
    MemoryMP3Stream.Free();
    MemoryMP3Stream := nil;
  end;

  ButtonPlaySpeech.Caption := 'Play';
  ButtonSaveSpeech.Enabled := True;
  EditKey.Enabled := True;
  EditToken.Enabled := True;
  EditRegion.Enabled := True;
  MemoText.Enabled := True;
end;

procedure TFormMain.FormCreate(Sender: TObject);
begin
  if not BASS_Init(-1, 44100, 0, 0, nil) then
    raise Exception.Create('Error: BASS_Init');

  EndPlay();
end;

procedure TFormMain.FormDestroy(Sender: TObject);
begin
  EndPlay();
  BASS_Free();
end;

function TFormMain.IsPlay(): Boolean;
begin
  Result := MemoryMP3Stream <> nil;
end;

procedure TFormMain.ButtonPlaySpeechClick(Sender: TObject);
var
  Stream: TMemoryStream;
begin
  if IsPlay() then
    EndPlay()
  else
  begin
    Stream := MakeMP3Stream();
    if Stream = nil then
      Exit;
    BeginPlay(Stream);
  end;
end;

procedure TFormMain.ButtonSaveSpeechClick(Sender: TObject);
var
  Stream: TMemoryStream;
begin
  Stream := MakeMP3Stream();
  try
    if Stream = nil then
      Exit;
    if not FileSaveDialog.Execute() then
      Exit;
    try
      Stream.SaveToFile(FileSaveDialog.FileName);
    except
      on E: Exception do
      begin
        MessageDlg('Problem with save mp3 file!'+#13+E.Message, TMsgDlgType.mtError, [TMsgDlgBtn.mbOK], 0);
        Exit;
      end;
    end;
  finally
    Stream.Free();
  end;
end;

function TFormMain.MakeMP3Stream(): TMemoryStream;
var
  OldCursor: TCursor;
begin
  Result := nil;

  OldCursor := Screen.Cursor;
  try
    Screen.Cursor := crHourGlass;

    if EditRegion.Text = '' then
    begin
      MessageDlg('Region needed!', TMsgDlgType.mtInformation, [TMsgDlgBtn.mbOK], 0);
      EditRegion.SetFocus();
      Exit;
    end;

    if (EditKey.Text = '') and (EditToken.Text = '') then
    begin
      MessageDlg('Key or Token needed!', TMsgDlgType.mtInformation, [TMsgDlgBtn.mbOK], 0);
      EditKey.SetFocus();
      Exit;
    end;

    if Length(MemoText.Text) > 1000 then
    begin
      MessageDlg('Too long text!', TMsgDlgType.mtInformation, [TMsgDlgBtn.mbOK], 0);
      MemoText.SetFocus();
      Exit;
    end;

    // try gen token
    if EditKey.Text <> '' then
    begin
      try
        EditToken.Text := GetToken(EditRegion.Text, EditKey.Text);
      except
        on E: Exception do
        begin
          MessageDlg('Problem with token generation!'+#13+E.Message, TMsgDlgType.mtError, [TMsgDlgBtn.mbOK], 0);
          Exit;
        end;
      end;
    end;

    // try gen mp3
    try
      Result := MakeSpeechMP3Stream(EditRegion.Text, EditKey.Text, EditToken.Text, MemoText.Text);
    except
      on E: Exception do
      begin
        MessageDlg('Problem with mp3 generation!'+#13+E.Message, TMsgDlgType.mtError, [TMsgDlgBtn.mbOK], 0);
        Exit;
      end;
    end;
  finally
    Screen.Cursor := OldCursor;
  end;
end;

end.
