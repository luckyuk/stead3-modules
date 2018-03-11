require "timer"
loadmod "decor"

dofile "uma1.lua"

obj {
    nam = 'milk';
    dsc = [[На полу стоит блюдце с {молоком}.]];
    act = function()
	p [[Это для котика.]];
    end;
}

room {
    nam = 'main';
    title = 'ДЕКОРАТОРЫ';
    dsc = [[Привет, мир!]];
    obj = { 'milk' };
    ondecor = function(s, name, press) -- котика обработаем в комнате
	if name == 'cat' and press then
	    local mew = { 'Мяу!', 'Муррр!', 'Мурлык!', 'Мяуууу! Мяуууу!', 'Дай поесть!' };
	    p (mew[rnd(#mew)])
	    return
	end
	return false -- а все остальное -- в game
    end
}

local text = [[Привет любителям и авторам INSTEAD!
[break]
Это простая демонстрация
альфа версии декораторов.
[break]
Название позаимствовано от FireURQ.
[break]
Надеюсь, вам понравится INSTEAD 3.2!
Теперь вы можете нажать на {restart|ссылку}.]];
function game:timer()
	return false
end
function game:ondecor(name, press, x, y, btn, act, a, b)
	-- обработчик кликов декораторов (кроме котика, который обработан в main)
  end
function init()
	timer:set(10)
	D {"bground", "img", "background.png", background = true, w = 480, h = 320, z = 200 }
    D {"moon1", "img", "moon.png", fx = 0, fy = 0, frames = 1, x = 240, y = 45, xc = true, yc = true, anim_scheme = "slide", slidex = 480, slidey = 0, slide_stepx = 1, slide_stepy = 0, w = 560, h = 75, delay = 250, z = 5}
  D {"mountain_big1", "img", "mountain_big.png", fx = 0, fy = 0, frames = 1, x = 240, y = 112, xc = true, yc = true, anim_scheme = "slide", slidex = 0, slidey = 0, slide_stepx = 1, slide_stepy = 0, w = 518, h = 51, delay = 150, z = 20}
  D {"mountain_big2", "img", "mountain_big.png", fx = 0, fy = 0, frames = 1, x = 240, y = 112, xc = true, yc = true, anim_scheme = "slide", slidex = 259, slidey = 0, slide_stepx = 1, slide_stepy = 0, w = 518, h = 51, delay = 150, z = 20}
  D {"trees1", "img", "tree_s.png", fx = 0, fy = 0, frames = 1, x = 240, y = 235, xc = true, yc = 81, anim_scheme = "slide", slidex = 132, slidey = 0, slide_stepx = 4, slide_stepy = 0, w = 856, h = 81, delay = 25, z = 17}
  D {"trees2", "img", "tree_s.png", fx = 0, fy = 0, frames = 1, x = 240, y = 235, xc = true, yc = 81, anim_scheme = "slide", slidex = 810, slidey = 0, slide_stepx = 4, slide_stepy = 0, w = 856, h = 81, delay = 25, z = 17}
  D {"treel1", "img", "tree_l.png", fx = 0, fy = 0, frames = 1, x = 240, y = 275, xc = true, yc = 135, anim_scheme = "slide", slidex = 0, slidey = 0, slide_stepx = 4, slide_stepy = 0, w = 856, h = 135, delay = 25, z = 16}
  D {"trees11", "img", "tree_s.png", fx = 0, fy = 0, frames = 1, x = 240, y = 235, xc = true, yc = 81, anim_scheme = "slide", slidex = 472, slidey = 0, slide_stepx = 4, slide_stepy = 0, w = 856, h = 81, delay = 25, z = 17}
	D {"uma", "img", "uma.png", x = 460, y = 320, xc = 226, yc = 160, first_frame = 0, frames = 8, anim_scheme = 'sheet', data = sheetData, anim_type = 'loop', anim_step = 1, w = 227, h = 162, delay = 50, z = -1}
  D {"trees21", "img", "tree_s.png", fx = 0, fy = 0, frames = 1, x = 240, y = 235, xc = true, yc = 81, anim_scheme = "slide", slidex = 290, slidey = 0, slide_stepx = 4, slide_stepy = 0, w = 856, h = 81, delay = 25, z = 17}
  D {"treel11", "img", "tree_l.png", fx = 0, fy = 0, frames = 1, x = 240, y = 275, xc = true, yc = 135, anim_scheme = "slide", slidex = 340, slidey = 0, slide_stepx = 4, slide_stepy = 0, w = 856, h = 135, delay = 25, z = 16}
  D {"mountain_small1", "img", "mountain_small.png", fx = 0, fy = 0, frames = 1, x = 240, y = 138, xc = true, yc = true, anim_scheme = "slide", slidex = 420, slidey = 0, slide_stepx = 1, slide_stepy = 0, w = 640, h = 41, delay = 150, z = 18}
  D {"mountain_small2", "img", "mountain_small.png", fx = 0, fy = 0, frames = 1, x = 240, y = 138, xc = true, yc = true, anim_scheme = "slide", slidex = 100, slidey = 0, slide_stepx = 1, slide_stepy = 0, w = 640, h = 41, delay = 150, z = 18}
  D {"fog1", "img", "fog.png", fx = 0, fy = 0, frames = 1, x = 240, y = 320, xc = true, yc = 106, anim_scheme = "slide", slidex = 200, slidey = 0, slide_stepx = 4, slide_stepy = 0, w = 480, h = 106, delay = 25, z = 3}



  D {"tree1sigi1", "img", "tree_l_sugi.png", fx = 0, fy = 0, frames = 1, x = 240, y = 320, xc = true, yc = 320, anim_scheme = "slide", slidex = 350, slidey = 0, slide_stepx = 6, slide_stepy = 0, w = 1080, h = 320, delay = 25, z = -2}
  D {"tree2take1", "img", "tree_l_take.png", fx = 0, fy = 0, frames = 1, x = 240, y = 320, xc = true, yc = 320, anim_scheme = "slide", slidex = 10, slidey = 0, slide_stepx = 6, slide_stepy = 0, w = 1080, h = 320, delay = 25, z = -2}
  D {"banner1", "img", "rakkan.png", x = 30, y = 260, xc = true, yc = true, w = 22, h = 86, z = -3}
  D {"banner2", "img", "rakkann.png", x = 460, y = 60, xc = true, yc = true, w = 20, h = 100, z = -3}
end