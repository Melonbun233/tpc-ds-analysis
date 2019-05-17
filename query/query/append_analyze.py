#append EXPLAIN (FORMAT JSON, ANALYZE) to all queries at their beginnings
# Save the modified file in to the folder ../query_explain

sf = 1000;

for i in range(99):
	old = open("queries_{sf}/query_{num}.sql".format(num = i, sf = sf), "r");
	new = open("../query_analyze/queries_{sf}/query_{num}.sql".format(num = i, sf = sf), "w");
	lines = old.readlines();

	#set non-parallet
	new.write("SET max_parallel_workers_per_gather TO 0;\n");

	# open log file
	new.write("\\o /var/lib/postgresql/data/analyze/sf_{sf}/analyze_{num}.json\n".format(num = i, sf = sf));
	new.write("EXPLAIN (FORMAT JSON, ANALYZE)\n"); 
	for line in lines:
		new.write(line);

	new.write("\\echo query_{num} processed".format(num = i));
		
	new.close();
	old.close();
