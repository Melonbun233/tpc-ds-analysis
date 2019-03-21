# Calculate the ratio of (data out)/(data in) for each node
# Note that when the filter is applied to a node, we will lose the data
# filtered, so I decide to ignore the nodes with a filter.
from __future__ import division;
from parse import parse_explain;
import json;
import numpy as np;
import matplotlib.pyplot as plt;

def extract_plan(plan, result):
	#store plan only when there're children and no filter in the 
	#current plan
	if ("Plans" in plan and "Filter" not in plan):
		store_plan(plan, result);

	#recursive
	if("Plans" in plan):
		for child in plan["Plans"]:
			extract_plan(child, result);

def result_add(node_type, result, datain, dataout):
	if(node_type in result):
		result[node_type]["Count"] += 1;
		result[node_type]["Data In"] += datain;
		result[node_type]["Data Out"] += dataout;
	else:
		result[node_type] = {"Count": 1, "Data In": datain, "Data Out": dataout};

#store the plan's (data out)/(data in) ratio
#This plan doen't contain filter and it has at least one child
def store_plan(plan, result):
	node_type = plan["Node Type"];
	types = result["Types"];
	datain = 0;
	dataout = 0;

	for child in plan["Plans"]:
		datain += child["Plan Rows"] * child["Plan Width"];

	dataout = plan["Plan Rows"] * child["Plan Width"];

	#Store different nodes
	if("Scan" in node_type):
		if ("Scan" in types):
			result_add(node_type, types["Scan"]["Types"], datain, dataout);
		else:
			types["Scan"] = {"Data In": 0, "Data Out": 0, "Count": 0, 
			"Types": {node_type: {"Count": 1, "Data In": datain, "Data Out": dataout}}};
		types["Scan"]["Data In"] += datain;
		types["Scan"]["Data Out"] += dataout;
		types["Scan"]["Count"] += 1; 
	# join node
	elif("Join" in node_type):
		join_type = plan["Join Type"];
		if("Join" in types):
			if(join_type in types["Join"]["Types"]):
				result_add(node_type, types["Join"]["Types"][join_type], datain, dataout);
			else:
				types["Join"]["Types"][join_type] = {node_type: {"Count": 1, 
				"Data In": datain, "Data Out": dataout}};
		else:
			types["Join"] = {"Data In":0, "Data Out":0, "Count": 0, 
			"Types":{join_type:{node_type: {"Count": 1, "Data In": datain, "Data Out": dataout}}}};
		types["Join"]["Data In"] += datain;
		types["Join"]["Data Out"] += dataout;
		types["Join"]["Count"] += 1;

	#else
	else:
		result_add(node_type, types, datain, dataout);

	result["Total Count"] += 1;

def compute_ratio(types):
	#data ratio
	for child in types:
		node_type = types[child];
		ratio = node_type["Data Out"]/node_type["Data In"];
		node_type["Ratio"] = ratio;

		if (child is "Join"):
			for join_type in types["Join"]["Types"]:
				node_type = types["Join"]["Types"][join_type];
				if ("Merge Join" in node_type):
					ratio = node_type["Merge Join"]["Data Out"]/node_type["Merge Join"]["Data In"];
					node_type["Merge Join"]["Ratio"] = ratio;
				if ("Hash Join" in node_type):
					ratio = node_type["Hash Join"]["Data Out"]/node_type["Hash Join"]["Data In"];
					node_type["Hash Join"]["Ratio"] = ratio;

		if (child is "Scan"):
			for scan_type in types["Scan"]["Types"]:
				node_type = types["Scan"]["Types"][scan_type];
				if (node_type["Data Out"] is not 0 and node_type["Data In"] is not 0):
					ratio = node_type["Data Out"]/node_type["Data In"];
				else:
					ratio = 0;
				node_type["Ratio"] = ratio;


##############################################################################

result = {"Total Count":0, "Types": {}};

data = parse_explain();
for i in range(99):
	plan = data[i][0]["Plan"];
	extract_plan(plan, result);

#Compute ratios
compute_ratio(result["Types"]);

result_str = json.dumps(result, indent = 4);
print(result_str);
f = open("count_data_ratios.json", "w");
f.write(result_str);
f.close();

#plot graph
objects = [];
ratios = [];
types = result["Types"];

for key in types:
	objects.append(key);
	ratios.append(types[key]["Ratio"]);

index = np.arange(len(objects));

plt.bar(index, ratios, color = "SkyBlue");
plt.xlabel("Operators");
plt.ylabel("Ratio of Data Out/Data In")
plt.xticks(index + 0.35, objects, fontsize = 8, rotation = 30);
plt.title("Ratios of Data Out/Data In for for different operators");
plt.show();


