#append EXPLAIN (FORMAT JSON) to all queries at their beginnings
# Save the modified file in to the folder ../query_explain
# 

sf=1000;

for i in range(99):
	old = open("queries_{sf}/query_{num}.sql".format(num = i, sf = sf), "r");
	new = open("../query_explain/queries_{sf}/query_{num}.sql".format(num = i, sf = sf), "w");
	lines = old.readlines();

	new.write("SET max_parallel_workers_per_gather TO 0;\n");

	new.write("\\o ../../../explain/sf_{sf}/explain_{num}.json\n".format(num = i, sf = sf));
	new.write("EXPLAIN (FORMAT JSON)\n"); 
	for line in lines:
		new.write(line);

	new.write("\\echo query_{num} processed".format(num = i));

	new.close();
	old.close();
