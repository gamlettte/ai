---@class neuron_demo
---@field private _weight_vector number[]
---@field private _bias number
---@field private _input_clots integer
---@field private _activation_f fun(input: number): number
local neuron_demo = {}
neuron_demo.__index = neuron_demo


---@public
---@param weight_vector number[]
---@param bias number
---@param activation_f fun(input: number): number
---@return neuron_demo
---@nodiscard
function neuron_demo.new(weight_vector, bias, activation_f)

    assert(type(weight_vector) == "table")

    for _, v in ipairs(weight_vector) do
        assert(type(v) == "number")
    end

    assert(type(bias) == "number")

    assert(type(activation_f) == "function", type(activation_f))
    assert(type(activation_f(0.0)) == "number")

    ---@type neuron_demo
    local self = setmetatable({
        _weight_vector = weight_vector,
        _bias = bias,
        _input_slots = #weight_vector,
        _activation_f = activation_f
    }, neuron_demo)

    return self
end


---@public
---@param input number[]
---@return number
---@nodiscard
function neuron_demo:run(input)

    assert(type(input) == "table")
    for _, v in ipairs(input) do
        assert(type(v) == "number")
    end
    assert(#input == #self._weight_vector)

    ---@type number
    local sum = self._bias
    for i = 1, #input do
        sum = sum + input[i] * self._weight_vector[i]
    end

    return self._activation_f(sum)
end


---@type number[]
local weight_vector = {1, 1}

---@type number
local bias = -1

---@type fun(input: number): number
local function re_lu(input)
    assert(type(input) == "number")
    return input > 0 and input or 0
end

---@type neuron_demo
local _2i_and_neuron = neuron_demo.new(weight_vector, bias, re_lu)

---@type number[][]
local all_possible_inputs = {
    {0, 0},
    {0, 1},
    {1, 0},
    {1, 1}
}

---@type number[]
local expected_outputs = {
    0,
    0,
    0,
    1
}

---@type number[]
local real_results = {}
for _, value in ipairs(all_possible_inputs) do
    ---@type number
    local result = _2i_and_neuron:run(value)
    table.insert(real_results, result)
end

assert(#real_results == #expected_outputs)
for i = 1, #real_results do
    assert(real_results[i] == expected_outputs[i],
           real_results[i].." is not "..expected_outputs[i])
end

