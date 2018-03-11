require "timer"
loadmod "decor"
dofile "uma1.lua"

--[[
Создание декоратора:
D { "имя декоратора", "тип декоратора", параметры ... }
-Удаление декоратора:
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

dofile "uma1.lua"

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
