-- Lua Prototyping

-- Define the Dog class
Dog = {}

-- Dog 'constructor' with a sound parameter
-- the colon (:) syntax is syntactic sugar and is synonymous to Dog.new(self, sound)
function Dog:new(sound)
    local newDog = {
        sound = sound
    }

    -- set table's lookup __index method to new object (newDog)
    -- the metatable then can lookup the object instance
    self.__index = self

    -- setmetatable adds newDog to Dog's metatable
    -- this effectively means that newDog inherits Dog's behavior
    -- (returns reference id for the table)
    return setmetatable(newDog, self)
end

function Dog:woof()
    print(self.sound .. '!\n')
end

MyDog = Dog:new('rarf')
MyDog:woof()  -- same as doing MyDog.woof(MyDog)


------------------------------------------------------------------------
------------------------------------------------------------------------


-- Creating a second Dog object (copies the Dog class)
AnotherDog = Dog:new('woof')

-- add a new function to the cloned object
function AnotherDog:play(action)
    print(tostring(self) .. " " .. action)  -- .. means concatenation
    self:woof()
end

AnotherDog:play('runs away')
-- table: 026f8400 runs away
-- woof!

-- override __tostring in Dog's metatable
-- 'AnotherDog:__tostring()' will not override __tostring in Dog's metatable
-- __tostring() is used either by print() or tostring()
function Dog:__tostring()
    return 'Sparky'
end

AnotherDog:play('licks my hand')
-- Sparky licks my hand
-- woof!
