-- Counts total number of customers including startup customers and full customers

-- Create Variables

local full_customer_deal_count = 0
local startup_customer_deal_count = 0
local date = os.date("%d") - 1
local yesterday_cyfe = string.format(os.date("%Y%m").."%02d",date)

pagination_table = {1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20}

--First call because of pagination

for key,value in pairs(pagination_table) do
		local page_key = value
		local response = http.request {
		url = 'https://sales.futuresimple.com/api/v1/deals.json?stage=won',
		params = {
			page = page_key	
			},
		headers = {
			['X-Pipejump-Auth']= 'YOUR KEY HERE',
			}
		}
		local JSON = json.parse(response.content)
		if response.content == "[]" then break end
		for key,value in pairs(JSON) do
				if JSON[key].deal.user_name == "Brent Fagg" then
				startup_customer_deal_count = startup_customer_deal_count + 1
				else
				full_customer_deal_count = full_customer_deal_count + 1
			end		
		end
end

--Create Lua Table

local dealcount_table = {["data"] = {[1] = { ["Date"] = yesterday_cyfe, ["Full Customers"] = full_customer_deal_count, ["Startup Customers"] = startup_customer_deal_count } }, ["onduplicate"] = {["Startup Customers"] = "replace", ["Full Customers"] = "replace"}, ["cumulative"] = {["Full Customers"] = "1", ["Startup Customers"] = "1"}, ["yaxis"] = {["Full Customers"] = "0", ["Startup Customers"] = "0"}}
local dealcount_json = json.stringify(dealcount_table)


-- PUSH DATA TO CYFE


local push_dealcount_to_dashboard = http.request {
	method='post',
	url = 'YOUR CYFE URL',
	data = dealcount_json
}


return "200"
