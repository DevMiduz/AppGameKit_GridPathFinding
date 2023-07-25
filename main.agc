
/*
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at https://mozilla.org/MPL/2.0/.
 */

/*
*	main.agc
* 	CREATED BY: DEV MIDUZ
*	https://github.com/DevMiduz/AppGameKit_GridPathFinding
*	devmiduz@gmail.com
*/

/*

	INCLUDES

*/

#include "includes.agc"

/*

	CONSTANTS

*/

/*

	FUNCTIONS
	
*/

function InitGame(grid ref as Grid)
    grid.tileSize = 8
    grid.width = 20
    grid.height = 10
    
    initGrid(grid)
endfunction

/*

	MAIN PROGRAM

*/

InitEngine()

global blocksImage as integer
blocksImage = LoadImage("pathfinding_blocks.png")

global gGrid as Grid
global gVisited as Tile[]

InitGame(gGrid)

do
    Print( ScreenFPS() )
    
    if(GetPointerPressed())
    		tileX as integer
    		tileY as integer
    		
    		tileX = GetPointerX() / gGrid.tileSize
    		tileY = GetPointerY() / gGrid.tileSize
    
		resetDistances(gGrid)
		pathfindingLoop(gGrid.tiles[tileX, tileY], gGrid)
    endif
    
    Sync()
loop
