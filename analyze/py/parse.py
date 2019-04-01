import json;

def parse_analyze():
	all_analysis = [];
	#read all explains to all_queries
	for i in range(99):
		f = open("../analyze_{num}.json".format(num = i));
		all_analysis.append(json.load(f));
		#print("Parsed analyze_{num}.json file".format(num = i));
		f.close();
	print("Parsed all analysis json");
	return all_analysis;

# all_explains = parse_analyze();
# print json.dumps(all_explains[0], indent = 4);