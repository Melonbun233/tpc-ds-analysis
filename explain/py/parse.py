import json;

def parse_explain():
	all_explains = [];
	#read all explains to all_queries
	for i in range(99):
		f = open("../explain_{num}.json".format(num = i));
		all_explains.append(json.load(f));
		print("Parsed explain_{num}.json file".format(num = i));
		f.close();

	return all_explains;

#all_explains = parse_explain();
#print json.dumps(all_explains[0], indent = 4);