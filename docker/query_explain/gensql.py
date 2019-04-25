#run sql file generated from this python script. 
#query_0.sql still need to be manually modified
sf = 1000;
f = open("queries_{sf}/execute_all.sql".format(sf =sf), "w");

for i in range(99):
	# execute the sql file
	f.write("\\i query_explain/queries_{sf}/query_{num}.sql \\t on \n".format(num = i, sf = sf))

f.close();