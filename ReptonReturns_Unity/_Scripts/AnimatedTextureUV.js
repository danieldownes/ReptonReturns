
var uvAnimationTileX = 24; //Here you can place the number of columns of your sheet. 
                           //The above sheet has 24

var uvAnimationTileY = 1; //Here you can place the number of rows of your sheet. 
                          //The above sheet has 1

var bFlipHorizontally = false;
var bFlipVertically = false;
var framesPerSecond = 30.0;

function Update () 
{
    var fHFlip = 1.0;
    var fHOffset = 0.0;

    var fVFlip = 1.0;
    var fVOffset = 0.0;

    if( bFlipHorizontally )
        fHFlip = -1.0;

    if( bFlipVertically )
        fVFlip = -1.0;

    // Calculate index
    var index : int = Time.time * framesPerSecond;
    // repeat when exhausting all frames
    index = index % (uvAnimationTileX * uvAnimationTileY);
    
    // Size of every tile
    var size = Vector2 (1.0 / uvAnimationTileX, 1.0 / uvAnimationTileY);

    // split into horizontal and vertical index
    var uIndex = index % uvAnimationTileX;
    var vIndex = index / uvAnimationTileX;

    if( bFlipHorizontally)
        fHOffset = 1;

    // build offset
    // v coordinate is the bottom of the image in opengl so we need to invert.
    var offset = Vector2 ((uIndex + fHOffset) * size.x, 1.0 - size.y - vIndex * size.y);
    
    renderer.material.SetTextureOffset ("_MainTex", offset);

    if( bFlipHorizontally)
        size.x = -size.x;

    renderer.material.SetTextureScale ("_MainTex", size);
}