#append EXPLAIN (FORMAT JSON, ANALYZE) to all queries at their beginnings
# Save the modified file in to the folder ../query_explain
for i in range(99):
	old = open("query_{num}.sql".format(num = i), "r");
	new = open("../query_analyze/query_{num}.sql".format(num = i), "w");
	lines = old.readlines();

	new.write("EXPLAIN (FORMAT JSON, ANALYZE)\n"); 
	for line in lines:
		new.write(line);
		
	new.close();
	old.close();
