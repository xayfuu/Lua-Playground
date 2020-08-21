------------------------------------------------------------------------
------------------------------------------------------------------------
-- if-else examples

function mymax(a, b)
    if a<b then return b else return a end
end

function notnil(o)
    if o ~= nil then
        return true
    else
        return false
    end
end

function mymath(a, b, operand)
    if operand == "+" then
        return a + b
    elseif operand == "-" then
        return a - b
    elseif operand == "*" then
        return a * b
    elseif operand == "/" then
        return a / b
    else
        error("invalid operation")
    end
end


------------------------------------------------------------------------
------------------------------------------------------------------------
-- error handling examples

function add(a,b)
    assert(type(a) == "number", "a is not a number")
    assert(type(b) == "number", "b is not a number")
    return a+b
end


function mul(a,b)
    if type(a) ~= "number" then
        error("a is not a number")
    end
    if type(b) ~= "number" then
        error("b is not a number")
    end
    return a*b
end


function failfunc()
    return n/0
end

-- pcall(f, arg1, ...) builtin is a protected call towards a function
-- and assures no error is thrown if the function fails. Instead it
-- returns the status of the error
if pcall(failfunc) then
    print("Success")
else
    print("Failure, but the program is still running")
    print(2+2)
end


-- xpcall(f, err) also calls the requested function, but this time
-- with an error handler that does something specified by the
-- programmer if an error occurs.
function myerrorhandler(err)
    print("ERROR:", err)
end
print(xpcall(failfunc, myerrorhandler))
print("And the program is still running!")


------------------------------------------------------------------------
------------------------------------------------------------------------
-- Loops

function infloop()
    a = 2
    while(true) do
        a = a ^ 2
        print(a)
    end
end


function countdown()
    for i = 10, 0, -1 do
        if i == 0 then
            print("Lua!")
        else
            print(i)
        end
    end
end


function looptable(t)
    for idx, value in pairs(t) do
        print(idx, value)
    end
end


function batman(n)
    str = "Na"
    repeat
        str = str .. "na"
        n = n - 1
    until(n == 0)
    print(str .. " Batmaaan!")
end


------------------------------------------------------------------------
------------------------------------------------------------------------
-- tables

myTable = {
    1,
    2,
    true,
    "Hello",
    key = (function() return "World!" end)()
}

--[[
print(#myTable) -- 4; len function ONLY counts integer indexes, not key:value pairs
print(myTable[1]) -- indexes start at 1
print(myTable[2]) -- all non-key:value pairs can be called with their indexes
print(myTable["key"]) -- key:value pairs must be called like this
print(myTable[99]) -- non existant keys or indexes return nil

myTable[5] = "New Value" -- add new value at index 5
print(myTable[5])

myTable["key2"] = "Another new Value" -- add new value with a key
print(myTable["key2"])
print(#myTable) -- 5;

table.insert(myTable, 4, "value")
print(myTable[4])
print(#myTable) -- 6;

for i,v in pairs(myTable) do
    print(i,v)
end
--]]


------------------------------------------------------------------------
------------------------------------------------------------------------
-- Metatables (doku: https://www.lua.org/pil/13.html)

-- > Lua has default implementations for when an operand is called, like
--   +, -, / or *. These methods are very similar to Python, as they
--   are called __add, __sub, __div, and __mul respectively.

-- > Like in Python, these methods can be overwritten. In Lua, this works
--   by defining a metatable.

-- > In the following, we use the already defined metatable for a string
--   object to add Python's behavior of concatenating strings with '+'

Meta = getmetatable("")
Meta.__add = function(l, r) return l .. r end
print("Foo" + "Bar")

-- > Or we can achieve Python's behavior when multipying strings like in
--   the following
Meta.__mul = function(str, val)
        if val == 1 then
            return str
        end
        toAdd = str
        repeat
            str = str + toAdd
            val = val - 1
        until(val==1)
        return str
    end
print("Foo" * 5)

-- > Thus, a metatable can change the behavior of any table it is
--   "attached" to.

-- influence from http://nova-fusion.com/2011/06/30/lua-metatables-tutorial/
mt = {
    -- __index can be a function or another table to lookup in (prototyping)
    __index = function(t, key)
        if table[key] == nil then
            return 0
        else
            -- return t[key] results in infinite loop
            return table[key]
        end
    end,

    -- when trying to set a value in a table, and that value is not
    -- present in the table, then __newindex is called
    __newindex = function(t, key, value)
        if type(value) == "number" then
            -- rawset allows for setting some value in a table t
            -- without having to use __newindex (this is to avoid infinite
            -- loops when setting new values in tables)
            rawset(t, key, value * value)
            -- t[key] = value * value results kin infinite loop because this effectively calls __newindex again
        else
            rawset(t, key, value)
        end
    end
}
t = {}
setmetatable(t, mt)

print(t.foo)    -- 0 (normalerweise nil)
print(t.bar)    -- 0 (normalerweise nil)
t.foo = 4
print(t.foo)    -- 16
print(t["foo"]) -- 16
t.foo = 20
print(t.foo)    -- 20 (__newindex wurde nicht erneut aufgerufen)
t.bar = "not_a_number"
print(t.bar) -- "not_a_number"



------------------------------------------------------------------------
------------------------------------------------------------------------
-- Prototypes

-- > metatables can be used to achieve class behavior
-- > a table can be a class, and each table that is "attached" to
--   that table will "inherit" that table's behavior
-- > this is Lua's concept of prototyping

Dog = {}

function Dog:new(name, sound) -- same as Dog.new(self, name, sound)
    local newDog = {
        name = name,
        sound = sound,
    }
    self.__index = self  -- this is where the "copy" of Dog is made and put into __index, so Dog's behavior stays as a lookup
    return setmetatable(newDog, self)  -- this tells Lua to "attach" Dog's behavior to the newDog table (or "instance"), so the new instance can use __index to lookup methods and variables in case newDog itself doesn't have those
end

function Dog:woof()
    print(self.name .. " says " .. self.sound .. '!\n')
end

MyDog = Dog:new('Bello', 'rarf')
MyDog:woof()

------------

AnotherDog = Dog:new('Sparky', 'woof')

function AnotherDog:play(action)
    print(self.name .. " " .. action .. "!")
end

function AnotherDog:woof()
    print(self.name .. " " .. self.sound .. "s and barks all day!\n")
end

AnotherDog:play('licks hand')
AnotherDog:woof() -- uses AnotherDog:woof()
MyDog:woof() -- uses Dog:woof()
