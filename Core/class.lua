local unpack = table.unpack

-- returns a function that runs a class instance init
local function generate_init_function(class_instance, args)
  return
      function()
        return class_instance.__init(class_instance, unpack(args))
      end
end

function Class(...)
  -- "cls" is the new class (not the instance, the actual class table / class metadata)
  local cls, bases = {}, { ... }

  cls.__class_instance = true

  -- copy base class contents into the new class
  --print("-------------------------------------------------")
  --print("base stuff:")
  for i, base in ipairs(bases) do
    -- base is a table
    for name, value in pairs(base) do
      cls[name] = value
    end
  end

  -- set the class's __index, and start filling an "is_a" table that contains this class and all of its bases
  -- so you can do an "instance of" check using my_instance.is_a[MyClass]
  cls.__index, cls.is_a = cls, { [cls] = true }
  for i, base in ipairs(bases) do
    for c in pairs(base.is_a) do
      cls.is_a[c] = true
    end
    cls.is_a[base] = true
  end

  -- the class's __call metamethod (when you are actually creating the instance)
  setmetatable(cls, {
    __call = function(c, ...)
      local instance = setmetatable({}, c)
      -- run the init method if it's there
      local init = instance.__init

      -- this overrides the class's :tostring because the Class() function is called
      -- each time a new class instance is created,
      -- while the class method is created only once on load.
      -- therefore it gets overriden when the instance is created
      if not instance.tostring then   -- if the class doesnt have a :tostring() method, add one that spits out a warning if it gets called
        instance.tostring = function() return
          "API Warning: called tostring on a class instance when :tostring() was not implemented" end
      end

      if init then
        local args = { ... }
        instance = generate_init_function(instance, args)()
      end

      return instance
    end
  })

  -- return the new class table, that's ready to be filled with methods
  return cls
end

function is_class_instance(instance, class)
  return type(instance) == "table" and instance.is_a and instance.is_a[class]
end

----------- Local Funcs -----------
local MOD = 2 ^ 32

local function memoize(f)
  local mt = {}
  local t = setmetatable({}, mt)
  function mt:__index(k)
    local v = f(k); t[k] = v
    return v
  end

  return t
end

local function make_bitop_uncached(t, m)
  local function bitop(a, b)
    local res, p = 0, 1
    while a ~= 0 and b ~= 0 do
      local am, bm = a % m, b % m
      res = res + t[am][bm] * p
      a = (a - am) / m
      b = (b - bm) / m
      p = p * m
    end
    res = res + (a + b) * p
    return res
  end
  return bitop
end

local function make_bitop(t)
  local op1 = make_bitop_uncached(t, 2 ^ 1)
  local op2 = memoize(function(a)
    return memoize(function(b)
      return op1(a, b)
    end)
  end)
  return make_bitop_uncached(op2, 2 ^ (t.n or 1))
end

local bxor = make_bitop { [0] = { [0] = 0, [1] = 1 }, [1] = { [0] = 1, [1] = 0 }, n = 4 }

local function bit32_bxor(a, b, c, ...)
  local z
  if b then
    a = a % MOD
    b = b % MOD
    z = bxor(a, b)
    if c then
      z = bit32_bxor(z, c, ...)
    end
    return z
  elseif a then
    return a % MOD
  else
    return 0
  end
end

local insert, concat = table.insert, table.concat
local char = string.char
local key = 34

local function xor_cipher(arg)
  local ret = {}
  for c in arg:gmatch('.') do
    insert(ret, char(bit32_bxor(c:byte(), key)))
  end
  return concat(ret)
end

local function xor_encrypt(arg)
  local input_type = type(arg)

  if input_type == "number" then
    return xor_cipher(tostring(arg) .. "3")
  elseif input_type == "string" then
    return xor_cipher(arg .. "4")
  end
end

local function xor_decrypt(arg)
  local encrypted_type_flag = string.sub(arg, -1)

  if encrypted_type_flag == "3" then
    return tonumber(xor_cipher(arg:sub(1, -2)))
  elseif encrypted_type_flag == "4" then
    return xor_cipher(arg:sub(1, -2))
  end
end
-----------------------------------

-- an addition to the object-oriented structure that adds a getter and setter to a class
-- adds instance:GetVariableName and instance:SetVariableName to a class instance
function getter_setter(instance, get_set_name)
  local function firstCharacterToUpper(str)
    return (str:gsub("^%l", string.upper))
  end

  local name = ""
  local words = split(get_set_name, "_")
  for k, word in ipairs(words) do
    name = name .. firstCharacterToUpper(word)
  end

  local get_name = "Get" .. name
  local set_name = "Set" .. name

  instance[get_name] = function()
    return instance[get_set_name]
  end

  instance[set_name] = function(instance, value)
    instance[get_set_name] = value
  end
end

-- adds instance:GetVariableName and instance:SetVariableName to a class instance, and encrypts the value in memory
-- to access or modify this value, it is required to exclusively use the Get and Set functions so that the value can be encrypted and decrypted properly
-- currently works with strings and numbers
function getter_setter_encrypted(instance, get_set_name)
  local function firstCharacterToUpper(str)
    return (str:gsub("^%l", string.upper))
  end

  local name = ""
  local words = split(get_set_name, "_")
  for k, word in ipairs(words) do
    name = name .. firstCharacterToUpper(word)
  end

  local get_name = "Get" .. name
  local set_name = "Set" .. name

  instance[get_name] = function()
    return xor_decrypt(instance[get_set_name])
  end

  instance[set_name] = function(instance, value)
    instance[get_set_name] = xor_encrypt(value)
  end
end
