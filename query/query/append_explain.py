#append EXPLAIN (FORMAT JSON) to all queries at their beginnings
# Save the modified file in to the folder ../query_explain
for i in range(99):
	old = open("query_{num}.sql".format(num = i), "r");
	new = open("../query_explain/query_{num}.sql".format(num = i), "w");
	lines = old.readlines();

	new.write("EXPLAIN (FORMAT JSON)\n"); 
	for line in lines:
		new.write(line);

	new.close();
	old.close();
