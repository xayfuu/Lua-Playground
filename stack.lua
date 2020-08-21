Stack = {}

function Stack:new()
    self.__index = self
    return setmetatable({}, self)
end

function Stack:push(v)
    self[#self+1] = v
end

function Stack:pop()
    if self:isempty() then
        error("Stack is empty")
    end
    local popped = self[#self]
    self[#self] = nil
    return popped
end

function Stack:peek()
    return self[#self]
end

function Stack:dump()
    for i,v in pairs(self) do
        print(i,v)
    end
end

function Stack:isempty()
    return #self == 0
end

function Stack:copy(stack)
    if getmetatable(stack) ~= Stack then
        error("Object to copy from is not a Stack")
    end
    if not stack:isempty() then
        for i = 1, #stack, 1 do
            self[i] = stack[i]
        end
    end
    return self
end

-- https://www.lua.org/pil/7.1.html
function Stack:iter()
    local i = 0
    return function()
               i = i + 1
               if i <= #self then return self[i] else return nil end
           end
end
