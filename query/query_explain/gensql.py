f = open("execute_all.sql", "w");
for i in range(99):
	# open log file
	f.write("\\o ../../explain/explain_{num}.json\n".format(num = i))
	# execute the sql file
	f.write("\\i query_{num}.sql\n".format(num = i))

f.close();