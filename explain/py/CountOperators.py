#this script parse the explain json and count all distinct node types
#The result is saved to count_operators.json
from parse import parse_explain;
import json;
import numpy as np;
import matplotlib.pyplot as plt;

#recursive helper function to extract all plans
#This funciton takes a dictionary
def extract_plan(plan, result):
	#Store the plan
	store_plan(plan, result);
	if ("Plans" in plan):
		for child in plan["Plans"]:
			extract_plan(child, result);

#helper function to add a node_type count
def result_add(node_type, result, data_flow):
	if (node_type in result):
		result[node_type]["Count"] += 1;
		result[node_type]["Data Flow"] += data_flow;
	else:
		result[node_type] = {"Count": 1, "Data Flow": data_flow};


# Store a plan's info into result
def store_plan(plan, result):
	node_type = plan["Node Type"];
	data_flow = plan["Plan Rows"] * plan["Plan Width"];
	types = result["Node Types"];
	# store number of this node type
	# scan node
	if("Scan" in node_type):
		if ("Scan" in types):
			result_add(node_type, types["Scan"]["Scan Types"], data_flow);
		else:
			types["Scan"] = {"Data Flow": 0, "Count": 0, 
			"Scan Types": {node_type: {"Count": 1, "Data Flow": data_flow}}};
		types["Scan"]["Data Flow"] += data_flow;
		types["Scan"]["Count"] += 1; 
	# join node
	elif("Join" in node_type):
		join_type = plan["Join Type"];
		if("Join" in types):
			if(join_type in types["Join"]["Join Types"]):
				result_add(node_type, types["Join"]["Join Types"][join_type], data_flow);
			else:
				types["Join"]["Join Types"][join_type] = {node_type: {"Count": 1, "Data Flow": data_flow}};
		else:
			types["Join"] = {"Data Flow":0, "Count": 0, 
			"Join Types":{join_type:{node_type: {"Count": 1, "Data Flow": data_flow}}}};
		types["Join"]["Data Flow"] += data_flow;
		types["Join"]["Count"] += 1;

	#else
	else:
		result_add(node_type, types, data_flow);
	# Filter is not a node type, but it is a operator
	if ("Filter" in plan):
		result_add("Filter", types, data_flow);

	result["Total Count"] += 1;
	result["Total Data Flow"] += data_flow;


result = {"Total Data Flow": 0, "Total Count":0, "Node Types":{}};
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
objects = [];
counts = [];
data_flows = [];
types = result["Node Types"]

for key in types:
	objects.append(key);
	counts.append(types[key]["Count"]);
	data_flows.append(types[key]["Data Flow"]);

index = np.arange(len(objects));

plt.bar(index, counts, color = "SkyBlue");
plt.xlabel("Operators");
plt.ylabel("No. of operators");
plt.xticks(index + 0.35, objects, fontsize = 5, rotation = 30);
plt.title("Number of different operators used in tpc-ds with scale factor of 1");
plt.show();







