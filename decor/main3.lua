require "timer"
dofile "uma1.lua"
loadmod "decor"
--[[
Создание декоратора:
D { "имя декоратора", "тип декоратора", параметры ... }
Удаление декоратора:
D { "имя декоратора" }

Получение декоратора, для изменения его параметров:
D"имя декоратора"

Пересоздание декоратора:
D(D"имя декоратора")

Общие аргументы декораторов:
x, y - позиции на сцене
xc, yc - точка центра декоратора (по умолчанию 0, 0 -- левый верхний угол)
xc и yc могут принимать значение true - тогда xc и/или yc расчитаются самостоятельно как центр картинки
w, h - ширина и высотра. Если не заданы, в результате создания декоратора будут вычислены самостоятельно
z - слой. Чем больше - тем дальше от нас. Отрицательные значения - ПЕРЕД слоем текста, положительные - ПОСЛЕ.
click -- если равен true - то клики по этому объекту будут доставляться в here():ondecor() или game:ondecor()

Например:
function game:ondecor(name, press, x, y, btn)
name - имя декоратора
press - нажато или отжато
x, y -- координаты относительно декоратора (с учетом xc, yc)
btn - кнопка

hidden -- если равен true - то декоратор не видим

Если вы используете анимацию, или подсветку ссылок в текстовом декораторе нужно включить таймер на желаемую частоту,
например:
timer:set(50)

Типы декораторов:

"img" - картинка или анимация
Параметры:
сначала идет графический файл, из которого будет создан декоратор.
Вместо файла можно задать declared функцию, возвращающую спрайт.
frames = число -- если это анимация. В анимации кадры записаны в одном полотне. Размер каждого кадра задается w и h.
delay = число мс -- задержка анимации.
background - если true, этот спрайт считается фоном и просто копируется (быстро). Для фонов ставьте z побольше.

fx, fy - числа - если рисуем картинку из полотна, можно указать позицию в котором она находится

anim_scheme - текст - может быть 'horisontal', 'vertical' или 'sheet'. Указывает способ, которым размещена последовательность кадров в файле изображения.
'horisontal' - строчный способ, 'vertical' - столбцовый, 'sheet' - упаковка с вырезанием пустого места.
first_frame - число - указывает начальный кадр анимации.
data - переменная - указатель на таблицу, содержащую данные о размещении 'sheet' - кадров анимации
framesx, framesy - число - количество столбцов и строк в анимации при способе 'vertical' или 'horisontal'
anim_type - строка - тип анимации. 'loop', 'flip-flop' или 'once'.
begin_frame - число - кадр, с которого начнётся воспроизведение в первом цикле анимации
anim_step - число - указывает прямой или обратный порядок воспроизведения. Значения 1 или -1



Пример:
	D {"cat", "img", "anim.png", x = -64, y = 48, frames = 3, w = 64, h = 54, delay = 100, click = true }
	D {"title", "img", "title.png", x = 400, y = 300, xc = true, yc = true } -- по центру, если тема 800x600


"txt" - текстовое поле
В текстовом поле создается текст с требуемым шрифтом.
В тексте могут быть переводы строк '\n' и ссылки {ссылка|текст}.
Параметры:
font - файл шрифта. Если не указан, берется из темы
size - размер шрифта. Если не указан, берется из темы
interval - интервал. Если не указан, берется из темы
style - число Если не указано, то 0 (обычный)
color - цвет, если не указано, берется из темы
color_link, color_alink - цвет ссылки/подсвеченной ссылки (если не указано, берется из темы)

Ссылки обрабатываются как у декораторов. Например:

function game:ondecor(name, press, x, y, btn, act, ...)
press - нажатие или отжатие (для текстовых декораторов приходит только отжатие
x, y -- координаты ОТНОСИТЕЛЬНО декоратора
name -- имя декоратора
act и ... -- ссылка и ее аргументы
Например {walk 'main'|Ссылка}

function game:ondecor(name, press, x, y, btn, act, where)
act будет равен 'walk'
where будет равно 'main'

]]--

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
	if name == 'text' and not act then
		D'text':next_page()
		return false
	end
	if act == 'restart' then
	    D'text':page(1)
	    p("click:", name, ":",a, " ", b, " ", x, ",", y) -- вывели информацию о клике
	    return
	end
	return false
end

declare 'box_alpha' (function (v)
	return sprite.new("box:"..std.tostr(v.w).."x"..std.tostr(v.h)..",black"):alpha(32)
end)

declare 'flake' (function (d)
    d.y = d.y + rnd(3)
    d.x = d.x + rnd(3) - 2
    if d.y > 600 then
	d.y = 0
	d.x = rnd(800)
    end
end)

declare 'kitten' (function (cat)
    cat.x = cat.x + 2
    if cat.x > 500 then
      cat.x = -64
    end
end)

declare 'kitten1' (function (digit1)
    digit1.x = digit1.x + 2
end)

declare 'kitten2' (function (digit2)
    digit2.x = digit2.x + 2
end)

declare 'kitten3' (function (digit3)
    digit3.x = digit3.x + 2
end)

declare 'tiledslid' (function (tiledslide)
    tiledslide.slidex = tiledslide.slidex + 3
    tiledslide.slidey = tiledslide.slidey + 2
    if tiledslide.slidex > tiledslide.w then
		 tiledslide.slidex = 0
    end
    if tiledslide.slidey > tiledslide.h then
		 tiledslide.slidey = 0
    end
end)

declare 'tiledslid1' (function (tiledslide)
    tiledslide.slidex = tiledslide.slidex - 3
    tiledslide.slidey = tiledslide.slidey - 2
    if tiledslide.slidex < 0 then
		 tiledslide.slidex = tiledslide.w
    end
    if tiledslide.slidey < 0 then
		 tiledslide.slidey = tiledslide.h
    end
end)

function init()
  local k = {
    drt = sheetData.frames
    }
  print (sheetData)
  print (sheetData.frames)
  print (k["drt"][1].x)
	timer:set(50)
	for i = 1, 100 do
		decor:new {"snow"..std.tostr(i), "img", "box:4x4,black", process = flake, x= rnd(800), y = rnd(600), xc = true, yc = true, z = -1 }
	end
	decor.bgcol = 'white'
	D {"cat", "img", "anim.png", process = kitten, x = -64, y = 88, frames = 3, w = 64, h = 56, delay = 100, click = true, z = -1}
	D {"digit1", "img", "led.jpg", process = kitten1, x = -64, y = 48, shiftx = 0, shifty = 0, first_frame = 0, frames = 10, begin_frame = 3, framesx = 5, framesy = 2, anim_scheme = 'horisontal', anim_type = 'flip-flop', anim_step = -1, w = 32, h = 63, delay = 500, click = true, z = -1}
	D {"tiledslide", "img", "background.png", fx = 0, fy = 0, frames = 1, process = tiledslid1, x = 64, y = 48, anim_scheme = "slide", slidex = 0, slidey = 0, w = 480, h = 320, delay = 500, click = true, z = -1}
	D {"digit2", "img", "led.jpg", process = kitten2, x = -64, y = 148, shiftx = 0, shifty = 0, first_frame = 0, frames = 10, begin_frame = 3, framesx = 5, framesy = 2, anim_scheme = 'horisontal', anim_type = 'loop', anim_step = -1, w = 32, h = 63, delay = 500, click = true, z = -1}
	D {"digit4", "img", "led.jpg", x = 264, y = 148, shiftx = 0, shifty = 0, first_frame = 0, frames = 10, begin_frame = 3, framesx = 5, framesy = 2, anim_scheme = 'horisontal', anim_type = 'flip-flop', anim_step = -1, w = 32, h = 63, delay = 500, click = true, z = -1}
	D {"digit3", "img", "led.jpg", process = kitten3, x = 64, y = 248, shiftx = 0, shifty = 0, first_frame = 0, frames = 10, framesx = 5, framesy = 2, anim_type = 'once', anim_step = 1, w = 32, h = 63, delay = 500, click = true, z = -1}
	D {"uma", "img", "uma1.png", x = 164, y = 298, xc = true, yc = true, first_frame = 0, frames = 8, anim_scheme = 'sheet', data = sheetData, anim_type = 'loop', anim_step = 1, w = 227, h = 162, delay = 50, click = true, z = -1}
	D {"bg", "img", box_alpha, xc = true, yc = true, x = 400, w = 180, y = 300, h = 148, z = 2  }
	D {"text", "txt", text, xc = true, yc = true, x = 400, w = 160, y = 300, align = 'left', hidden = false, h = 128, typewriter = true, z =1 }
end
