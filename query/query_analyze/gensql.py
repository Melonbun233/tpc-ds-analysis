#run sql file generated from this python script. 
#query_0.sql still need to be manually modified
f = open("execute_all.sql", "w");
for i in range(99):
	# open log file
	f.write("\\o ../../analyze/analyze_{num}.json\n".format(num = i))
	# execute the sql file
	f.write("\\i query_{num}.sql \\t on \n".format(num = i))

f.close();