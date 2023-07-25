/*
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at https://mozilla.org/MPL/2.0/.
 */

/*
*	grid_path_finding.agc
* 	CREATED BY: DEV MIDUZ
*	https://github.com/DevMiduz/AppGameKit_GridPathFinding
*	devmiduz@gmail.com
*/

/*

	INCLUDES

*/

/*

	CONSTANTS

*/

#constant TILE_OPEN = 0
#constant TILE_CLOSED = 1
#constant TILE_IMPASSIBLE = 2

/*

	TYPES
		
*/

type Grid
	tileSize as integer
	width as integer
	height as integer
	tiles as Tile[0,0]
endtype

type Tile
	id as integer
	gx as integer 
	gy as integer 
	px as integer
	py as integer
	status as integer
	distance as integer
	sprite as integer 
	distanceText as integer
endtype

type Player
	gx as integer
	gy as integer
	px as integer
	py as integer
	sprite as integer
endtype

type Enemy
	gx as integer
	gy as integer
	px as integer
	py as integer
	sprite as integer
endtype


/*
	
	FUNCTIONS
	
*/

function initGrid(grid ref as Grid)
	id as integer
	
	grid.tiles.length = grid.width
	
	for gx = 0 to grid.width
		grid.tiles[gx].length = grid.height
		for gy = 0 to grid.height
			tile as Tile
			
			tile.id = id
			tile.gx = gx
			tile.gy = gy
			tile.px = gx * grid.tileSize
			tile.py = gy * grid.tileSize
			tile.status = TILE_OPEN
			tile.distance = -1
			
			tile.sprite = CreateSprite(blocksImage)
			SetSpritePosition(tile.sprite, tile.px, tile.py)
			SetSpriteAnimation(tile.sprite, 8, 8, 4)
			PlaySprite(tile.sprite, 0)
			
			tile.distanceText = CreateText(str(tile.distance))
			SetTextPosition(tile.distanceText, tile.px, tile.py)
			
			if(Random(0, 8) = 0) 
				tile.status = TILE_IMPASSIBLE
				PlaySprite(tile.sprite, 0, 0, 4, 4)
			endif
			
			grid.tiles[gx, gy] = tile
			inc id
		next gy
	next gx
	
endfunction

function resetDistances(grid ref as Grid)
	for gx = 0 to grid.width
		for gy = 0 to grid.height
			grid.tiles[gx, gy].distance = -1
			SetTextString(grid.tiles[gx, gy].distanceText, str(grid.tiles[gx, gy].distance))
		next gy
	next gx
	
endfunction

function pathfindingLoop(startTile ref as Tile, grid ref as Grid)
	// maxTicks can be used to limit the distance that is checked.
	// but may impact lower powered devices AI functioning correctly.
	maxTicks as integer = 200
	ticks as integer
	
	visited as integer[]
	toVisit as Tile[]
	currentTile as Tile
	
	//Loop until required distance or until all tiles have been reached.
	startTile.distance = 0
	toVisit.insert(startTile)
	
	distance as integer
	
	while(toVisit.length > -1 and ticks <= maxTicks)
		currentTile = toVisit[0]
		toVisit.remove(0)
		
		if(hasTileBeenVisited(currentTile, grid, visited) = -1)
			visited.insert(currentTile.id)
			visited.sort()
			
			SetTextString(currentTile.distanceText, str(currentTile.distance))
			
			findTileNeighbours(currentTile, grid, toVisit, visited)
			inc ticks
		endif
	endwhile
	
endfunction

function findTileNeighbours(tile ref as Tile, grid ref as Grid, toVisit ref as Tile[], visited ref as integer[])
	if(tile.gx > 0)
		//LEFT
		if(hasTileBeenVisited(grid.tiles[tile.gx - 1, tile.gy], grid, visited) = -1 and isTileImpassible(grid.tiles[tile.gx - 1, tile.gy]) = -1)
			grid.tiles[tile.gx - 1, tile.gy].distance = (tile.distance + 1)
			toVisit.insert(grid.tiles[tile.gx - 1, tile.gy])
		endif
	endif	
	
	if(tile.gy > 0)
		//UP
		if(hasTileBeenVisited(grid.tiles[tile.gx, tile.gy - 1], grid, visited) = -1 and isTileImpassible(grid.tiles[tile.gx, tile.gy - 1]) = -1) 
			grid.tiles[tile.gx, tile.gy - 1].distance = (tile.distance + 1)
			toVisit.insert(grid.tiles[tile.gx, tile.gy - 1])
		endif
	endif

	if(tile.gx < grid.width)
		//RIGHT
		if(hasTileBeenVisited(grid.tiles[tile.gx + 1, tile.gy], grid, visited) = -1 and isTileImpassible(grid.tiles[tile.gx + 1, tile.gy]) = -1) 
			grid.tiles[tile.gx + 1, tile.gy].distance = (tile.distance + 1)
			toVisit.insert(grid.tiles[tile.gx + 1, tile.gy])
		endif
		
	endif
	
	if(tile.gy < grid.height)
		//DOWN
		if(hasTileBeenVisited(grid.tiles[tile.gx, tile.gy + 1], grid, visited) = -1 and isTileImpassible(grid.tiles[tile.gx, tile.gy + 1]) = -1) 
			grid.tiles[tile.gx , tile.gy + 1].distance = (tile.distance + 1)
			toVisit.insert(grid.tiles[tile.gx, tile.gy + 1])
		endif
	endif
	
endfunction

function isTileOpen(tile ref as Tile)
	if(tile.status = TILE_OPEN) then exitfunction 1
endfunction -1

function isTileImpassible(tile ref as Tile)
	if(tile.status = TILE_IMPASSIBLE) then exitfunction 1
endfunction -1

function hasTileBeenVisited(tile ref as Tile, grid ref as Grid, visited ref as integer[])	
	if(visited.find(tile.id) <> -1) then exitfunction 1
endfunction -1
