#append EXPLAIN (FORMAT JSON, ANALYZE) to all queries at their beginnings
# Save the modified file in to the folder ../query_explain
for i in range(99):
	old = open("query_{num}.sql".format(num = i), "r");
	new = open("../query_analyze/query_{num}.sql".format(num = i), "w");
	lines = old.readlines();

	#set non-parallet
	new.write("SET max_parallel_workers_per_gather TO 0;\n");

	# open log file
	new.write("\\o ../../analyze/analyze_{num}.json\n".format(num = i));
	new.write("EXPLAIN (FORMAT JSON, ANALYZE)\n"); 
	for line in lines:
		new.write(line);

	new.write("\\echo query_{num} processed".format(num = i));
		
	new.close();
	old.close();
