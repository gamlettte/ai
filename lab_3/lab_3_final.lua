local img = require("png-lua.png")
local _ = require("png-lua.deflatelua")
local perceptron = require("perceptron.perceptron")
local activation_functions = require("perceptron.activation_functions")


---@type string
local filepath = io.read()

---@type integer[]
local input = {}
local _ = img(filepath,
              function(_, _, rowpixels)
                  for _, value in pairs(rowpixels) do
                      local sum = value.R + value.G + value.B
                      local v = (sum > 255 and 0 or 255)
                      table.insert(input, v)
                  end
              end,
              false,
              true)

---@type string
local weights_path = io.read()

---@type perceptron
local mnist_perceptron = perceptron.new_from_file(weights_path,
                                                  activation_functions.ENUM.SIGMOID.FUNCTION,
                                                  activation_functions.ENUM.SIGMOID.DERIVATIVE)
---@type string[]
local print_table = {}
for _, v in ipairs(input) do
    table.insert(print_table, v == 0 and " " or "@" )
end

print(#print_table)
for i = 0, 27 do
    local a = table.concat(print_table, "", (28*i + 1), (28*(i + 1)))
    print(a or "#")
end

---@type number[]
local result = mnist_perceptron:run(input)

---@type number
local max_value = -math.huge

---@type integer
local max_index = 0

for k, v in ipairs(result) do
    if v > max_value then
        max_value = v
        max_index = k
    end
    print("num " .. k - 1 .. "res " .. v)
end

print("the digit is " .. max_index - 1)
