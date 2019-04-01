#convert all json files to a csv formated file
#each query and operator will be assigned a unique id
#the data is store each operator per row
#
#########################################################################################
# operator_id # parent_id # child_id # query_id # <All Other Fields from JSON file>
#########################################################################################

from parse import parse_analyze;
import json;
import os;

def extract_fields(plans, fields):
	#store unique field
	for field in plans:
		if field != "Plans" and field not in fields:
			fields.append(field);

	#recursively call this function to all its child plans
	if "Plans" in plans:
		for plan in plans["Plans"]:
			extract_fields(plan, fields);

#extract all data with the fields
#data is a list, and each element contains a dict with fields as keys
def extract_data(plans, fields, data, query_id, parent_id, id_counter):
	#create an empty dict
	data.append(dict.fromkeys(fields));
	index = len(data) - 1;
	for field in plans:
		if field != "Plans":
			data[index][field] = plans[field];

	data[index]["query_id"] = query_id;
	if (parent_id is not None):
		data[index]["parent_id"] = parent_id;

	node_id = id_counter;
	data[index]["id"] = node_id;
	id_counter += 1; 

	data[index]["child_id"] = [];

	#recursively call this function to all its child plans
	if "Plans" in plans:
		for plan in plans["Plans"]:
			child_id, id_counter = extract_data(plan, fields, data, query_id, node_id, id_counter);
			data[index]["child_id"].append(child_id);

	return node_id, id_counter;

def truncate_last(f):
	f.seek(-1, os.SEEK_END);
	f.truncate();


def write_element(f, element):
	if isinstance(element, dict):
		data = json.dumps(element).replace(',', ';').replace('"', '');
	else:
		data = str(element).replace(',', ';').replace('"', '');
	f.write("\"" + data.encode("ascii", "ignore") + "\",");

def wirte_list_element(f, element):
	if isinstance(element, dict):
		data = json.dumps(element).replace(',', ';').replace('"', '');
	else:
		data = str(element).replace(',', ';').replace('"','');

	f.write(data.encode('ascii', 'ignore') + ',');
	
def process_none(f, key):
	if key == "Group Key":
		f.write("{},");
	else:
		f.write(",");

def convert_csv(fields, data):
	f = open("tpcds_node.csv", "w");
	#write all fields
	for field in fields:
		f.write("\"{str}\",".format(str = field));
	truncate_last(f);
	f.write("\n");

	#parse data
	for row in data:
		#order guaranteed
		for key in fields:
			if row[key] is None:
				process_none(f, key);
				continue;

			#check if the element is a list
			#If ture, we only process the most upper level
			if isinstance(row[key], list):
				f.write("\"{");
				for value in row[key]:
					wirte_list_element(f, value);
				if len(row[key]) is not 0:
					truncate_last(f);
				f.write("}\",");
			else:
				write_element(f, row[key]);
		truncate_last(f);
		f.write("\n");

	f.close();
	print("converted to tpcds_node.csv");

# def write_file_rec(f, data):
# 	if isinstance(data, list):
# 		for element in data:
# 			write_file_rec(f, element);
# 	else:
# 		f.write("'{str}',".format(str = data));

all_plans = parse_analyze();

#get all fields
fields = [];
for i in range(99):
	plans = all_plans[i][0]["Plan"];
	extract_fields(plans, fields);
fields.append("query_id");
fields.append("id");
fields.append("parent_id");
fields.append("child_id");

print json.dumps(fields, indent = 4);

data = [];
id_counter = 0;
for i in range(99):
	plans = all_plans[i][0]["Plan"];
	child_id, id_counter = extract_data(plans, fields, data, i, None, id_counter);

convert_csv(fields, data);

#print json.dumps(data[0], indent = 4);

# for element in data:
# 	if (element["Params Evaluated"] is not None):
# 		print str(element["Params Evaluated"]);

# print "should have " + str(len(data)) + " elements"; 


	




