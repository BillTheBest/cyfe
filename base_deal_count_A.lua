--First part of script to count opportunities (Base calls them Deals) in sales pipeline

--Create Variables

stage_table = {"incoming", "qualified"}
pagination_table = {1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20}

local pipeline_deal_count = 0

--Make calls to Base

for key,value in  pairs(stage_table) do
	local stage_key = value
	for key,value in  pairs(pagination_table) do
		local page_key = value
		local response = http.request {
		url = 'https://sales.futuresimple.com/api/v1/deals.json?',
		params = {
			page = page_key,
			stage = stage_key	
			},
		headers = {
			['X-Pipejump-Auth']= 'YOUR_KEY',
			}
		}
		local JSON = json.parse(response.content)
		if response.content == "[]" then break end
		for key,value in pairs(JSON) do
			pipeline_deal_count = pipeline_deal_count + 1
		end
	end	
end

--Activate Part B
storage.pipeline_deal_count = pipeline_deal_count

return "200"
