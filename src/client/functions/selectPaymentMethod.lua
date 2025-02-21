---@class PaymentMethodData
---@field price number
---@field label string?
---@field allowBlackMoney boolean?

local defaultPaymentMethod <const> = 'money'
local paymentMethodLocales <const> = {
    header = 'Choose a payment method',
    input = {
        label = 'How would you like to pay?',
        description = {
            default = 'Choose how you would like to pay %s$.',
            withReason = 'Choose how you would like to pay %s$ for "%s".'
        },
        accountTypes = {
            money = 'Cash',
            bank = 'Card',
            black_money = 'Blackmoney',
        }
    }
}

---@param data PaymentMethodData
local function getPaymentMethods(data)
    local options = {
        {
            value = 'money',
            label = paymentMethodLocales.input.accountTypes.money
        },
        {
            value = 'bank',
            label = paymentMethodLocales.input.accountTypes.bank
        }
    }

    if data.allowBlackMoney then
        table.insert(options, {
            value = 'black_money',
            label = paymentMethodLocales.input.accountTypes.black_money
        })
    end

    return options
end

---@param data PaymentMethodData
---@return string
local function selectPaymentMethod(data)
    local price = data.price
    assert(price and type(price) == 'number', 'price must be a number')

    local label = data.label
    if label then
        assert(type(label) == 'string', 'label must be a string')
    end

    if data.allowBlackMoney == nil then data.allowBlackMoney = false end
    assert(type(data.allowBlackMoney) == 'boolean', 'allowBlackMoney must be a boolean')

    local rows = {
        {
            label       = paymentMethodLocales.input.label,
            description = label and paymentMethodLocales.input.description.withReason:format(price, label) or
                paymentMethodLocales.input.description.default:format(price),
            type        = 'select',
            icon        = { 'fas', 'file-contract' },
            options     = getPaymentMethods(data),
            default     = defaultPaymentMethod,
            required    = true
        }
    }

    local retval = lib.inputDialog(paymentMethodLocales.header, rows)

    return retval and retval[1] or false
end

return selectPaymentMethod
