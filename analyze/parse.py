import json;
import pprint as pprint;
all_queries = [];

#read all explains to all_queries
for i in range(99):
	f = open("explain_{num}".format(num = i));
	all_queries[i] = json.load(f);

pprint(all_queries);
