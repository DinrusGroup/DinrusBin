module derelict.sdl.sdlsprites;


class Sprite{
  private
    int Flags; // for SDL_BlitSurface
    bool isDead; // need to destroy ?
	
    int Remove()
	{
	PrevRect.w = w;
	PrevRect.h = h;
	return SDL_BlitSurface( Background, @PrevRect, Surface, @PrevRect );
	}
  public
    byte ID; // we can easily determine the sprite's type
    SpriteList ParentList;
    int AnimPhase; // which image we draw
    int NumberOfFrames; // count of frames [by brombs]
    int x, y, z; // x, y coords for screen, z for sorting
    int w, h; // Width & Height of sprite
    SDL_Surface Surface, Background, Image; // Screen, Background and sprite images
    SDL_Rect SrcRect; // source rectangle what contains the image-data
    SDL_Rect PrevRect; // rectangle of previous position in the screen
	
    this( string _Image, int Width, int Height, bool UseAlpaChannel = false){	
	   SDL_Surface *Temp;
		ID = 0;
	  if( std.file.exists( _Image )){  
		Temp = IMG_Load( PChar( _Image ) );
		// Use alpha channel of image or transparent color?
		if( UseAlpaChannel)
		  Image = SDL_DisplayFormatAlpha( Temp );
		else
		  Image = SDL_DisplayFormat( Temp );
		SDL_FreeSurface( Temp );
		Flags = SDL_SRCCOLORKEY | SDL_RLEACCEL | SDL_HWACCEL;
		SDL_SetColorKey( Image, Flags, SDL_MapRGB( Image.format, 255, 0, 255 ) );
		NumberOfFrames = Image.w / Width;
	  }
	  else
			NumberOfFrames = 0;
		  AnimPhase = 0;
		  isDead = false;
		  x = 0;
		  y = 0;
		  z = 0;
		  w = Width;
		  h = Height;
		  SrcRect.y = 0;
		  SrcRect.w = w;
		  SrcRect.h = h;
	}
  ~this(){
	  if (Image != null)
		SDL_FreeSurface( Image );
	} // remove sprite from screen, result=-2 then background surface is lost
	
    void GetCollisionRect( SDL_Rect *Rect )
	{
		Rect.x = x;
		Rect.y = y;
		Rect.w = w;
		Rect.h = h;
	}
    void Draw(){
	SDL_Rect DestRect;
	
	 SrcRect.x = AnimPhase * w; // which animation phase need to draw?
	 DestRect.x = x; // set screen positions
	 DestRect.y = y;
	 SDL_BlitSurface( Image, @SrcRect, Surface, @DestRect );
	 PrevRect = DestRect;
	 } // draw sprite on screen
	      void Move(){} // move a sprite
    void Kill(){isDead = true;} // we will need to destroy this sprite
  }

  class SpriteList:List
	{	
  protected
    Sprite Get(int Index){}//{return Get( Index );}
    void Put( int Index, Sprite Item);
  public
    property Items[ Index : Integer ] : TSprite read Get write Put; default;
  }

  class SpriteEngine{
  private
    bool NeedSort; // do we need to resort sprites by Z?
    SDL_Surface *FSurface, FBackground; // screen and background surface
    void SetSurface( SDL_Surface *_Surface );
    void SetBackground(SDL_Surface *_Surface );
  public
    SpriteList Sprites; // all sprites
    int NumberOfRects;
    SDL_Rect[] UpdateRects;
    bool NeedRedrawBackground; // background surface is lost?
    void Clear(); // destroy all sprites from list
    void SortSprites(); // that is
    void AddSprite( Item : TSprite ); // add a sprite to list
    void RemoveSprite( Item : TSprite ); // remove a sprite from list and from memory
    void Move; // move all sprites in the list
    void Draw; // draw all sprites in the list
    property Surface : PSDL_Surface read FSurface write SetSurface; // screen surface
    property BackgroundSurface : PSDL_Surface read FBackground write SetBackground; // background surface
    this( SDL_Surface *_Surface );
    ~this();
  }

  bool isCollideRects( SDL_Rect *Rect1, SDL_Rect *Rect2){
  
	result = true;
	if ( Rect1.x + Rect1.w < Rect2.x ) |
    ( Rect1.x > Rect2.x + Rect2.w ) |
    ( Rect1.y + Rect1.h < Rect2.y ) |
    ( Rect1.y > Rect2.y + Rect2.h ){
    result= false;}
	return result;
	}

implementation

int CompareZ( Sprite Item1, Sprite Item2)
{
  if (Item1.z < Item2.z)
    return -1;
  else if (Item1.z > Item2.z)
    return 1;
  else
    return 0;
 }


// Create a sprite. Transparent color is $00ff00ff

// we can separately determine the collision rectangle





// TSpriteEngine ----------------------------------------
constructor TSpriteEngine.Create( _Surface : PSDL_Surface );
begin
  inherited Create;
  NeedSort := false;
  Sprites := TSpriteList.Create;
  FSurface := _Surface;
  NeedRedrawBackground := false;
  NumberOfRects := 0;
  UpdateRects := nil;
end;

destructor TSpriteEngine.Destroy;
begin
  Clear;
  Sprites.Free;
  inherited;
end;

void TSpriteEngine.AddSprite( Item : TSprite );
begin
  Item.Surface := Surface; // setting new sprite's surfaces
  Item.Background := FBackground;
  Item.ParentList := Sprites;
  Sprites.Add( Item );
  NeedSort := true;
  SetLength( UpdateRects, Sprites.Count * 2 * sizeof( TSDL_Rect ) );
end;

void TSpriteEngine.RemoveSprite( Item : TSprite );
begin
  Sprites.Remove( Item );
  SetLength( UpdateRects, Sprites.Count * 2 * sizeof( TSDL_Rect ) );
end;

void TSpriteEngine.Move;
var
  i, max : integer;
  TempSpr : TSprite;
begin
  if Sprites.Count > 0 then
  begin
    NeedRedrawBackground := false;
    i := 0; max := Sprites.Count;
    repeat
      if Sprites[ i ].Remove = -2 then
        NeedRedrawBackground := true;
      if Sprites[ i ].isDead then
      begin
        TempSpr := Sprites[ i ];
        RemoveSprite( TempSpr );
        TempSpr.Free;
        dec( Max );
      end
      else
      begin
        Sprites[ i ].Move;
        inc( i );
      end;
    until i >= Max;
  end;
  if NeedSort then
  begin
    SortSprites;
    NeedSort := false;
  end;
end;

void TSpriteEngine.Draw;
var
  i, j, num : integer;
begin
  num := Sprites.Count;
  j := 0;
  if num > 0 then
  begin
    for i := 0 to num - 1 do
    begin
      UpdateRects[ j ] := Sprites[ i ].PrevRect;
      Sprites[ i ].Draw;
      inc( j );
      if not Sprites[ i ].isDead then
      begin
        UpdateRects[ j ] := Sprites[ i ].PrevRect;
        inc( j );
      end;
    end;
  end;
  NumberOfRects := j;
end;

// set all sprites' Surface to _Surface 
void TSpriteEngine.SetSurface( _Surface : PSDL_Surface );
var
  i : integer;
begin
  FSurface := _Surface;
  if Sprites.Count > 0 then
    for i := 0 to Sprites.Count - 1 do
      Sprites[ i ].Surface := _Surface;
end;

// set all sprites' Background surface to _Surface 
void TSpriteEngine.SetBackground( _Surface : PSDL_Surface );
var
  i : integer;
begin
  FBackground := _Surface;
  if Sprites.Count > 0 then
    for i := 0 to Sprites.Count - 1 do
      Sprites[ i ].Background := _Surface;
end;

void TSpriteEngine.Clear;
var
  TempSpr : TSprite;
begin
  while Sprites.Count > 0 do
  begin // destroy all sprites
    TempSpr := Sprites[ 0 ];
    RemoveSprite( TempSpr );
    TempSpr.Free;
  end;
  Sprites.Clear;
end;

void TSpriteEngine.SortSprites;
begin
  Sprites.Sort( @CompareZ );
end;

end.
