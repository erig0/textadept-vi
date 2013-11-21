-- Implementations of the motion functions.
local M = {}

local vi_ta_util = require 'vi_ta_util'
local line_length = vi_ta_util.line_length
local buf_state = vi_ta_util.buf_state

-- Normal motions
function M.char_left()
  local line, pos = buffer.get_cur_line()
  if pos > 0 then buffer.char_left() end
end

function M.char_right()
    local line, pos = buffer.get_cur_line()
	local docpos = buffer.current_pos
    -- Don't include line ending characters, so we can't use buffer.line_length().
    local lineno = buffer:line_from_position(docpos)
	local length = line_length(lineno)
	if pos < (length - 1) then
	    buffer.char_right()
	end
end

---  Move the cursor down one line.
-- 
function M.line_down()
    local bufstate = buf_state(buffer)
    
    local lineno = buffer.line_from_position(buffer.current_pos)
    local linestart = buffer.position_from_line(lineno)
    if lineno < buffer.line_count then
        local ln = lineno + 1
        local col = bufstate.col or (buffer.current_pos - linestart)
        bufstate.col = col  -- Try to stay in the same column
        if col >= line_length(ln) then
            col = line_length(ln) - 1
        end
        if col < 0 then col = 0 end
        buffer:goto_pos(buffer.position_from_line(ln) + col)
    end
end

---  Move the cursor up one line.
-- 
function M.line_up()
    local bufstate = buf_state(buffer)
    local lineno = buffer.line_from_position(buffer.current_pos)
    local linestart = buffer.position_from_line(lineno)
    if lineno >= 1 then
        local ln = lineno - 1
        local col = bufstate.col or buffer.current_pos - linestart
        bufstate.col = col
        if col >= line_length(ln) then
            col = line_length(ln) - 1
        end
        if col < 0 then col = 0 end
        buffer:goto_pos(buffer.position_from_line(ln) + col)
    end
end

-- Select motions (return start,end_)
function M.sel_line()
  local lineno = buffer:line_from_position(buffer.current_pos)
  return buffer:position_from_line(lineno), buffer.line_end_position[lineno]
end

return M