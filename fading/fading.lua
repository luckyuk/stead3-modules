require "sprite"
require "theme"
require "timer"

instead.fading = false

local f = std.obj {
	{
		started = false;
		timer = false;
		effects = {};
	};
	delay = 20; -- default delay
	max = 16; -- default max
	effect = false;
	oldeffect = false;
	nam = '@fading';
}

function f.effects.fadeblack(s, src, dst)
	sprite.scr():fill('black')
	if s.step < s.max / 2 then -- fadeout old
		local alpha = 255 - (s.step * 2 / s.max) * 255;
		if alpha > 0 then
			src:draw(sprite.scr(), 0, 0, alpha);
		end
	else -- fadein new
		local alpha = ((s.step - 1 - s.max / 2) / s.max) * 255 * 2;
		if alpha > 0 then
			dst:draw(sprite.scr(), 0, 0, alpha);
		end
	end
end

function f.effects.crossfade(s, src, dst)
	local alpha = ((s.step - 1) / s.max) * 255;
	src:draw(sprite.scr(), 0, 0, 255 - alpha);
	dst:draw(sprite.scr(), 0, 0, alpha);
end

function f.effects.move_left(s, src, dst)
	sprite.scr():fill('black')
	local x = theme.scr.w() * s.step / s.max
	src:copy(sprite.scr(), x, 0);
	dst:copy(sprite.scr(), x - theme.scr.w(), 0);
end

function f.effects.move_right(s, src, dst)
	sprite.scr():fill('black')
	local x = theme.scr.w() * s.step / s.max
	dst:copy(sprite.scr(), theme.scr.w() - x, 0);
	src:copy(sprite.scr(), -x, 0);
end

function f.effects.move_up(s, src, dst)
	sprite.scr():fill('black')
	local y = theme.scr.h() * s.step / s.max
	src:copy(sprite.scr(), 0, y);
	dst:copy(sprite.scr(), 0, y - theme.scr.h());
end

function f.effects.move_down(s, src, dst)
	sprite.scr():fill('black')
	local y = theme.scr.h() * s.step / s.max
	dst:copy(sprite.scr(), 0, theme.scr.h() - y);
	src:copy(sprite.scr(), 0, -y);
end

local scr, scr2
local cb = timer.callback

function timer:callback(...)
	if f.started then
		return '@fading'
	end
	return cb(self, ...)
end

function f.start()
	local old = sprite.direct()
	sprite.direct(true)
	sprite.scr():copy(scr)
	sprite.direct(old)
	f.timer = timer:get()
	f.effect.step = 0
	f.started = true
	timer:set(f.effect.delay or 20)
end

function f.change(ops)
	if type(ops) == 'string' then
		ops = { ops }
	end
	ops.forever = true
	f.set(ops)
end

function f.set(ops)
	if type(ops) == 'string' then
		ops = { ops }
	end
	ops.delay = ops.delay or f.delay
	ops.max = ops.max or f.max
	if not ops.forever then
		f.oldeffect = std.clone(f.effect)
	end
	f.effect = std.clone(ops)
	if ops.forever then
		f.oldeffect = std.clone(f.effect)
	end
end

local oldrender = sprite.render_callback()

sprite.render_callback(function()
	if f.started and not sprite.direct() then
		sprite.direct(true)
		sprite.scr():copy(scr2)
		scr:copy(sprite.scr())
	end
	if not f.started and oldrender then
		oldrender()
	end
end)

std.mod_cmd(function(cmd)
	if cmd[1] ~= '@fading' then
		return
	end

	f.effect.step = f.effect.step + 1

	f.effects[f.effect[1]](f.effect, scr, scr2)

	if f.effect.step > f.effect.max then
		f.started = false
		if f.oldeffect then
			f.effect = std.clone(f.oldeffect)
		end
		timer:set(f.timer)
		sprite.direct(false)
		return std.nop()
	end
	return
end)
std.mod_init(function()
	f.set { 'crossfade' };
end)

std.mod_start(function()
	scr = sprite.new(theme.get 'scr.w', theme.get 'scr.h')
	scr2 = sprite.new(theme.get 'scr.w', theme.get 'scr.h')
--	f.effect = f.oldeffect
end)

std.mod_step(function(state)
	if not state then
		return
	end
	if player_moved() and std.cmd[1] ~= 'load' then
		f.start()
	end
end)

fading = f
