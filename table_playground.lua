String = {}

table_custom_add = {
    __add = function(str_left, concatenable)
        return str_left .. concatenable.str
    end
}

function String:new(s)
    local concatenable = {str = tostring(s)}
    self.__index = self
    return setmetatable(concatenable, table_custom_add)
end

function concat_strings(...)
    local concat = ""
    --for i = 1, select("#",...) do
    for i = 1, #... do
        concat = concat + String:new(select(i,...))
    end
    return concat
end

print(concat_strings("Lua ", 5, ".", 3, ".", 4, " ist die aktuelle Version."))
