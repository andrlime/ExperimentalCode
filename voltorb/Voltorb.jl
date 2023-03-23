using GameZero
using Colors
using Distributions

HEIGHT = 640
WIDTH = 640
BACKGROUND = colorant"#CCCCCC"

# Colors
RED = colorant"#FF0000"
GREEN = colorant"#00FF00"
BLUE = colorant"#0000FF"
YELLOW = colorant"#FFFF00"
DARK = colorant"#333333"

# Some other config
SIZE = 5
CURRENT_LEVEL = 1 # Current level number
COIN_COUNT = 1 # Defaults to 1 to allow multiplication
WIDTH_OF_SINGLE_NUMBER = 22
LINE_HEIGHT = 40

# Text actors
textZero = (TextActor("0", "arial.ttf"; font_size=36, color=Int[255,255,0,255]))
textOne = (TextActor("1", "arial.ttf"; font_size=36, color=Int[255,255,0,255]))
textTwo = (TextActor("2", "arial.ttf"; font_size=36, color=Int[255,255,0,255]))
textThree = (TextActor("3", "arial.ttf"; font_size=36, color=Int[255,255,0,255]))
textFour = (TextActor("4", "arial.ttf"; font_size=36, color=Int[255,255,0,255]))
textFive = (TextActor("5", "arial.ttf"; font_size=36, color=Int[255,255,0,255]))
textSix = (TextActor("6", "arial.ttf"; font_size=36, color=Int[255,255,0,255]))
textSeven = (TextActor("7", "arial.ttf"; font_size=36, color=Int[255,255,0,255]))
textEight = (TextActor("8", "arial.ttf"; font_size=36, color=Int[255,255,0,255]))
textNine = (TextActor("9", "arial.ttf"; font_size=36, color=Int[255,255,0,255]))
textVoltorbs = (TextActor("Voltorbs", "arial.ttf"; font_size=36, color=Int[255,255,0,255]))
textCoins = (TextActor("Coins", "arial.ttf"; font_size=36, color=Int[255,255,0,255]))
textActorList = [textZero, textOne, textTwo, textThree, textFour, textFive, textSix, textSeven, textEight, textNine]

# Structures for the game
struct Level # Define a possible level
    id::Int64 # level number e.g. 1, 2, 3
    twos::Int64 # amount of 2x
    threes::Int64 # amount of 3x
    voltorbs::Int64 # amount of voltorbs, boom!
end

struct VoltorbFlip
    level::Int64 # level number, now that i generated the level it doesn't matter the struct
    tiles::Array{Union{Missing, Int64}, 2} # tiles as an array
    revealed::Array{Bool, 2}
    VoltorbFlip(level::Level) = new(level.id, generateTiles(level), generateFalseGrid())
end

function generateFalseGrid()
    global SIZE
    board = Array{Union{Missing, Bool}, 2}(missing, SIZE, SIZE)
    for i in 1:SIZE*SIZE
        board[i] = false
    end

    return board
end

function generateTiles(level::Level)
    global SIZE
    board = Array{Union{Missing, Int64}, 2}(missing, SIZE, SIZE)
    
    # Generate the corresponding number of voltorbs
    for i in 1:level.voltorbs
        randomNumber = rand((1:SIZE*SIZE), 1)[1]
        if ismissing(board[randomNumber])
            board[randomNumber] = 0
        else
            i -= 1
        end
    end

    # Generate 2s and 3s
    for i in 1:level.twos
        randomNumber = rand((1:SIZE*SIZE), 1)[1]
        if ismissing(board[randomNumber])
            board[randomNumber] = 2
        else
            i -= 1
        end
    end

    for i in 1:level.threes
        randomNumber = rand((1:SIZE*SIZE), 1)[1]
        if ismissing(board[randomNumber])
            board[randomNumber] = 3
        else
            i -= 1
        end
    end

    # Everything else is a 1
    for i in 1:SIZE*SIZE
        if ismissing(board[i])
            board[i] = 1
        end
    end

    return board
end

function getTileByCoordinates(board::Array{Union{Missing, Int64}, 2}, row::Int64, col::Int64)
    index = (row-1)*SIZE + col
    return board[index]
end

function getTextFromValue(value::Int64)
    global textActorList
    if value <= 9 && value >= 0
        return textActorList[value + 1]
    else
        return textVoltorbs
    end    
end

function getListOfTextActors(value::Int64)
    # Go digit by digit
    mutable_value = copy(value)
    list = []

    if value == 1
        return [1]
    end

    while mutable_value > 1
        append!(list, mutable_value % 10)
        mutable_value /= 10
        mutable_value = floor.(Int, mutable_value)
    end

    if value >= 10
        append!(list, mutable_value)
    end

    return reverse(list)
end

level1 = Vector{Level}([Level(1, 3, 1, 6), Level(1, 0, 3, 6), Level(1, 5, 0, 6), Level(1, 2, 2, 6), Level(1, 4, 1, 6)])
buffer = 20 # buffer from the top left of the screen
STOP_MLTP = 1.5 # stops at [this var]/2 of the screen (e.g. 1.5 -> stops at 75%)

game::VoltorbFlip = VoltorbFlip(Level(1, 3, 1, 6))
function draw(_::Game)
    global game
    global WIDTH_OF_SINGLE_NUMBER
    global LINE_HEIGHT
    fill(DARK)
    draw(Rect(10, 10, 2*WIDTH-20, 2*HEIGHT-20), BACKGROUND)

    # Some config
    global buffer
    global STOP_MLTP
    buffer_per_tile = 5 # small padding for the tile
    dx = STOP_MLTP*WIDTH # the width of the voltorb screen
    dy = STOP_MLTP*HEIGHT # height of voltorb screen
    per_x = dx/SIZE # width per tile
    per_y = dy/SIZE # height per tile

    # Draw tiles
    for i in 1:SIZE
        for j in 1:SIZE
            # self commenting code
            starting_coordinate_x = (i-1) * per_x + buffer + buffer_per_tile
            starting_coordinate_y = (j-1) * per_y + buffer + buffer_per_tile
            size_x = per_x - (2*buffer_per_tile)
            size_y = per_y - (2*buffer_per_tile)

            # draw the tile
            draw(Rect(starting_coordinate_x, starting_coordinate_y, size_x, size_y), BACKGROUND)

            show = true # if true, show the numbers. for debug only.
            if show && game.revealed[(i-1)*SIZE + j] # show the value of the tile
                current_value = getTileByCoordinates(game.tiles, i, j)
                text_actor = getTextFromValue(current_value)
                text_actor.pos = (starting_coordinate_x + buffer_per_tile, starting_coordinate_y + buffer_per_tile)
                draw(text_actor)
            end
        end
    end

    # Draw summary per row
    for i in 1:SIZE
        starting_coordinate_x = dx + SIZE*buffer_per_tile
        starting_coordinate_y = (i-1) * per_y + buffer + buffer_per_tile
        size_x = 2 * WIDTH - 20 - starting_coordinate_x - buffer_per_tile
        size_y = (per_y - (2*buffer_per_tile))

        # draw the tile
        draw(Rect(starting_coordinate_x, starting_coordinate_y, size_x, size_y), BACKGROUND)

        # find the row
        # Note that by design it is impossible for V > 5 or sum_row > 15.
        row = game.tiles[i,:]
        sum_row = sum(row)
        number_voltorb = count(i->(i == 0), row)

        textListSum = getListOfTextActors(sum_row)
        textListVoltorb = [number_voltorb, 10]

        c = 0
        for j in textListSum
            st_x = starting_coordinate_x + buffer_per_tile + c*WIDTH_OF_SINGLE_NUMBER
            st_y = starting_coordinate_y + buffer_per_tile
            
            actor = getTextFromValue(j)
            actor.pos = (st_x, st_y)
            draw(actor)

            c += 1
        end

        c = 0
        for j in textListVoltorb
            st_x = starting_coordinate_x + buffer_per_tile + c*WIDTH_OF_SINGLE_NUMBER
            st_y = starting_coordinate_y + buffer_per_tile + LINE_HEIGHT
            
            actor = getTextFromValue(j)
            actor.pos = (st_x, st_y)
            draw(actor)

            c += 1
        end
    end

    # Draw summary per column
    for i in 1:SIZE
        starting_coordinate_x = (i-1) * per_x + buffer + buffer_per_tile 
        starting_coordinate_y = dy + SIZE*buffer_per_tile
        size_x = (per_x - (2*buffer_per_tile)) 
        size_y = 2 * HEIGHT - 20 - starting_coordinate_y - buffer_per_tile

        # draw the tile
        draw(Rect(starting_coordinate_x, starting_coordinate_y, size_x, size_y), BACKGROUND)

        # find the col
        # Note that by design it is impossible for V > 5 or sum_col > 15.
        col = game.tiles[:,i]
        sum_col = sum(col)
        number_voltorb = count(i->(i == 0), col)

        textListSum = getListOfTextActors(sum_col)
        textListVoltorb = [number_voltorb, 10]
        
        c = 0
        for j in textListSum
            st_x = starting_coordinate_x + buffer_per_tile + c*WIDTH_OF_SINGLE_NUMBER
            st_y = starting_coordinate_y + buffer_per_tile
            
            actor = getTextFromValue(j)
            actor.pos = (st_x, st_y)
            draw(actor)

            c += 1
        end

        c = 0
        for j in textListVoltorb
            st_x = starting_coordinate_x + buffer_per_tile + c*WIDTH_OF_SINGLE_NUMBER
            st_y = starting_coordinate_y + buffer_per_tile + LINE_HEIGHT
            
            actor = getTextFromValue(j)
            actor.pos = (st_x, st_y)
            draw(actor)

            c += 1
        end
    end

    # Draw total coin count
    global COIN_COUNT
    global textCoins

    start_x = dx + SIZE*buffer_per_tile
    start_y = dy + SIZE*buffer_per_tile
    end_x = 2*WIDTH - start_x - buffer_per_tile - buffer
    end_y = 2*HEIGHT - start_y - buffer_per_tile - buffer
    draw(Rect(start_x, start_y, end_x, end_y), BACKGROUND)

    textListCoins = getListOfTextActors(COIN_COUNT)
    c = 0

    textCoins.pos = (start_x + buffer_per_tile, start_y + buffer_per_tile)
    draw(textCoins)

    for j in textListCoins
        st_x = start_x + buffer_per_tile + c*WIDTH_OF_SINGLE_NUMBER
        st_y = start_y + buffer_per_tile + LINE_HEIGHT
        
        actor = getTextFromValue(j)
        actor.pos = (st_x, st_y)
        draw(actor)

        c += 1
    end

    return nothing
end

function on_mouse_down(g::Game, pos)
    # get which tile that is
    global buffer
    global WIDTH
    global HEIGHT
    global STOP_MLTP
    global game

    inner_x = buffer
    inner_y = buffer
    outer_x = STOP_MLTP*WIDTH # the width of the voltorb screen
    outer_y = STOP_MLTP*HEIGHT # height of voltorb screen

    mouse_x = pos[1] * 2
    mouse_y = pos[2] * 2

    coord_x = floor.(Int,((mouse_x-inner_x)/(outer_x-inner_x)) * (SIZE) + 1)
    coord_y = floor.(Int,((mouse_y-inner_y)/(outer_y-inner_y)) * (SIZE) + 1)

    if !(mouse_x < inner_x || mouse_x > outer_x || mouse_y < inner_y || mouse_y > outer_y)
        game.revealed[(coord_x-1)*SIZE + coord_y] = true
        if game.tiles[(coord_x-1)*SIZE + coord_y] == 0
            println("Game over!")
        else
            global COIN_COUNT
            COIN_COUNT *= game.tiles[(coord_x-1)*SIZE + coord_y]
        end
    end
end
