#this script parse the explain json and count all distinct node types
#The result is saved to count_operators.json
from parse import parse_explain;
import json;

#recursive helper function to extract all plans
#This funciton takes a dictionary
def extract_plan(plan, result):
	#Store the plan
	store_plan(plan, result);
	if ("Plans" in plan):
		for child in plan["Plans"]:
			extract_plan(child, result);

#helper function to add a node_type count
def result_add(node_type, result):
	if (node_type in result):
		result[node_type] += 1;
	else:
		result[node_type] = 1;


# Store a plan's info into result
def store_plan(plan, result):
	node_type = plan["Node Type"];
	# store number of this node type
	# scan node
	if("Scan" in node_type):
		if ("Scan" in result["sub"]):
			result_add(node_type, result["sub"]["Scan"]);
		else:
			result["sub"]["Scan"] = {node_type: 1}
	# join node
	elif("Join" in node_type):
		join_type = plan["Join Type"];
		if("Join" in result["sub"]):
			if(join_type in result["sub"]["Join"]):
				result_add(node_type, result["sub"]["Join"][join_type]);
			else:
				result["sub"]["Join"][join_type] = {node_type: 1};
		else:
			result["sub"]["Join"] = {join_type:{node_type: 1}};

	#else
	else:
		result_add(node_type, result["sub"]);
	# Filter is not a node type, but it is a operator
	if ("Filter" in plan):
		result_add("Filter", result["sub"]);

	result["total"] += 1;


result = {"sub":{}, "total":0};
#data is a list contains 99 results from queries
data = parse_explain();
for i in range(99):
	#plan is a dict that is the root of all plans
	plan = data[i][0]["Plan"];
	extract_plan(plan, result);

result_str = json.dumps(result, indent = 4);
print(result_str);
#save result to count_operators.json
f = open("count_operators.json", "w");
f.write(result_str);
f.close();

#draw graph






